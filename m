Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75343332900;
	Thu, 27 Nov 2025 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255433; cv=none; b=eiyWOOdpQfvxCwSqUjrE/KnjroT+Rt0pwuBlqZEG2EPQGcrUo+CtkH9GSzzsZ5JsQ5nwovLsYg0FEXdPpkNWJ9s6vhXa1Ym7gCP74t26yNZO0DlU8T1alQTVZ6KTTEbB4ao0m1LJ9tJdCWPKUHB+8IxTdQS1jSOxDtAqytnpV8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255433; c=relaxed/simple;
	bh=gryWYD/J8cLmQ1lMGOWycTuahuAhhf3eRiNv3Li4Lh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6S6RXr9qqHFXoNpkcjLJqspIyJU6HMirUXtr07KCcf5nPlpAUMo77zmBfu7VyU0htLUNGNb8CDGtX1oIKBv1XUce8LLz1RApavYrlHR/QvOKhhR0+5YBwBSdVSRyggliMDBuH0CmKzE5h9j1yOqgfuKCUmprRsuadR+nNLbjcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Dl+ALuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Dl+ALuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E71C4CEF8;
	Thu, 27 Nov 2025 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255433;
	bh=gryWYD/J8cLmQ1lMGOWycTuahuAhhf3eRiNv3Li4Lh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Dl+ALuNiSl7J//DstmsIFA286CIiEV0z+ckYNuQ8hrBxc+Ef2kTrArlZz+eVGnzz
	 duTryhh8eWeB5vJyYC5sKxjJMRnBi8PVqk3y9jfUw+IuWysNOTBnw1L8rMsmWOlW6H
	 Z1j94K2bbpZgwL6yudNgnUAMZ7u9mCl5uknCuKSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/112] drm/i915/dp_mst: Disable Panel Replay
Date: Thu, 27 Nov 2025 15:46:47 +0100
Message-ID: <20251127144036.686372355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit f2687d3cc9f905505d7b510c50970176115066a2 ]

Disable Panel Replay on MST links until it's properly implemented. For
instance the required VSC SDP is not programmed on MST and FEC is not
enabled if Panel Replay is enabled.

Fixes: 3257e55d3ea7 ("drm/i915/panelreplay: enable/disable panel replay")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15174
Cc: Jouni Högander <jouni.hogander@intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20251107124141.911895-1-imre.deak@intel.com
(cherry picked from commit e109f644b871df8440c886a69cdce971ed533088)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ placed MST check at function start since DPCD read was moved to caller ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -591,6 +591,10 @@ static void _panel_replay_init_dpcd(stru
 {
 	struct intel_display *display = to_intel_display(intel_dp);
 
+	/* TODO: Enable Panel Replay on MST once it's properly implemented. */
+	if (intel_dp->mst_detect == DRM_DP_MST)
+		return;
+
 	if (intel_dp_is_edp(intel_dp)) {
 		if (!intel_alpm_aux_less_wake_supported(intel_dp)) {
 			drm_dbg_kms(display->drm,


