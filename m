Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037423;
	b=El+75ssGlCTnFL3YqBI1c6ikfFgFdTMyOzy12k0AC9cz/vJ3pDfwLe7FBJ8jyP71vRZG
	 /Iaw/TewyHrGbNXumYm6wj4rjP3snybYDK6zEQSOAljfCve9oPeFh2WeIkn1kkOna89Sh
	 zmnhdHLeL0Shfb8oONUw3h9JNJ25PJjPbvawLgqH/vrxm4dxP15XdkFaqxquXyDDXusUn
	 NR03JSBVZE/xQqy8jVcyRaNbQanwedD/1BP4WUCU1P4J9RFvHf3HNqF4ja7l689w9ftjw
	 f8eK0g5One7sXWUWwQNB0F3WAC9vvcYA5lafwI808AV7Mp6Wz5we//LcebZn4s7f5ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b2tLlqhNDCXOgBc8z24N+SJE/dhn6MMjM99eys1ktig=;
	b=GuoUypmGhnWDcVHOaXBWpKwQSuSgLwFOYGA1CEyyHttO8iTQ/S1/OjJSZvRChGKRW0c1
	 ObQJfqXyRT7lSla1Ic4DgceXY7WlHz6QbwyoIEN0GF7UxJbSu+xRy+pCCC/OoKcudSld0
	 VftDcGa9/0WWCMMV6xx/LAqN5bZYTxnNpi1hAWQ/EeYa7azJBM1XMWmpioYaSYQKMnxWh
	 8G6KpzjLQep+Dqr5yMSY1V7mA5dZFXpIGppe+WKN9uAaDS71jx9aBsb6yDUrRWw3crWAY
	 7G/SUTToYZvhM7WSxdOKiUNFwlmSoqP/tlhqZRCX7ulHsDlG4zkMh6mupNBG3ipXx5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B7xfd1nc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88971606A337;
	Wed, 18 Nov 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B7xfd1nc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26241F000C4;
	Wed, 18 Nov 2026 21:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037423;
	bh=b2tLlqhNDCXOgBc8z24N+SJE/dhn6MMjM99eys1ktig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7xfd1ncuI3gY6KiOO6YgdIZtuVyO0IlQ/8yylZnLzXF+OJkBIDSpluUdFSJpMgc0
	 6peVdnPoD/C2QNP7NvzpimV1bJ1qyF1aFN+/zCQTrv3cVBnwhYBUECSMvlq2CUT+aC
	 4XIrYl7ysW2uwB9pUeZDd6kSVcZR6EHjJ7XXo9bE=
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
Subject: [PATCH 6.6 1396/3318] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Wed, 18 Nov 2026 15:33:38 +0100
Message-ID: <20261118150402.472294926@linuxfoundation.org>
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
index d3e929d084221..a9e1d31725d91 100644
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



