Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022777;
	b=qahB5tKL2ngaF6RKmzkeO2ZTu4LLMipi3o+4kHb18R2e7nY/H5Xo8zW+/5BXE0zU+KHr
	 qFYHIqtnMGijzE/QM2iPM739FqaNLKf9IeSAtn3K8zkWePyE4iUmi7lB2Y0ZQhzRWYULg
	 twUZb9Lw4qtMVK5/TxPtAxjnTwn6h6nkMDAw2YcZ7tGEnPpsq6Sje3MZ1p/2AV93Uz071
	 PZ/56E3t3rthY+j+PS1xHdhiwXDq/BhE6Iek0XOqBUVGPuaxt2RhXbr+W9BgJpH8TjaJX
	 L+h1GCqdSdPj5YfGW3z8sM+MJ9TOlkuzC9XahFl+Iy7DXPUlEyG1U7RnEA0hjuh5ykg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=msxL4SwUOYQwo6eXUvVwQL6WseISh8qbqPk5ZcPwp28=;
	b=R8VT0AIsbKn3VC9vzOfDWuwz4uwfpdPwz24vi8F/Sm+g2Xw+fYUfskwUWR75A5gs86nJ
	 hcGc2yDjEOFFrNpre3IKI85aaBGzDcEi04GvMAaTxKgCRSc8LFUcKvPUauZPH4/cNWNpM
	 lBYC6jxKNPc3yWeaD11XRKNxoFrbnWH6KbTWhRpJqZgPfM8u8VQKnO+g7XAl2Xj6LP+hl
	 /qLg7Rv2VUVfRzjzXtmFuEf2UfFRANgrsgObhv70RMDIa+Kza/B8alElMu/g45UYIEC3l
	 lMM+8cJhBoDLl7So/Eik3t+VJrpOayWL6bAWAICHLuyz0BCmuUnkNg0Ui/p1ntCvgqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lYVRdpCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCC60A263A;
	Wed, 18 Nov 2026 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lYVRdpCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BAB1F000C6;
	Wed, 18 Nov 2026 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022777;
	bh=msxL4SwUOYQwo6eXUvVwQL6WseISh8qbqPk5ZcPwp28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYVRdpCfcKmPwXNCbt0bLuhU9XQy743tWMyM+UlJsizFxX1u4kIJ/lVBe7O9YMqkM
	 WnYQcOT147D3WzUjzf80mgAWNbs08KTkul0horQwUqlkEInfFNMlUW94wey+J4peZQ
	 RoBYsl337v9ULTetPYJaaPM4XG84J/qogL2dD6Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0132/2151] drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation
Date: Wed, 18 Nov 2026 15:31:07 +0100
Message-ID: <20261118150126.599570666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4f65ce729a473..e99645103b23d 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -507,8 +507,8 @@ EXPORT_SYMBOL_GPL(drm_of_lvds_get_data_mapping);
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
@@ -539,8 +539,8 @@ EXPORT_SYMBOL_GPL(drm_of_get_data_lanes_count);
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



