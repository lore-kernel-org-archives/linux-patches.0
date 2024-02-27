Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597D140391;
	Tue, 27 Feb 2024 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042298; cv=none; b=XNbK2lvjEJp7NoiHZZsAlq2Rsa/AQ0tX/tAxRyC5s+iVq2CaALMI84VvzGfIND9/ms+nXt4WEQSyWLQil3oYjHEr2zlo0Yn8q2vrK+VUGU4YK1hncesgt/oPFtf/Y+0TdZHbW8R8geioiEUgvF7tBMl7k9EAHe1rbYZEwoeKZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042298; c=relaxed/simple;
	bh=dekAj5cPaIfzmlZAmsfD8KEAqXOUwqkhRXO30EPSZ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+4FynpsKZiVJ8gYtlLPu0bDynP7m8rZCI+39vlCtTjAdna64GZhSDcTlJpjleIaWh2an7lix8EWlD9NoNfiHsiw334OGDTee/NsnOMGSzrbUljwTXguh/AdMvrq5QXjdb9WFctoluhlE0Z0OdnhSxKoXMK9OkSijXBasQl5tYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcFrHLQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcFrHLQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7222BC433C7;
	Tue, 27 Feb 2024 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042297;
	bh=dekAj5cPaIfzmlZAmsfD8KEAqXOUwqkhRXO30EPSZ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcFrHLQQSJOTFgPFjgkJeCicN4SHbt8X1GiX5NsbtzUEEr0Y69wUV+yQGXgRdJ74j
	 iumt5VYKIC+5CuCc1JOcPwyWlDZn2Brcc3I3MXrUycb1IcGiBEZdPFUYNidPkf6g1j
	 w0sFnTk3luU1z25eNy5UABdt6CF/SKaIhs5uGZ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/299] RDMA/irdma: Add AE for too many RNRS
Date: Tue, 27 Feb 2024 14:25:30 +0100
Message-ID: <20240227131632.820251424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 630bdb6f28ca9e5ff79e244030170ac788478332 ]

Add IRDMA_AE_LLP_TOO_MANY_RNRS to the list of AE's processed as an
abnormal asyncronous event.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@gmail.com>
Link: https://lore.kernel.org/r/20240131233849.400285-5-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/defs.h | 1 +
 drivers/infiniband/hw/irdma/hw.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/defs.h b/drivers/infiniband/hw/irdma/defs.h
index d06e45d2c23fd..9052e8932dc18 100644
--- a/drivers/infiniband/hw/irdma/defs.h
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -346,6 +346,7 @@ enum irdma_cqp_op_type {
 #define IRDMA_AE_LLP_TOO_MANY_KEEPALIVE_RETRIES				0x050b
 #define IRDMA_AE_LLP_DOUBT_REACHABILITY					0x050c
 #define IRDMA_AE_LLP_CONNECTION_ESTABLISHED				0x050e
+#define IRDMA_AE_LLP_TOO_MANY_RNRS					0x050f
 #define IRDMA_AE_RESOURCE_EXHAUSTION					0x0520
 #define IRDMA_AE_RESET_SENT						0x0601
 #define IRDMA_AE_TERMINATE_SENT						0x0602
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index aff68aa8dfad4..1745f40b075fd 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -387,6 +387,7 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 		case IRDMA_AE_LLP_TOO_MANY_RETRIES:
 		case IRDMA_AE_LCE_QP_CATASTROPHIC:
 		case IRDMA_AE_LCE_FUNCTION_CATASTROPHIC:
+		case IRDMA_AE_LLP_TOO_MANY_RNRS:
 		case IRDMA_AE_LCE_CQ_CATASTROPHIC:
 		case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
 		default:
-- 
2.43.0



