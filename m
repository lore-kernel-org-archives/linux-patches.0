Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F24288B2;
	Sat, 12 Sep 2026 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208946; cv=none; b=MjE+FeRYUSiHFA9xedE/W5wB2GiDW9G9vAHUEWsb5qimtHLzQpYCLfh9a4N5Drx0Q8sIWtT7IJTXOCC9sO4su/N3J7yK5EUoDicJh3rE4R5gbA+R4OjmdrJehO5ayTyzjp4UTXmUb+xIPuelpCk9jMbb3Si1DWKXUTPFZv2tby8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208946; c=relaxed/simple;
	bh=qiNopt7HA1NA4A4fVcHWM2bJCHgimWqVtygY0qZuB64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHKGt6xi3QqhiygSqI6bMyGUTjDHFfcsiPxgCQtA3Bgrd3p7+f5qtnV+WWIntTCB1zdpPGGe3HNv6ULOhKcVAQ3nrHf/kF2qYv0BXVDfx8Dm/ZcUzMI0dBiM+gZjqItfgdIGIlffcIa8U1EgLZVsetEWz4iGjQme25/cVqtoAAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waeu97gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waeu97gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98431F000FF;
	Sat, 12 Sep 2026 10:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208945;
	bh=bN3eu58rBtpwvSadNiO1TK/a6ApJRuv+jpHDbnCoRJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waeu97gmul4btWJm27f1XhK0yg6oU/l6Ph/LQSX3/gaqxsffBGlfqZm/27PF9uZab
	 Kr6ZC/XiiLc9d28HSYqDViLMHcp0pYg3GbeCGf/1MOI6et5U7ETKaX4jJPf6NFVIWx
	 lxwy5Cf5sJKnscyLzSFxNZAkBsZHINNUd6rHk/N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0720/1518] powerpc/44x: Set GPIO chip parent
Date: Sat, 12 Sep 2026 08:48:09 +0200
Message-ID: <20260912065639.722722159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b9254d222d0b38cc6f7b73119fad6316f65278be ]

The PPC4xx GPIO driver stopped assigning an explicit parent
to the gpio_chip when it moved away from of_mm_gpiochip_add_data().

Restore that association from the platform device so OF GPIO lookup
can match phandles to the registered gpiochip.

Tested on: Cisco MX60W. No more probe deferral.

Assisted-by: Codex:GPT-5.5
Fixes: 1044dbaf2a77 ("powerpc/44x: Change GPIO driver to a proper platform driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260517063754.21819-1-rosenp@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/44x/gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/44x/gpio.c b/arch/powerpc/platforms/44x/gpio.c
index aea0d913b59d0..4413a94cf7a6a 100644
--- a/arch/powerpc/platforms/44x/gpio.c
+++ b/arch/powerpc/platforms/44x/gpio.c
@@ -169,6 +169,7 @@ static int ppc4xx_gpio_probe(struct platform_device *ofdev)
 
 	gc = &chip->gc;
 
+	gc->parent = dev;
 	gc->base = -1;
 	gc->ngpio = 32;
 	gc->direction_input = ppc4xx_gpio_dir_in;
-- 
2.53.0



