Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A6C313535;
	Mon, 13 Apr 2026 16:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098715; cv=none; b=FScv8r9/Mm+Vp37tTxP9b6fNJvKGRHQoIeC6rRRyQfXeSVnX6HMNr/A3ldOidswBJJoDiw7VHksQuKZLQ2UlnNSNagEYi6dFerHF6FrXc+X74qZ/1IuoBGjpuEEfHfaaNieVfpSVsBJQVQVXaBKpbMBqTDTcWFseUjGXRwlTB+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098715; c=relaxed/simple;
	bh=Jo3gQqMGp0nABjWD39TwZefsq6C3S0b5INq8LmhA7WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeQXqRoMJ6Vc7lPpU59Z8v42+/BGc9o7nha1vLZICCmomYh5XKSeK9zObIUgzj3toaX+mV7YJlWUUrJCM+1W9estQeZa+gDdabAW4uKGaMrJQipz3ecBcFbR+KLQqwRRliNtK9wUvUVl734fsm+99YugphUKKFEXv0Dy3gs8lng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFNhIbEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFNhIbEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C3BC2BCAF;
	Mon, 13 Apr 2026 16:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098714;
	bh=Jo3gQqMGp0nABjWD39TwZefsq6C3S0b5INq8LmhA7WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFNhIbECcFqMkzPgnumqSvykAhSkbMWUNRoiv5jCZpKncq1mhpGkoaiJ11RrVc5ws
	 ZsogQLqxwgfF59xqmky9kTCvMkqZkZHjqsPcmF1pB/nQnHH9+Eoa9cGxkR+f758k5L
	 Z1D6FkvSrAMl4j0dlmPg81vFgoODhOnFxIlDcDn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Heiko Schocher <hs@nabladev.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/491] powerpc: 83xx: km83xx: Fix keymile vendor prefix
Date: Mon, 13 Apr 2026 17:55:05 +0200
Message-ID: <20260413155821.295805979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bcdc2c203ec93..e108d316a744e 100644
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



