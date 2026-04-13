Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E962FFFBE;
	Mon, 13 Apr 2026 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097345; cv=none; b=HD3404lC4E5Hqnz31yP8YEuE+aTPhN9soDuR30V2kyZddyPlO4kCTs7EFTW5rTMRyYhNx8gEoJmYO5aHRYUeTPVHVsL3dZ5eCHHam1sy7CRgW/iYM+XQ3FwU9NieasCE4W2+Ro9bGSGMrIfumXqf426vUl5s1mXKDcaXvehtA90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097345; c=relaxed/simple;
	bh=NwTBfV+IB8VQZt8ttQ4WtaW9v75Y6ZhgnajpCWmsxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkokB6hgyd33eb6Am2Y8uOpn20SVSix5q/kJ/IFDLof2aVJeBL8DBAnno2U3AtdCFmo93MDrdiaHxpmcTVbLHdlQeaX4D88kRb2J/Ybls2mFB1DV8oWJt++16lcfYY/zc9VKgGHA8XIfe7zoJXx6/S+/JDP38Jw4UM06JNePew4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPMWZgdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPMWZgdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9EAC2BCAF;
	Mon, 13 Apr 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097344;
	bh=NwTBfV+IB8VQZt8ttQ4WtaW9v75Y6ZhgnajpCWmsxnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPMWZgdnIsj/Jfpk+daWz1yHZQ88LdqYDNLqrFIFYNpHQpuK5/M1pzEreY0t4Wf15
	 TvS7ZmixVzJXcJSHaKl2c6U5Uewr5vScsex3ZeyVaVBTu/aqzR6grxrz0jUHLHBFGn
	 vE/M6K1KirSNl5G8869xiU/WNhlVogV6IGj0X74w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Heiko Schocher <hs@nabladev.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/570] powerpc: 83xx: km83xx: Fix keymile vendor prefix
Date: Mon, 13 Apr 2026 17:53:52 +0200
Message-ID: <20260413155834.227824733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 108e1e4d2683e..fa6a022892e63 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -156,8 +156,8 @@ machine_device_initcall(mpc83xx_km, mpc83xx_declare_of_platform_devices);
 
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



