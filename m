Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641533B6FC;
	Wed,  3 Dec 2025 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779685; cv=none; b=V3vMQBGVjbBVmj3QiZl2rCQUDHcpkHfGRmuhym8zWS6cvLFcxBFXMCTMqp7c0M9Hgk9ARoURoJX5ckMTSiF+eGA1NoJckxFW/a0h47mXuJgRG6gQLsA+uVeOYEUrvzgZqFZbsRUOvJhjwcpNseNB2QhNSgS7+HymVPmveOWr1v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779685; c=relaxed/simple;
	bh=Bo6+UmSRgU1hyBZ03/T2Sz0b6VWTdRNmrxqBjk+ItSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tx6kxKniz/DxuyWr56fAIykTr9+8V5xIwWQRnf1WwSwJmXVnqG8RQatGNg3HP0R5/RWuOwBQnvj+bcsLYzbHn5Xh6e/w83TQGvHwgjGPJmznsb+omejBeLogCENsRHnSyjmj0UAxOMTeRkoLmxWxbDRQYWWYVN+PN56Acq/69CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oF8E/ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oF8E/ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DFEC4CEF5;
	Wed,  3 Dec 2025 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779685;
	bh=Bo6+UmSRgU1hyBZ03/T2Sz0b6VWTdRNmrxqBjk+ItSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oF8E/ue8UestdjfPdJkyA21InzYUmBfct7NB5aL8VMtPStxTK96s3+6mKmD6aBPP
	 GYXaRpbWP70e1subImrrb+DqDV+BxsBfpP1zgf58SnIEX3Vj1bmNIzimijSJ4jRSZx
	 KdvlzPJPP0M9twYJXQD+FYmC9+gh4Kmsj9mEAwIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.1 331/568] drm/amdgpu: Fix function header names in amdgpu_connectors.c
Date: Wed,  3 Dec 2025 16:25:33 +0100
Message-ID: <20251203152452.833043630@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1166,7 +1166,10 @@ static void amdgpu_connector_dvi_force(s
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
@@ -1179,8 +1182,14 @@ static int amdgpu_max_hdmi_pixel_clock(c
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


