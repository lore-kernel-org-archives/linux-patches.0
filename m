Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3102F60A7;
	Tue, 11 Nov 2025 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823147; cv=none; b=bZOZvH+sEuJZqyBMCe2Z3zeGEyO2UIy3cp982kCRHjhAE0hwhDDTihh6QZFGfClZgbezONoDIb7fREtDGHUeRQy+e4hRHyfunWwSosUtxCicGf3xDaI2sjuDOLeMRZP8b4nVUeV93KejTzUWdr7p3yfeM7RFntC7GlnEqVGOGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823147; c=relaxed/simple;
	bh=RRM7bjhq52q5NNvEucakSfQB4bU51WGs70q6kopkAOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLizIO0q2tkLAG1aN+j4jr8hv3QlHEWhzvd6YlRRaNgi7gIB+K+JnHi9G/47/WANQvsT7s5jccecpSYTD3ksRY9xAM9LRQw4iysuK3onl5BN/RnHKsTTqR+/cXAUm2WGW+jav00mZlSr5yjGZ7YkfZZe3g/0OzHmgJsbF3Wfwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qznG9bM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qznG9bM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98420C4CEFB;
	Tue, 11 Nov 2025 01:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823146;
	bh=RRM7bjhq52q5NNvEucakSfQB4bU51WGs70q6kopkAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qznG9bM0DtG7bOMK01loytRT384Qcg+JjApzyxru0oLZ0HAg/tdFOTMxOqZofsKjx
	 MVvIlRmpMgLFRPRpxQgwWsZx1NjCMSFNBVy+/UiWZXzK/LGIuLPJp6U1SZdvn4adeJ
	 kyzPHiiMZJFagFASJWWjp0+HWnsl3P+/5aaf7f9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 239/849] drm/amd/display: Fix dmub_cmd header alignment
Date: Tue, 11 Nov 2025 09:36:49 +0900
Message-ID: <20251111004542.216735082@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 327aba7f558187e451636c77a1662a2858438dc9 ]

[why & how]
Header misalignment in struct dmub_cmd_replay_copy_settings_data and
struct dmub_alpm_auxless_data causes incorrect data read between driver
and dmub.
Fix the misalignment and ensure that everything is aligned to 4-byte
boundaries.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index 6a69a788abe80..6fa25b0375858 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -4015,6 +4015,10 @@ struct dmub_alpm_auxless_data {
 	uint16_t lfps_t1_t2_override_us;
 	short lfps_t1_t2_offset_us;
 	uint8_t lttpr_count;
+	/*
+	 * Padding to align structure to 4 byte boundary.
+	 */
+	uint8_t pad[1];
 };
 
 /**
@@ -4092,6 +4096,14 @@ struct dmub_cmd_replay_copy_settings_data {
 	 */
 	struct dmub_alpm_auxless_data auxless_alpm_data;
 
+	/**
+	 * @hpo_stream_enc_inst: HPO stream encoder instance
+	 */
+	uint8_t hpo_stream_enc_inst;
+	/**
+	 * @hpo_link_enc_inst: HPO link encoder instance
+	 */
+	uint8_t hpo_link_enc_inst;
 	/**
 	 * @pad: Align structure to 4 byte boundary.
 	 */
-- 
2.51.0



