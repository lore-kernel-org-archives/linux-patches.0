Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029921;
	b=Oftm8ZfVjDm647yhWxyLkC5uiNLlm71ojwdB/TIhgpHxN7Bfn+pEZ7MLYGXe74YaHWwq
	 UiURAhBxE/UzJJ5l43GO8Bs6AXMcoRaQi+MUMuDipTnwbWnFgFD9x9F6D2HqWa+1SPEU5
	 9sc39jFZrTo0lO5F4fGbk04QRkMrCw1d6AvUZbxBboz5mNOnA6eFNnJtAg6M33qpPPhH5
	 2XoW4dqVE308akr3HeXwVdrSJS15RblB7DxPYBiFGVxIQZ9akQzN63fp+OZdY6hPW9AdP
	 6XpnO6ntdGxvZC8kWi0dNhxzS0omgdbBh2K4VQppjJArbwQtJmtCNuN3k0BcI/xK2Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jXJ5cslF2dLs1rx8kMsLyFtvNhjXMzp6L4HB1saiQKE=;
	b=5CzKq75zTQ8qhnlqu1vaP78JzWoYOR4fd0/XnMn714av3+qWH7j6xhwHCqtHayXv9kBR
	 hHFNdvwejASObbtuMHYP9FqmKTYDf4y0Y6zGki1n6TPSEctMxCAiLRu2TK8GoA9/m/0EH
	 Ca80iUm2r3Os6096k5zJOLgnliEuV7XUJggpoYLrThLMbtlkGy3qnubkru1oHz1VFNQyw
	 5PCHPuei62EQPJDZaU7In4nprcKQlqsGlldUFOgz39IMoSS+7BYrzibLca0bUuZgVrnZW
	 KTHOmpApok4n8WF6GdE7XydrtjeTOeGF86uKC5X/xm+hAyKTRwx7+nXQzms1MNW5xUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNrSvlqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8A60A381B;
	Wed, 18 Nov 2026 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNrSvlqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075241F000C6;
	Wed, 18 Nov 2026 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029920;
	bh=jXJ5cslF2dLs1rx8kMsLyFtvNhjXMzp6L4HB1saiQKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNrSvlqA9PfhP6RRMvzsTBujwGP7atM//Ul6eFIXop4GvfZSDaVb0XlxPZXg5NC0n
	 5WWPnQpG4ubDjbZDeWStXOwXQBbEBCfpbZP0NF+EqK+JJeFBo0xm4BiDs5aU1IpIaF
	 3Im3rRvwvKzrql3T2L9XGFajMq1+2DrRYNGbq2xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0522/1756] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150029.933573210@linuxfoundation.org>
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
index 3e08fbf2ba2d9..b8107ee501b15 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -796,6 +796,17 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
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
 	struct queue_limits lim = {
@@ -805,6 +816,8 @@ static int swim_floppy_init(struct swim_priv *swd)
 	int drive;
 	struct swim __iomem *base = swd->base;
 
+	swim_set_parameters(base);
+
 	/* scan floppy drives */
 
 	swim_drive(base, INTERNAL_DRIVE);
-- 
2.53.0



