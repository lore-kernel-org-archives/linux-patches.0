Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC172820DD;
	Wed, 23 Apr 2025 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421644; cv=none; b=cITKdAhXOIeHj4R2RTIFgdo97C6XHIAUz1RdXDi4RC1YKOC5RptEeyRB+Ubt+ZxPB6F4HdSpBc8a84G8BfWNsTbaZLAIi+vY9W+D1LwuGianelCu9NA5rhfTL3ciszVxLb2hpuV6A/y5x581mUHBZrTcHKN8AHHe725zgGa+TR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421644; c=relaxed/simple;
	bh=8U8O9NEMEt2cQvxayVjpbbEWHXqn3KVPxVBavgPe81A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2+brZNopgfwrita3ft2T4/Kadd2tuAXqfkvkMqPhY7IDmajnqZDbE/Z5+YaDF28nkKXsERF/9ko49dmoGuEgbsevWgy2GkAgBM7RX73legYSUhn0S6M0/+fI8jjW3sw4wVogIaTQrjs3qaTQI7UnqftpGh1/2PgJRN3kV795so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UltLSL6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UltLSL6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1285AC4CEE2;
	Wed, 23 Apr 2025 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421644;
	bh=8U8O9NEMEt2cQvxayVjpbbEWHXqn3KVPxVBavgPe81A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UltLSL6YwyOzi9+KJeY3BQayvcpdSmrWD+wlWsYs93+t/tgEyGwOTnq5rKzv+yORD
	 0A3kfBCjEvjZYwvb4zdTOQZ5ADsWQOjomElYX12m/G0cBkGRnRmWeQwjtKnYc94QTO
	 H+YxJFcIFKWrE2r4wXXPucBDfbkIOrLOCMu24m74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 215/241] drm/i915/display: Add macro for checking 3 DSC engines
Date: Wed, 23 Apr 2025 16:44:39 +0200
Message-ID: <20250423142629.345455625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit ec0c7afa70d5ccec44e736b60ed2e7c191d054cb upstream.

3 DSC engines per pipe is currently supported only for BMG.
Add a macro to check whether a platform supports 3 DSC engines per pipe.

v2:Fix Typo in macro argument. (Suraj).
Added fixes tag.

Bspec: 50175
Fixes: be7f5fcdf4a0 ("drm/i915/dp: Enable 3 DSC engines for 12 slices")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250414085701.2802374-1-ankit.k.nautiyal@intel.com
(cherry picked from commit 6998cfce0e1db58c730d08cadc6bfd71e26e2de0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_device.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -159,6 +159,7 @@ struct intel_display_platforms {
 #define HAS_DPT(__display)		(DISPLAY_VER(__display) >= 13)
 #define HAS_DSB(__display)		(DISPLAY_INFO(__display)->has_dsb)
 #define HAS_DSC(__display)		(DISPLAY_RUNTIME_INFO(__display)->has_dsc)
+#define HAS_DSC_3ENGINES(__display)	(DISPLAY_VERx100(__display) == 1401 && HAS_DSC(__display))
 #define HAS_DSC_MST(__display)		(DISPLAY_VER(__display) >= 12 && HAS_DSC(__display))
 #define HAS_FBC(__display)		(DISPLAY_RUNTIME_INFO(__display)->fbc_mask != 0)
 #define HAS_FPGA_DBG_UNCLAIMED(__display)	(DISPLAY_INFO(__display)->has_fpga_dbg)


