Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016935;
	b=pvm3y99Y8PpKBmmMpC2xtzk1lfv8yl9N6HAGUs2S3nhmuTSiOTERdiAsQreg4Z2Dsh+4
	 7vux/EhQrazS2Eb60Wb4vOLnJmI6IOsbDPDOsrUspaN72AFoJsEwmA37uF/l7p1v+pSIk
	 kmobmlF0A8sC+ZYiEIZe0rYtgPTB1KoH+RKdTifKSyAnGwXB5iwCHRihwgVKhqAKtaB38
	 xPAgzSohTJtcdSi1AZaaVcbhlGxdwIXoPCkNFcLMsp8FxBU4ncBmzSv4zMY3R7RWofqT3
	 5txYSeIWdImpKDFjCTpFNzydr+qItTUveqMkiDE3jVBI++Sy2R9HsTcn2r4QY4YnTJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=97u+F3xE2eD+7RiAd67qJZba4IQvR+X1Lrwnf+28N1A=;
	b=svVKkI1W+AGHAGWQgv1tlr2XaqjtUMSyj/Oy9d59vHf6Rui9bQiMyn8tgn1XDsU+W5hF
	 ofD2JpchGO84284g83rMk8hayVU95V0Pqa0VLosOBMdjxmJlLd0itNJBmsfz2xoC/WtnP
	 jqorTcZE9Y5uSWyFwO4UcH8pR4gCAwogdVj6N+wwYVH7Wg7s1hj2oiIIOkIIEpCr96cd9
	 OyTiy8BkK8sjwfqgaFEMs2aYBZFRiIJS0pl+UTdqig9Slkvwrwqu3YuWEwR0FBGL/v1HW
	 aLDeGdEb5WTz/WvaCbbXrP3B4KUwtvSGQRNNe0GOXnmJKBQz85VJj2zy/0N2xCiRe8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wU47cM1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F572606A320;
	Wed, 18 Nov 2026 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wU47cM1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5D71F000C4;
	Wed, 18 Nov 2026 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016935;
	bh=97u+F3xE2eD+7RiAd67qJZba4IQvR+X1Lrwnf+28N1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wU47cM1P97Wr1ks6Xrp8IrSWEGm+9QBxbyiwa3Zhd0S40Fe2hnkGlPTq300ZTF8gE
	 DKDXoriJ6loXIyWuKjFGntTu1wEFubjR4M33zlYd3QGhxwkONeR/DkmlYw3lGzbd30
	 CLs99bBoconyu0HeNKSImJ00MMYzrYxUgc/CjxuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0706/2651] swim: Refactor SWIM setup
Date: Wed, 18 Nov 2026 15:32:26 +0100
Message-ID: <20261118150313.243382483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 62977e8ea98e99dbf86609e65930e6607398e1c5 ]

The write to the setup register is really chip initialization, so do it in
swim_floppy_init() rather than floppy_open(). Drop the udelay(), which was
apparently copied and pasted from swim3.c where it presumably relates to
interrupts, of which this chip has none. (See also mkLinux SWIM 3 driver.)

Cc: Joshua Thompson <funaho@jurai.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/e9facb07b20436a6941ec067288e84d8dd9311c0.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3c02a14c8996 ("swim: Enable clock divider only where appropriate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index c2d7ad3f065cf..b8384525fc9ab 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -628,8 +628,7 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		fs->ref_count = -1;
 	else
 		fs->ref_count++;
-	swim_write(base, setup, S_IBM_DRIVE  | S_FCLK_DIV2);
-	udelay(10);
+
 	swim_drive(base, fs->location);
 	swim_motor(base, ON);
 	swim_action(base, SETMFM);
@@ -816,6 +815,8 @@ static int swim_floppy_init(struct swim_priv *swd)
 	int drive;
 	struct swim __iomem *base = swd->base;
 
+	swim_write(base, setup, S_IBM_DRIVE | S_FCLK_DIV2);
+
 	swim_set_parameters(base);
 
 	/* scan floppy drives */
-- 
2.53.0



