Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49928137F;
	Thu, 13 Feb 2025 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457700; cv=none; b=FdgzHWXgNxMWJu/bGVYH3nuQGDxQSOoiSvdjIVPNHjaW7+7zDRmFS4BsUgqbAzn47NU9PGufgp5sD9WhKXv46x/WzovuEeXn05Yg7mCtSnjcrnARUGkyQWJB7cE5L3BUBZJ2Tj81UOOaLD+5UA0gkdFvOzl1JyK07FU/45xa2Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457700; c=relaxed/simple;
	bh=s+dRbH3wP4ny00gTlbjhHTZwezjhs1HJFo1oQKn5Ztk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk97sQI3a/3q/YrswYB4xODnePfvIsAzD/x52b/dJ2hOJOKCpQZO0cKweQ3ZLewGvmHj5yKGjYAKTgf17nFzVQPMDiBfVOUAh9YCIoPKePgQvoJbHiK09W+WUFZ3Qj2mZ85FUgA+asQ1oQjmgPdXsfGyrNoz3OmjdoPZwZYZLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRCfjBV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRCfjBV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF059C4CED1;
	Thu, 13 Feb 2025 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457700;
	bh=s+dRbH3wP4ny00gTlbjhHTZwezjhs1HJFo1oQKn5Ztk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRCfjBV8OikyT8F9VLWX2DoogkpNvgDgDuqNzenQDkiWjxGIZLJg+3rOcX79s3loP
	 BiGUDcOL/o4kMpOZZOsZcx/LqhnU1DdUavmMPX7DUHjX2SpGAqQVjje4DWDY3zhUmq
	 VBq341ukga47wtIod7VFV7pFC/x1wqXED8Vexwzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 161/422] Revert "drm/amd/display: Use HW lock mgr for PSR1"
Date: Thu, 13 Feb 2025 15:25:10 +0100
Message-ID: <20250213142442.758579309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

commit f245b400a223a71d6d5f4c72a2cb9b573a7fc2b6 upstream.

This reverts commit
a2b5a9956269 ("drm/amd/display: Use HW lock mgr for PSR1")

Because it may cause system hang while connect with two edp panel.

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -63,8 +63,7 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
-	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
 
 	if (link->replay_settings.replay_feature_enabled)


