Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4725C129;
	Mon,  1 Apr 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988483; cv=none; b=lg9wgd1eqb8BS6hOOcITxE+BLnZghBo3mmMpfaaIq+Yl4Q/W7WWdkOk4AHcoDznlnp/jxKCJ61Ykyn+S5Vo2lmuYIy+/P95qJ+B0EqJxWZv2i6PCMi7g1I3J8YF8P4JTrmoHdFnCnWarcdmzYYcpRIz5WG6P8vv+tzUlz8wKZ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988483; c=relaxed/simple;
	bh=5ZF+1oJogPxjojJICAP2GlNJza+7Wf/K+2Q1WHEK35s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkKvsWspO822wJKiBCygBheAUCPUIFSPfkt02QAyQ/A8IdMjQFMPTW2BWG/CQz9P5Ojw1+fJmVud/9Dsjd84uq9r83UrwxIOodS3MrG+05XJG5fB0PAmauhitNXCwgPF0vXrDGCizFyrRlFhRPDFKcIlQGWzHxYrs4uu/fidtt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKscKC7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKscKC7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530B9C433F1;
	Mon,  1 Apr 2024 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988482;
	bh=5ZF+1oJogPxjojJICAP2GlNJza+7Wf/K+2Q1WHEK35s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKscKC7D05+FNlMGl3RdetNpC69aVDvy3KSFZE7EjT0LKZRfOM8/vaYB6JPrOB8gs
	 hztBwWTL7EztVphpPlDGlNE327htt+IJFoyVsCQIWJ6LWDKt9KvJS6aIGyPcUgVEnh
	 pntRJplgf9QLmmbRWBEtKh0uhtcoeULib9e90b8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 169/432] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:42:36 +0200
Message-ID: <20240401152558.190133097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



