Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B3352FC4;
	Tue, 26 Aug 2025 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217021; cv=none; b=cbBuwUexBhdVU8Z3H8trbD8XjgEpu3KAdiSunAMa6sLLICFAsOhMJm2Y7R5WY4PiCFiArIjIWz5dqwAak4T3ckh5xuhgTVvAQECwoMXehGbMI++BlqhOoPBTQrnuGEup6LXaGXUTb0FSsJ+iBAeXifJ2aCDda6vu1P4dWWiNRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217021; c=relaxed/simple;
	bh=aSy7AJdhtX+FxIJKadzQoIiQpjebwAcgBxLJt/xREvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox/yQS0usgF18+OQ6QMdwSOR0Ne2zdt653DYlllyeLIEZXm9ALoJLUZiXwWsBYEQx8kt67JvHPmkupJyoGHKjfiBwzVPKJ9Cdz8i1DgdoMLUuf0x6wjpaCelQMrt5WK1/Y8ofsqzT6/cqnoCFPHL8qEw6/qcRA4yvFHzHdo9oKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvz2Xatv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvz2Xatv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC61C113D0;
	Tue, 26 Aug 2025 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217021;
	bh=aSy7AJdhtX+FxIJKadzQoIiQpjebwAcgBxLJt/xREvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvz2XatvUJz8H1iAYvH9NufRUpgtJWR4SWOC+cMIAf919x27l6/gIiDJx0tWnVNHl
	 /6ZLcNj7W/ZS7fIaELAiWB4z6NCK0lMzkxIHQUddqedguUCEHn0bIVyWz15y9FYXsN
	 5bvvnxW3CVz4gwdaKK5tBFoOT53DEPWM7C/OVzSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 629/644] drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()
Date: Tue, 26 Aug 2025 13:12:00 +0200
Message-ID: <20250826111002.144233059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b840da3f052a..b5a15b7aae66 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -256,6 +256,9 @@ enum mod_hdcp_status mod_hdcp_hdcp1_create_session(struct mod_hdcp *hdcp)
 		return MOD_HDCP_STATUS_FAILURE;
 	}
 
+	if (!display)
+		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
+
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.context.mem_context.shared_buf;
 
 	mutex_lock(&psp->hdcp_context.mutex);
-- 
2.50.1



