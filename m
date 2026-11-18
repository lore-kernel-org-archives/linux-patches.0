Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029923;
	b=Dpw7m0YLz7AWaw4tfGg02Lr7CWfya3Oys+Vc7vKDsKDkAxOfx4CgYBhrbWufrLT3mvfF
	 wzA8sPOBZryIh1ZgyW6dIP2is94gQAMviPe4dPhJb06YbXElSLuVDGHvhUjoPNkdEqhuu
	 9968uyXWX9ZTqpm4rVp5+NCi0qwQspa3pQ6l8mueloPNqL+o7+NBonvsNR6DA3yqbrlq9
	 7aQZ4eCLSz0H/S7MKgP+nI8Iv/HDoGcjoCXsoUB3NaMIhPJGZk4JRCE7HMLJlU08qGOp0
	 JzvYhsLv/7y7HeJoOfy7iey96RvN+BnwMfPGCu5CZ0L75AGApPNdzv2kCWZmsGeI/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAkdV+o3CnBhk8E+TsYGg3PG2oCwf9dUZZ0lnU9ettY=;
	b=oRP38L3wC7V+ssZJN8396rWppZCi36JiBUSDcTi0RerGj3k2OqGiRCpPu1VgqRMUePRP
	 KQDI+FI28zZOKbgc9fXfNRWow0jST+X7HolZYvu/ONnZ4ZDq8EAWDz2eXThazT2IOm0yx
	 LHNpoGbIoAUo39PLQ17NMeN640jWT9tG6xd3XquQhWWiP57/HQUsFakNkAWstsGXhpn2C
	 DSGPVVJXkdkNq7n2DZ7CkolwK246KldegnzirX3nII1+lXCba3YTtkJB2qW/5FoPFch27
	 Gp7iiAdbNUAqePjFyp9zGmhgThMYZxYeMVaWlNRStdlvTFDsSGolyngdG7vFuT6PIaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6wkhrPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AB5606A32F;
	Wed, 18 Nov 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6wkhrPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13F21F000C6;
	Wed, 18 Nov 2026 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029923;
	bh=iAkdV+o3CnBhk8E+TsYGg3PG2oCwf9dUZZ0lnU9ettY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6wkhrPV86vWgWD+nVB3Dwv7IHuc/vJRHGEtYE+5VIoQr0nUG8j8165C/BaJZRvNB
	 Vxpdr5swgPv7fJ3OWGR0yWMNSohnUAnQcFIVL5uAtBqKBcgCkx7O/6bRvUgqZoz8kS
	 z3DIfhfsu8+/+DqT2GR5/Z0cMj3/9tBCeEvciAHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0523/1756] swim: Refactor SWIM setup
Date: Wed, 18 Nov 2026 15:44:10 +0100
Message-ID: <20261118150029.969375963@linuxfoundation.org>
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
index b8107ee501b15..2c3dea0b24fe7 100644
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



