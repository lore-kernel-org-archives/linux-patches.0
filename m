Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ACD15853B;
	Thu, 13 Feb 2025 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459152; cv=none; b=top9+VUdBd2L4FDTaowNGXb9HlAohi43Ezk1GRS0qNf1Xet5HOz8Qi/4/SgGSdoSp5C8O5NXtcDCzNLtKE6Vr0fsSc97s3PdiiTYPHFYMjxhF9a1aEB6VR9VSxmTmO2miGIS2OpZDiE25PHFCdTgWfJ11srRoIiiD/rB/+MYMRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459152; c=relaxed/simple;
	bh=vrlFp/DoJopkNrFfvhPYOOX/LzL7IeO6vNz7DMR4+6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdiH0RExYDkjUri4EfNgwpeDMxBR1Y5jQXAmg3Mz+ySZ4yKkQEvwYBcQueGEgUJcLZ3Ru5GR1726tValo47o1yrfPFH/+T0tIslyXfQlu014GIKnCGunDEOJOWg+8p6h1pgGtxQZF22lpU4sX/jhgdqDUriCmBezhpvxdUpXUjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUdHgZeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUdHgZeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF12C4CED1;
	Thu, 13 Feb 2025 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459152;
	bh=vrlFp/DoJopkNrFfvhPYOOX/LzL7IeO6vNz7DMR4+6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUdHgZegR19Tpg7wYI+4gTPSKf3vSTgmE+eTHn7SmENHK/wqA5jjbWyw50U+eoqdw
	 jf7vo7iomcxi+x1MnbedEViEvENMz7jwlbxZ8rT9KHOi2D0pQU8+ysOYGNtcakkR5z
	 gugx26pl6w04yZftkD2lNE9z7rU0v5RGPVIQ7c9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 184/443] drm/i915/dp: Iterate DSC BPP from high to low on all platforms
Date: Thu, 13 Feb 2025 15:25:49 +0100
Message-ID: <20250213142447.715824693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 230b19bc2bcc5897d0e20b4ce7e9790a469a2db0 upstream.

Commit 1c56e9a39833 ("drm/i915/dp: Get optimal link config to have best
compressed bpp") tries to find the best compressed bpp for the
link. However, it iterates from max to min bpp on display 13+, and from
min to max on other platforms. This presumably leads to minimum
compressed bpp always being chosen on display 11-12.

Iterate from high to low on all platforms to actually use the best
possible compressed bpp.

Fixes: 1c56e9a39833 ("drm/i915/dp: Get optimal link config to have best compressed bpp")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: <stable@vger.kernel.org> # v6.7+
Reviewed-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/3bba67923cbcd13a59d26ef5fa4bb042b13c8a9b.1738327620.git.jani.nikula@intel.com
(cherry picked from commit 56b0337d429356c3b9ecc36a03023c8cc856b196)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2049,11 +2049,10 @@ icl_dsc_compute_link_config(struct intel
 	/* Compressed BPP should be less than the Input DSC bpp */
 	dsc_max_bpp = min(dsc_max_bpp, pipe_bpp - 1);
 
-	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp); i++) {
-		if (valid_dsc_bpp[i] < dsc_min_bpp)
+	for (i = ARRAY_SIZE(valid_dsc_bpp) - 1; i >= 0; i--) {
+		if (valid_dsc_bpp[i] < dsc_min_bpp ||
+		    valid_dsc_bpp[i] > dsc_max_bpp)
 			continue;
-		if (valid_dsc_bpp[i] > dsc_max_bpp)
-			break;
 
 		ret = dsc_compute_link_config(intel_dp,
 					      pipe_config,


