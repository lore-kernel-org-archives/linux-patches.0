Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015146;
	b=IpqLwMrstgFWwAfsRJkh+AOQ6CM92/BW68Y9egqxFreB1axKQt8OXOfH8gGEHogCjhxr
	 2uod5EOGwKff4UqkffLz2ZNBMNpkymLF+PgYN6iOziNsL8zm6oog3Hc5VLK8xWpNzmCy+
	 9rrYTzOmbDezB/Hh4/0IVSS8uyQBEPfBHw8CVPh59wvE29GJzyYBMQ3i+k7lVCCdJ8GID
	 0VOIt0fDhFLOUyzw3VJiAskP4SV/O+j6QavbL0vFx408tQg5L7uuRxy+1eU91uFcxG48a
	 XyFT38s+tIFqWusMRhrcQQVmBY1N1ATuvemeFkxB8lxsVjvJ/Pnshm9q7CmzwYViBxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/2ellJMrU5RBHEMmF91PYMdUrRKO/PmWM1A77gTSRw=;
	b=5bv7zJpoc9j+xQy+s6RW+GveICptnweBdF2oejfh4Ufe9HwxgRt84Svtqor2GN8KxI0m
	 Kni+zExkIbF+PRUPUT6xr0msVOcuCWHNJ7mjcbdxoC5xXI8klgs94AeNsgeuN1mHyqd2A
	 BpcGuDl9pv7QnbAmdF1AOW1zhsoheogWL6HDJ5n6sKU5+iUbnRjfY5cxzBMWocrQAOjmh
	 VQknlEmY4ZZcatTwrpZ7yvL5m0cslxQp43D6msjNb+yUAe0GejlBkRe0aQ/F7PdHFTppt
	 DkxYcAgZSUgYoQCJ6CTeHpwQs5OE8ZLCM1JkEPRwEXU6767oZD7MQomjZGt9K0LZXDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fO8F5ZDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB0606A332;
	Wed, 18 Nov 2026 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fO8F5ZDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA01F000C8;
	Wed, 18 Nov 2026 15:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015146;
	bh=w/2ellJMrU5RBHEMmF91PYMdUrRKO/PmWM1A77gTSRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fO8F5ZDbIz2S9wHZQASuDNNDxJ4PHLDB3W4o6o0YDylwTEDzpUkEpwnJAZG9qVqcT
	 ofExKZhGCIuMJD23W9MbPPAXUGuLmkUAwVf9wkosNPhO1tWEjARtkAXG2RqZdgxihK
	 3IUI7SGjlu35YbtSxtIL16tdTh6I9gUuwAMCxnIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0067/2651] drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation
Date: Wed, 18 Nov 2026 15:21:47 +0100
Message-ID: <20261118150250.352292151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e495117735e1f..cf02dbca54581 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -550,8 +550,8 @@ EXPORT_SYMBOL_GPL(drm_of_lvds_get_data_mapping);
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
@@ -582,8 +582,8 @@ EXPORT_SYMBOL_GPL(drm_of_get_data_lanes_count);
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



