Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05D1EF08A;
	Tue,  3 Dec 2024 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236544; cv=none; b=LoHPiQiLjEZSwsNhh+ngODgiII9ptI7wF98LZNI8jSP8x2sRygCNWq3U9O7wl5Us0uIki+eO7M4NSvp99epVAaibecYP5/qJwf2e3IjSF1INMQ26YNIRfJGp7UzCMNKV24bRelAKlNZU4/bX1qn6pW7SUiBSMU3GXGMXcoG85KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236544; c=relaxed/simple;
	bh=8TzJsXs91OncnAIVO3QT+4IyJOv5cHEG+5kH5/a3gVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/CbM3Kae7A/8qUiHlI2CSDDAJ81C2WXpnkC9t8IBFcgxbTHymlFlXzZt1xhgrT0Q7zYwxUXSkEYMOgSjCXCg1PjJ+Xl1uYaI9gmTn4r5CqB7ZbjFobUBi9X8HFdc3r8zGADvHKqufk6b4N1afvcywfLJh/Rhc1SNGORUSdqOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjD05uee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjD05uee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2ACC4CECF;
	Tue,  3 Dec 2024 14:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236544;
	bh=8TzJsXs91OncnAIVO3QT+4IyJOv5cHEG+5kH5/a3gVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjD05ueeM8sn7KI6BC4O0HIhDBiUk4H1a9/A/uhXPcGEInWaLO3c6NACFF06rfAiZ
	 81EDJyUUWWQndEnJGUX4OK7ZmbbagnOB2eLzJYYjrMc4pgQAtvA2PKgj6sdR7VeW9d
	 sBNsSxDbLTOjzuXUVpjlBOZwL1DGTotjhRKNv/PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/138] drm/etnaviv: dump: fix sparse warnings
Date: Tue,  3 Dec 2024 15:31:19 +0100
Message-ID: <20241203141925.473185446@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9d839b4fd8f78..15bc7f20aed92 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -73,7 +73,7 @@ static void etnaviv_core_dump_header(struct core_dump_iterator *iter,
 	hdr->file_size = cpu_to_le32(data_end - iter->data);
 
 	iter->hdr++;
-	iter->data += hdr->file_size;
+	iter->data += le32_to_cpu(hdr->file_size);
 }
 
 static void etnaviv_core_dump_registers(struct core_dump_iterator *iter,
@@ -83,8 +83,8 @@ static void etnaviv_core_dump_registers(struct core_dump_iterator *iter,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_dump_registers); i++, reg++) {
-		reg->reg = etnaviv_dump_registers[i];
-		reg->value = gpu_read(gpu, etnaviv_dump_registers[i]);
+		reg->reg = cpu_to_le32(etnaviv_dump_registers[i]);
+		reg->value = cpu_to_le32(gpu_read(gpu, etnaviv_dump_registers[i]));
 	}
 
 	etnaviv_core_dump_header(iter, ETDUMP_BUF_REG, reg);
@@ -220,7 +220,7 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 		if (!IS_ERR(pages)) {
 			int j;
 
-			iter.hdr->data[0] = bomap - bomap_start;
+			iter.hdr->data[0] = cpu_to_le32((bomap - bomap_start));
 
 			for (j = 0; j < obj->base.size >> PAGE_SHIFT; j++)
 				*bomap++ = cpu_to_le64(page_to_phys(*pages++));
-- 
2.43.0



