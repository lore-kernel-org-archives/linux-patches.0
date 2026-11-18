Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016924;
	b=0DS5JnwKYQ7Mbfd1ZFVxAgvLc2mMKZkaiTXe9OrHNFh/zYaFle6ZpWC1C/seNaMM5yoR
	 ouqrsgzXeIr2kerPI3VeIYwnLxU7H2nAO25Uy/dr98nodHKj3XXza2rQxJvCOB5RLU9Vc
	 aV30L3OIP4byt41D10uaoEpI+2vqcbAmK3gbBpBDHVWc/H8Ufr7kxnHR8gHh/cXmSFkY6
	 4dhwBF7QJfZa7COLel1RiorWtlhZ2Utahd9nPpGhc5M4s/QZ4NoK18lPrECbj7U0eQMY+
	 luHMOlpC6/g8DPMg50qL7Z0XraBmNi4aeUEJJ13a5PW6+NEIzQPYSCN2mSIGesNPSug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kosDrwWf+pIDk9Boj4R5pS+YXw7OGAwNDO9ILYqvzWI=;
	b=qWyn3hUACO03LZ/3xvY0FkStPWAhx6CyFvs8nGW1JrteqCF9xs1jTB5GN5eoJm/1QQTu
	 0+t6GeWEESI/hjqOlsP/FbxDgbbIprNVywtOBsxiZhIo2wxCffPj0svQDXaFwtYp/kipe
	 FmOpzHYgZESGJU4Cf9yVZ68YZwMVXScHBID9GVciLImV5nNVfKfRce2OPYDg6khuIfxhO
	 VNNOaE7SknkmT5t3bZ1DML5pDkpPCz6lVjQ33zFpQw5ZHUaOxM9deZaCe/NydLzBwLpEm
	 1b738RlthKvfDQBCcwTYunkKMKKI6LyoyZGAk/pu43vB6y/4eUo0ZJfcS5srwoB9c8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQBiNr4A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5CE606A31C;
	Wed, 18 Nov 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQBiNr4A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456541F000C6;
	Wed, 18 Nov 2026 15:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016923;
	bh=kosDrwWf+pIDk9Boj4R5pS+YXw7OGAwNDO9ILYqvzWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQBiNr4AcBiz2v7Rvh4OVot37XUhE7/IkLqtE4TbX8FCroPvxef4XubyW7gpTYKeM
	 ik5arypesvUOUCD+5WApHeoiZnbfULfazl+Z0I8Wtr/G0s0zAICMbM+parNPBWR29d
	 qw1zvieHERmWjn0ucqcMQOLxQEHiA/IF55Ka3kC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0702/2651] swim: Enable the drive when probing
Date: Wed, 18 Nov 2026 15:32:22 +0100
Message-ID: <20261118150313.103812967@linuxfoundation.org>
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

[ Upstream commit 57d88c8f4ea34a4dd7c5351bd026e225c7283f3f ]

According to the ISM spec, the MOTON bit "causes the Enable 1 and Enable 2
signals to be turned on to the drive." It doesn't actually turn on the
motor. When selecting a drive, enable MOTON. Disable it upon eject or
release. This fixes detection of the Sony FDHD drive.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/f5bf5b596a33a801faaaaa6dc2844c30d3ee82b2.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 4721e073a8740..4ddb87977fe1f 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -154,8 +154,9 @@ struct iwm {
 /*----------------------------------------------------------------------------*/
 
 enum drive_location {
-	INTERNAL_DRIVE = 0x02,
-	EXTERNAL_DRIVE = 0x04,
+	NO_DRIVE = 0,
+	INTERNAL_DRIVE = BIT(1),
+	EXTERNAL_DRIVE = BIT(2),
 };
 
 enum media_type {
@@ -311,9 +312,15 @@ static inline void swim_drive(struct swim __iomem *base,
 	if (location == INTERNAL_DRIVE) {
 		swim_write(base, mode0, EXTERNAL_DRIVE); /* clear drive 1 bit */
 		swim_write(base, mode1, INTERNAL_DRIVE); /* set drive 0 bit */
+		swim_write(base, mode1, MOTON);
 	} else if (location == EXTERNAL_DRIVE) {
 		swim_write(base, mode0, INTERNAL_DRIVE); /* clear drive 0 bit */
 		swim_write(base, mode1, EXTERNAL_DRIVE); /* set drive 1 bit */
+		swim_write(base, mode1, MOTON);
+	} else {
+		swim_write(base, mode0, INTERNAL_DRIVE);
+		swim_write(base, mode0, EXTERNAL_DRIVE);
+		swim_write(base, mode0, MOTON);
 	}
 }
 
@@ -447,6 +454,7 @@ static int floppy_eject(struct floppy_state *fs)
 	swim_drive(base, fs->location);
 	swim_motor(base, OFF);
 	swim_eject(base);
+	swim_drive(base, NO_DRIVE);
 
 	fs->disk_in = 0;
 	fs->ejected = 1;
@@ -652,8 +660,10 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
+	}
 	return err;
 }
 
@@ -682,6 +692,7 @@ static void floppy_release(struct gendisk *disk)
 	if (fs->ref_count == 0) {
 		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+		swim_drive(base, NO_DRIVE);
 	}
 	mutex_unlock(&swim_mutex);
 }
@@ -804,6 +815,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	if (swim_readbit(base, DRIVE_PRESENT) &&
 	    !swim_readbit(base, ONEMEG_DRIVE))
 		swim_add_floppy(swd, EXTERNAL_DRIVE);
+	swim_drive(base, NO_DRIVE);
 
 	/* register floppy drives */
 
-- 
2.53.0



