Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050593;
	b=qpClA1ou1IeVhp3TWq47ceaBJzBp+eQDShuXUf2KV7C6xgI+csy5X6avugyNtXxSQ/Tk
	 4YsotYJVHKLne+T9/VhIGBfKn7Ajhy98al1wtQhzkX7l2GW8yTEgi1RoDz8/hObEDZpLD
	 5JX+xox8EGTeLawZuUE1i5O1rgAmUbHB+uSJb/oj8IQ/0DL5mYit2wpRNzCSAKJsjQVfd
	 XFsIhotMdB3Iu7BcX3AZ3aXxiVnSFzS3yB9TaHKqhH02o/TksMKhGKqTQVuolAeMA2Vrl
	 x13NuOjOtIC5gr96NdPm1eP3sLrBDe5S1JAxytz5hqw8v2t9w/pB0DJcInUq8CEqCtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C+5gDTK2Wvv1Rg7D+PwsS3hv8Ri6SLouweqE6JL15pY=;
	b=E9txfF8PC+YExEuLXcTqFECVTKJKv0r2LMtqVYGazto+3Z4LBH5uC/oHylbZltIYoWA8
	 YxYRI/jygAu3uWJuQcrFehD55TCRZKxNLN+Z84ovtYm1jM2UqDtsFVzxqmqszmM5beqLW
	 x8uupxTeJRMSts1hDTaXOm2OWSTF2lddm3AxF1c7mIeKMRv2L1Kmdrzx3Yn97plBrzp3e
	 VNW64tkOAFcBw2Gso9a82FujBMOhQFCoLeeZBJS9EuArN/0kREZBr8vfGM7tg1735zW33
	 SrFsgEsSG643yhknJlkmV0yuxcGX3jXzUVHzGlz48fmaB9hPKqEa2kW+eciT/Zk8DWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6Lag+xX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897BB606A325;
	Thu, 19 Nov 2026 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6Lag+xX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8851F000C4;
	Thu, 19 Nov 2026 01:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050593;
	bh=C+5gDTK2Wvv1Rg7D+PwsS3hv8Ri6SLouweqE6JL15pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6Lag+xXk3Jdmrz4ncD9+X4jK0an09z1Ct2w/SkkPwTOHj6Qmcd0eYS58ae4LybTq
	 Ccbcj1sWrh16VboKuRZ3vacM39ByMmZxazoSPLVil3vCClNoWedPul1Ic0vL9ZHBtm
	 wYV8YmLM6t2hLDfAekr8yWMToL5OEp42yHLZEcLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2764/2857] nvmet: zns: reject a NUMD whose byte count wraps
Date: Wed, 18 Nov 2026 16:03:18 +0100
Message-ID: <20261118150341.122909948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ca4fd4e88e116..9035c78fba75c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -905,6 +905,9 @@ static u32 nvmet_io_cmd_transfer_len(struct nvmet_req *req)
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
index 64ec757c7c23b..877d5f7ebc782 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -324,9 +324,17 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 
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



