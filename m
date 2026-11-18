Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018424;
	b=yHE0b8A17nDm4Lqs2jUS6D+2BKPf5EWAM1N17JykZle7mccA9D48zdq9B4zTlSg1Rsd/
	 M6y95/vetawiQUbRxmoS8IKxrq+cmBsK3jnw8544n2I292vkY88gq0vJ4vRJEJ89sRGQH
	 TjCODhAfJyX6rCLkd+1x/vv9ydt6tLYXQc6PEN8pFaoFQvu09W9j98uyhP3K3U+7+KD+J
	 cLKTIIAXXzwu2TJV7YJQ3Dx34nwQ96/rmn+78hjnlf7MAMnvQMkx8xOAv1GYCyBam2ugF
	 SNTo4xmY4bBQkXKnF5RsYg97SSi2qzg35W+NiyBHmiDta2PdE/LX34qvBASfokPLjcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSyhYI837nQpvsgsFDFxjsU22F0rJ/tiwh/ZX+qYWi0=;
	b=5a3hAYu9jLl9W3a/RN1h/pysIQC3oBqNh1UrQJQPK9MgAfTAiWrD0nZXcu9dprgp3Vhp
	 ecYgIZe4bXcBriChR8SJcI2bNwxfX7I4c900A/dgfnduOGfYYP/9Ql2HvOke+2MYXNoMx
	 LHIQpPwiLCvRNsmuFcJe8TwzLhYuwi3kyVITjbbAjVCSBEzxCwTK2KKylANFDRBclnqUW
	 w7OgzHISZ9Ad6x4jpaNV2Pbxf79gGkXfzAvSMJ8W4boo4GC2hjYTPFx5chGQ+3Z29mQ85
	 orFCbOl68x+V7i3qUsPRsp6R+A9A0MPFUg7IGcOztfn9cu7QOEek5MiKUi8k+P91ulw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrPGFF2L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F079606A320;
	Wed, 18 Nov 2026 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrPGFF2L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D371F000C5;
	Wed, 18 Nov 2026 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018423;
	bh=RSyhYI837nQpvsgsFDFxjsU22F0rJ/tiwh/ZX+qYWi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrPGFF2LVVCyj7JDvVuetnjOrazzi5f/6pP0NZGSeMn2oPXmLK6t04flbWjHqW92g
	 MEC2lWv0g1vMJeJRGXUUWShvL0/ZC7d9Gzd1E/8JP+Tn1tAI0kcvJ/9ivt58/iBjv8
	 4JkuJECZMM2yocW7y4KbSkiqpWG1AsD6w7OoTJAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1218/2651] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150331.853991574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3346562275f80..0702588ac60fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8481,8 +8481,8 @@ static int __init scsi_debug_init(void)
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



