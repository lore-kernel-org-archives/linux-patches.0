Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974EA369990;
	Sat, 12 Sep 2026 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200748; cv=none; b=EP6Oui1gaPXncM3aG/Py/WpmGlygnN27NinVzVl38SkT1ybOA72aQTxyW2Ly5exz7GhOnCBzvVnNcFFPPgRBTMrL5xtTJP1i82yX4NbbBC5SzfWHKoYaBHKR93koVh0s3ekidtJDDrU0R6tUoKt9sKKAv7Eud6jsW230lVr7r9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200748; c=relaxed/simple;
	bh=7CXqY+F7WsV6OOQWwa3WQiK+Fg2WT4j1YfHLettXh88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF6feffC0cVL9SNd0k8CEDLa9MSTaBYJ+OyQy6bRXmVs3+kxINNSO0GjRO6orUmJHwCHhifnSak1CvSgCH1JxW6Vkm8njz1PX25wu/0Gdw8bH9tHC8gW8ME68T7bcI6uH+S0aOoN6PBegupegeZIRf+Bfn41VfLQ+iKrMhI5oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYqsBlYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYqsBlYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0191F00898;
	Sat, 12 Sep 2026 08:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200747;
	bh=ZOaYEwgvl1wLAav1EZqz70pf/8YWTb06I4Gz7OkB9n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYqsBlYEnPt8Lkpoyn/LKKfUkH0l6zI1meViZz7B4OWwiDRWSynj9GyjEPpHRMG5L
	 gDCsderHYwB4LWx2iZAkpegIikQbTNDMsU3zucpDRsWBF4v2inPKaMVoLbTZQFtz8P
	 wdbznggnJqy5eO0R+fPQGeYCF80Omd5F7jtWtG9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0853/1815] powerpc/44x: Set GPIO chip parent
Date: Sat, 12 Sep 2026 08:43:23 +0200
Message-ID: <20260912065708.945266310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



