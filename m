Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0F113CA93;
	Thu, 12 Dec 2024 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023944; cv=none; b=aqufAmBUyr2xR5Y7Et7QIrtMKvLy3hal64QCrlbTjVrcXOUlDDBfucM9I3h3B30CyojTaRKKq/cwtEgFla97WybX83vErgQYklDoSe585n51xdoEy3Pjar63aKGOPylQahk5K2ffL8kH33ehAQESUaDf2am82z/qJ3XKMUN1bhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023944; c=relaxed/simple;
	bh=Pr1lQ851D1UxkO8AxQZoAroDzfkeO+uGUE7SHnu2Xs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddHnYW3NmM34AMSyykwW4xvkdlvB/Fz0b71lCuZS11CQlJZnacIy0EBrCAu8tfREhbwubwCu/O555/v7rTyTAaQ/a3vK/Jre3E92fHNrR3PCIbrpkMYg6NmVngw5Zm75ICmdz4ziqUi20EI337kqBp5HLtOkJ9WNxnTRisorsLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJpdmEF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJpdmEF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F92C4CECE;
	Thu, 12 Dec 2024 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023944;
	bh=Pr1lQ851D1UxkO8AxQZoAroDzfkeO+uGUE7SHnu2Xs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJpdmEF8InzR3xF28mRK0g4Nug/hmg+fi6EWh8WWYxAWGUk9ByDkUSEaZwCad8DrP
	 +9piMV65Bq5wxM1qzMDwGOumCFUAvhw6BQcqP/qnxtWGj0OZ4tJv4OEd1RZ0GYe2pM
	 u51QwBuciwD6c4i+Kr841kRZ8OkRKkZCgLYwP7PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/459] drm/etnaviv: dump: fix sparse warnings
Date: Thu, 12 Dec 2024 15:57:53 +0100
Message-ID: <20241212144258.846410404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7b57d01ba865b..0edcf8ceb4a78 100644
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



