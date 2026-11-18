Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040652;
	b=txcVT6ek6CsgtZhObneQY5PbajFHiSl+2M3lntq7fUfq1pumU6SkWzymqI8q99tVHChp
	 fPCuvFwzc7s3kW+x2LYJBkzHsk8y2TNZCPz0HletePrWnjKqsl2RXULUpwldrdbVexBfj
	 boBPIZWE6bvdUl+E6J2Vk/4cH56XzRXveUol/4rUhgOiUypehhgv9VFmOLz6ZWRVPPvpw
	 MCREr7wbCyllxgMLqfJMlUyq7AE7cPUi1huqduZBbrQ8XjWZgMzcEzIKUlGZFKwOqGM5J
	 KEZ5gK+g7yHmaWBBALrRHuEj6WUHlZz9FOSCsEGIly3bOwEOFcTqWCiuZXANfl+PDvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JX0genVEPoDLTFuLPpOtO+It2dVjKzpyNr73gxaDvo=;
	b=bbodOIsfDqYMr4e1esA1QaZekzV7CBQqo6d1uG1+cIrs44+ueV6kzCNSABof7tEiLDnC
	 l5bVz1Zpru1ThcZ6sEPOyaTYun+RkjO/L9k2NVIH088sKb/HEuT7aSC1t72uVZAvVYewl
	 6IQdDrAdet9xHbZ1b48mhYqzGBMEZlFaDj6WXKpWW1qRNfJXjiecv3XtxjaPTkLLLtHvL
	 VjcHhF4DeGaMzpLKqUYVv0UJZ4LN2ardCnRwJfcPp8KpKZ+olRKnnU2EnlLmPandzboWK
	 CPCD40H58F6VRL8L6pTxftWQFgnBEViXYI7ncdMgvflPADTnXsaJU2at5SBy6402qNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCNBzaL0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E51606A31C;
	Wed, 18 Nov 2026 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCNBzaL0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA621F000C4;
	Wed, 18 Nov 2026 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040652;
	bh=0JX0genVEPoDLTFuLPpOtO+It2dVjKzpyNr73gxaDvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCNBzaL0Q+K3QW/+DMJXh0+WzUfz8x2wsmCwu73wgcOXb1hH+elRbTET1MSESu+70
	 yOPFZk+7j3BGVZPDFsgleL8/NJnMQEPcWwBI0fi8ixkVP563qOIbZarhup29dSsqh0
	 10rDzFpkjihITNDcfKTkDsj+Lk5a/KAwYbOyK2Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2532/3318] scsi: scsi_debug: Refuse a negative physblk_exp
Date: Wed, 18 Nov 2026 15:52:34 +0100
Message-ID: <20261118150437.291955692@linuxfoundation.org>
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
index 5d8561ec323b9..f7a3c20a4acf7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6863,8 +6863,8 @@ static int __init scsi_debug_init(void)
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



