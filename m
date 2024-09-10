Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D031DA4C;
	Tue, 10 Sep 2024 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964744; cv=none; b=qnSX9b4PiiBvfN9sAF2azO6weTRcNhhmpz9GSJKroEr5migoUMctwSJJ4ht+fKHznfVD3r6k0gyz1nCeoLNNRMER5GJ6f4JQmYx3xt1ixyVchae6CZ/MNLQNHFmYXctn3z6mgRckbwqYIE343pYmoqFg6HI+vozB/24EnOcgSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964744; c=relaxed/simple;
	bh=tOnGU4WRCmAJNWKzTht7Ic780WY0geifhKwQqEC+8CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB7iwBTaBEDaxnE/GTCJ4DTaU1HHpaABJ9a9mmA12MJK8kf9h+/hg2rRZ5AlMyJjUaJt+CsJymc3hE0hJ9HUgA4w7u9hriS2dAoQtvMlSpwEeOwpkCiYpY/49KSEnXxuW5jqkSP10BPItR3AhFyTrmdvcEVmwZ4XsfHIXFnNeXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhxeaUje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhxeaUje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7AAC4CEC3;
	Tue, 10 Sep 2024 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964744;
	bh=tOnGU4WRCmAJNWKzTht7Ic780WY0geifhKwQqEC+8CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhxeaUjeLPyPRPHKDVzE0qRDK9ugSvwt8FC2KGA87LmEVvpGQ7sQER+T/8+fKmMEf
	 yLLKu5hinrM8n+uXkJWcKlFvC7IC3KmU9aNaZp6/pCZLnPHcHR0p0HQNmQ+7xHk2FI
	 Gf2Q5C8EGzzr9GveeuH3PIz51kp5vvBOxXf0Wle0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/186] drm/amd/display: Add array index check for hdcp ddc access
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092555.338754132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 4e70c0f5251c25885c31ee84a31f99a01f7cf50e ]

[Why]
Coverity reports OVERRUN warning. Do not check if array
index valid.

[How]
Check msg_id valid and valid array index.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index 8e9caae7c955..1b2df97226a3 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -156,11 +156,16 @@ static enum mod_hdcp_status read(struct mod_hdcp *hdcp,
 	uint32_t cur_size = 0;
 	uint32_t data_offset = 0;
 
-	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID) {
+	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID ||
+		msg_id >= MOD_HDCP_MESSAGE_ID_MAX)
 		return MOD_HDCP_STATUS_DDC_FAILURE;
-	}
 
 	if (is_dp_hdcp(hdcp)) {
+		int num_dpcd_addrs = sizeof(hdcp_dpcd_addrs) /
+			sizeof(hdcp_dpcd_addrs[0]);
+		if (msg_id >= num_dpcd_addrs)
+			return MOD_HDCP_STATUS_DDC_FAILURE;
+
 		while (buf_len > 0) {
 			cur_size = MIN(buf_len, HDCP_MAX_AUX_TRANSACTION_SIZE);
 			success = hdcp->config.ddc.funcs.read_dpcd(hdcp->config.ddc.handle,
@@ -175,6 +180,11 @@ static enum mod_hdcp_status read(struct mod_hdcp *hdcp,
 			data_offset += cur_size;
 		}
 	} else {
+		int num_i2c_offsets = sizeof(hdcp_i2c_offsets) /
+			sizeof(hdcp_i2c_offsets[0]);
+		if (msg_id >= num_i2c_offsets)
+			return MOD_HDCP_STATUS_DDC_FAILURE;
+
 		success = hdcp->config.ddc.funcs.read_i2c(
 				hdcp->config.ddc.handle,
 				HDCP_I2C_ADDR,
@@ -219,11 +229,16 @@ static enum mod_hdcp_status write(struct mod_hdcp *hdcp,
 	uint32_t cur_size = 0;
 	uint32_t data_offset = 0;
 
-	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID) {
+	if (msg_id == MOD_HDCP_MESSAGE_ID_INVALID ||
+		msg_id >= MOD_HDCP_MESSAGE_ID_MAX)
 		return MOD_HDCP_STATUS_DDC_FAILURE;
-	}
 
 	if (is_dp_hdcp(hdcp)) {
+		int num_dpcd_addrs = sizeof(hdcp_dpcd_addrs) /
+			sizeof(hdcp_dpcd_addrs[0]);
+		if (msg_id >= num_dpcd_addrs)
+			return MOD_HDCP_STATUS_DDC_FAILURE;
+
 		while (buf_len > 0) {
 			cur_size = MIN(buf_len, HDCP_MAX_AUX_TRANSACTION_SIZE);
 			success = hdcp->config.ddc.funcs.write_dpcd(
@@ -239,6 +254,11 @@ static enum mod_hdcp_status write(struct mod_hdcp *hdcp,
 			data_offset += cur_size;
 		}
 	} else {
+		int num_i2c_offsets = sizeof(hdcp_i2c_offsets) /
+			sizeof(hdcp_i2c_offsets[0]);
+		if (msg_id >= num_i2c_offsets)
+			return MOD_HDCP_STATUS_DDC_FAILURE;
+
 		hdcp->buf[0] = hdcp_i2c_offsets[msg_id];
 		memmove(&hdcp->buf[1], buf, buf_len);
 		success = hdcp->config.ddc.funcs.write_i2c(
-- 
2.43.0



