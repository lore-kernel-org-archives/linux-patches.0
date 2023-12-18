Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCE8129ED2;
	Mon, 18 Dec 2023 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9E7kJe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89C1C433C7;
	Mon, 18 Dec 2023 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908432;
	bh=u8sC+6vLBNowj0UVITO/ZLE7JA+ZB6QAPFy/hpjoivA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9E7kJe9Nqz5K75Jjn7rQn4Ype0W+iAgMn/4wPUfysihlP1Kvog5xBE6QpWyYf/V6
	 7PZAn9XIB+JGxnkOzy8F8djjrcZ00avej+kLx/mIxVBHw88uHYG3WeRVtzXFLJ4PoC
	 aVViDLlAslbr3bA40UnXG3g+s/7SApR+qr/beLpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bbaa <bbaa@bbaa.fun>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.6 147/166] drm/edid: also call add modes in EDID connector update fallback
Date: Mon, 18 Dec 2023 14:51:53 +0100
Message-ID: <20231218135111.703787198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

commit 759f14e20891de72e676d9d738eb2c573aa15f52 upstream.

When the separate add modes call was added back in commit c533b5167c7e
("drm/edid: add separate drm_edid_connector_add_modes()"), it failed to
address drm_edid_override_connector_update(). Also call add modes there.

Reported-by: bbaa <bbaa@bbaa.fun>
Closes: https://lore.kernel.org/r/930E9B4C7D91FDFF+29b34d89-8658-4910-966a-c772f320ea03@bbaa.fun
Fixes: c533b5167c7e ("drm/edid: add separate drm_edid_connector_add_modes()")
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231207093821.2654267-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2308,7 +2308,8 @@ int drm_edid_override_connector_update(s
 
 	override = drm_edid_override_get(connector);
 	if (override) {
-		num_modes = drm_edid_connector_update(connector, override);
+		if (drm_edid_connector_update(connector, override) == 0)
+			num_modes = drm_edid_connector_add_modes(connector);
 
 		drm_edid_free(override);
 


