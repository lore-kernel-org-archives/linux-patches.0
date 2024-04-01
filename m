Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0B340876;
	Mon,  1 Apr 2024 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991314; cv=none; b=ikHdBxHGvoVUFhJAvIs8V7Ote2N6Ub9bDMkLeaSsVIwLudV2kkgvNg7qXqQMiNYYAhlQD45nEHnfCjHXtCrmebfFvMRnNj37r8hTyuPYr2vKCbc7mSO0QIE1jw2+xpao2aTUIq3y0eMezi1jgFGCKIVdKuCn0/Gn7kI0dgbVyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991314; c=relaxed/simple;
	bh=uDeA9SrJ+y+fHoqP4nfcTOlYYh1chtURrx2BGObXRBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NapzL/a0P6aZTooJlfUFJek9dkU0JSuM40PFHZnZ1N2os6VH/elPd5YVxSawJ37oDnhbn7osNBFku31VRVC9qz8YLdr4SL+ps1EUssR0fnVowXNtGnBgVM6guOtdZgZ6anX46GsBhdezMKt4xbJ1tnc//Tnj2bfKTCsuZEJ4SCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQ2nmL8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQ2nmL8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06D9C433F1;
	Mon,  1 Apr 2024 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991314;
	bh=uDeA9SrJ+y+fHoqP4nfcTOlYYh1chtURrx2BGObXRBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQ2nmL8qRzD1e7BToUkvDncj5YpJg8veqEBRbWp+YO5SwS5fT4ozbrH5sQvcYIZ1g
	 E/G+EKHXyeGKwWNciyHF3PX01ndgqZcuFylF7wQ7/ig6ni4dKqOvfYFwc61CwVMrbl
	 L2rtVp43IBzNYSJlkhpp1XFQ3a+Tf2u7Ql9wBdso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 228/272] drm/i915/bios: Tolerate devdata==NULL in intel_bios_encoder_supports_dp_dual_mode()
Date: Mon,  1 Apr 2024 17:46:58 +0200
Message-ID: <20240401152538.078352736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3413,6 +3413,9 @@ static bool intel_bios_encoder_supports_
 {
 	const struct child_device_config *child = &devdata->child;
 
+	if (!devdata)
+		return false;
+
 	if (!intel_bios_encoder_supports_dp(devdata) ||
 	    !intel_bios_encoder_supports_hdmi(devdata))
 		return false;


