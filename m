Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCE142903;
	Mon, 16 Sep 2024 12:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488450; cv=none; b=ZMEwGNFyAtJuXjGwBW1sKgmq0tabTGuB9xSUAof20qbjlCehgwz0rvT8OBPfCNhlUPMb172fwTtjQP6wUP98DhsoHPYZopM+ZszPfSwQlOGKFGOLhIcRMM0qC2/T1tezDVCRGuNs38MaNU6Ljqjw6V5/XeKX8+x+xguVsvF3DyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488450; c=relaxed/simple;
	bh=m7zFGszEgoAXGQyGfO/LNUa8iwIFMXhKZRu7ZPwA6og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyobttQNwAXAygElqTi9D6q5JyQpPtOBA21qGTzy7+j3gtOJgfqGdG5Rkgo4m8hAeE9Qf7ByhVvdYpYWQ4v0VhA/M117d4ATmekYOTws/w+WEgwCADn5BOLN2/1015A+lo0Vm6Y222r58zcAvw2bRr9XdvtKMW4VlZFpwu/H5VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9jBO31R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9jBO31R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E9C4CEC4;
	Mon, 16 Sep 2024 12:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488450;
	bh=m7zFGszEgoAXGQyGfO/LNUa8iwIFMXhKZRu7ZPwA6og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9jBO31RaGFsx4Kddq/cYaCf7n9wVXdS5BhpS6Upg5Dop4cS8ia0zDwDZkDMW33yb
	 f3Qs/V+T23cbx4GGow83wgpocmuxGnbuj0KjzXWjqkWxuO38hNRlJ+hnesMvExtW2L
	 4bDos6Hfe62sD/51Dsn7QXIYu+ptPCzdHjww68ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 117/121] drm/xe/display: fix compat IS_DISPLAY_STEP() range end
Date: Mon, 16 Sep 2024 13:44:51 +0200
Message-ID: <20240916114232.984676760@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit dd10595c3232d362f5a01e5d616434b2371ae8d4 ]

It's supposed to be an open range at the end like in i915. Fingers
crossed that nobody relies on this definition.

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/fe8743770694e429f6902491cdb306c97bdf701a.1724180287.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 453afb1a439994deeacb8d9ecbb48c1f2348ea0a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h b/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
index cd4632276141..68ade1a05ca9 100644
--- a/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
+++ b/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
@@ -96,7 +96,7 @@ static inline struct drm_i915_private *kdev_to_i915(struct device *kdev)
 #define HAS_GMD_ID(xe) GRAPHICS_VERx100(xe) >= 1270
 
 /* Workarounds not handled yet */
-#define IS_DISPLAY_STEP(xe, first, last) ({u8 __step = (xe)->info.step.display; first <= __step && __step <= last; })
+#define IS_DISPLAY_STEP(xe, first, last) ({u8 __step = (xe)->info.step.display; first <= __step && __step < last; })
 
 #define IS_LP(xe) (0)
 #define IS_GEN9_LP(xe) (0)
-- 
2.43.0



