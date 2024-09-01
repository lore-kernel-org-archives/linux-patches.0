Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27594181CE1;
	Sun,  1 Sep 2024 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208286; cv=none; b=OlDKJWdAZBmxGNoRvK5vL6O9lGIcgRWY5t9Hy0pTEUQBbctwAdaTXnvZo0KwtQ2D1X4sBfsQ1kLA9+PbiLRawHY1MrlqYbmc51Ot1cooiU/0JLRrnpXCGFWmz5bEmDcoD0Ry3km1nuVYrxmOggSDT8Fy9gIUHe6iAkgtuMEsp9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208286; c=relaxed/simple;
	bh=q/hGbgBNzW+lb99hYTDy9jk9C9h3l8RbyDgL9qwljcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsmkggsr5pubhdws59TQeCAg5WpAo25+o34ouxJPaKnfhcD+qx7hBqQFREtEteOT2N0KXInAVaCNKW+/T4VVdlnFI5j82Q7Qs+9zClOSs5UXL/eyjgR7faTloVtfoiq/568X1h+3qXOIRaCW17XY37UFAZkbo3ANV9byTaK0O8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPKeKlry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPKeKlry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32F9C4CEC3;
	Sun,  1 Sep 2024 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208286;
	bh=q/hGbgBNzW+lb99hYTDy9jk9C9h3l8RbyDgL9qwljcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPKeKlry+KqeH39op1KnNPgyfLhWvP8HbEmCvSDTiPvm4V33gFYxTr+Sf0uxrMK8r
	 E6+u+46lpQEzXhMiJ0KUNzAk7qwxWvVsErHxCqZuLmwzAHqJPwxXgJwPws4mkLf1Nb
	 BHUD+QdCjpWvHCbb1ZJgyOuKZczZORBUkeDQK8KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 036/149] drm/i915/dsi: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Sun,  1 Sep 2024 18:15:47 +0200
Message-ID: <20240901160818.820407178@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 7d058e6bac9afab6a406e34344ebbfd3068bb2d5 upstream.

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Fixes: f6f4a0862bde ("drm/i915/vlv_dsi: Add DMI quirk for backlight control issues on Lenovo Yoga Tab 3 (v2)")
Cc: stable@vger.kernel.org
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823075055.17198-1-hdegoede@redhat.com
(cherry picked from commit a4dbe45c4c14edc316ae94b9af86a28f8c5d8123)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/vlv_dsi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1869,7 +1869,6 @@ static const struct dmi_system_id vlv_ds
 		/* Lenovo Yoga Tab 3 Pro YT3-X90F */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 		.driver_data = (void *)vlv_dsi_lenovo_yoga_tab3_backlight_fixup,


