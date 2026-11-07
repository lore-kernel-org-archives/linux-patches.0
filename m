Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060755;
	b=jgB+uMeR48rghXy5rpHpQ9six/3mj6c6XDdZTtep7TVcmg7KOv4FXoqmRKwUQkTb/2um
	 y6AU0x2rdIpKUD5eGXtybIOTdckKq0o0+iF8RKD6xWVw00hwsemDm+Bg+o2CmdExrI22r
	 TZRHMs8bQ954yYh7levd/HdPeG7xfFsA0PxhavsVgBBHj8X1aisqqynXMw6MzhdAFKtDB
	 s6dadEV2nLMuvkY45VoxaNldqk2zVo2eYKOv73aZBLs4InUhup3W7X8oz5T7Hn0dr1zB5
	 3k0Zfszz7+aGXmCuo+uoQyJ3XpfQYlJHLrgZrb1UgahFxXbP8GGHinmBVCi+D+XWHPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S7Nc/YMJu/M46y2RSFuWraNlY1X/8fhmlE/ONVuyAHs=;
	b=rH3XMTki6CMqAFfCEKywggP+/9BqfPP87RiMpEjPbCpDe0ix2Id6AZFKKWgDMmcbl1te
	 r18CVaq7JIQv3xIpxpuQB8XOH7TlDQVlhNn065rTTjrKefixmYJ4D1DXN06ICa0gI4r1P
	 mZLpYrxMBkdrY0JR/8huvdhvwhWxvl409AkBtFiOmgnQhqKUNCNKcBnQQBa3wqKhqYT8v
	 8ywBoSxmMNXD/xkYGS4tEcivwF1YindokyIAGDyY1/ehpBHj4Z+z7lJzpkWdJJvlxD/A4
	 G16pYZvQlwvcz82hFT4LmmTmhpxbs/OcoAC0oFqIdgytyicyuQ2A1u4/CTTXY5tCeUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3GXBc85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF64E606D803;
	Sat,  7 Nov 2026 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3GXBc85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABFC1F008A1;
	Sat,  7 Nov 2026 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060754;
	bh=S7Nc/YMJu/M46y2RSFuWraNlY1X/8fhmlE/ONVuyAHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3GXBc85hRsiG28zUK0eN5qY76VWteIVmrPOF1JLkacNSCt/6Y3WakceKJTjByV0+
	 g0jhOnUe4yVT8RAUe2WKtFuyBlKqZd9t/DJMBFKwTddy7ytFaAbBeRWB1ZvJarU9B1
	 Q2nDNpFOUsMDM4NYW+vXloFrQMEDT6XeoswLFI9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0129/1536] media: ivtv: stop VBI start-code scan before short tail
Date: Sat,  7 Nov 2026 08:35:45 -0500
Message-ID: <20261107135001.309604826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f373cf17fb8e7a530bc6e1e36fc41cb5dab2cdaa ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index 80478b026d752..279a4d6bece19 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -330,7 +330,7 @@ static u32 compress_sliced_buf(struct ivtv *itv, u32 line, u8 *buf, u32 size, u8
 	unsigned lines = 0;
 
 	/* find the first valid line */
-	for (i = 0; i < size; i++, buf++) {
+	for (i = 0; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] && buf[3] == sav)
 			break;
 	}
-- 
2.53.0



