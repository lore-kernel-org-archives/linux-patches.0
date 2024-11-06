Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25441DFE3B;
	Wed,  6 Nov 2024 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897976; cv=none; b=uFlMtkdqSJXcg8Fc4kSEfR/nTm8MRpXZ4cEEjbyejVxxFXkK4y1OhroJuUrxwqnthdewWuGy6LEYZlVWpevMtyeL34sz0Pns5qUcf6tI3WemkIEDiFrNjE6bqOxFMr7v2CiKOT/vSW/ENNykMZA8GERN2p0hifFg8NFbYfFXC90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897976; c=relaxed/simple;
	bh=xhR+pYITDjnLsk8+sr/LvJQrdmfgiEm8YfHRxg5QSoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnf7slnnvsEHEaMUEalqRg4rwQqeklXuBUmhOA0ScpD28WQJnLykG+vZTevfo30BzklecLebmh1jqiarUv5qK3rkNocUU+tVPM8ZKtI7LY5lKU+zKhANNVE92Eh9KskSq0AWe+4pZxpFc7x3DM5WgFBJpceded29yHlmI6WXSsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIhDs4NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIhDs4NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35828C4CECD;
	Wed,  6 Nov 2024 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897976;
	bh=xhR+pYITDjnLsk8+sr/LvJQrdmfgiEm8YfHRxg5QSoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIhDs4NXo8zD/UKTmE9Q8TWTBJPXDXTJX3iLy7r1IInicAsc/3dX4xSAp34d32k0f
	 AJu4DxkTPkBezyEhjkcl4/knAbh8tX/24bjwk1rnvx0Su1axDotryX5TZO3Mn4r4KO
	 N0ZIPojN6KSNhhDPhBbhwBA5pAoj6ZxBCqkyMQBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/462] drm/msm: fix %s null argument error
Date: Wed,  6 Nov 2024 12:59:36 +0100
Message-ID: <20241106120333.557459850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 25b85075150fe8adddb096db8a4b950353045ee1 ]

The following build error was triggered because of NULL string argument:

BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c: In function 'mdp5_smp_dump':
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]
BUILDSTDERR:   352 |                         drm_printf(p, "%s:%d\t%d\t%s\n",
BUILDSTDERR:       |                                                   ^~
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]

This happens from the commit a61ddb4393ad ("drm: enable (most) W=1
warnings by default across the subsystem"). Using "(null)" instead
to fix it.

Fixes: bc5289eed481 ("drm/msm/mdp5: add debugfs to show smp block status")
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/611071/
Link: https://lore.kernel.org/r/20240827165337.1075904-1-sherry.yang@oracle.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index b31cfb554fa23..a1cc205192f34 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -358,7 +358,7 @@ void mdp5_smp_dump(struct mdp5_smp *smp, struct drm_printer *p)
 
 			drm_printf(p, "%s:%d\t%d\t%s\n",
 				pipe2name(pipe), j, inuse,
-				plane ? plane->name : NULL);
+				plane ? plane->name : "(null)");
 
 			total += inuse;
 		}
-- 
2.43.0



