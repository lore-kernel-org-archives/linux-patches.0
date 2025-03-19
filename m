Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDDD1E5205;
	Wed, 19 Mar 2025 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395092; cv=none; b=g8jlQ7pQNK4KgXXZEmzbXn7W1qO2IQTWAUr9dRozWKo8mrsKU10RHZV+H8ZNtWaOpGS+MXizXa16iuqmtlyEyGDmZPTe5XG67nIjf4IIiUxpyow5j7FBAfyRXKTPfNfKHEuJYS1pTxG8vD9UozlDXVhTm6jaGd5SuYy/LiDFFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395092; c=relaxed/simple;
	bh=+PEca+wbuBkdfdwq26ro82rCYcRK+JLWxlLdtjkle4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZAOCw8mUk/8i2mXiFX5qraDbfV47FM8iKYBMkEVysceIKoudtvPT0CtqhUN/vspeOqw5N8x3axccQteVMyENOETKjHV8EttmkVWdsmmYjXO17yh9og4jMPSqunH41lBfVGQgpIaOzYynxU4UNAnoZ+X2egy3sWd+/NsdZe4Bb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ym+up5+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ym+up5+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116ACC4CEE4;
	Wed, 19 Mar 2025 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395092;
	bh=+PEca+wbuBkdfdwq26ro82rCYcRK+JLWxlLdtjkle4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ym+up5+JhSmVT8Ncc1EC/fDUN+Jf8sRoZ1zvirSIlnvEr2Z0uz6e00VcMgkvw0OW1
	 BvvslAN+CSsOHe6fn7Jj8twaYag0wg8HOf6x8WtyhrzJUSYi+woOzj+F6T5wlIe8ij
	 nOBepPUqNB/CTS+91S/SVuwRzqPeTmA565gUhi8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/231] drm/nouveau: Do not override forced connector status
Date: Wed, 19 Mar 2025 07:30:33 -0700
Message-ID: <20250319143030.297341422@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index b06aa473102b3..5ab4201c981e4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -776,7 +776,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



