Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028087;
	b=MmgDspteUesIPz9WFtvvxTfQul1SrDOW+JJrrbk0h6z/2wS8kPyCsEY86pZULuk3YmoX
	 3d3xROp1JcW9aHAU1B4ljzxwMqor1nJSeRhaM/40bJSS0K8onu04dQ6RByBm2indsxr5Z
	 hmAKBRK7OQk7x3/ugZ/BVPIfbnzMnCkVkllPd0g71sUSOzSVjjmXHgba3DAkUirbUwWJU
	 LMuV2U49n8AGM/K9+iogBWMPECTvmLAUkgbEeZH/BHkFn1DcNcki6D9t+qZgSWaaBndfI
	 9ZDP3zQm61SEMxccs2VlQEcxYoxPN5tnOBsReXDfmT6S3Otp5l0bUEv+3i09/LgSCBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ANfYwpMKUewAAnpEU+m4RrD3CzkR9fi1aEtKTI8pIvI=;
	b=zaMXR+4fxpoYwWSL/UBRViYAADOueuAjE9IG7x/xaL0UkUNnGtO6NtyaIN4TeACetJvZ
	 xmFvt9zvOS4qbtrynIZrNAFa0SIyE+M0adclranYX6q2ErqXLsJbDJqnKNYYe+682LIK4
	 SnVpmSX20swhP0JKuVkhdebp9BBaX7OyVpz2wc1ZlnlKiQI0tVaoGh037oS2C5si4mTgF
	 smpAnSsWIM1i1cK4ad0qjjqVu/mVgHusjehpChqHtz6W5+Nub/2B6mWUxhE9NjDzf9jg7
	 E2yPCzUaFF5Dls1UShDwbr0G9iXXJHRx5UK/ZETFOjrt624dMn9a+Z/IBAs2RFBMoqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqJ4mNmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E70606A31C;
	Wed, 18 Nov 2026 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqJ4mNmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9175D1F000C4;
	Wed, 18 Nov 2026 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028087;
	bh=ANfYwpMKUewAAnpEU+m4RrD3CzkR9fi1aEtKTI8pIvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqJ4mNmV3JTAAL8Kbot2+ct1IoecDKJKjyttW4x2au5XvM/cBjkxo3k/JZak7N2fO
	 J9FFLXzxjX9R0f6bODZyTQRXcoOld+5/Imlr94EC49NS/LX/mLToPYArcT3bje+Nld
	 PaTX8U5kBJAgJ5jRerp4pxxDmplzkFe8Cyy5gsQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2020/2151] nvmet: zns: reject a NUMD whose byte count wraps
Date: Wed, 18 Nov 2026 16:02:35 +0100
Message-ID: <20261118150235.319773177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 36b3dab59e212..f6e3ae9e54bcd 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1075,6 +1075,9 @@ static u32 nvmet_io_cmd_transfer_len(struct nvmet_req *req)
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
index 00f694ac3986c..577759f1a4e18 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -319,9 +319,17 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
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



