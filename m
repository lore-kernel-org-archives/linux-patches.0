Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85181233128;
	Tue, 26 Aug 2025 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207987; cv=none; b=ivBx5wNq8MdIZrGFLVKPmt+QrnMsl3IZb2VnnXQK/EySJcDMWjhl8h1AYmP2X2HLLY0F8CXNsEzdB72mGv2rCOxHA4pw4ppfF9RcLh4YtJWdgoR4ojUsKiWjYptobZT0QoYYKiJR/OwaAhJNniKQqTcf+jRu82LmIq8u92KErA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207987; c=relaxed/simple;
	bh=Kaq0XLGFKs5MwDlc5J62DwQlPdrm0p7cMS1avHgni4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+OxMnOVCXZ8b8puMIkqNQsB9PtjPCGjvoalrK7lZmIu8wpk8UoyJIk+gyFqtGb4xBmfVrCQ4jKsTieu0JpaxGtqHq9y9D8rPwyUhLMDmHmmQQ+/pcYFNVbJXtjjmkhTe4l5gMsOmYg7JSFomIW4clSK8Qv/FQPJYs4ms/HkW4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udpUG+XP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udpUG+XP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16426C4CEF1;
	Tue, 26 Aug 2025 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207987;
	bh=Kaq0XLGFKs5MwDlc5J62DwQlPdrm0p7cMS1avHgni4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udpUG+XP6vz5NwNeqcz4kLV5GmOc4dzuOofgmfh2zaROMzu0UaDz7jPSTGG2vZV45
	 2zfbNzQ6CtnQoEs1iAL5itRnsfY9S6jKiHSLYsdelSmh/vyAnM9VBir68SjIUt9Y+d
	 ATRdLwhpFdckfCFhJ/w803lDXUTBJ391L1jt/WyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 395/457] drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826110947.059038427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 7a2ca2ea64b1b63c8baa94a8f5deb70b2248d119 ]

The function mod_hdcp_hdcp1_create_session() calls the function
get_first_active_display(), but does not check its return value.
The return value is a null pointer if the display list is empty.
This will lead to a null pointer dereference.

Add a null pointer check for get_first_active_display() and return
MOD_HDCP_STATUS_DISPLAY_NOT_FOUND if the function return null.

This is similar to the commit c3e9826a2202
("drm/amd/display: Add null pointer check for get_first_active_display()").

Fixes: 2deade5ede56 ("drm/amd/display: Remove hdcp display state with mst fix")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5e43eb3cd731649c4f8b9134f857be62a416c893)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
index e58e7b93810b..6b7db8ec9a53 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -260,6 +260,9 @@ enum mod_hdcp_status mod_hdcp_hdcp1_create_session(struct mod_hdcp *hdcp)
 		return MOD_HDCP_STATUS_FAILURE;
 	}
 
+	if (!display)
+		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
+
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.context.mem_context.shared_buf;
 
 	mutex_lock(&psp->hdcp_context.mutex);
-- 
2.50.1



