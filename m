Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025240;
	b=oGXID4uC0R3dtJDVUQP6Cf3AL0otHJSL8LFwuOqEF9T1zzpkuPcbz/F1WWovynZbTgav
	 b/QH6A6sq/WNZTXA1jp1R9xfilg5Fhp5QB3DnbFAim16QTe9rufIIXGIyF6LQAQykqD79
	 JJzAWPtoKvckNhuu49QTwsD6HFM7KnWgnGJna9UGajafj1dWvPeCYwM7wCXwmHK7zBDJb
	 AqE8DijcGYsaiR8IOsg3zAF6UjLt70wo0G7gTWjdRweW5Cia9kLjiP+YBQ0NnoZB8su4h
	 ZskOupJYUHvnhNtkAR2l3tOK8RNEwIWryRn7meoZGUg6+KsOdy2FKdNLh7/bWyzF3sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mZZIRD8ZxwWLcxvky7xU0E85D+nxd0QkLjd2SNvQ7j8=;
	b=B9dzWjYhzV40B1HQEfrd2L4bdOFbeJBmbPZ9RybWGH5V2V1gciZ2vF7+jzKHnteIzsTx
	 +f5gfxAaNFj5pPpUBXksTR0C0eEoOSR1Mm6rXWtDwzJq0cd2HajLXevcTJSBWfNV9fpKK
	 QOPH+oLyAW43P9DeFiW3S8Hmv5IFBPhJR1779xNXb1Fa+jWyu6TsAC1y8ZlpKhX82BWbo
	 rKMMsRArKSip9Wcs8IUmrYSY7ImS4ybyCZM2ALpazgJLsP1ZX7t/Izet2aUo0zhLpTWuW
	 KtuusJoCwvryDzyLcQ1g/UPnCj2/IDAwEtVT5avz0gkbYJufVSmLzrRFDO0ZQ0FEFtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zsyek97J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4738E606A32F;
	Wed, 18 Nov 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zsyek97J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9F01F000C5;
	Wed, 18 Nov 2026 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025239;
	bh=mZZIRD8ZxwWLcxvky7xU0E85D+nxd0QkLjd2SNvQ7j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zsyek97JaMZUkKXyu/g90IHdOmwYko1t6NyVWK97uu8cTFeluC1mBD2GMhjQ+kOaL
	 QeYGxditEggjg8oG5RrsYhYvw4YqgWuvyko3H5yLMCm3H0a2tfK2TVMu12YEuiawyu
	 anEyWxxZ5CWnvo5gbr3cyadrpGF5mRPtLw57RoXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1008/2151] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118150159.155189404@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a349876633f7a583429367daf16f9a4282118255 ]

sdebug_init() refuses a physblk_exp above 15, but the parameter is a signed
int, so a negative value is accepted. The driver then shifts by it when it
builds the Block Limits VPD page, which is undefined behaviour, and READ
CAPACITY (16) reports an exponent of 15 for -1.

Refuse a negative value as well, and print it as a signed value.

Assisted-by: LLM
Fixes: ea61fca58c13 ("scsi_debug: Add support for physical block exponent and alignment")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-18-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4bb80f9dd67f5..168babffc146d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8503,8 +8503,8 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (sdebug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
+	if (sdebug_physblk_exp < 0 || sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %d\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-- 
2.53.0



