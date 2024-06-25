Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B4146A67;
	Tue, 25 Jun 2024 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309359; cv=none; b=CXBTEYDNGoiC+r7uS05c6PWQLcn+lmQy+Ll+VbXSdmtHKKxoMNv/cDIWZR2CRjmwhl6sNXGjXpOWoN3vLSoCU4ISse4C7EfM9hvVuK6zMSTnSTT4uM3+iSH7lry9wUijkTIy2gkMsZbEG+l7Q4MPuXzI4rUzOeP0Mve3RH1/ArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309359; c=relaxed/simple;
	bh=4E2N0TRHW0VH9cyQEr5aH8HEmxmEhke+aemfIKuQp8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eq2ydoKh0BbM+3H8J4pzYUlbplGgZTC+2duaK/wMPb1OmN+7fSK75Ou8g/WgwE34tULknmo9NuQVIFTHI2qwRbeb8J3no3ZpM7q78ccPV/wWospZm0iegdq9iXWwy95m/xwJ2fSlA8KDuVzTKHT+Y6+wzCH/2wa1Q0xrn+sNNhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTFdPdUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTFdPdUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4BEC32781;
	Tue, 25 Jun 2024 09:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309359;
	bh=4E2N0TRHW0VH9cyQEr5aH8HEmxmEhke+aemfIKuQp8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTFdPdUl2QNZXuJj3EYaQkeqt/z4IOdXvOhOkk/79HLorywhDjtYmOp4woEOJSYQg
	 fHcDVOR8ImJqaBcdUjsoCqFGEzzSiJWfEdYTCsxnXZU8cGqOLozfqQo7gvQpV0BGFQ
	 BtmJpqCJzL2l8a+bo8pTWBM20hMsGGj2WztIORbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 152/192] drm/i915/mso: using joiner is not possible with eDP MSO
Date: Tue, 25 Jun 2024 11:33:44 +0200
Message-ID: <20240625085542.993584408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,6 +393,10 @@ bool intel_dp_can_bigjoiner(struct intel
 	struct intel_encoder *encoder = &intel_dig_port->base;
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
+	/* eDP MSO is not compatible with joiner */
+	if (intel_dp->mso_link_count)
+		return false;
+
 	return DISPLAY_VER(dev_priv) >= 12 ||
 		(DISPLAY_VER(dev_priv) == 11 &&
 		 encoder->port != PORT_A);


