Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585475;
	b=M4Y4FVqW2QVHOHC5wy6+lR/OQ7ZVYRBUHix21v5c04fBJwLqwOhxswFRQkKmAnc0ksSG
	 AvIojL8cNbFr4DBG0yEMPfxE77XEjEg6kXqe6yw7aGr4FadtClkDcTF3nFvdXWuEuU9uk
	 jDUQK0/VbgjN1PsoGkUWTg8oKDAwGTUjhn9HNxey71Bp99MW0UzkLRW8lyNNZr/0+cnpx
	 MeHmhV7TzcRmyA5/mJE2o0+3LibWP1gpOeJsZh13r2mePtdIwKG3F7thX67udKwzNHAW0
	 UgWmvc/BvOy0keV6bT5ySJmO63rhtbxqUMO1EeTTEE4/c8dihVZF4LfZYlnuabwDmrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RCIchLjLdyNg3e3rQDAenYxYAwk6CzYTItc3Wi9sCns=;
	b=NB56DvUqaX7pT2qW+FU3fpSgAaJX3cE2k0CS372401NG0S4HZxipLoKFPJ6XFuh4pR2v
	 yw6266ddw7HDUZ/zOYDgZbVmk/cFb5b6lwhI0wGksMofeCkc6FtKu27Q15Tw4XihNCS/i
	 9rlSlX3AJ79Bo5GlP7Ct9qUp2UhaaiY2N+qiy+D6Wyi00DnhWg0K9Pm46nIcsmVIKfcDc
	 zkvKUT14JilzPlm2FjgwpQ9S6KzeUi4BefSr06jdNSYTfq7WGro/sNLEXfKnHseH5PCoL
	 oz4AU2XjwYby8ScEcSv6wRSts8J9VuKOW8yIrTR3UDcZcPfXAHyasfE5maqREhXjYig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0SyPkF+x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EC9606EB82;
	Fri, 13 Nov 2026 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0SyPkF+x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C721F000C4;
	Fri, 13 Nov 2026 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585475;
	bh=RCIchLjLdyNg3e3rQDAenYxYAwk6CzYTItc3Wi9sCns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SyPkF+xLUakfFc8O+6OWpNFF4Qki39EM8d7t51FUAtrrWLx9dUTkVg4er6b0GpKp
	 1IG6SC1HAaIvHFFD0WTVdSiib4vGxWDSYNOuu/D/5Ekik/Pjsi8VrT+NrbPwZuZ66h
	 1ioQJyIKPTF3JMC+f4j8e5fufNc/BOurX/VuWDko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 127/507] drm/i915/display: Disable pipe joiner on WCL
Date: Fri, 13 Nov 2026 10:47:11 -0500
Message-ID: <20261113153758.749345296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 3152122e6aefe..d79b6367cd57f 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -475,9 +475,9 @@ bool intel_dp_has_joiner(struct intel_dp *intel_dp)
 	    !connector->panel.vbt.edp.pipe_joiner_enable)
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



