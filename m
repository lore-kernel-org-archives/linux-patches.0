Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07621CA8F;
	Mon,  1 Apr 2024 16:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987586; cv=none; b=ePon7EaRKCWtJLwAj/H6cMU30E7fW0Ghds3DgZKsf/ac22KGDSUXqmOCBWjpEG2l4B6ke6Sx+OMA6MLCZe2Ngr/4k+s77gcIUn9lddC3mWvXX73C9gkUc7PCI8ahdEH2QKbWg5tMvFc9jTka9USiPX7HFjR9FnRLOof5nv315fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987586; c=relaxed/simple;
	bh=rHhE3d1+Ftz8Scrylh0ADebtcs6el7WJTQigHPjw9Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hjuXrCbuC9FLbpAbmqoWe8Qfmi7hjk+h32kKpxuIwUaGAwiJA9nFXOZFm0/CJyGTUO04szkdj3Xughc47C6B8DhIhasu88JToPUA9oXvPJUFlBZ0cTcR62QqVB1JvhNVFwaWNxjIl2ghEtjpu67GDrNpUs+rLQJaiiiOzswF2a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNLf3PMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNLf3PMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5DBC433C7;
	Mon,  1 Apr 2024 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987586;
	bh=rHhE3d1+Ftz8Scrylh0ADebtcs6el7WJTQigHPjw9Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNLf3PMn7vgif7YyOXgTzmVLKMIJ6jZY9iVriRFRJkYZcerhBR2Sg/iwa0FqSRnIG
	 ptq9nF6sLx/wmf/qt//jw3CdX8hsqwyPx0Hz2Ds06uHnaDH9esYlfbGj166qt0Svae
	 r4UwyFCRk4mToXPx2SIBrkSnwO4AAc1Ro0b3KXw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 332/399] drm/i915/bios: Tolerate devdata==NULL in intel_bios_encoder_supports_dp_dual_mode()
Date: Mon,  1 Apr 2024 17:44:58 +0200
Message-ID: <20240401152559.088450492@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3344,6 +3344,9 @@ bool intel_bios_encoder_supports_dp_dual
 {
 	const struct child_device_config *child = &devdata->child;
 
+	if (!devdata)
+		return false;
+
 	if (!intel_bios_encoder_supports_dp(devdata) ||
 	    !intel_bios_encoder_supports_hdmi(devdata))
 		return false;


