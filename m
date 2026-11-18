Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048495;
	b=H3Y28D+2meTt01numnjC+d5sCGiK4ORDuirR98LjCuUJcgbQATFtEk9+zJKDZM6EwxA5
	 CfZlLe1r5RkrmQce+AKkCQO70uB/x6xwln7u2v6fad8Ue87J2o+jb2bCWKuRUezMmgYdG
	 wfSJdc53HgZumUSdj0Xh86Xlh/xfnqTEaVt30KjJCV147Nxj2ZBRXxKMZV2pgu9h2/zJJ
	 a7vQIRXFCxxy3e9BtQCFQOkOdezJWZJMtz4Ci8ToTxno7cbc5qEe9zsUlH2L6QAGy3J93
	 KmQTXeNzpTBGafMKxxuFdT5tgc1AGoUlXw05kutBt4cgwWa5FhIM1TKF9SryH/2KupA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WfbRgpJ0hoeRyKtEfNWUYjKsTJgevaibHpvjFePKA6c=;
	b=tVPyBzC7ws2oL2xnwycW1qIQeDOFc6MkufAKlVh0wNi8e9ztmqRlmXScGp2QA9v1QMD2
	 5aOiY4BEQ2xcMAr3iP3/mSP2qOZFAJwhj6YoMDkW8N+WZm49XiYYoI5Y87w6CxyodWs97
	 tLW7UfnsH9Xm7ivr1ql6EEhUhDHWLjVmUqDBT9F9O29OKPzdqS7NaeI/QYM7thnbpdAga
	 iWOC9SN+xKCfDszT0lzQLgwaWDCBXUoQNIqaftXc5mtYoC+3OL5+N0ZDTgkJM+hGIagaZ
	 Pu6KavLP8vIRC2b5GXtPo8ufVDm7QY1/4w3t2wTVRc1MVyOClpY+FjxMZ/Vl0YZ4QnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvZdFRBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8A0606A32F;
	Thu, 19 Nov 2026 00:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvZdFRBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9051F000C4;
	Thu, 19 Nov 2026 00:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048495;
	bh=WfbRgpJ0hoeRyKtEfNWUYjKsTJgevaibHpvjFePKA6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvZdFRBPjh4Puol2XxUUlbU+syfOOd6qqJf8U6hygwHnw5rzhicMGkBA5hmoEz2fw
	 gobd5vknx8lDviqhmXWyWBzmMW4B7hOTPGwOEb+H94XN7ZkWm1BJmSK58aSAXyjWyq
	 C4SwNOTYlKFKiSWd7qH3LmokSOVETjBcMO2CKobA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2015/2857] swim: Configure parameter memory
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150313.951465073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 94da24a80dc8e..7096fac6cd1b8 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -798,12 +798,25 @@ static void swim_cleanup_floppy_disk(struct floppy_state *fs)
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



