Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B8327B340;
	Mon, 23 Mar 2026 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282445; cv=none; b=Je8f7I5enZjFzhbGrh4wkaPvP2VT4j4PsA3hzaN+LrpGeV3fMdWApGUBSgy9tbGqG8gR94Cjfb8A8TvcQL1UQSfBVpt0ANh1j/VaGttqE9CmPAZ7nbXwhWC9I+Mi/Fn3dR6QmSt1vBb67BI+yr/KJtnxD3Q0sph906YHCslRQBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282445; c=relaxed/simple;
	bh=fXkXL0g83ZznkRuookI7oMd6WuWTNtb/pcI+nXB0DMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvBkXyo8TryPdJB5hHbTdn9BQ3gVmw041EnyGIjle80x1ytNvkL9mvIAGkhfmGDy/krc4mE2frOTeiFg8Y7ZF9UwOgRGh7Zy4r/JOKo24N2kBK+iz+WG+jdo0AtKQUl4u6hgTQ70Gz5/XdGXq3p0FkdZuEaBc6j979ygMm7KFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zONMnbpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zONMnbpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69CC4CEF7;
	Mon, 23 Mar 2026 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282445;
	bh=fXkXL0g83ZznkRuookI7oMd6WuWTNtb/pcI+nXB0DMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zONMnbpjqv0M6DMvhlkJk+xKbs8OBa9kNBM3e3Kd/uMzy0ukXQtrFgr1UdOLv4y7d
	 JaPe6xndunf66J4uQ7gt51gs+6ipd5gqBbX13C99QoPlqr2YufIKNuR1f/p0tjNBBe
	 g/hMfk+ELb6MaDiCgOb6iY+rAUnKrSHhG3+Aj7mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Heiko Schocher <hs@nabladev.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/481] powerpc: 83xx: km83xx: Fix keymile vendor prefix
Date: Mon, 23 Mar 2026 14:42:21 +0100
Message-ID: <20260323134529.109651715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 907acdecc94af..25135a1518fc8 100644
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



