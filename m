Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042540;
	b=2DanM99obQ/dR64czewkHyu7swofkhNO2ZpC6YiOZRgA+GLzq4Xkt678nYgZ5uHnmKUx
	 24biab6cmI7rnQDqnST+Yyd1a9kLPYBvYWt/BTSYufWq6T1Sr18Yg6BMoqOw7y243BoYu
	 SgJBaN+L36wI5O/q97s1WurAb7M+mCHsw8HYpUkSC+TQGxsAw0IpuXu5AnGU9nlopAD+I
	 jpJJufQwNg7juC6A6gyTbljEHzBb55y7bGT47Q1+ZVtBBdWIQnWrWzqbKFqeA5NYwPLdr
	 2KKcJXfZjIq9nTWlfVrA/TEjdXArLrkAU1lLdtP67n083kXXBLlNelWASpiYCgkY9Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z9Lk9ZHq0iGIsDoJpFG0E1UsxQ/s5rKryoO+BX8aVXI=;
	b=Twk1SOP2umROs6SUaBAQvDkIWTm3B3Gzj4CBHs7H6hPA4rHKy7qhlCeSHV6Uclx5aWTD
	 mAsfvnqiZCwl31zVAItcDJX1m3DndFQ4TgOLq45guTKbZw3BhRsP7bArLVz7WPI1n9n8I
	 JG0PxjYRScjf0Tz6iM5g3Vm3Jn/JxJsxOnxJYyhIC/TEK2uINWPdOpp/YY+eCVO1yiQ/O
	 ZkeysXHP51izinI+6H2e3BkBLASsjC6fiIIyzZDBTbdkTfcwMeyw+3zvU3W6Cq2GlsdJV
	 GqMhTwqYLiFMLly8SrKQ6EmRG2UxFis8KnaBgDZciXLUfFMfXLcS/GolBI03DGLlGWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au1rxwL0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F8606A31C;
	Wed, 18 Nov 2026 22:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au1rxwL0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119991F000C4;
	Wed, 18 Nov 2026 22:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042540;
	bh=z9Lk9ZHq0iGIsDoJpFG0E1UsxQ/s5rKryoO+BX8aVXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Au1rxwL0gvlJbsMv8KxyH0zjvh3P2qvfko2w8a+0YRJoCwmw4+eYb2aFLmGcrwZxL
	 v+CDgxspdXnnvWcPQSK+ThcN503V4lLiSm9fSQrUOFUD5Htnlmzke7tqO3qcMzLZkr
	 fvZaArPcRaWQcdIUClqIt6Rj/l+GjDsS0asqmCPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3208/3318] nvmet: zns: reject a NUMD whose byte count wraps
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150455.986604750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 12740bec646dafe009a7d9a4d22d3495ef1ea5cd ]

Zone Management Receive computes its buffer size as (numd + 1) << 2 in
u32, in nvmet_bdev_validate_zone_mgmt_recv(),
nvmet_bdev_zone_zmgmt_recv_work() and
nvmet_bdev_execute_zone_mgmt_recv(). NUMD is a 32-bit dword count, so
any NUMD from 0x3fffffff up wraps.

The data length check in nvmet_bdev_execute_zone_mgmt_recv() sees the
same wrapped value, so such a command can pass it. A data length that
does not match the wrapped size is already rejected by that check, with
Data SGL Length Invalid.

Every site agrees on the wrapped size, so the target zeroes and fills
only that many bytes and nothing leaks, but it answers a command whose
NUMD asks for 4 GiB or more.

Reject a NUMD from U32_MAX / 4 up with Invalid Field at the start of
nvmet_bdev_execute_zone_mgmt_recv(), before this handler or its work
item computes the byte count. A size_t computation would still wrap on
32-bit kernels, where nvmet_check_transfer_len() and req->transfer_len
are 32 bits wide.

nvmet_io_cmd_transfer_len() in core.c, which the pci-epf transport uses
to size its buffer, computes the same expression before this handler
runs. Return 0 there for such a NUMD, so pci-epf allocates no buffer and
the handler then rejects the command.

Tested over the loop, tcp, rdma and fc transports with a zoned
null_blk namespace: a wrapping NUMD, sent with a data length that
matches the wrapped size, was accepted before this patch and now fails
with Invalid Field, while ordinary NUMD values still succeed. The core.c
change only affects pci-epf and is build-tested only.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c |  3 +++
 drivers/nvme/target/zns.c  | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e3dd453025751..7b24528174ca8 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -906,6 +906,9 @@ static u32 nvmet_io_cmd_transfer_len(struct nvmet_req *req)
 	case nvme_cmd_dsm:
 		return nvmet_dsm_len(req);
 	case nvme_cmd_zone_mgmt_recv:
+		/* The handler rejects a NUMD whose byte count would wrap. */
+		if (le32_to_cpu(req->cmd->zmr.numd) >= U32_MAX / 4)
+			return 0;
 		return (le32_to_cpu(req->cmd->zmr.numd) + 1) << 2;
 	default:
 		return 0;
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 34b30ec859c99..8f6909ef67ba5 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -323,9 +323,17 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
 void nvmet_bdev_execute_zone_mgmt_recv(struct nvmet_req *req)
 {
-	u32 out_bufsize = (le32_to_cpu(req->cmd->zmr.numd) + 1) << 2;
+	u32 numd = le32_to_cpu(req->cmd->zmr.numd);
+
+	/* From U32_MAX / 4 up, (numd + 1) << 2 wraps here and in the work. */
+	if (numd >= U32_MAX / 4) {
+		req->error_loc = offsetof(struct nvme_zone_mgmt_recv_cmd, numd);
+		nvmet_req_complete(req,
+				   NVME_SC_INVALID_FIELD | NVME_STATUS_DNR);
+		return;
+	}
 
-	if (!nvmet_check_transfer_len(req, out_bufsize))
+	if (!nvmet_check_transfer_len(req, (numd + 1) << 2))
 		return;
 
 	INIT_WORK(&req->z.zmgmt_work, nvmet_bdev_zone_zmgmt_recv_work);
-- 
2.53.0



