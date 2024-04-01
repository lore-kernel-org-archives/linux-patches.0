Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F044D9F6;
	Mon,  1 Apr 2024 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990405; cv=none; b=V5Vu86M+ftIVd1YhM2MnYdbN8pSYYaMiJI5RfLpFoL8I5xetxSEThrc1mirMCdBO4I8RYhyth6ig6ZVT8JzXyeyoPafSaFCsNJPXmxDpekVQbNF7S6mmthBjGVhk4nmnGy+KoQodOk8K5LtcrSWIAnzetGr4LGMKQT3C3ynbVCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990405; c=relaxed/simple;
	bh=1oE1TpX7L6kLhcNB17Yltnc8d2UwDt5msA1Bp1IBPDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjkcHzB4xcRyIxgWooTNSOlUnK1Ch1j13rabjYkM2q80pUO39a4OMn/Bwr6KolH3TgTBez/Zo1EBybm8TAYUb7yPoVITJUa7F18Ii8JKinLZvx7W8nrLHU/UIIyXncAvJ9sBBPnBefvMJVNgiB/LsfDN6d/pQEaY0w2DJ8jQCcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iOtpblc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iOtpblc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7899C43399;
	Mon,  1 Apr 2024 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990405;
	bh=1oE1TpX7L6kLhcNB17Yltnc8d2UwDt5msA1Bp1IBPDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iOtpblc5qP4t0gCM0p4XICOXOSAUX7yunXOuVDz3+/ARiBdoxgNv1KEQ4lkjLCkg
	 hN5ceTxwu0WJ9M0Y214L8aM8lTfuQur23W++asfI4bvQxUK51Pj8uoz1OMYvN7d6UX
	 o0N+utfiTgP8VGZSt79FaCgbbPDkEfEHRov+kO7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 343/396] drm/i915/bios: Tolerate devdata==NULL in intel_bios_encoder_supports_dp_dual_mode()
Date: Mon,  1 Apr 2024 17:46:32 +0200
Message-ID: <20240401152558.144665628@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 32e39bab59934bfd3f37097d4dd85ac5eb0fd549 upstream.

If we have no VBT, or the VBT didn't declare the encoder
in question, we won't have the 'devdata' for the encoder.
Instead of oopsing just bail early.

We won't be able to tell whether the port is DP++ or not,
but so be it.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10464
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240319092443.15769-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 26410896206342c8a80d2b027923e9ee7d33b733)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -3313,6 +3313,9 @@ bool intel_bios_encoder_supports_dp_dual
 {
 	const struct child_device_config *child = &devdata->child;
 
+	if (!devdata)
+		return false;
+
 	if (!intel_bios_encoder_supports_dp(devdata) ||
 	    !intel_bios_encoder_supports_hdmi(devdata))
 		return false;


