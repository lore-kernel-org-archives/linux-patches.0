Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9871B1ADFFE;
	Tue, 26 Aug 2025 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215304; cv=none; b=EkOivcmD/G3XvExMMv1ZidKtoF92XRtWrgwYNF3bgIo7+ewmvKgUoSATg4ZzXSOXenmZQJ4bFJR4GIePlcu1QW1MPAYBHN9M+fYfX08sjC1d72mcgwooTpNG+I6n3o0xG/L3qj09tzwQtPlg7rOZIhPZgWs4+VEYfwms7WQ6+Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215304; c=relaxed/simple;
	bh=74GjVozd1b4mdY2K3P/cmiHx/RWLRx+NEpqjF6GX9mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huaBXEqh0l2yO32fsSV5oG/9HYMsvP2iAj0gz0lz7aUZzQuKZITEeaVD3nLqnb3XhDFiyssXFFRUf+rAnc3I4xxjtWo9GFaUkYNRC9MuTiGqsz9VUTMnAwWVqfSvavZQiPvda+4n7h6dJM/BCyCqrfUwLx2bHBZTFxmOY09aJJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0dx58+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0dx58+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F55C4CEF1;
	Tue, 26 Aug 2025 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215304;
	bh=74GjVozd1b4mdY2K3P/cmiHx/RWLRx+NEpqjF6GX9mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0dx58+TxDftKNYvaALXYXuI8UWpPUKyQO0oI7plVtA/jI9DtdN0YU86F/L1brCD7
	 n9sbE3w7IRDj/A3598Fw+W15J9z/Ghfc6ezL6Wo+gvlCiNF8LyQQ+spn0aXPceJgrP
	 j5+BhGRHXpAyTzvgQ4c8F75K12e7Scg9fEPWjBL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/482] drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()
Date: Tue, 26 Aug 2025 13:11:57 +0200
Message-ID: <20250826110942.284695686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f8f127e7722..ab6964ca1c2b 100644
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



