Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2DC2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86D2C433EF;
	Tue, 18 Apr 2023 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821831;
	bh=JKv030SXGkCg+MZ24BYUSh+KHff6OFw9/xqV8cw7hS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhmRwW63sie0bmqei78rXUf8ly+7VSiEBB89vyK1yEX1r834Y8vchTDbYtjOkcsr5
	 BTNP8tNFIT2ervfogJrBdjNMr5NuKXbI7rrCCoU7J1BGcQhAjiQlMRgfn97aqt2zXB
	 ITqh7NOSv1OaYpKuZFI3Qsicvz/fqozyV6yBOGIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/134] drm/armada: Fix a potential double free in an error handling path
Date: Tue, 18 Apr 2023 14:21:54 +0200
Message-Id: <20230418120314.972418709@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b89ce1177d42d5c124e83f3858818cd4e6a2c46f ]

'priv' is a managed resource, so there is no need to free it explicitly or
there will be a double free().

Fixes: 90ad200b4cbc ("drm/armada: Use devm_drm_dev_alloc")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/c4f3c9207a9fce35cb6dd2cc60e755275961588a.1640536364.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/armada/armada_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 0643887800b4d..142668cd6d7cd 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -99,7 +99,6 @@ static int armada_drm_bind(struct device *dev)
 	if (ret) {
 		dev_err(dev, "[" DRM_NAME ":%s] can't kick out simple-fb: %d\n",
 			__func__, ret);
-		kfree(priv);
 		return ret;
 	}
 
-- 
2.39.2



