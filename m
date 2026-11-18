Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059769;
	b=aGsrd1ingzBXH0+dpV6qybRxLhVvzT4vJtovBpWwO2XI9Cif+KmKPxelyFVrlQHpAync
	 q76LnhpDZQNl++o+1GzQuqBl7l4uyb9LcA2NKRAtfba7kQUYaf9aRcHm/wRDjRclm7Y2I
	 tESvKm0Y9ERLJ8RGNaSLIIfHYtto3M7B5ucmuKrmHzao9O4UjMhyhwhd72hijnsc5RtYT
	 fxmcdcn27//sSfJeAYV/dQhsLLw76WMTixRCUUZLWbNqU+x7bJlhYJwCFsbkjKdlosvBy
	 F8KuOBBPbjfyCl51CeOTdUS54i1dpOqmurnitwLeOJxZo8zoByc6kTbPx+tGg3Ynrtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ocb8rooMU3Z3Y3xasFmcq9dO46ME11z0M/D83xBUdwY=;
	b=dhXuBt4PJI6M5/+pe0XykXJtRTq0NQEt+bY8Sf7ZnvCKRD7g8FkHsFPVQEC3R5r2CxIu
	 mj3m1WGdAS9hG45O9YyHFeaQ+EUaQw4iulyrGJkDfDsFTUgDPzsJfSVR5Uv8acsEkOym8
	 hAsrnjpuWM5NIhD4rX7oH+v2RI/HeuPKeSkGryqQbYbtLkYibBzHzGMpQUdaRO29D94ti
	 ufzaUs1k+3QWgYBBUXyKjT7CTenPDbYwXOmr2lP2XZv1ONV47HUSHo9PndR4jO9WV0hOy
	 mPTj+XcPnhY3l87aFFHj5FOU+T4SxSoIwTbLpfpW35NVl7m4U4FajWCy8I5H/1VBsgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ki01L/KG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF93606A320;
	Thu, 19 Nov 2026 03:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ki01L/KG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B01F000C4;
	Thu, 19 Nov 2026 03:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059769;
	bh=Ocb8rooMU3Z3Y3xasFmcq9dO46ME11z0M/D83xBUdwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ki01L/KGV8EsRXZ7amhBxxHr9APWxz9s2670AEw9TWLe4wQ6z4FxZ0Tq+B51T1TQG
	 SEkbqWNxKDAUzo7ZqoIjez5edtre1A9uXIYkxnE9ttOE79Kd9Lt8ZjEK0xb2YAxPN1
	 kpkPXWd+WlsrhaGoZxX8Smt7iA12WCvukDu2Y8Hg=
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
Subject: [PATCH 5.10 0959/1848] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118145957.143369365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context around ufshcd_send_uic_cmd() instead of ufshcd_send_bsg_uic_cmd(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 4b2d4169073c7..86756da193ee2 100644
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



