Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055264;
	b=TGgYWBGfeLHl4NRLwP2BNY9KLDq7lO+Rw69xwbbyD632ZqesbCe9cLJwiz6PBVDaBfEb
	 1ePQUBFRXpLdZPSM/nNlyfg6mBL+kvcVj1ErOadrsuGSsCC2WwNLupYDVLGNOhX25AWj0
	 /oqitf2W3Rl+0tDH6LE3Xy46cqL7zgX9ZdL/rfhBRYohKsCjQmO2LlSeuyYZALZ/IL5y2
	 YAstLXO+qkRYCGAUOSY8gZUei0yoG7VMf+8KubrLmtEgY1AzqrH1fAj4/xz2nl+JxCN36
	 wCtySfG3ynM49xXZ1ZH95uRTCJUAlWqmzyg3uqQnu7P68h0AOfQaLS5eRzHLG1w6nHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlZQ9ROksGiiDP12Gw4Vg3gdNpYlJ/h+WKcUhUg4Kxc=;
	b=pwMn5WQ2iEHS3vVIRD69QOPQcQO+Ri/qtg4K+UL3fG+VzEADllOU7Jk3a7srI5NYUcjv
	 FxjSAsDpKvNdjH0NU1uDOLoZ7efY02B61jMPfXqgABUmvwTxouPgVVoWX9gMjzUeVzqKf
	 JC59Ui/86R0ve/VN0M/O9FwnQq5NVJzvnq7V/TEZPSA6Y2qmkpeh0ccN/44o+MVXxHOHf
	 d8bDFh9WnS6cFtP1oZbxP3X/rZCEZV1bA9ci+PeTeKiRiITJ2nLOvomX9mYxGs0tkkRVh
	 Oi08I7FV9awk7lh55Bc52LBRJ6A39XkeXu93JnKurm2x7MsKPdJowMpKTiSKzvhyREQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3Yk66x7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECACD606A325;
	Thu, 19 Nov 2026 02:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3Yk66x7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9C61F000CC;
	Thu, 19 Nov 2026 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055263;
	bh=hlZQ9ROksGiiDP12Gw4Vg3gdNpYlJ/h+WKcUhUg4Kxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3Yk66x7wPx408ij0xMS2kylDHM4W8qaZw5kAWc/rh8smpVqwZozw7vXwOlKijuko
	 u2a5fyr7WVXmgyn1ylXFa9K920y6I7nfdvbDXZEN062v1yfOeMlq2NuFd2Qs07f2yY
	 gV4lB1HpIMOxTWVWsht8Lwj1gp0IPu7J0UZW9pWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1569/2214] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150114.816693359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 994a778d966592d0e211deaf6e436fcb21413935 ]

The original SWIM chip has a 16 byte memory to store parameters which
control read/write timing. The SWIM 2 chip retains the last 4 parameters
which control write pre-compensation, but omits the first 12. Hence
SWIM 2 can perform reads without any parameter memory setup but SWIM 1
cannot.

Configure the SWIM parameter memory with the appropriate values so that
SWIM 1 can read too. The parameters used here were observed in SWIM chip
memory, using Macsbug, while MacOS was reading from an MFM floppy disk.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/eccb76911fd255330b05eb3174ac15c29bb41a23.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f32fb9b388c13..ea64e386d2f16 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -794,12 +794,25 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
 	blk_mq_free_tag_set(&fs->tag_set);
 }
 
+static void swim_set_parameters(struct swim __iomem *base)
+{
+	unsigned int i;
+	static const u8 mem[] = { 0x18, 0x41, 0x2e, 0x2e, 0x18, 0x18, 0x1b, 0x1b,
+				  0x2f, 0x2f, 0x19, 0x19, 0x97, 0x1b, 0x57, 0x3b, };
+
+	swim_write(base, mode0, 0); /* reset parameter memory index */
+	for (i = 0; i < 16; ++i)
+		swim_write(base, parameter, mem[i]);
+}
+
 static int swim_floppy_init(struct swim_priv *swd)
 {
 	int err;
 	int drive;
 	struct swim __iomem *base = swd->base;
 
+	swim_set_parameters(base);
+
 	/* scan floppy drives */
 
 	swim_drive(base, INTERNAL_DRIVE);
-- 
2.53.0



