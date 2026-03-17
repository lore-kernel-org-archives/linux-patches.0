Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FC73A4F46;
	Tue, 17 Mar 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767147; cv=none; b=u8UABz/Lct4aT+FH7ApVKfkrGDPPv5OT7Otlk8i0oiQHAq8PC6Wm3KUk3r33wvrGB1ZIJNLf2xaQgzUyL6LX95HUIAoONbiNSz/w23+lOl6Nt5W+ILTbhLYn5GnfyuBndakRX+kCUMeGDnLYHJr2Mdu5pLLfsXAMu/j3Fn4a8ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767147; c=relaxed/simple;
	bh=2JqNM4btoqd9upwBblMSGmmk6B/rDM4pecX0zGOKNZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRL+bBuJ2JiMl8k6NZOD+q9KEGoTGFaeXATZ2oWuc87h0aon47QtY+S53M3u11R6vH6ATvT1YK3dX4xk+YkrACMQlk8JGfTJsgSqnGbUUCbcwbqrk0dJ2SfEW3k+iCLZotZeYyfgD/+GbvaGwMf4CJX1VTM6Ya2VrQX9iCXVoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpm4f9m2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpm4f9m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2872C19424;
	Tue, 17 Mar 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767147;
	bh=2JqNM4btoqd9upwBblMSGmmk6B/rDM4pecX0zGOKNZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpm4f9m2Bxvr+vL1UHsrjlylIf69Zvr1Zg6YYDggalJUHMUlZU6TEExPMBj55Id33
	 wHkX0Nq0AQFJGhnqtW9w+Y2uohS+pZRQqxzgSgfrD9cF0qwFmQP47d5SEfswpnguv9
	 8R6QNLjBKKgS3GkFTzprRo9PtLYx8PxCHlfXFKqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Heiko Schocher <hs@nabladev.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/333] powerpc: 83xx: km83xx: Fix keymile vendor prefix
Date: Tue, 17 Mar 2026 17:30:53 +0100
Message-ID: <20260317163000.257781621@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



