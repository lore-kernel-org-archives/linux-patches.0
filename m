Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590986;
	b=uQ194+bD4RWYTVybIIeeyDTwz7s6yaiZPwaXkrpi8s80MzuahSmfwSzNjBrgvli1Mr+i
	 AE8ZUX1oq0qonMnN2/+cPaTchonl73i4C+XHmENCs+e5f7TDz1HWbDyDCU0Hx9g8lUjb+
	 RnQnq9iwrTv5h/QkBfhZ0XxfXHTcz8JzQ94h12lhZCm+zROTbTSw90SlE5m6YzuR0Bs35
	 laGIilERdusAkHr2iKxl4/j6TK/bJdAYoMGuHjH2MZklkdtd8bTwX7gbK7TCIZKrC3wix
	 F4+j5yfcub5zjx04Cg/V7pHbFp5rKY5I6xDk1yoh19+gDmqIO8ZcgwHqe/K63X4Nhyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fUxEvz2voCpzgI6nsqh+LM2mCXXToXZZYkJWMbGWFUo=;
	b=p541v7y0+qR7vf0Jtab2XPXryEaVweq/N9ISfwT07Wzg1+UHg9kEuM4+r8CsfVaEOrel
	 JJnHbcjsDHB91qbYlMSGOhH7Taaz+Svtbkd9DlGKw65Q9w0U/8DyUa1KkehWoTl7Nvg3L
	 c1VRayJmYuyw+01aTesjKOVMZbMu4ybD70zaE0W81CdKoJSQRbiz5uZdtlxo8n+oVMZOq
	 tPtDDgdTBdIDfmAsYtMmPebGNnzAJcK78YPyRY+KDGE5IrJSLYa9spJeXQnbRKdIHl4lE
	 JRa+RyuyN1R2RoDpcO67ktkv5TcIquUAKQLEK33GqtcMuOddiZuARNLSEg/W6y3APyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTqWZa8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356FF606F728;
	Fri, 13 Nov 2026 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTqWZa8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1AD1F000C4;
	Fri, 13 Nov 2026 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590986;
	bh=fUxEvz2voCpzgI6nsqh+LM2mCXXToXZZYkJWMbGWFUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTqWZa8+NzHYv92n2bviUDTUVnMd8nYACAZmzkpqrRlUBQAFqe6CrQMzFQ1l/reTk
	 giviHZ+jl726crPvki10z8EauEcEVdsdTqIZ0Lk1fn89+Kt2nmFv9WUXL6DikjV2mI
	 yHh7AQbj5r3oIJ2yrUUNajoxWyx/3jxBAPEYWa1g=
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
Subject: [PATCH 6.12 162/670] scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
Date: Fri, 13 Nov 2026 10:45:26 -0500
Message-ID: <20261113153817.587977845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



