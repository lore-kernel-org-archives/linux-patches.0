Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77721DF256;
	Wed, 19 Mar 2025 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395221; cv=none; b=YRH5D5fwqJSJ442KH97/brEdwV/daEKgsPd1BUvdO/9lIVUgJGqUdMxzglI4qOqiHpRh86OMBNvKKr+zkzsZK5liIFZypT00pxgEJs4MzgA68+BomRPwqnDbSYRSnQ/flf44xTn7hU8TzWsG3lnrCN4zq9gfyWuH2dxqwywIUak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395221; c=relaxed/simple;
	bh=FGh1Uvfo+unASKoFG+7wac1IdGq8hLkPt+2lsNUfzxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz68sDZZNn3WPpOqD3+y1qHQlIQjeUv6oVSeYBpq0Z/hO10DYzZJ9RDQZYbXQQSHAdEFXYYeXbpxVwRfuOZrUVz3cE+bAn2ywzhKVLD2CYdXhQIBXk/rKoLvWGCdf0dMYY+dgN7g9tCcO8JAzVv+5HXhZHZKf42fv1/ZtVqnXN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlC7nSP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlC7nSP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E976C4CEE4;
	Wed, 19 Mar 2025 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395221;
	bh=FGh1Uvfo+unASKoFG+7wac1IdGq8hLkPt+2lsNUfzxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlC7nSP/ykNlSW3NbbttXwAiz8ugShzSWfrMlG1/AqrKjjR615ZhBiHaIyB6shUuS
	 N4vUxaEL0l8NDDwVzUzxA6JqxQavwq+70H0sf2bGL766B+m6rZA+2+gbM8FPYcdiD6
	 bswBpJMxZZKuJpsa7RojqD5ReEvEchXftwsu48Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/166] drm/nouveau: Do not override forced connector status
Date: Wed, 19 Mar 2025 07:31:02 -0700
Message-ID: <20250319143022.488700281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 22a125243d81f..c1985448d9b38 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -758,7 +758,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



