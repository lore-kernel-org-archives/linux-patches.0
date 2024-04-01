Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461274B5AE;
	Mon,  1 Apr 2024 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989833; cv=none; b=jwGYMVpeSMVIVl105WdH+eBenBNi2kPkOrA2ug4cSWjuuY0bfBBrhw1059gC83AailplJcPEw+OQ7qA7fJEYfg3TqZ+l22yI4eA0YtMPBsg34Hp0mF8f53s6RJuJO55kuOtyU9ofTgWJGygGul/B4HaNU8Q+5/d4DBANuE3Xodc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989833; c=relaxed/simple;
	bh=aOOuPy9LnVKmP6YgnfekEX55eQpehYmh5nrdm7MHBxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEdw+k6TvFQJIrt/jp4hp66fldmnFglNsBfd3SzatfONlfzo3aINbU+vwrPq8h5VP15Kga3V/kbUX+QwQo5LmmInNzJxfqjip5n6mtW+o05zLVMCCoEHc3mkjdtDARmtPfL4kf+/A1c95fVbCOPqGkx+pBe5Wk2HpDsDusXn2kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7SAYNWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7SAYNWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD514C433F1;
	Mon,  1 Apr 2024 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989833;
	bh=aOOuPy9LnVKmP6YgnfekEX55eQpehYmh5nrdm7MHBxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7SAYNWy7Nm/LQ3LuBsZFFu8i/I9tqHvAMxw9uWfYelXMA3Y2k2RkUUgAOkKN/zh3
	 NPeM4DX5bgolVThCuAgSAF9kqWyCwlnyN6jz6+27bmzAUqBw0Ayu6xaB1MSAGydcua
	 PNP8Scz0fzKz9I1rPO1YMpqbsAwRCaBdtCQBRsdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/396] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:43:18 +0200
Message-ID: <20240401152552.387635662@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit abf493988e380f25242c1023275c68bd3579c9ce ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Maxime Ripard <mripard@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/dcda6d4003e2c6192987916b35c7304732800e08.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 25c9c71256d35..4626fe9aac563 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -508,7 +508,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4_hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	drm_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
-- 
2.43.0



