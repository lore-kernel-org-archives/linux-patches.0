Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFB91B87D5;
	Wed, 19 Mar 2025 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394931; cv=none; b=GtQkkV428zIzuaI6/zLe+ecMNa+opNp+49YePzrY2GniGXMgHA+xvHbE7MzKnlktp03oUnV2iuxCC4LzU1c8F8xP5mbGDviUmUSUx4kDkIvjYmEQIesMTzmo3pavb4pehXxm3tnAPC6Z2XCNEkELbXTxR7HVeXLMYKe6LM7TWh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394931; c=relaxed/simple;
	bh=PrQ/tyPtRkKNPradbRl9xhtS+9bme7Y8APgVJfx2TT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfVFXtpEzvT/2hQmgVR9tpobzdgwRQXX7YjlVYjSAw4EosMYzin6RAiiZPEFbd5nxHxoi1JTbqj1yXq+1hoVoJjg5nzV9g5Ao9zLYKCCJY/WlRaKQ1dD3N9E28uue2Q5DQeYJbxL/Qef9zvoJw4P3nQpldoS9txPuRfV4tbFnZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWmb7sbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWmb7sbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D340C4CEE4;
	Wed, 19 Mar 2025 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394931;
	bh=PrQ/tyPtRkKNPradbRl9xhtS+9bme7Y8APgVJfx2TT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWmb7sbcOGsIPAPDZ+JN9d2z1hiEwl0yzSbVRCmgzSJNNZbCDUPB6lJqiB+/0NP3m
	 goi60A5G5v2hSlzdXgSRoJeeVHCTVo7LzzFdYv8WjQGqylyULfbLqWYODbgBnsfZYP
	 BIdFXeq1QrgitpnoV0HF8kS/Abz6/HP2oQA6AACk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 146/241] drm/nouveau: Do not override forced connector status
Date: Wed, 19 Mar 2025 07:30:16 -0700
Message-ID: <20250319143031.331310357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 01f1d77a2630e774ce33233c4e6723bca3ae9daa ]

Keep user-forced connector status even if it cannot be programmed. Same
behavior as for the rest of the drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250114100214.195386-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 8d5c9c74cbb90..eac0d1d2dbda2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -775,7 +775,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



