Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAAA1AC8AE;
	Thu, 15 Aug 2024 14:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731105; cv=none; b=fvFrM4eSt21RZHBuDVmyZQbiQFkRaBMExj3woOUKZAfj0KAiaj16piwrQn8ZWve+L5pXM4My0dn6SJ1lys+2XkSvDU99wQhNYRLe7yx0WJ64Sl3Qoctmzvy2m9UM82WVcqhYuLB2XwFnmfhhxXwC0qkTfBPTgNkp0IZ3s7r5ifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731105; c=relaxed/simple;
	bh=Oa0uMVhkNDaQMKUgILujiFXoT+x92ZlKn0zr0rzb3wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHopTwQWdlpjI5D7crkfI03MxltXRpx0xEPFNuayzLOZaJoQO+3tViSCg6qnp08at5/h8jcbw2hQ2U6xq5N3/8LIPZ60cot/hGOHAxmr3IeLvfXtJAOFlTmCUT6CEhgBJu82O7DLoowVt6rAGAUPeDGv/WX/J2rDvl334zZLXuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9qMHymX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9qMHymX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2B7C32786;
	Thu, 15 Aug 2024 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731104;
	bh=Oa0uMVhkNDaQMKUgILujiFXoT+x92ZlKn0zr0rzb3wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9qMHymXBCwubGfaxZRv8t7XKSdHe3VQrFxp6Io8cplrVgmyynSYvGWdgCI+BcYqs
	 LWIp8mg7q7CVr71WPJDjsKyU75As2N+9gYLqXsaYfxqDX1bHC7xJBi29dTm799T0/j
	 +KE2fToMf2ehzTpJT7gLjHAgHYur59jacHG/FbKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicolas=20Pomar=C3=A8de?= <npomarede@corp.free.fr>,
	Christian Zietz <czietz@gmx.net>,
	Eero Tamminen <oak@helsinkinet.fi>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/259] m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages
Date: Thu, 15 Aug 2024 15:22:37 +0200
Message-ID: <20240815131903.730663659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eero Tamminen <oak@helsinkinet.fi>

[ Upstream commit f70065a9fd988983b2c693631b801f25a615fc04 ]

Avoid freeze on Atari TT / MegaSTe boot with continuous messages of:

	unexpected interrupt from 112

Which was due to VBL interrupt being enabled in SCU sys mask, but there
being no handler for that any more.

(Bug and fix were first verified on real Atari TT HW by Christian,
 this patch later on in Hatari emulator.)

Fixes: 1fa0b29f3a43f9dd ("fbdev: Kill Atari vblank cursor blinking")
Reported-by: Nicolas Pomarède <npomarede@corp.free.fr>
Closes: https://listengine.tuxfamily.org/lists.tuxfamily.org/hatari-devel/2024/06/msg00016.html
Closes: https://lore.kernel.org/all/9aa793d7-82ed-4fbd-bce5-60810d8a9119@helsinkinet.fi
Tested-by: Christian Zietz <czietz@gmx.net>
Signed-off-by: Eero Tamminen <oak@helsinkinet.fi>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240624144901.5236-1-oak@helsinkinet.fi
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/atari/ataints.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 56f02ea2c248d..715d1e0d973e6 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -302,11 +302,7 @@ void __init atari_init_IRQ(void)
 
 	if (ATARIHW_PRESENT(SCU)) {
 		/* init the SCU if present */
-		tt_scu.sys_mask = 0x10;		/* enable VBL (for the cursor) and
-									 * disable HSYNC interrupts (who
-									 * needs them?)  MFP and SCC are
-									 * enabled in VME mask
-									 */
+		tt_scu.sys_mask = 0x0;		/* disable all interrupts */
 		tt_scu.vme_mask = 0x60;		/* enable MFP and SCC ints */
 	} else {
 		/* If no SCU and no Hades, the HSYNC interrupt needs to be
-- 
2.43.0



