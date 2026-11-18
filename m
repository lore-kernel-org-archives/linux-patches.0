Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024189;
	b=GBf2xzv+fC4i+/A+IO9RkWhyjm3enmmbT+/49gEmEtv4L7lNkoHpsXAxGdhe+EgaTUqI
	 XfxngbbTN/g2l8DXATadVXerFZ90D4lJfsnYoKVvnKKTI+GNEbRr7Xh49TGjQCicWiDNV
	 S99qULpdx1tzNiuzUlBe8YeBG+iDa8m8S0ZSSLTqT/2l1hidXVI8fdkX2CL3jqxvJoqMS
	 z4dO0LQSvR9TFpv4UM95XAkuQOt0JLKxwKKluicMhy9wiVYa1Po3zx/gOzzYYOZFPJR0E
	 wDGaiQ4y9B8dQ7Dc31lD1wII9iMWlJuN7nu5of3h9rOBPGdkL5wvMzh1WK71We2najA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yB2rz3x5TOJu1PMnAaEYpBFc57P/0mw1/ftPG7HtRvM=;
	b=S8tEi3sG5EAR97YZEKDXLqE6GNn1rHu7vlszYBSBSmyJXi7rodYe6j3BdfPdFeBPJ+FT
	 gzes75rNuBRAbc63AOIb9UmgQSu1TzZ+B0oez1NSkxQIrwr1Sr59wKA6w7/KCYDp2cR5B
	 aWU2w8TWJh9uVPwl/O29M8Be8Bb5I7oPM9NII7mGezT9w71EzpSoUVKZPr8aOx1ZsliNe
	 WgwFMUJdBYcA7n6lEhA7Kc56GMYuq9r4/VZP9nmwFh945EYUMouwGc9VMuw+2r6opfyB5
	 hNeqRUBn8IGAFx/1J2PbQbHsdUy7mFzzCZqLRsX1Oz1CIZJIyC0YJ6yBG4l8VJDDLzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IcNP2jw9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B616606A31C;
	Wed, 18 Nov 2026 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IcNP2jw9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3D31F000C4;
	Wed, 18 Nov 2026 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024188;
	bh=yB2rz3x5TOJu1PMnAaEYpBFc57P/0mw1/ftPG7HtRvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcNP2jw9/CyvnSfjz5wBp4x6oEzVxx302USMhcw/gnmzzkfAtfSFyvyJxTJeBznzN
	 PxoUA4aBEB/E/36Wl84bDoIlvHXzWGtSqyAKvJF/UlwZmY1lMtoIbGNUULlZxfxJhk
	 iIDcppYM3vG4mps7evdyHUNOuxM+dXyDYINigmB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0635/2151] swim: Refactor SWIM setup
Date: Wed, 18 Nov 2026 15:39:30 +0100
Message-ID: <20261118150145.014625291@linuxfoundation.org>
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
index ac5475a987b74..7e567e7219ba1 100644
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



