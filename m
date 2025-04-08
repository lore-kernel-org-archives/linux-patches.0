Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAC26A0C2;
	Tue,  8 Apr 2025 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113828; cv=none; b=Ftx2rczyOOvxOTZmHAO8WF1Z4D5h/ZiyeBLeHwPwoO6f21e4sfoGm+xo6U4NTC/73Y9YAk8ryYVRKFrqqPC5xiyh9IaIapD/Zxz65BldKWEzhBvhpHpWEumMDdi8cL2zIvZo/OVOTUUCyIEr5lcXvYFVq1krt2nJJeNHeOriHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113828; c=relaxed/simple;
	bh=K57vgOT/+l+QAkSq0PE/et7+2imTPPwxxIiKJppZkqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY8mvuCeIPvr2NG90/de7HZOcloYSm9ks9xou2RXNq0OiQ5pqYQCe2y/zFmsu9yb7bZ6sK8yxQ3cs51yhEDkyD8XQwm/YO2bstDVKlbK3UZxOTqomtahaoRCvH8LxiW3wKnqJ8OQLKbCRHephO5WT9rDW0LHe6QLMc9dGXELS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMND/Rqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMND/Rqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5460CC4CEE5;
	Tue,  8 Apr 2025 12:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113828;
	bh=K57vgOT/+l+QAkSq0PE/et7+2imTPPwxxIiKJppZkqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMND/RqbGdGADOKDCr7vx+1V3vQecREIM28uoeO3ClKcqR0FTVoVyBX5M2W02b1qb
	 5ASYhY5NXvyzimLL6EojFKaj02b4ZTNQNHea3t10dpAEJqDuG66xECXW+EuJkviFK2
	 UdRVYlklGxgvtwwsNjSuIvK6vjp1xLRQwokTPq7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/154] drm/nouveau: Do not override forced connector status
Date: Tue,  8 Apr 2025 12:49:37 +0200
Message-ID: <20250408104816.418410730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c49303ba30c80..6f2bf5e9992f8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -759,7 +759,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



