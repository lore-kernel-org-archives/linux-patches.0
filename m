Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254945381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A066BC433C0;
	Mon, 19 Jun 2023 10:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171323;
	bh=9RoSE9FixoUb3VxDeIaXna0OWvELECVEc//L0sQQbnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHGn4pYhzLiagCXcb6GTepsrjLaeZijMR9aaMWCcMuOHXTSZq77XRMWHWmhj3q1nc
	 UbX2Rt/Z/G8I4a7mS071XVwV1yy7jRW0GzB/hJwxZGlz4p40OZRCtWjxcz3fhw9XzL
	 r3HXL9lT8IFEuD19Mg07IqsoAn20BRus3g5L992Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalia Petrova <n.petrova@fintech.ru>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/49] drm/nouveau: add nv_encoder pointer check for NULL
Date: Mon, 19 Jun 2023 12:30:18 +0200
Message-ID: <20230619102132.026205948@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Natalia Petrova <n.petrova@fintech.ru>

[ Upstream commit 55b94bb8c42464bad3d2217f6874aa1a85664eac ]

Pointer nv_encoder could be dereferenced at nouveau_connector.c
in case it's equal to NULL by jumping to goto label.
This patch adds a NULL-check to avoid it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 3195c5f9784a ("drm/nouveau: set encoder for lvds")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[Fixed patch title]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230512103320.82234-1-n.petrova@fintech.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index c6d6ce9af2565..5783ffc6e5ebe 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -712,7 +712,8 @@ nouveau_connector_detect_lvds(struct drm_connector *connector, bool force)
 #endif
 
 	nouveau_connector_set_edid(nv_connector, edid);
-	nouveau_connector_set_encoder(connector, nv_encoder);
+	if (nv_encoder)
+		nouveau_connector_set_encoder(connector, nv_encoder);
 	return status;
 }
 
-- 
2.39.2



