Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456462F83A2;
	Tue, 17 Mar 2026 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765513; cv=none; b=UAQ3bGBnXTyqkiHqXqaQioIBHX+qLj4NoS7+pWHjFufyOTnEI+qzIrk7GB1alb4MC9nSg7Jva1ENgau1nKh0GiZXsGdNU9HfYZr7BGOIbggijPJPxFzziDm/WRDGuZsXu43+wTfmFHLbxVcp2zKkDxxD8zHM9tjS3rYgaGDx7FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765513; c=relaxed/simple;
	bh=ENmC2T0AhyMXKv6lRNRygBtXvMg/Edl85gJrYEUqg7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNRAgftmOlwA+X+fbTCNeIEZ0di0g9oe6obeUEZXrTnBtEB/iYQv+FbUNgJlK1ZlGZmlhbpLPG1u81qQD57WUtLMYOMh8AmWaDdzHAdAfyaQKk41RGF4KrEjMt6iqoLoVZsUc6D5SQWS6vww0xSPexchKxBvgHNm/npborqiA6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf0xVBef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf0xVBef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A26C4CEF7;
	Tue, 17 Mar 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765513;
	bh=ENmC2T0AhyMXKv6lRNRygBtXvMg/Edl85gJrYEUqg7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf0xVBefD6dpAz8PuUa31GiKofVWojRCMWYyvnthZ9IJ4yNDXtkAmCZaXm1HAbTV2
	 0WaOgAF0M0Sq2+5EgNkqh5qMoabmxXXVOAQ1dUGuegOcr/8mI481KjgVgg9qO1r4AT
	 sGqTBb8j1a4Asvk0aYB8wbyaxdb2Y4YsuQTsdufQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Heiko Schocher <hs@nabladev.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 007/378] powerpc: 83xx: km83xx: Fix keymile vendor prefix
Date: Tue, 17 Mar 2026 17:29:24 +0100
Message-ID: <20260317163007.240463183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Neuschäfer <j.ne@posteo.net>

[ Upstream commit 691417ffe7821721e0a28bd25ad8c0dc0d4ae4ad ]

When kmeter.c was refactored into km83xx.c in 2011, the "keymile" vendor
prefix was changed to upper-case "Keymile". The devicetree at
arch/powerpc/boot/dts/kmeter1.dts never underwent the same change,
suggesting that this was simply a mistake.

Fixes: 93e2b95c81042d ("powerpc/83xx: rename and update kmeter1")
Signed-off-by: J. Neuschäfer <j.ne@posteo.net>
Reviewed-by: Heiko Schocher <hs@nabladev.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260303-keymile-v1-1-463a11e71702@posteo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/83xx/km83xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index 2b5d187d9b62d..9ef8fb39dd1b1 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -155,8 +155,8 @@ machine_device_initcall(mpc83xx_km, mpc83xx_declare_of_platform_devices);
 
 /* list of the supported boards */
 static char *board[] __initdata = {
-	"Keymile,KMETER1",
-	"Keymile,kmpbec8321",
+	"keymile,KMETER1",
+	"keymile,kmpbec8321",
 	NULL
 };
 
-- 
2.51.0



