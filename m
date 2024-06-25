Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A01465A8;
	Tue, 25 Jun 2024 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308772; cv=none; b=qiGzphS2Qiss/jgWpthHVBBA6R5RKqxZfUEkpYC5Ij5UGT6N9XgS9WREwp4QvvfHwa41uqd0O0NgA8DOcb0e+HjHCrLMiUCLykevXQA0aa79KABvykFrK6cz/caeRUOqCM60/ZSehBlA+8P3QtkMtAOKWQBT2dqEIiLDGuejkFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308772; c=relaxed/simple;
	bh=kOsZpQsasGUse1LG4Sb1yxHc8l8LHG8XApNonokN+bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qoF1+99xDN+Zumipw4YNak707yvR4I8xwd1+pgY1I4K6T3UyHlOkJ58LGaUWL9WcYSzvAfWE9kVPvRAyuM/6mJIgeLU8GogNp7hRs51oGQAbK5EpNdBJl4AgfPn+H+cCusrrqLp70KQMveV8iS4mQMJzdTDtQX0ZWF7hRFumAcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gb/pwFNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gb/pwFNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B22EC32781;
	Tue, 25 Jun 2024 09:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308771;
	bh=kOsZpQsasGUse1LG4Sb1yxHc8l8LHG8XApNonokN+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb/pwFNYeh+qSXy0WBmW7IaeXkO/pQhtQ/kuDeB0bH2kcDNJvTqkoJ/5eMkMtqjL/
	 L0OeNa89gKnGKBGvy5+gfBu3QPgOegiaLf/bGaUOPkHxpQPH0iKGaYZGEEqpQEn/mJ
	 pxYvWeHNlsuL0otBvKXy12umKC8Do5cvMX9gr/xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.9 203/250] drm/i915/mso: using joiner is not possible with eDP MSO
Date: Tue, 25 Jun 2024 11:32:41 +0200
Message-ID: <20240625085555.845406599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,6 +431,10 @@ bool intel_dp_can_bigjoiner(struct intel
 	struct intel_encoder *encoder = &intel_dig_port->base;
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 
+	/* eDP MSO is not compatible with joiner */
+	if (intel_dp->mso_link_count)
+		return false;
+
 	return DISPLAY_VER(dev_priv) >= 12 ||
 		(DISPLAY_VER(dev_priv) == 11 &&
 		 encoder->port != PORT_A);


