Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024170;
	b=FfyeeJScLJW1y9F6LurYFmmpjxig/g3DtHKpLiVKayaaSGaOqNnXMTWbz2v5ek8ZQFcM
	 SRP3elkJExq/gDzeyg0BJckLp4DDXAFd7/mKinoU6LhtQbJuZgf71kE9UUWrhqCT6cYZA
	 3PagQaAvb/PTsWRl/4kwNLrB+g0wdj2Uy1SSHy0GZ2LKJmdbo4aMdaIdUfoJwrbanUxvs
	 5zmLHzyVMYjk58IcsNQsOdahz0FTU4lMRdKrsJOUo0dcyI+S1yRokIm6voJk5x1xjR21f
	 2axWjMCK6OQ1myXFZEr373FgIp+tbpmhQygNozsggudRp4jwLNHVbiA9jS+okZgYh6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hLf9zvwjBifqxrqa9UvWsD1Yya1Qy58Yd6JJ21pXkPg=;
	b=SZG0G1RQXp/Sjn6cuZMK1FdfOsIEBr/LVcAkusnz3HKfPUbYbPJfkb0NA1qyJSO4fqNE
	 UsI+R/b8lH1mjcUyC3GntWlWX4IaG7NIsUe1nLvgxpPLsh3SrV7/2N7JNqoVyH265eoX+
	 6gUzQlYI+VRI11zzbgQMohgCZa18eCZ7eb6LRe9mPrRcMOdBPio/upff4Z/TuFsP1eT7N
	 SFYQ2PfzbKh3ZfskYkot3+rt5QgxZlxD+gbKkDTsjfXITNhHoO5SKIqhuxKSat2NfXGIz
	 GI1fRSfgLcc0TNS6prnrXsgqonVJLPsDRhmBBU1KJUMwJud8u72r2d1DYRHPxJ+GlOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIabthr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A2606A31C;
	Wed, 18 Nov 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIabthr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5A91F000C4;
	Wed, 18 Nov 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024169;
	bh=hLf9zvwjBifqxrqa9UvWsD1Yya1Qy58Yd6JJ21pXkPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIabthr2hAgh2jNKXRFfgUfyEfwh0icFo/zWC6j1vMa8stv3ym9LO3Rn+CjhPa7kF
	 MSL0QglKKkDMUDVnH8sBPnf5V8H3ESR541uQgPHEJNo1zKABdd4SvSe7+QFl3zTL87
	 aTAC9KD1aBeijGXfvZEgAKVcVtWngZ51Tms764nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0630/2151] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118150144.840555719@linuxfoundation.org>
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

[ Upstream commit a2d22b3f25c388f9fbce7bf36a45a8900dce4aa3 ]

Before turning off the spindle motor, call swim_drive() to select the
appropriate drive. Remove the swim_drive() call from swim_add_floppy()
because it was already called by swim_floppy_init().

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/370f73fcceb53ce4860904ce6cf4f06ade0e43d5.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f487e9dfcb544..143e104c7dfaf 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -679,8 +679,10 @@ static void floppy_release(struct gendisk *disk)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -752,8 +754,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



