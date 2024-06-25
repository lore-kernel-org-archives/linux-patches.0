Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394AF13C90B;
	Tue, 25 Jun 2024 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309786; cv=none; b=QieLyw+HfPKe4e7+cARDHqVrb1oad5UdYUMTb7rg8JlmFa7zou0CHljAY2ioIi1RSZbypkl+IBxvCb/dmlS7ysFmUZ9+BHOQBQTNWQZuBQb+ghAMnePKC/XKw4nng48Zw45FKrwIrlCKwA2C+nQfj1H3eagMrTWlz7yd3fPaoso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309786; c=relaxed/simple;
	bh=b0Y24rvRbI/dA/smTz7wGci57GOnJcghw/L4fxVxS9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NK/1MuTBGn1JA+OaS6nmO+F2ozSg6Zt2+5lP3XWTtaOHxx4pP14NUm8D3Dyf8Br93PHEvxZOs8njoyaBpsJw0ov0M8cGG7pHenn9uwDT8/xEsowAYkeE5qeMYQ3g93puyOGb7IiYKUHXfMqLW3rLYomJJR6RXUcVK3sbL9dHujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN/YDgu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN/YDgu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DECC32781;
	Tue, 25 Jun 2024 10:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309786;
	bh=b0Y24rvRbI/dA/smTz7wGci57GOnJcghw/L4fxVxS9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN/YDgu1R9PGy3wADBxAeymjVSae3VWDaB7eVGfmS+BoOiO0aR946IDfnpl4tXmkw
	 dI9dZy4Pqae5pkEemh73TninjOKG8a9umXIV03q6zN9+42+1UMzjrwppQqnWnX1qKn
	 CiDvoLAWFU+dQqgoQsmgHgv+Xu+gzh8GiysHXhCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 104/131] drm/i915/mso: using joiner is not possible with eDP MSO
Date: Tue, 25 Jun 2024 11:34:19 +0200
Message-ID: <20240625085529.890115727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -390,6 +390,10 @@ bool intel_dp_can_bigjoiner(struct intel
 	struct intel_encoder *encoder = &intel_dig_port->base;
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
+	/* eDP MSO is not compatible with joiner */
+	if (intel_dp->mso_link_count)
+		return false;
+
 	return DISPLAY_VER(dev_priv) >= 12 ||
 		(DISPLAY_VER(dev_priv) == 11 &&
 		 encoder->port != PORT_A);


