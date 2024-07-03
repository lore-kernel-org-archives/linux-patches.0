Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1617556B;
	Wed,  3 Jul 2024 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005865; cv=none; b=RS9uyZ3kkTE/GpR9MFM2yVRKVHAcGyunhRgpntzLQfQHvND9pmxZi0LFzNzapPy43cHL6O4Tv7CzHQ3hf+KcRQX+zS2eKVENxnhl+vQ341mfULEXTGiAGYmEJrO6TmqqnMKCv7QLhCkun/UnhXhXMKfL1fD+Cxyira0ZwThwL1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005865; c=relaxed/simple;
	bh=j/ifpxQ9TEf9eC+Bh2Zhoo/7eLj/E7EY/5u3UHj6bJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+Exd1FeM8mlBfZijTSulgq4XIHoVJ0szKCf5Ur+sOeu9pR+DQyV6XXGf7ChMZG7QJjAosZ/oZUO9kckLDHpMXc6Q5Ir1YOGZYorP0lZiTKNB35e0u1lrbRkBjykkI4/4wGZtBrl5n1WTsdVIsojGipDl4lFRfNEnn0tO3mo2n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akYSNTQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akYSNTQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131E7C2BD10;
	Wed,  3 Jul 2024 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005865;
	bh=j/ifpxQ9TEf9eC+Bh2Zhoo/7eLj/E7EY/5u3UHj6bJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akYSNTQZixhO1rJqo1Ut8GbejzNo23gctM5DiVaqHt1w9ZQYBgOQEBxTh+HzS60uT
	 fT4s+6AFCOhAm2Wy5u/9c3jaS6fwEG8Rr4IikQPJjTJV8AtJzSgOQTIGWaC3q5u3SZ
	 u2jPbhLZgeuCLD2kObdfhJe/gkgHexFufBXMayLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 223/356] drm/i915/mso: using joiner is not possible with eDP MSO
Date: Wed,  3 Jul 2024 12:39:19 +0200
Message-ID: <20240703102921.550287890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 49cc17967be95d64606d5684416ee51eec35e84a upstream.

It's not possible to use the joiner at the same time with eDP MSO. When
a panel needs MSO, it's not optional, so MSO trumps joiner.

v3: Only change intel_dp_has_joiner(), leave debugfs alone (Ville)

Fixes: bc71194e8897 ("drm/i915/edp: enable eDP MSO during link training")
Cc: <stable@vger.kernel.org> # v5.13+
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1668
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240614142311.589089-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 8b5a92ca24eb96bb71e2a55e352687487d87687f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -226,6 +226,10 @@ bool intel_dp_can_bigjoiner(struct intel
 	struct intel_encoder *encoder = &intel_dig_port->base;
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
+	/* eDP MSO is not compatible with joiner */
+	if (intel_dp->mso_link_count)
+		return false;
+
 	return DISPLAY_VER(dev_priv) >= 12 ||
 		(DISPLAY_VER(dev_priv) == 11 &&
 		 encoder->port != PORT_A);


