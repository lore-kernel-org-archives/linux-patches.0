Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F6382C60;
	Tue, 29 Apr 2025 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947600; cv=none; b=phr7+0xFWpSRnZyuG2RjEVB8qKzZsL4H7gEqzf4aQ4PDeEbZU3aXIaL6BA/ZUc1hoCWXQBVQFUBaPxz5R7u/qxM7+FbG7SErH8NtszsOV+ZlURnGyARGIz5W39VzcMt8SAGA8SMxcpmyToMb/7am8Qxyf9+LNzadR0FPakV+G7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947600; c=relaxed/simple;
	bh=daw/pOv6/VveXinlqHrKWzZKB9FA3+w+WJE0QXSltb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/m+yWI/Mkd+6higcN7uxBGt6EP5O7uaSjmqY0WCpCwMyzUTzagIxkgt/8EN3upD10S2NLp92PDzmtIEEak9hFzFvMg5puAOcwOrgNr5SB0I96fQgCDJU2wY3JbRpNIBhNERUxedOJlMgt6/fQLKz6UU5NFygG7A5YE7RJroAvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QefSIEK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QefSIEK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B85C4CEE3;
	Tue, 29 Apr 2025 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947600;
	bh=daw/pOv6/VveXinlqHrKWzZKB9FA3+w+WJE0QXSltb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QefSIEK8TFTPf3z9XV581Vvdzye3egHfxZdteOjszhkl8EthEoVFb6D8ka9vTeVku
	 sPrIO7OXdXvaXQBX+KeZPN5/bShG5Hxi/0WxbCNWMhQj52kdr/kq321XQSQlPaZ2W4
	 pp9om4h2tT2YnpcVBNFrcZ89+dvUoLU2h+XUbXb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Rohit Chavan <roheetchavan@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/280] drm/amd/display: Fix unnecessary cast warnings from checkpatch
Date: Tue, 29 Apr 2025 18:39:48 +0200
Message-ID: <20250429161117.043981273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Rohit Chavan <roheetchavan@gmail.com>

[ Upstream commit c299cb6eafaf76d0cb4094623d6401c45d8bd0dc ]

This patch addresses warnings produced by the checkpatch script
related to unnecessary casts that could potentially hide bugs.

The specific warnings are as follows:
- Warning at drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c:16
- Warning at drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c:20
- Warning at drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c:30

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rohit Chavan <roheetchavan@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: cd9e6d6fdd2d ("drm/amd/display/dml2: use vzalloc rather than kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index cb187604744e9..dedf0fd3eb276 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -13,11 +13,11 @@
 
 static bool dml21_allocate_memory(struct dml2_context **dml_ctx)
 {
-	*dml_ctx = (struct dml2_context *)kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+	*dml_ctx = kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
 	if (!(*dml_ctx))
 		return false;
 
-	(*dml_ctx)->v21.dml_init.dml2_instance = (struct dml2_instance *)kzalloc(sizeof(struct dml2_instance), GFP_KERNEL);
+	(*dml_ctx)->v21.dml_init.dml2_instance = kzalloc(sizeof(struct dml2_instance), GFP_KERNEL);
 	if (!((*dml_ctx)->v21.dml_init.dml2_instance))
 		return false;
 
@@ -27,7 +27,7 @@ static bool dml21_allocate_memory(struct dml2_context **dml_ctx)
 	(*dml_ctx)->v21.mode_support.display_config = &(*dml_ctx)->v21.display_config;
 	(*dml_ctx)->v21.mode_programming.display_config = (*dml_ctx)->v21.mode_support.display_config;
 
-	(*dml_ctx)->v21.mode_programming.programming = (struct dml2_display_cfg_programming *)kzalloc(sizeof(struct dml2_display_cfg_programming), GFP_KERNEL);
+	(*dml_ctx)->v21.mode_programming.programming = kzalloc(sizeof(struct dml2_display_cfg_programming), GFP_KERNEL);
 	if (!((*dml_ctx)->v21.mode_programming.programming))
 		return false;
 
-- 
2.39.5



