Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C893339B58;
	Tue, 11 Nov 2025 01:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824987; cv=none; b=UAC+i1OUqQRcB9O5bM+UKzXWVeeZAnyqZrja18hrc8InBJWTVa73Y3ScLnY8yWgtjwC7gaAvU4RBfdz4oATb47XkwNHDNPEyARv7U6RuGIWoF7dt7z6zfnkXajldC7CQgLFEu/BmiVEGPQOQVsLrBEBstBkPz0mHwvMi/OmquW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824987; c=relaxed/simple;
	bh=z53kIwrqqJJzbx/u36MA/Dv1zPV2tLQ7A/2O/KchetI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFiNTLUz2wV1VAW/znUKPsgmCwm3iPRUlJjDPiPEFqSwgKsWwo4VpKhEdUCqS4QuFjnCrk8gLy+BsWRiiIKWgL4MUem1kEoMMkurCV5NPAyhTgYLUrnU4LiCv1ru4tufqjLKY9bkm/fYcu+5AalZQyyOlRvWJjakUDDFi6r+jX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw+NeTNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw+NeTNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE92BC19421;
	Tue, 11 Nov 2025 01:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824987;
	bh=z53kIwrqqJJzbx/u36MA/Dv1zPV2tLQ7A/2O/KchetI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw+NeTNQAhlVM3Qj1fcN4QoO6NK9fb3xRoGxuaEGp+X5yVdzfQyRE1OeJbV6w8JAR
	 leC7M4uJzAf1RmM9zGhoZMHgCAw5Mzg46QhbpEYakobdUFjlVCROwmiqKTZhKJDYLc
	 UCmZwCLTQd3BfXpmaHxIXFir1NsW0H1mlQHcUCa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.12 563/565] drm/amdgpu: Fix function header names in amdgpu_connectors.c
Date: Tue, 11 Nov 2025 09:46:59 +0900
Message-ID: <20251111004539.686378928@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 38ab33dbea594700c8d6cc81eec0a54e95d3eb2f upstream.

Align the function headers for `amdgpu_max_hdmi_pixel_clock` and
`amdgpu_connector_dvi_mode_valid` with the function implementations so
they match the expected kdoc style.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1199: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Returns the maximum supported HDMI (TMDS) pixel clock in KHz.
drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c:1212: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Validates the given display mode on DVI and HDMI connectors.

Fixes: 585b2f685c56 ("drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1196,7 +1196,10 @@ static void amdgpu_connector_dvi_force(s
 }
 
 /**
- * Returns the maximum supported HDMI (TMDS) pixel clock in KHz.
+ * amdgpu_max_hdmi_pixel_clock - Return max supported HDMI (TMDS) pixel clock
+ * @adev: pointer to amdgpu_device
+ *
+ * Return: maximum supported HDMI (TMDS) pixel clock in KHz.
  */
 static int amdgpu_max_hdmi_pixel_clock(const struct amdgpu_device *adev)
 {
@@ -1209,8 +1212,14 @@ static int amdgpu_max_hdmi_pixel_clock(c
 }
 
 /**
- * Validates the given display mode on DVI and HDMI connectors,
- * including analog signals on DVI-I.
+ * amdgpu_connector_dvi_mode_valid - Validate a mode on DVI/HDMI connectors
+ * @connector: DRM connector to validate the mode on
+ * @mode: display mode to validate
+ *
+ * Validate the given display mode on DVI and HDMI connectors, including
+ * analog signals on DVI-I.
+ *
+ * Return: drm_mode_status indicating whether the mode is valid.
  */
 static enum drm_mode_status amdgpu_connector_dvi_mode_valid(struct drm_connector *connector,
 					    struct drm_display_mode *mode)


