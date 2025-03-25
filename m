Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45C7255E47;
	Tue, 25 Mar 2025 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905689; cv=none; b=hTMxSR1DRLlpAhpgQW6xJNvC5gTEF8Me5B295gAcLZyaBgdhBLEHLBtQ71IglULROY60zD4niKeqvzoO5cbB2pC1NhYOnw2TD6Vo1JJ7b5O5xGB3/GCl6LGn278ZBOiLhB7b003bR6/5IZK5EsG2cEHUgR2LXXK12iZ2JhsEavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905689; c=relaxed/simple;
	bh=pBRh2qGYRgHE/rVllQ7jqrYcIzklJpKokwbORUz9dyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxoB0AxFom5N2qQgIU4B8E1n1Jc03mLSdDsuQ1Vm1U3+BV3VQXIckmDdazguzBYumhGjWFD/7MrD+wBnj7jCzSMkPMUznXG6uO0zvmzv+dlXR0vNyxuyiGZeAM9u4sVR42cR1kzmESygKu2zRMfYmmknWUjQm6CVLy/anS15hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExW74+mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExW74+mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7844AC4CEE4;
	Tue, 25 Mar 2025 12:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905689;
	bh=pBRh2qGYRgHE/rVllQ7jqrYcIzklJpKokwbORUz9dyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExW74+mj4oxy0wLsA3ZY6Ikkq5mVdVAwXhFcuK+SRZ4u3dTE/Rn+LBYguyjJhNNIL
	 iJ4wju+hgFQicHJRPItSiwzAwUefns4znnYrw8WD6JiL/sp0XJi3hm6t5e7BQjEUYm
	 7gf6OAvoM+7NrPAnDDHrhd/Nl9ox1AjhLM9uBmy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/198] drm/nouveau: Do not override forced connector status
Date: Tue, 25 Mar 2025 08:20:32 -0400
Message-ID: <20250325122158.478682978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
index bdf5262ebd35e..5a30d115525ad 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -755,7 +755,6 @@ nouveau_connector_force(struct drm_connector *connector)
 	if (!nv_encoder) {
 		NV_ERROR(drm, "can't find encoder to force %s on!\n",
 			 connector->name);
-		connector->status = connector_status_disconnected;
 		return;
 	}
 
-- 
2.39.5



