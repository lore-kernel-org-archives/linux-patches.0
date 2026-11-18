Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060747;
	b=yfxuqUlOKr2viZ5tAAAN39v/7word1DQHYoqdc0Kz+bM5E4uj/26i+TAEUd4Iql0E41y
	 X2r2hPUqXzRDU8W8VzGtzVbpLjX9ij1HPgTZhU5lh6CzBoJvADBZ/tOeem7TSNGnEEw7R
	 uJcNO34ZCXcxul2QXi1sHsyoJiIdeEd3Rkk6Ugk7N/EwlAtVhqBg2fa0VGcoRHbR1tTL3
	 Il4TV5WSBxPlisJoplRJ88nnLrptoImu2wsr5FXJbYWAfLOPEgqxbm+JgUGvbrCscLc/4
	 9nsAMqCkYQa/U/tAQctNJMVpfuRY30A1upnXBj2lZQW3zbsL2a69mD6B2vlzSZhO1UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3SuIhM7Tl7Zui9SUndRGpu5CjW5cWnUslVxpVoQ05w=;
	b=AFOI+uYyRszy0IMn30rCZy01sGYAlAduw9JHFrqZeo5Uefvmo3JBs1TPekiJw8X0TdC1
	 6A5JBn1+I6NDNqrCfGr8QMDYIVgfw/1FTOzBCTH9UCtWZ4/jzkydz1eNA+lvKokmhE3TY
	 tu4KqkoLb00ald+0xltFpx7RxFs0cO7K41agGRLzjD6Xzj4BFzjtniPraPXpYERRhSPY1
	 2EVPV3gksBcysyPgcPKnoRzpB2XEBaTCMMYm5xhzsVV+6FDI9j1Mctk+OJyzsGl1WdkjL
	 Wks2ged8Og/esozfucT5S/bFUvwhtBqxvZYJ3UJ8KHzLFtIWbkRv9JzMMBM0IFd0Viw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY7gN6IN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90E7606A325;
	Thu, 19 Nov 2026 03:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zY7gN6IN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB501F000C4;
	Thu, 19 Nov 2026 03:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060747;
	bh=Z3SuIhM7Tl7Zui9SUndRGpu5CjW5cWnUslVxpVoQ05w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zY7gN6INUa3sWF4MkfT4Jnzbnyy+1ruc4SEjoBxc8CYjenGAg9e7444cK+lmF04pP
	 RhJtPBpkuixtLIkiAVVa2bqifDsIxG3jbWtNNNJGTg6oq3JhvxokU7mFA+qAIhgihO
	 790Sdeb1KsEyOI0GpYo7yhW2vWBUjYvjgTAqhBEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1310/1848] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150014.310764049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d10cabe464319..fbcd9b41455ca 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -805,12 +805,25 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
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



