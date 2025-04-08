Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BD269B13;
	Tue,  8 Apr 2025 10:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109872; cv=none; b=NUpg0gppugE4lpkgi/x7JVpO+CAA/nevsXqrxBAL3W8aPMCGjnya3hNv9BoCiycal0GlQ9/CWghme0JQPZg6zoLL96plEZAVQOUh7troAGQekO96ULnDoykSQLNCpdQKcmp+ba7dHNJNWt1T0RkQFkmL33zwJ9T6TapHlq80qMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109872; c=relaxed/simple;
	bh=DWcGSRo8VkHKQZzwKRvWNDVBL/sOqIttm3XS1CLT7GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbI5kEZRIq8EEEgGUjZYTGtU6BQVgLIilcq7vW85BqmciKTqgnvSzsnXqbbxPnxHy/0EPIyfczvudhpEf/QYjT53P6ctUrtUJHRKZA5EzRiZGk6Pj94H5S/NTfiC9K744L/c8PUXaXkbxMt5kE5DaxnQzWRar3HDipy4FwT6TDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBksxOuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBksxOuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C860C4CEEB;
	Tue,  8 Apr 2025 10:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109872;
	bh=DWcGSRo8VkHKQZzwKRvWNDVBL/sOqIttm3XS1CLT7GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBksxOuU3Z3eZjm0eX7A40BkPc5qSba1ummx+CVoSz4+99sFqVL/xQiPXXd7xKT4X
	 iWKwyzJh6qyChH/crRM3yn8S6ymq8e19a5r0y0QJ5TbocGTv1UcCrO6SMwcpvoKokI
	 IoQzfM9qHZXMei1pGZAp0ukiSSzBIL7K1J9N/wfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/227] drm/nouveau: Do not override forced connector status
Date: Tue,  8 Apr 2025 12:47:03 +0200
Message-ID: <20250408104821.752809415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6b8ad830c0348..aa8e4a732b7ce 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -751,7 +751,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



