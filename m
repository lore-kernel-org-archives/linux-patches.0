Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028838;
	b=l0wNgK1G5btl/dq6P+xz3c7/DL1d4bt8ch9+7oOhoQ2GWEkK9cllCJ2ndQijaruJ9Xko
	 6olBAAOuIDMXCxxe4q/qitaGHDCh6XkoMVZqXy+Q9+IY0MDdySIZpmPryPKMw5u40b4eR
	 ZF763l3I9n4Os/L2/Pv9oLG/7DoCc/2DpKdeReLsgVzy5JAdc6ZUCZlelNUYG4XsAEDPj
	 DY4yDKvDeSPCfzcQQrYFsObbJ2NlBKPpVUBuVTwS/2pvtnseVAeikm67V7Sj90To0TuK2
	 6qiDKr9jbfzLEuOJkCqfGUyq2hTUL1dXE/6R8hAnM5KbHjgDEx+yP45ur9yUwQgTvCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ZbfjUoL5KOoDwMHZWR38J4AL37AFteTTTj4w16bXew=;
	b=UrZv37GHmFJB0R3NgQc08eKvim51qwu94hdrg0b0UQCO+49GnD4+LiBKT5Wi0YF0eqn9
	 Q1nUEnAiQ+hvVoOgog7kQYa4psVJ9WdgvqMg9Yds9VPr9eBqHDj56JcpmP7bhA2gtB1LH
	 ib/DukuhOlWqKsEEVj+SIE8Nmv1E5mU6nMBocohLcpsGXoZ8DxEhgDXWIxmynm9jsTTqr
	 +0Sy8qUrifyYzjeeRyIqAu1zXCPhHJ2nHiSZdy/7ubX5Hpv+Xq9lXotkshpVZLpsaGplG
	 OfW5jVd5pCdLA1XLwZVdDayGDp2IKOA9s6M8vp2+I5T31zy0fAheNd/6pR/KoMHOYkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSAwdEKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0260A263F;
	Wed, 18 Nov 2026 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSAwdEKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25EA1F0089E;
	Wed, 18 Nov 2026 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028838;
	bh=/ZbfjUoL5KOoDwMHZWR38J4AL37AFteTTTj4w16bXew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSAwdEKJhIKfpKTZ30e8E+i6C+B9dhWTIEIs61TMvIICEs8vc2TPE7LT3uewDFxpi
	 4GGGF+eVoooU7ZnF/6q/CpshcAxdEUKBUSkRNqS3awbatoRWgTEg98ifCB0a5LM/Oh
	 f+IxiyYZnvQT2d0/G2RJue05i5AWrD5Qi+vrrpSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0137/1756] drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118150013.624601895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit e3eca845ef7d6cd8c407f9b42beb45af94ff096b ]

Update drm_of_get_data_lanes_count_ep() return value documentation
to match the drm_of_get_data_lanes_count() return value documentation.
The drm_of_get_data_lanes_count_ep() is only a wrapper around the
drm_of_get_data_lanes_count() and therefore returns the same error
codes.

Simplify the return code description of drm_of_get_data_lanes_count()
and drm_of_get_data_lanes_count_ep() to -ENODATA and -EINVAL.

Fixes: fc801750b197 ("drm: of: Add drm_of_get_data_lanes_count and drm_of_get_data_lanes_ep")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260305205840.95978-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_of.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 177b600895d3c..8adbfe8b88b50 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -444,8 +444,8 @@ EXPORT_SYMBOL_GPL(drm_of_lvds_get_data_mapping);
  *
  * Return:
  * * min..max - positive integer count of "data-lanes" elements
- * * -ve - the "data-lanes" property is missing or invalid
- * * -EINVAL - the "data-lanes" property is unsupported
+ * * -ENODATA - the property does not have a value.
+ * * -EINVAL - the "data-lanes" property is missing or invalid
  */
 int drm_of_get_data_lanes_count(const struct device_node *endpoint,
 				const unsigned int min, const unsigned int max)
@@ -476,8 +476,8 @@ EXPORT_SYMBOL_GPL(drm_of_get_data_lanes_count);
  *
  * Return:
  * * min..max - positive integer count of "data-lanes" elements
- * * -EINVAL - the "data-mapping" property is unsupported
- * * -ENODEV - the "data-mapping" property is missing
+ * * -ENODATA - the property does not have a value.
+ * * -EINVAL - the "data-lanes" property is missing or invalid
  */
 int drm_of_get_data_lanes_count_ep(const struct device_node *port,
 				   int port_reg, int reg,
-- 
2.53.0



