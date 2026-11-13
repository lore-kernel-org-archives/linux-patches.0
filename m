Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590159;
	b=hUKfihKJsDoNx1h74rZgOLC+O4w2j2gOlPS4STbwfjRzvTUxgiF3VYAJBT4LYFwhiyA0
	 Rb4I2Ujjs91nHoUZgsZ3Udvbi+8R90pDGD7u6ocLilHEAn9vX3AfswhxHuW1VvUBk+GQR
	 fLZFcbYhbI5dS/n4r6IrD00OjPFg6DG/QW7Dnof1l7qSJkBX2VOcl2p7uE6Mc796fv64B
	 fVLbmylS6pp5rX5B4OPaoG+4bfNqqj4rsoTuWcE6vbk8SfqDf/vZTqDYbmkk8hBUC8w8a
	 jC7EO/D8Poh6wRhX4QnojgiiIQX45VBv5oz21fUl4KWyr3RXeCwwYnPJbVaqODR14Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4X7FNBEopkGcDPwJ+7AQaPq0r0bw5OsrLAn9VOXEnQ=;
	b=t//tmJuBFzqQQOOpVBXY+NaOdIjkRxgkG5kuiNbtlI5H042Y+FbXnj5qZewnDWPgtnGM
	 IpzXCCVkAHciyjKp4Ly9sCqPrv5FJCzFdNoYPuooKjJfvz/nsvs0HC5t7SHfGHPJjUfLK
	 g36Q2pJ6N65Nqeykfc9YbITCTM6ny1m3vf4ceDR2nXKTAY8Qo7zpzb8cfGtpSzGhclJlQ
	 uvJkHr+aOgX0+JIzJBYFqQJ8JBEzL3yhXVRzW3VoCbrTPY1u+G3jARtvL43k8Rawg2nMz
	 6WnRejCjc8BORG2G6Dy33RHHP7So/JNV82kDZq2rdO35EslECpegGhj4qD3fqHjVuXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znTAmbt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12980606D4B2;
	Fri, 13 Nov 2026 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znTAmbt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84181F000C4;
	Fri, 13 Nov 2026 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590158;
	bh=a4X7FNBEopkGcDPwJ+7AQaPq0r0bw5OsrLAn9VOXEnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znTAmbt7MHY2HSzmcAlFESBV/nYLjSiTOiRoV2v4q3dY/rfmWEuXCr/JepaNPB8Uc
	 l+ShxUNsUOfvHMnP03wyStf9HZ1iBC7HhuHP5NOS+VKMRkdk6rpsablKY91b898raA
	 8qwWYIR64XL2Vz3ogdly0uQE6RsMvWeunk+/a7mM=
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
Subject: [PATCH 6.18 171/686] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Fri, 13 Nov 2026 10:45:04 -0500
Message-ID: <20261113153826.768512303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 36def5ef24d62..59a473261ae16 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -178,6 +178,10 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
+		if (uc.argument2 & MASK_UIC_COMMAND_RESULT) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
-- 
2.53.0



