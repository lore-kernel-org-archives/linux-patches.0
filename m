Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FC3FF1B5;
	Thu, 30 Jul 2026 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422395; cv=none; b=GSk70OmZPRk8yTvOR8EcIWm73kIUlA1GE4dDPDrhQheG7exln3G5zspMFUn53sofHsjPPuhUA2dfWTE3wy9gGVNI07s3NS9wPxhcU/DdXY+UAXel+YD+XpHy/DH+ALk4DFipinRQofA2p0THvdzLrXyS4SApv1f9PcC9uwF/9Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422395; c=relaxed/simple;
	bh=vBXXrjoXnaXWsDYAkJAd4d8Du/Eh/K1hjxfah88HUd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuBd7KI1+uP2H8Q69xCUiwAE746eoB+j5sZYvpS/1Tj3XLysfUssVg/cimkVTYRdcE7bINixDBJ3g+cAJ49TQZBFwna/WUjx0yy76hW+KMB7+g4dC8PP5d27dD+WxgYSSfvuASk4Ny3o/y7JvtANsn5FQ3Cm4jez/9uwijTB3I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vM6otas7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vM6otas7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183A51F000E9;
	Thu, 30 Jul 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422394;
	bh=q6XlJ2LbvN9ttIJ1yFWehOunJjrSIPX5YXhv8Had6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vM6otas7kdT2KA2fRH6hFNaia1eRBL87SAYbvK/NPMoPCLiLVhZ4N8IV9eFXduMx3
	 nRISDQkd3KwgUA4giz747fKxH+bXcbFKRwAPixQHY6cUTwat36jVghnVd17vIKZ95A
	 kSLMwTqRBQiogiU5rDJMClxLb/CYLjMmAaxuivJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.1 424/744] drm/i915/vrr: require valid min/max vfreq for VRR
Date: Thu, 30 Jul 2026 16:11:37 +0200
Message-ID: <20260730141453.308142582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit f8a9262c7a6fc2de9802e14b0228114f0333869e upstream.

Ensure the EDID provided min/max vfreq are valid. Most scenarios are
already covered (by coincidence) through the checks in
intel_vrr_is_capable() and intel_vrr_is_in_range(), but be more explicit
about it. At worst, a zero min_vfreq could lead to a division by zero in
intel_vrr_compute_vmax().

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 117cd09ba528 ("drm/i915/display/dp: Compute VRR state in atomic_check")
Cc: stable@vger.kernel.org # v5.12+
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260625131040.1051272-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 1765cf59f517b02f3b0591fe5120930d08bddeb6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -64,6 +64,10 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
+	if (!info->monitor_range.min_vfreq || !info->monitor_range.max_vfreq ||
+	    info->monitor_range.min_vfreq > info->monitor_range.max_vfreq)
+		return false;
+
 	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 


