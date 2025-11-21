Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A990430EF7F;
	Fri, 21 Nov 2025 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733163; cv=none; b=kktwuamNwdPuCkslhxVZWeOGZw6ywZ61fPEzg3cz4RafhTXX5ftDj/9UXo4VNybGqIn6i8M/YGj6dxRJUhBtgftYvEaBMKYxWXdMMuQ6/hRlXEmqpz9aY61D6ASqYTX8gNuK1BWdzkW1fqzSCJ8+dtF/yIoWJomG1qosf6IIEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733163; c=relaxed/simple;
	bh=z7OH03k8PI9b1CSCzsf9ol9qIqSswfyBYEh5v1mBwOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hJ7a92uyJTC6fqkP82EVWwK2CZFFZfRMhKKFWZhXQ5zul20pQ7jOqMeU6lPFbcVk1wgq/WV/9UQ4Ticwrt0gqOFJ2Y5DN7GXn6DECGDuQGV72yb48MK5wBwtrJhkx4KiH0BoN9soS66FmwsQC1mmivYLQ+pQE+ooPipTaf9bNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anRcfG7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anRcfG7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E4AC4CEF1;
	Fri, 21 Nov 2025 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733163;
	bh=z7OH03k8PI9b1CSCzsf9ol9qIqSswfyBYEh5v1mBwOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anRcfG7vdwCf1DAKV5HC3GyT/wtZzkIHlxBEDcoPdchHhlyUtApFch62wdfor1zw6
	 Ur6nOk1urQ1O5cpft1kKTa9yBCiCKLNCp1Tt4WHh1YnG9k6uZDMKUprCPwxxnFDjRz
	 LmyEWrZVLoM/4jSZ8MIxJB2K7jYBzsmPhT7ZFzbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.6 373/529] drm/amdgpu: Fix function header names in amdgpu_connectors.c
Date: Fri, 21 Nov 2025 14:11:12 +0100
Message-ID: <20251121130244.298463842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1206,7 +1206,10 @@ static void amdgpu_connector_dvi_force(s
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
@@ -1219,8 +1222,14 @@ static int amdgpu_max_hdmi_pixel_clock(c
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


