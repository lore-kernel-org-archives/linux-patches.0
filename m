Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71DFFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E949DC433D2;
	Mon, 15 May 2023 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172350;
	bh=0zeMxstQsi049kfBIVT6iNTnxplUdAGgXg1JoQvLJu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1TL0nU7YmvsyhAgLI9cpc1dcnWwSgneRJdztSxdtBmUSDrUrbEy3TXGK6Ied3uoV
	 nmROvLv9F2deYEP0WTYtf93qHA00VPQ9AwRhQ4NEsGsfDFd75j2Qy12VA/MPGSFK/G
	 hX9iZZ30Gh2Cn5q2ARl8Pr4XWfqmCex76cNOKwAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/381] drm/i915: Make intel_get_crtc_new_encoder() less oopsy
Date: Mon, 15 May 2023 18:26:15 +0200
Message-Id: <20230515161742.428005297@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 631420b06597a33c72b6dcef78d1c2dea17f452d ]

The point of the WARN was to print something, not oops
straight up. Currently that is precisely what happens
if we can't find the connector for the crtc in the atomic
state. Get the dev pointer from the atomic state instead
of the potentially NULL encoder to avoid that.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230413200602.6037-2-ville.syrjala@linux.intel.com
Fixes: 3a47ae201e07 ("drm/i915/display: Make WARN* drm specific where encoder ptr is available")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 3b6692357f70498f617ea1b31a0378070a0acf1c)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index d46011f7a8380..9a06bd8cb200b 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5844,7 +5844,7 @@ intel_get_crtc_new_encoder(const struct intel_atomic_state *state,
 		num_encoders++;
 	}
 
-	drm_WARN(encoder->base.dev, num_encoders != 1,
+	drm_WARN(state->base.dev, num_encoders != 1,
 		 "%d encoders for pipe %c\n",
 		 num_encoders, pipe_name(crtc->pipe));
 
-- 
2.39.2



