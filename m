Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79049635;
	Wed, 30 Jul 2025 09:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868947; cv=none; b=BSgOVuHvMpfena/0hrKWTKYsQLL1TalgKBp4ijnWt5OUC3q5TETujdyYKtUYm2JAmU982h3jJkBz9y0tgKPwCXFtgcBToVZanBlQAAjfvYYEPE/kDVo+iOwoZ+2TNvjC3U1b5i9Je7KsBZIa1EsnArJBTzEP1fF66uS4WODlBsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868947; c=relaxed/simple;
	bh=4hFiwACNAGr3bF6jTFBJiE3LK/oXIa5qj9zNLBl3OoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBsle3Gj+UP+jKv+Q38Yb/iV7r3YVZ11ws/D/0ygKT7OPRjGG502C4eMI8C+zkdJNq++S0XtE4T3ivKYawbvzkwUnp5Iw2TCaH+a9Xqrs3P2d7jgCvK6/Z/GBJTfhiigqr/GoaokKroPePgNa4CpVVGXdp8wdkhalMVMI1kvtJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfhSG0JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfhSG0JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B10C4CEF5;
	Wed, 30 Jul 2025 09:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868947;
	bh=4hFiwACNAGr3bF6jTFBJiE3LK/oXIa5qj9zNLBl3OoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfhSG0JU+PiovthwsV1LhQxvCjoTVUV0gXzVdNDPa+OU1S8zBIsdaPn68ZSRTFcyF
	 btB9uSO+1NhYrWpQhIDXYtNYSmfNSbQHxz1J9Ux4RsRk1AbPAjkXmvfjCPiqz7sB64
	 chCfDRpo4BJ1i5EY8diqGm+E7KBA6iNLgYme2x+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 6.12 115/117] Revert "drm/xe/forcewake: Add a helper xe_force_wake_ref_has_domain()"
Date: Wed, 30 Jul 2025 11:36:24 +0200
Message-ID: <20250730093238.284249319@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomita Moeko <tomitamoeko@gmail.com>

This reverts commit deb05f8431f31e08fd6ab99a56069fc98014dbec.

The helper function introduced in the reverted commit is for handling
the "refcounted domain mask" introduced in commit a7ddcea1f5ac
("drm/xe: Error handling in xe_force_wake_get()"). Since that API change
only exists in 6.13 and later, this helper is unnecessary in 6.12 stable
kernel.

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_force_wake.h |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/drivers/gpu/drm/xe/xe_force_wake.h
+++ b/drivers/gpu/drm/xe/xe_force_wake.h
@@ -46,20 +46,4 @@ xe_force_wake_assert_held(struct xe_forc
 	xe_gt_assert(fw->gt, fw->awake_domains & domain);
 }
 
-/**
- * xe_force_wake_ref_has_domain - verifies if the domains are in fw_ref
- * @fw_ref : the force_wake reference
- * @domain : forcewake domain to verify
- *
- * This function confirms whether the @fw_ref includes a reference to the
- * specified @domain.
- *
- * Return: true if domain is refcounted.
- */
-static inline bool
-xe_force_wake_ref_has_domain(unsigned int fw_ref, enum xe_force_wake_domains domain)
-{
-	return fw_ref & domain;
-}
-
 #endif


