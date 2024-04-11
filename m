Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409D13FD97;
	Thu, 11 Apr 2024 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831709; cv=none; b=npKMeRoDOWk2CYdVFkiBolRiNZ7NBbzZREMsVnfN5ViRfpgN7IDLWbtyQalbF3Tx16gD2MbGz39MycgKcETp+Syn5UGVx6j4YGHMqc5lhXxZjW8NyZS7gzv5U8wmh5hCioG6T4fYdEH9hHLdgeDMpBifLfqMduSTnrOzUYKXxPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831709; c=relaxed/simple;
	bh=0AjOUkQIS28jMip0S+eAAHfsggbWkf2IbC0LyEnLrJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGARfh8OXZzFw5Zo7FNclMW3I5+8Gevcb+GOafHguVaKPyh5jKrMem4yfUL0h7bgS9BH5CR59HHsPoFTIGGQaFtKoR/yM7qm+Rj7tEUOyY9frSqit22UJCoYA38Zm65EKNTUK3DZ3IjkyTzvchA2PLuedmc1EZKWpQp5CFRp0lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7H0IorO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7H0IorO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A877C433C7;
	Thu, 11 Apr 2024 10:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831709;
	bh=0AjOUkQIS28jMip0S+eAAHfsggbWkf2IbC0LyEnLrJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7H0IorOsHUMcESE/bhHdbrgn0f0IlnnK/JJpr+bUUnYpgX2R5EYzHW8WsbX/7F0J
	 EtiMrzuMrVdKniZHjodWr3q3MS5gZHsF5XRo1yKL55s1ll6VJYJ9dfv3ZxDa3TxFLk
	 iCp1l5lAVm/2f1GzL0DfZJBvurUbyQE6bmRXqI9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/294] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:22 +0200
Message-ID: <20240411095438.653921737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e8620838de9c..6d01258349faa 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -197,7 +197,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4_hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	vc4_encoder->hdmi_monitor = drm_detect_hdmi_monitor(edid);
 
-- 
2.43.0



