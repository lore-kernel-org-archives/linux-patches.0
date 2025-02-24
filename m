Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E9D146A63;
	Mon, 24 Feb 2025 14:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409150; cv=none; b=p6BwlDqSEpHj1z2lsfjLwBtf+pFflUuJE5Ta45yglD/YF9JVw4lJTjoagX2cIl2JVoo2BH3yzQdopZYKPbzOZ7/1hpgX0ALQS0rNwMw9ge83fUKsGvOjmYNGTWmfLECcFO0TftMYsKGGw14byCa2HqRargiX4M0woBmsr9wDz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409150; c=relaxed/simple;
	bh=9yEA3HGPoxrXl8X+ULiGfPS46HBi6L05hE5GsWAvJuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ3HtYvRs6ivBqGV6YLteqFIaLd5rN8Mwot0QGekS5WV65NJo+yY6RkwiRF/ibvKztZsVtcn5KLS7OoGXZXZM7T37/sVbRDKB1q/Vo5VBU+oauF2AwGGXqEu6Cy2xpEX/Uh9Ym82Q9ZqQItTXv7hQODWc+YvOQwwiJ5Eu79J2g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBkaVnij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBkaVnij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D5C4CED6;
	Mon, 24 Feb 2025 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409150;
	bh=9yEA3HGPoxrXl8X+ULiGfPS46HBi6L05hE5GsWAvJuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBkaVnijbv6g+HmHdRjPYmEEia683fIhBoD6sLt1XXN1XDFQIrZA3PXqWDtxz4Y71
	 rWXSjuNKmXsJTUvelgHDSa5yo8Iz5Zndy5PoRzdzAifVuAzGaqj91bo4WI0NFsYTUt
	 Q3I5cpVXwYmws9hG2RqBo5YIO1Ys1sHK93FnUxqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 094/138] drm/i915/dsi: Use TRANS_DDI_FUNC_CTLs own port width macro
Date: Mon, 24 Feb 2025 15:35:24 +0100
Message-ID: <20250224142608.174888046@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

commit 879f70382ff3e92fc854589ada3453e3f5f5b601 upstream.

The format of the port width field in the DDI_BUF_CTL and the
TRANS_DDI_FUNC_CTL registers are different starting with MTL, where the
x3 lane mode for HDMI FRL has a different encoding in the two registers.
To account for this use the TRANS_DDI_FUNC_CTL's own port width macro.

Cc: <stable@vger.kernel.org> # v6.5+
Fixes: b66a8abaa48a ("drm/i915/display/mtl: Fill port width in DDI_BUF_/TRANS_DDI_FUNC_/PORT_BUF_CTL for HDMI")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214142001.552916-2-imre.deak@intel.com
(cherry picked from commit 76120b3a304aec28fef4910204b81a12db8974da)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -808,8 +808,8 @@ gen11_dsi_configure_transcoder(struct in
 		/* select data lane width */
 		tmp = intel_de_read(display,
 				    TRANS_DDI_FUNC_CTL(display, dsi_trans));
-		tmp &= ~DDI_PORT_WIDTH_MASK;
-		tmp |= DDI_PORT_WIDTH(intel_dsi->lane_count);
+		tmp &= ~TRANS_DDI_PORT_WIDTH_MASK;
+		tmp |= TRANS_DDI_PORT_WIDTH(intel_dsi->lane_count);
 
 		/* select input pipe */
 		tmp &= ~TRANS_DDI_EDP_INPUT_MASK;


