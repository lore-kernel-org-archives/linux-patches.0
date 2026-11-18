Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039116;
	b=EmtA187AJhs5kk2sogMdNfPrwAaa94i0pAfCYJz692bLiR5F3jE+PwMrdCIjdltdyhhB
	 ZNlIWq8G7+uHT3E+fCpMbATnAR55juRJCC/E31Q7YOz9EBvHTxEsB2p5sCe3k6jF6ErsV
	 2d8KOX/zhQxfmITjgFr1Ae7YzYcHRblOeS+p0EnrJnmi39gtsjOV/T8EDgg6yY0b5r+xL
	 wU/wHHup3Fr+QGlHGMAb4aW/I54/VFp97iuuBPqZ5I9+e9PwSWqxIBdPQPxwA8gRpUp8r
	 QqiR0EA6xZpdTkOtqZJpm0PjE/uTQ6OpPWvhlLWdCPFDQfkumQd3d5n3X8QBbEJFYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=whRzfx77Bnff6VCZYU512yKI4bufJnXJIMXnDO5yhdw=;
	b=0HqzavyQXBmdeblkANJG1uiLgAYsqFmLslXOtJF0ouIL/pPl5Xtr+vZA9HeCiiw7ZMMn
	 PzW2cbkWAZd8hUErVjI6d30bKYCIIq/4ahKpAwzpFnNj8JCfAOaCC20JqHdtJeUYplSR6
	 a4n0q/Eqh6kZLDBJs/TpjnxY8V8cNjBD2+N5VLQLulNd7T5DBcZyH97XA6qRUjFzWtc3K
	 Mk+9q7CMmsjJCWwpWxc+KaeUTeFHqXF9Df26gniqcmvyN/3LCvEbStXPKh2uklrGygA2E
	 QadYwU+Cqyegc+Hn6lajqNtJokJXMRexjEgYM/RBc/qug8ovLvbgZX8ZqtOQ0/cOe8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAYW5oYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84D5606A320;
	Wed, 18 Nov 2026 21:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAYW5oYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341B21F000C4;
	Wed, 18 Nov 2026 21:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039116;
	bh=whRzfx77Bnff6VCZYU512yKI4bufJnXJIMXnDO5yhdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAYW5oYhlj30PTGQn4RRdgqcWBCmBc0tqoqOwmW88wkekyDxlJJ1KW0KieiTkw/nx
	 yqlctLI0Xjji4wYpkkfNFLhxRfoItv5lHYyQE6vdethBWCocjYf/yZzb1iElAnrzWX
	 IuiD+4U7fmXXtDV1Tcr8mfkFn07wIEnPIY6ajD2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1985/3318] drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150421.618843089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



