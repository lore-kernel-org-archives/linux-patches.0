Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516713A259;
	Tue, 27 Feb 2024 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043025; cv=none; b=EoIBBTpyz9FkkS3zAMjuwpTyYTZBdddZ008dAFxb+WnBChhhTKi3OIbIqhEWxW2oxTs03SC3GMSVh5XFxf8UssM+ZlTVTorR4ohZLRwQPv8KmSwgxWlulykjZYTxUFnVk+Mkz6/hQpKZi4IQEKXYJSwqV7MFQeF46gGt957qwck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043025; c=relaxed/simple;
	bh=eW7mPbRRGzLywvZpknijaR2UKOg3IqPImrYQX8ZQDQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s61LgYnCs3nLxshHx9xWTmSRgDCGgms74BLC7SPyZ05V6W+ajAvDq3uOML/bcnOZF3l6fETNtQGWsN9xrfTGzE02izGhgfn/yDdOhiXNg62sjIhArLKm/xhZW+9Wi6z8YBhHQJttBu5ZanZ+2mshZvraaNukLiYBp26624cAS/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VToWTY+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VToWTY+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750D1C433F1;
	Tue, 27 Feb 2024 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043024;
	bh=eW7mPbRRGzLywvZpknijaR2UKOg3IqPImrYQX8ZQDQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VToWTY+Ia/pLLv5ONHtNSwnY3mxZqBy8j02W7Fr7xuYIX0igq/VL6L9raW8WckFSj
	 7Px86lxtsyfiWP7hOfFrb2F2E9G7PTaWHM6fxATBknJDv4lPckIkelTxJ4PtFAM/aI
	 bGUxMeu9jHecI+T8CNZufcW7Q6QaTU7Tae/ZSjvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/245] RDMA/irdma: Add AE for too many RNRS
Date: Tue, 27 Feb 2024 14:26:34 +0100
Message-ID: <20240227131621.890031583@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index afd16a93ac69c..504449fc36c28 100644
--- a/drivers/infiniband/hw/irdma/defs.h
+++ b/drivers/infiniband/hw/irdma/defs.h
@@ -345,6 +345,7 @@ enum irdma_cqp_op_type {
 #define IRDMA_AE_LLP_TOO_MANY_KEEPALIVE_RETRIES				0x050b
 #define IRDMA_AE_LLP_DOUBT_REACHABILITY					0x050c
 #define IRDMA_AE_LLP_CONNECTION_ESTABLISHED				0x050e
+#define IRDMA_AE_LLP_TOO_MANY_RNRS					0x050f
 #define IRDMA_AE_RESOURCE_EXHAUSTION					0x0520
 #define IRDMA_AE_RESET_SENT						0x0601
 #define IRDMA_AE_TERMINATE_SENT						0x0602
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 21d55a12ebd9f..8781638d74272 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -379,6 +379,7 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 		case IRDMA_AE_LLP_TOO_MANY_RETRIES:
 		case IRDMA_AE_LCE_QP_CATASTROPHIC:
 		case IRDMA_AE_LCE_FUNCTION_CATASTROPHIC:
+		case IRDMA_AE_LLP_TOO_MANY_RNRS:
 		case IRDMA_AE_LCE_CQ_CATASTROPHIC:
 		case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
 		default:
-- 
2.43.0



