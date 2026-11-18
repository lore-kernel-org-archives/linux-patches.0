Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054099;
	b=JvST6TvWXYuDTloid396+H7c2Y6sK5qsYgXZJIhbpNiB70Mlo7+rJ7VE+2iUy+5UJ6Dy
	 qAKRWmJ2MRaMJPT4NxWzBbvtanBai/y2/740YzF1leV3WxjopzyTQ+DjLeROBZi3pS6CA
	 HK3b3JXVRkeD2LCADFLmtxym2ppIfs04JRl6RpI2cvO4FYOeux3/vMDRFm7IVk/HOUNa0
	 Qj/ihxgTAGFkXn7vPqTDcMQUKk041bqzx7gXAe0T7Et3TnjWjVC929TpJNVESyZFmZjnF
	 nh7inGMfzg+WSUGJ5QHZPsJep7R9k6Fu/G4jV16Ok48nuDz+REr2zYhmf4dbgw7dNag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBQQKNsM4Arx3vNVBtzDkZjkQNBaOL2ojqiRmvC6wLs=;
	b=PWnb5QpuNzm/teQ9mUi4xTcYlr5+iz6DzZnzlOvV39Z0B5OGaUX8P/JG/FW19TE0ptLP
	 vH3qzLbUzThTeGhHFeTVMCO/gKCP2113MwJ4JFkYfeZJKcmcdTSKCEpjRWNjja5dMRrah
	 2YlTCzngviQPUyRljpWPd6t9fGW6YcTbF2cGYZaVxNLnSh4HJnjkCzbDq52sIaM+2NHb0
	 +EfoRCv4x6QM4lEfoX6Xpm7uq9VkWpEPYlZG1JQnkepKZHd9DBhtZWliHrcXLaPhdkE37
	 R+DoriHLYx465bgu5ZIfyNoIamE+W+9JzGD36k+t7+Eg2M4spiqOf+sqOl4sbbJGkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pk9KvG6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BBB606A320;
	Thu, 19 Nov 2026 02:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pk9KvG6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE6C1F000C5;
	Thu, 19 Nov 2026 02:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054099;
	bh=bBQQKNsM4Arx3vNVBtzDkZjkQNBaOL2ojqiRmvC6wLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pk9KvG6IWMZKOTAirHP+Ddaflghb1ktiWT/uHHxjUq4l9NrIjyeHdlYMviegvsSmF
	 ZgIIS83jgz6BcULt/u5kIAVQ7ePx5+HjO8v66ONlPRaMCzXQ8/VRQZOops/H+fbstz
	 nqmysS6hDZ7mea/W3kZWrI0oB8SRcMc4I8ND4LD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1152/2214] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150058.072335106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 1ae42513205a38b811afedb6797f9f9c4de37b90 ]

ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
including the result byte (bits 7:0) that only the host controller
writes. A non-zero value triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
syzkaller.

Reject UIC commands that have the result byte set with -EINVAL.

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-5-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: adapted the patch to the older UFS source layout under the SCSI subsystem ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index e27b059ae2d1e..c7824287a691d 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -123,6 +123,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
+		if (uc.argument2 & MASK_UIC_COMMAND_RESULT) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = ufshcd_send_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev,
-- 
2.53.0



