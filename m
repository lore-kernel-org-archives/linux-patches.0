Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763532BCF43;
	Tue, 11 Nov 2025 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825538; cv=none; b=R9jNxF5carX/H1MZeVmnNEHq/HdmpgbmOmwNpUK12oJJyWcDC9qTUr90qK/wXUo/NcmT1d2KQ8r4jMgrqFY/RfCPCb5pH+cwhWi1XG3aNdwHIimLHCgn9qlscukBKi6GTGa2ufYUd+YrlbL9wiSnYSqU8AI7gZhpZEisx3oeDW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825538; c=relaxed/simple;
	bh=w41sWJjZ4qc+fS5692Wf/WTpd4bZaBV4RJDSnqfvWoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWbG+wYSNv55QzL5qe1dBbFcUDLDnazXdAuktL+zm6HI4pqpnlEq1Fp0FDhrQ74IURsQZNmum/O6rcsbnP9yyuBPnzUgrbJ2j+3tW/uWvJdJMBTro9+qSgeKn8p+hk0KwXIwKWlISY35DR0XNc/EMgZeY6BIBdC4R/ZpXznrAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0c+pdXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0c+pdXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1289C16AAE;
	Tue, 11 Nov 2025 01:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825538;
	bh=w41sWJjZ4qc+fS5692Wf/WTpd4bZaBV4RJDSnqfvWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0c+pdXXD01/bXJ3WnPLgIvgQmM575KIBOvuFgpTX0i9UwC0/waxdf9qIfCpXmWKa
	 lAvInvLYMCoTd04i3LRKk1hiscYD2Pl/SE7KsOLyjZgHh8Xz8IXvAsCg2DKoK0g07w
	 8AEaElpC+HUT+ev1iO2983ddyZoyADRmxHARjau4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.17 843/849] drm/amdgpu: Fix function header names in amdgpu_connectors.c
Date: Tue, 11 Nov 2025 09:46:53 +0900
Message-ID: <20251111004556.801875567@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 					    const struct drm_display_mode *mode)


