Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622329;
	b=grZdps52+o9T8uhpwrAoAJ540JJToleabO+9KDOyrmHIh++FHuzIMypUiwTgN5JUGfAf
	 lo1AjeaxMFf3J/z8Frlj1s22ex5g4gphlnMfdmBV/NOfIWSvUJlFIv0vDjCuR4ipb/FvR
	 O6C5nwjDC1rsdl1MWKxE+/HPAbKEovOV8h7iHKWWKP9pu4FSg/ZpaOc3BIoShX4+DiQ81
	 YLfUmkyEnN0FDsNZeJ1+V+mJ4xUpaM4RteSDnFE7G3S2ReZJsahyTNCa2T4BrkQJKxLw3
	 /GIdob5RyEyEsm31yP8cnMCwXXrRg81t91/Iwr3ZfJ/KDpHN62uLYhQq4iKJ9Erx2uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VZV5jtBpVZCuefBInyCEeMRFeOkz6WnAWa/jl5PRdSs=;
	b=T/j1zxt9Sz+/VdsVp+sh1/b9aa/w2PcTMH/WE3z3IZB6uohcERp6VeRutM92EvPDp/Ar
	 d732sHOxmGnMchZG+u40liXBl3FhorZLfV6sBwx1xPfg+iSJSOifNxglDxEvyO1omaWHl
	 mqLAul//j11s8c/7j1lEqIjh9dyWLJBPYDj1kypz4co/O4Te/DY/zIWajbzof1+/I/1ok
	 xF6e49sPXaJbfMPGXLgg412N6eG/L4BnccNllREHffvvTGpuhzH7MYrUHBiPtTvYh+vXN
	 05zpOWV1O1Bip4iwCDBZ5/8t5VLQZbrAN2AgF4xNPsid9h9Z6TwT3TM7/XBNtIKVC6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4OZp4LO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CC606A326;
	Wed, 25 Nov 2026 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4OZp4LO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17DE1F000C4;
	Wed, 25 Nov 2026 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622329;
	bh=VZV5jtBpVZCuefBInyCEeMRFeOkz6WnAWa/jl5PRdSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4OZp4LOXhE7zTJVshNJkWRRfc7KQNBxPzHUvV0BdHHVB9tuN4g6B8PfIfjakQJKO
	 XAT2qfLY6tXcRF73CoxjT6cv3DjisMQvdpUqKMLfPxE/nZ9BDrGZnZrF60dclcgDV7
	 n14q2ruRSyiBn3TLsjFYn4eGB+w+B9aPiwK6fkho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/990] drm/i915/display: Disable pipe joiner on WCL
Date: Wed, 25 Nov 2026 15:31:03 +0100
Message-ID: <20261125143833.713815124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Srinivas <vidya.srinivas@intel.com>

[ Upstream commit b42b656db1384255044754cd2163d370d766b776 ]

Pipe joining is not supported in the WCL display configuration.
Report no joiner support on WCL so that modes which would require
joining are rejected, matching the 4k 60Hz maximum resolution
documented for the platform.

v2: Rebase onto latest upstream
v3: Fix up the commit message
v4: Split the scaler and joiner changes into separate patches (Jani)

Bspec: 74286
Fixes: f8e1c3e07db1 ("drm/i915/xe3lpd: Add support for display version 30.02")
Cc: stable@vger.kernel.org
Suggested-by: Charlton Lin <charlton.lin@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patch.msgid.link/20261028070404.1913843-3-vidya.srinivas@intel.com
(cherry picked from commit 917676a55a690319a01b45d3956eaf94ba564df8)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
[ sashal: Dropped the unrelated eDP VBT pipe_joiner_enable check from the context, since this branch lacks it, and applied only the WCL DISPLAY_VERx100 != 3002 condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 84fca860c93ee..27bd54c4b4e63 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -490,9 +490,9 @@ bool intel_dp_has_joiner(struct intel_dp *intel_dp)
 	if (intel_dp->mso_link_count)
 		return false;
 
-	return DISPLAY_VER(display) >= 12 ||
+	return ((DISPLAY_VER(display) >= 12 && DISPLAY_VERx100(display) != 3002) ||
 		(DISPLAY_VER(display) == 11 &&
-		 encoder->port != PORT_A);
+		 encoder->port != PORT_A));
 }
 
 static int dg2_max_source_rate(struct intel_dp *intel_dp)
-- 
2.53.0



