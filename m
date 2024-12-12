Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E93216E0B;
	Thu, 12 Dec 2024 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025175; cv=none; b=oW21woZQ8EAhsyKn3DtrxJfoMuSi5thVwIxiTAGgi0XdwfNU2m2jU/lUf6a/VqD7yLt3Q6CJDme7oiGmw8vkLrw3hpXrQ80hs2OZEUIZpNgd1wG3oymrS++CXPAfTmxtREIR3xkKELu71W498IkrV72l3cmqo6T7uT08CFFGNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025175; c=relaxed/simple;
	bh=GUv8QbbbwkwF0FSZYCQHZRP+fNFfko6NhgJIg4ITf/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owYefIJodL+TqGlmjLUtbkWx7yMTbYWCwheaOatsfZlNv7oaWqXRRqagBiFVGy4RNYDintJwwwklB0ciHSQmANNSzmP6I8vpxDo6WR1HyhdRDCPz9hH6nsnNO3RMi60yOg0j1Yddabh5cRmhsc8rygQcDUrURFisRLR6pNUroSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbFgYffO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbFgYffO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C85C4CECE;
	Thu, 12 Dec 2024 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025175;
	bh=GUv8QbbbwkwF0FSZYCQHZRP+fNFfko6NhgJIg4ITf/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbFgYffO8NsnJwIO9fQ/iZ8UPdQvQ8cGfXT1ZTOYz/YTn05sh7n98Zbn515JVruUB
	 lhBw2M7fgl3X7o4DqmlLjj2Lc8TUOmxdPnSS7jg4AtaGuvpdy3GMfgIsYxIGPSBLHo
	 d4aGElxAvg5x84ahreul70g9AnZg69C9OwL5wJ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/321] drm/etnaviv: dump: fix sparse warnings
Date: Thu, 12 Dec 2024 15:59:52 +0100
Message-ID: <20241212144232.913259156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 03a2753936e85beb8239fd20ae3fb2ce90209212 ]

This patch fixes the following sparse warnings, by adding the missing endianess
conversion functions.

| etnaviv/etnaviv_dump.c:78:26: warning: restricted __le32 degrades to integer
| etnaviv/etnaviv_dump.c:88:26: warning: incorrect type in assignment (different base types)
| etnaviv/etnaviv_dump.c:88:26:    expected restricted __le32 [usertype] reg
| etnaviv/etnaviv_dump.c:88:26:    got unsigned short const
| etnaviv/etnaviv_dump.c:89:28: warning: incorrect type in assignment (different base types)
| etnaviv/etnaviv_dump.c:89:28:    expected restricted __le32 [usertype] value
| etnaviv/etnaviv_dump.c:89:28:    got unsigned int
| etnaviv/etnaviv_dump.c:210:43: warning: incorrect type in assignment (different base types)
| etnaviv/etnaviv_dump.c:210:43:    expected restricted __le32
| etnaviv/etnaviv_dump.c:210:43:    got long

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Stable-dep-of: 37dc4737447a ("drm/etnaviv: hold GPU lock across perfmon sampling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index 67901f4586a3f..827aed62027a2 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -75,7 +75,7 @@ static void etnaviv_core_dump_header(struct core_dump_iterator *iter,
 	hdr->file_size = cpu_to_le32(data_end - iter->data);
 
 	iter->hdr++;
-	iter->data += hdr->file_size;
+	iter->data += le32_to_cpu(hdr->file_size);
 }
 
 static void etnaviv_core_dump_registers(struct core_dump_iterator *iter,
@@ -85,8 +85,8 @@ static void etnaviv_core_dump_registers(struct core_dump_iterator *iter,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_dump_registers); i++, reg++) {
-		reg->reg = etnaviv_dump_registers[i];
-		reg->value = gpu_read(gpu, etnaviv_dump_registers[i]);
+		reg->reg = cpu_to_le32(etnaviv_dump_registers[i]);
+		reg->value = cpu_to_le32(gpu_read(gpu, etnaviv_dump_registers[i]));
 	}
 
 	etnaviv_core_dump_header(iter, ETDUMP_BUF_REG, reg);
@@ -207,7 +207,7 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 		if (!IS_ERR(pages)) {
 			int j;
 
-			iter.hdr->data[0] = bomap - bomap_start;
+			iter.hdr->data[0] = cpu_to_le32((bomap - bomap_start));
 
 			for (j = 0; j < obj->base.size >> PAGE_SHIFT; j++)
 				*bomap++ = cpu_to_le64(page_to_phys(*pages++));
-- 
2.43.0



