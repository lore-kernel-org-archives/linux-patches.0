Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024185;
	b=r4m7liJckEgNGz/lZcTyQSD2x8APRvqqNbbwZg6iutcjx8Fshxu1M0+Jnvcq19Xq5F/R
	 cO7DKpQUNqDB1/y9gN7+rKLYrnlfHrIGVc6S+imjZ+TBQaG7oene6SNfa/vrgRIXTtRHq
	 CArOqdjl9Ct8X5vlvMwdmT4xyec7bGTIMJky8HmvHE3JzuFLCJS8ReuY5Z4EuWVbm+yYf
	 qJozpoUDlI43yisvIwSQBoMlopFl2SY4AhjQ5ZHQCjQD9DurtL6lexH/Npje2iEBcak9g
	 hY+c2/Pk05l1vcSutxIwfnvXSWLha9q6aqpUpm3ES7qJpyEWo7QDI1AQZrRLoItsFEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EzRCmdXBv7ntYs/yCSw2FA8kd6CbxTbxmDXPZj6ZVoM=;
	b=IIgQlHRSQ6xEGo4Cn6LViFzw1u77L4EZ91YknMueglZkjuyifzH1DcZx/0vpg85IbQ4w
	 vYNFE4QPHrUvnZMYpIYgSZMRWBTXdWifge89zuTsYtqeR52awre2U/Yd1kfgEoZWZPE1c
	 +AbvYhSF68kBKi7v7AbmBXB2slnlhSxkKggbslMFwP8ep/IKE+pbrfhxtPuTedKMyazRv
	 RdqzJgdWymemOd2Bu3e67T1oK0TIvL6H1Y4LberJuB//Mh186M24XtmP+XoMkaRFEyb1I
	 T3bdBwcMNuh1c6wE47943TdyuLoT7ojQFmz1bMKUGjC9n96v7EieipgdWMXops4e77w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWVL4xBU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0A5606A31C;
	Wed, 18 Nov 2026 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWVL4xBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73961F000C4;
	Wed, 18 Nov 2026 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024185;
	bh=EzRCmdXBv7ntYs/yCSw2FA8kd6CbxTbxmDXPZj6ZVoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWVL4xBUOO78o4utsLRXCQICZaaPBwd+3FDIkQdlHvB2iNNjUeGIWK3+qkJqi50sY
	 bDUTxnJYwTMleAEEXKBoJyXwvNs59w+cMDjxFKASl1fiwrJRXZL5cVI0i9/rigj6tU
	 QQMpkoRD+RXwXuND5itN3mCKDEXFDby7/T7zpzHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0634/2151] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118150144.981795099@linuxfoundation.org>
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
index b83404d29994d..ac5475a987b74 100644
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



