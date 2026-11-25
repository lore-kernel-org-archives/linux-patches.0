Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617716;
	b=mf15UkJG31LVDDl0bjR3sB+fgdzvFmgYJ/saACJygUi9UGwnqoQ9f4zbPEv5T9x6Cqxm
	 5de2sQJiiwpUBBcEMZmlrbbS7U46CcZRvROSYRHdP/70ojmh/oXrLOVMwBKjmkT/5GkxN
	 AJbvcNV6oXmkx9LWgX/gg5iCUsNGLDObs9CBRP3AwXAxc4M6EAphuB/hOt+P8zxjFoQ8K
	 DGhlEYbVXUacwdOFY4FNdw05fXdhn4SMXdNdeAsShUenoOpcbHRh20PJHl71WqDu6Homc
	 dsRjFspvzBZKiWGkDqoleA0/6qf+MHHu3e++GnaUbyJVyMfgWcaMeIq+4vO9Jcjebpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXKcuQG58uJZbXlwbxK/zYNHAdJDwIE5tKtQvvubG+g=;
	b=NKQV52/xutpJPS4QgRBW3346VNEO86uC1CoeAQ7NkIzs24LNouGGXlx6EN6UHlo/Vl9p
	 2guq6vZVsh/jfiGzTfyEzqiNupkXfbZZUBPlV+fvp8Yvxo7CaRYVR+YQpEaoFW3UmZyLQ
	 PqWUCJzPhXp3yC14K3IA0wJafacJcd8dlC2mISiGxeOL0mPWtMI2sKQd4+UISs6QMa9fW
	 OooKFKHNz7NjDv9C2T6E706shSYNKXq5CQtItWCEO5U4a0vCzD5k62G1s369L7lGwdsdq
	 xk78KLZbohLThftQtA71j5nHfQq9RrGLbwHv6iDZq0VXa50qfFt+dPzN7YD/vhynqfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXbkMJG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD0606A31E;
	Wed, 25 Nov 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dXbkMJG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755421F000C0;
	Wed, 25 Nov 2026 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617716;
	bh=WXKcuQG58uJZbXlwbxK/zYNHAdJDwIE5tKtQvvubG+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXbkMJG8bek1IvKE2m7zihbaNNeitT41y8TBbBk0+oF3EnhMEU9pYXbnq98Mls6Sh
	 IKgEaCAwS4JeKI58fD3xpumn+JpJVcwMpuiMyA3HT7CCGqeMaalAcG4cik6SrqBqQ0
	 c/IAE15OM20NFUgB/XRGz1zJKWOmB/WVRX+lIyvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0051/1005] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Wed, 25 Nov 2026 15:23:09 +0100
Message-ID: <20261125143822.935236050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 9a2690eb4bbea8d7fbc3dfe478fca75fe956abb4 ]

The REQUEST SENSE length was taken from sg->len after the AHC_DMA_LAST_SEG
flag was or-ed in and the value converted to little-endian, so the 8-bit
field is 0x80 on big-endian hosts and the target is asked for 128 bytes
into a 32-byte buffer. Use the buffer size, as aic79xx does. On an SGI O2
with a Fujitsu MAX3147NC, the sense data of its CHECK CONDITIONs during
probe was lost.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Link: https://patch.msgid.link/20261013094253.2956-1-kaloz@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 8ad82171e925d..af6115bfb2808 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1097,7 +1097,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 				sc->byte2 = SCB_GET_LUN(scb) << 5;
 			sc->unused[0] = 0;
 			sc->unused[1] = 0;
-			sc->length = sg->len;
+			sc->length = ahc_get_sense_bufsize(ahc, scb);
 			sc->control = 0;
 
 			/*
-- 
2.53.0



