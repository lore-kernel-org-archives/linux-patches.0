Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216107;
	b=Wgtw8/F4AD+oZcGlTKCipzu07jMPOtUm5P2pLZ3RBIsq01O79zmC43coFQ7qGlanQVdg
	 h6vfoqU1EMZ5To2X/dveM04iyJWjwVQbVpTr+RlnBj0H2PQb7DeVOsCtdFqftL3g2658k
	 PnpAS1REtLhRmFJa01esP4nlvNWa8c7XtaIGxh3pe6OCnxsovUCm7nsfTzjt7F17hZNLR
	 e2J0iWXUdmrWvnOn9N1JJIWSvPU3FqIoHYFe4vR/dM+4d7E6oF05jD+MTzzQ0vup6Uli3
	 lRxcQy//l6IgI4jXCSx6/v2s1sjATFRt4dYqVP4QBnKvVJnMJ9JZ0yieVupV2rA1qQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQi1NweYI97abcrLBeYZqvUcNosgXDCQWSS+4KzHTaw=;
	b=40PTafRpCyMS+nOTvmbk6A5+TqZBjTqx7BZ4v/d16IM2hVfmLOZfkjorRdq9/zPsNqXK
	 6tTuGA2t/ZVT0YMIh5QLx5mLoiI3QwWCNRxwVtDU+sXBMYs36EmJXR2tHEF45yhnrO3sm
	 CcweK7zCbCaVaRXWH++0SUrR48TRDr3rDvNu/VcEH9XaiCT+pGcNAles1TjLS3FyX3Pbh
	 sKkFl6YCSZyUcYKtP/N9X3XEJOZ+ooFDuzDsD8idM9IBu0pA51EE4HMecU8IZgZ5L2Y88
	 UU4+XdChDNdeqBfkXY/K0jUC9bZNvVy4fcjqBpbXJfiX6wEcoBXrJwuGxlgPh8cgpKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Irvi4BC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FF2606A31A;
	Wed, 28 Oct 2026 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Irvi4BC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518DA1F01825;
	Wed, 28 Oct 2026 19:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216106;
	bh=kQi1NweYI97abcrLBeYZqvUcNosgXDCQWSS+4KzHTaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Irvi4BC9Ew4K3qF8L/qICipr4kWj7NA2nMUzT2RX/5+rek/UVFLxgIaCtCLcLTj+5
	 1m05eQsPru4/LFljLzxss15FMsnuTaIjShtQICsdQzt5L7NyVyvZ47EYmuHX1cOLc1
	 WJrfM2KLO7KH+wp9AyppV5ebxAdc00BZa6m9hL7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1442/1887] drm/amd/display: Check link_index before accessing dc->links[]
Date: Wed, 28 Oct 2026 17:58:58 +0100
Message-ID: <20261028170532.273645453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8aa2864044b9d13e95fe224f32e808afbf79ecdf ]

[WHY & HOW]
dc->links[] has max size of MAX_LINKS and NULL is return when trying to
access with out-of-bound index.

This fixes 3 OVERRUN and 1 RESOURCE_LEAK issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_link.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index 17f080f8af6cd..7a9e8e63b1da2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -285,6 +285,9 @@ const struct dc_link_status *dc_link_get_status(const struct dc_link *dc_link);
  */
 static inline struct dc_link *dc_get_link_at_index(struct dc *dc, uint32_t link_index)
 {
+	if (link_index >= ARRAY_SIZE(dc->links))
+		return NULL;
+
 	return dc->links[link_index];
 }
 
-- 
2.53.0



