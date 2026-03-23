Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983A21D00A;
	Mon, 23 Mar 2026 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274032; cv=none; b=KSXWpL0ORF8mYSMelBn5s+lH7aGXtQElGYg0CXIe5QMO57TzcV2U/gxQq4UoONCR2qKXdycCw+ZFWJAgaZAWd/Xxcr0K5HYOYfqdw5bpga28wva++FwCbL+Dnsukmlrbk2zdZ9gHi2FnzoV1HMQGqzEg/Vy5QAMU1HlAh/KmO/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274032; c=relaxed/simple;
	bh=ROO00yyzXyFXoPQ0QMWPP4EdPbgGkE3v4WpzQzvcD5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxB0g3jGl8KrZlI0sq13YbfN0QGC8CC2080xpR+6ruELLuDr/iirSI+bUaSPcVgbIkqs+JjZY2k1wAbqApnd3wMXEE7CNm2ur1NWUMBDGdHDz4+RDGy75dQsP6u6V0XLmgGWiK4lki60RRCZYFTeD5QWVqXJ3whGGvcCEH4usgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLIUO5M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLIUO5M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF45AC4CEF7;
	Mon, 23 Mar 2026 13:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274032;
	bh=ROO00yyzXyFXoPQ0QMWPP4EdPbgGkE3v4WpzQzvcD5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLIUO5M9dfYczDPjOpi/oBP6XhECccmr7ni0gumJA9PKmzW5YTx95tSkFk7MC6p/1
	 kyi+CFI/TOT202+hqvxiB9jXzNYhnYPspzQQ9rwDt2iglOXq8J5cOhw6Yh9UyQ+gCe
	 ZkmFCGcsx5UbEKCvQkspgwdXYmxGIHw5HScJuv90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 088/220] drm/i915/psr: Disable PSR on update_m_n and update_lrr
Date: Mon, 23 Mar 2026 14:44:25 +0100
Message-ID: <20260323134507.374642720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit b0a4dba7b623aa7cbc9efcc56b4af2ec8b274f3e upstream.

PSR/PR parameters might change based on update_m_n or update_lrr. Disable
on update_m_n and update_lrr to ensure proper parameters are taken into use
on next PSR enable in intel_psr_post_plane_update.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15771
Fixes: 2bc98c6f97af ("drm/i915/alpm: Compute ALPM parameters into crtc_state->alpm_state")
Cc: <stable@vger.kernel.org> # v6.19+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260312083710.1593781-2-jouni.hogander@intel.com
(cherry picked from commit 65852b56bfa929f99e28c96fd98b02058959da7f)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3087,6 +3087,8 @@ void intel_psr_pre_plane_update(struct i
 			 * - Display WA #1136: skl, bxt
 			 */
 			if (intel_crtc_needs_modeset(new_crtc_state) ||
+			    new_crtc_state->update_m_n ||
+			    new_crtc_state->update_lrr ||
 			    !new_crtc_state->has_psr ||
 			    !new_crtc_state->active_planes ||
 			    new_crtc_state->has_sel_update != psr->sel_update_enabled ||


