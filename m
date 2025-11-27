Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0C528D8E8;
	Thu, 27 Nov 2025 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255220; cv=none; b=IPnJYEpQESvWi0OetuOexVLQvWJmVtOqavPBMSN6bxzgvXYLcftNWziwhR/58a/ZnEH1+pnp8UsI26OMmAD0yW8BJBVD3Ul67brs4UFc34JydhSfgiBgdSsRov8lIhyvN/fMfGgas7tlKMEe506h0RVK+cSLdsxqQ8CfTqxLhTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255220; c=relaxed/simple;
	bh=CJRzWObSfedXo4QaxWgySKL1jz7L2auMhUjRoz9udTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrN1ZD5fKJfptFKqXvl+/N1pI9J4vKETjIE73hg3B6M1t0szV09SnA62rbUP8k0XPojBFskWQl1J9wHWd3K4+uhaRA2MNKxnnkCx+yKwrrkjzAWPxr0JJOMwaJV0SV9KsERSQDdl9uvsS0OpQk7J5lLWEv4MiwIlaJmESCzD0io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4X+Oi+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4X+Oi+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A37C4CEF8;
	Thu, 27 Nov 2025 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255220;
	bh=CJRzWObSfedXo4QaxWgySKL1jz7L2auMhUjRoz9udTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4X+Oi+Y7MhGQjhsZ7d7KzCCkfVRhFKwQXAdb4137QN96oIc8r7B6rXF8KUBeh1Ln
	 qmvPs1KDeuGlJDss9SPs+M2rVfK29G3HRUmhK5rf1iNMF+++eOmk25IjuoLPIP7CvH
	 jn3qAaJChDg+tKgEduOOowaePhXObR4MsOLltIok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 049/112] drm/amd/display: Increase DPCD read retries
Date: Thu, 27 Nov 2025 15:45:51 +0100
Message-ID: <20251127144034.637323261@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 8612badc331bcab2068baefa69e1458085ed89e3 upstream.

[Why]
Empirical measurement of some monitors that fail to read EDID while
booting shows that the number of retries with a 30ms delay between
tries is as high as 16.

[How]
Increase number of retries to 20.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4672
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ad1c59ad7cf74ec06e32fe2c330ac1e957222288)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1587,7 +1587,7 @@ static bool retrieve_link_cap(struct dc_
 	union edp_configuration_cap edp_config_cap;
 	union dp_downstream_port_present ds_port = { 0 };
 	enum dc_status status = DC_ERROR_UNEXPECTED;
-	uint32_t read_dpcd_retry_cnt = 3;
+	uint32_t read_dpcd_retry_cnt = 20;
 	int i;
 	struct dp_sink_hw_fw_revision dp_hw_fw_revision;
 	const uint32_t post_oui_delay = 30; // 30ms


