Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061055;
	b=LQGBZM4bq7JOFq2leUYjkTJ7a/5UIBDolRdTCAbBVbPGsOUev+ZUVaTcRrzOVk7kH1Jb
	 T6Or6wIz9yMKwdv5KLjC+J0PNYWLaN8cwrQSWkeBTDgSaQtSEY2ZEAatZUALqhMLe2HuG
	 5UC9ztS46X2x60K1VagGg2BITiARehgqDUn64838yjFv9X/p7Vf7lgM1JPF3UoExvuKUM
	 AAxTY30bu1Zct0S9nDHqFRaFI0RccwOJglQP0ofKhOnOk8DCZvUgbhc6QJUa/9ASJiFLQ
	 HhwXsHqJ3J2R6UKnJrjLMaybJr0NCrYcgPnJHrozWTDoA7K+XsarW0mh4oY9NDeddXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rX4Q91v41+czhTPbt4Mw8Gjkb0bz7K3VvM1cBcKSQzY=;
	b=QJwmmdl4LrEXStVQrEUsFdg8iDBsF5TkbLL2voBW6TKut4wHHBhwJWjuymfe72qLRZdA
	 Tpr6fQA56dS/6yIrNY2LPb6n2aTrbh4nQNZxdpSBzh9xCcSqI+94JqNFonVbVgddRNdjl
	 skL0I8sy/QI4BPsIPyuvibpl7uc1qeRo2JCB4lwcw5YxV3J9O6hca5s/pF3N/w//RoZH2
	 6cndY6jwRirMNGsEM63y1WXWa6KjBKOjzcM/0xfl5RhqhqBkhJC7sQ0ifDVh5bsRZuM3T
	 +EyjlvmZTLJUqCrGX3+GQAOycmTo+o98Tv1qLFCXGQg3tTNZvfTyoSa41vjIbxAaIfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFP3p8GX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF4B606D813;
	Sat,  7 Nov 2026 14:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFP3p8GX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2701F0089F;
	Sat,  7 Nov 2026 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061054;
	bh=rX4Q91v41+czhTPbt4Mw8Gjkb0bz7K3VvM1cBcKSQzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFP3p8GXizXZq5kjptPpOJ4MmaZYsU2nUmugC8SE7m5Q6NN4CXxwqWMluoLkZlG2F
	 +0xHGET17ZqnRG9iBTJzTFKi343WMqjCi1PXW6+3Vt6kycJzApej/WYLsOfC23KMpP
	 4+aCRj5hXfmrlVXQugtaNU1LHlsILknymsVSGVLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0386/1536] fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo
Date: Sat,  7 Nov 2026 08:40:02 -0500
Message-ID: <20261107135008.455170824@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 94e6a058b16820e02f25e1221a4c4e713ba23550 ]

Ensure the logo will not exceed the screen size, which then should
fix a reported KASAN: slab-out-of-bounds Read in fbcon_prepare_logo.

Reported-by: syzbot+0c815b25cdb3678e7083@syzkaller.appspotmail.com
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 5ce1aba2e7615..e582314f1ccc3 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -596,6 +596,13 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, par->rotate);
 	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
+	logo_lines = min(logo_lines, rows);
+	logo_lines = min(logo_lines, new_rows - 1);
+	if (logo_lines <= 0) {
+		logo_lines = 0;
+		logo_shown = FBCON_LOGO_DONTSHOW;
+		return;
+	}
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
-- 
2.53.0



