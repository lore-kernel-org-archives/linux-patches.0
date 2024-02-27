Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592278B61;
	Tue, 27 Feb 2024 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043591; cv=none; b=J3TBUtLdfHU+XzU9pvVkO1E53xrocMQg9/Vy5xZgIN5yU2mmotK0r8Rd1ksrxzripoQZ4POuXOoB9DJcghyrlhXtkBN2FwudnhoHAXxQQTCVBqP/az1UQPTRmv9sTYK/HhCzUB/gc4dezR0fuyXscrTnt91r0lmu8LvxdMhP6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043591; c=relaxed/simple;
	bh=FcbhMpcrvrX5ZS5+APJN8bRLpDHnNVXsNnKTHSP8Irk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlb5baUX7f8t92ZqGx7VLPdF/cC9PUEp2nikvIZY0+Oqx+Hv4N1mxXWTgi8jaUqY0XjXRP515L0u62y+7d4dDtzeJDiDG/1iuzpc5njQzEqivRSaBHPrBs1EXnHIngrDZcvN0C/BWAoEEjN7W24qQF901+nG2AIZwGg6bf//5Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCWfMDja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCWfMDja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B1C433C7;
	Tue, 27 Feb 2024 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043591;
	bh=FcbhMpcrvrX5ZS5+APJN8bRLpDHnNVXsNnKTHSP8Irk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCWfMDjaOB3uHVHcS1hm4YdKSLsYW+LbTor9MwOUBA7rDICcXhWL35CBnFYhuYY8Y
	 54ao0q7THG5Q90lnEIoYa5TAqGAzRdlHXNV+7irwo6Mjnp2BXQGS1FTkB4aphvgGBk
	 Vkw4EKxOePDfZ4MoYov7+6OBsCBIDsaSEu4kiiiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/195] RDMA/irdma: Add AE for too many RNRS
Date: Tue, 27 Feb 2024 14:26:36 +0100
Message-ID: <20240227131614.895962295@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ad54260cb58c9..ebe98fa2b1cd2 100644
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
index 12bd38b1e2c15..918a2d783141f 100644
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



