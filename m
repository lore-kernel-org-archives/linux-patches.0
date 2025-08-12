Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178DA3F9D2;
	Tue, 12 Aug 2025 18:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023066; cv=none; b=D4ho+7BkwHlA0Kg5T6E8yKGZkcI31NXzNF8T3ezbIRfkpsPTQkZxc8z73WRJpJaNON8r+112sl2dLF4aD+jJQM+/9CReCS1VIF/Y0BUKhCT/hS9XB+a7nND6nJ6yh3PxBUyHhcTl7xWvEiPL/UyJHgPJXMgDFdLczZMcQ6Fbu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023066; c=relaxed/simple;
	bh=udNBCj6hJfy1X9AXh2ZVuES/1+WeHenp7XHURgUMVsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4fxreutlz65UG3VfC5AyG0cWuZhfT3Wiq7b28HaFDJZgv0Pm4FXnbKGervFirWOlei9fSGx4Pcp3fbPrPA+Ce/SgdaQ06rGyYYgHpTVxB3pn+kcFtKN/qNVm0YA1ZVsZEnKeAqDyXrwR5M6xZIfb0X43cbW+/uNDpd8WViem/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPZLwj7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPZLwj7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2751FC4CEF0;
	Tue, 12 Aug 2025 18:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023065;
	bh=udNBCj6hJfy1X9AXh2ZVuES/1+WeHenp7XHURgUMVsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPZLwj7/0eR9f73++tt0Qj51Qvhggmsoxuc98YqhMhHzBAQ144VKc5C28y58YMDZx
	 olzA/XKb3dcWLmLccoYfd3TGMtNRkUqmBpa4D4Utz/Hdy9ebQAFl7wRR6ks47dfc8a
	 JfAO4y1+eJhGCL9BfGFSCqK20n0BaMiHFUk6JFIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 339/369] drm/i915/display: add intel_encoder_is_hdmi()
Date: Tue, 12 Aug 2025 19:30:36 +0200
Message-ID: <20250812173029.452309605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit efa43b751637c0e16a92e1787f1d8baaf56dafba upstream.

Similar to intel_encoder_is_dp() and friends.

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/e6bf9e01deb5d0d8b566af128a762d1313638847.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -2075,6 +2075,19 @@ static inline bool intel_encoder_is_dp(s
 	}
 }
 
+static inline bool intel_encoder_is_hdmi(struct intel_encoder *encoder)
+{
+	switch (encoder->type) {
+	case INTEL_OUTPUT_HDMI:
+		return true;
+	case INTEL_OUTPUT_DDI:
+		/* See if the HDMI encoder is valid. */
+		return i915_mmio_reg_valid(enc_to_intel_hdmi(encoder)->hdmi_reg);
+	default:
+		return false;
+	}
+}
+
 static inline struct intel_lspcon *
 enc_to_intel_lspcon(struct intel_encoder *encoder)
 {


