Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060988;
	b=pMIf4ZiZmFGP3BT/+626cD1P7WXJl+p9glocPsj0Pmdz8ygRWestVHrrpyBesdqI/68I
	 KGpEtXsCufjjsBuwFowp04ubPZz2I+kv4lFzPrX4ykULeWf1koorElCZS3O07cN2AIqlC
	 G+kXv7KAZ+TEaBuUXlf/2fSr+0cR9HxohI2mfKAVDv6KwXxPsj0FzaMk6+y6vrYVcbpj8
	 LM4Y3vdDd5kltzP8dNpVHayruXtDh615ghRdzZHRb96PcEwf8EYjBrSRdSwz9czfFTLhj
	 FLsv6rFLbT9kgg+GNANq9mYKrsAvbj8lM9PD+/SOCXKXA+jiTEPJXRH6KCzzshwoZmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/t75wy0G8WfebSnt+QqVgjifOkMa2OxFZxvWkq5L6pU=;
	b=c0taDg07eY/rjQIjWUb/mp6v8NsTEuiKGzZ6hGrCRr/sSzkfiZom1GPjKApsZ0x3XN5L
	 lojI9UI86/gX9mJUWE3t/JQr1enY4CJES52BsDEFhgxnj7i6yzwHRrzSqNZ8lbwqdF18k
	 7CfRZc63dsvndf2FP7/+mXO5zsDe45ZAI+NwFKkd9MVKxfQwXPrr7rSBPCjFSC43zdPfe
	 uBLfvbIb72FRe8UTp9nCSurpqvqmX2aidw2iVTda48AxPegSEx1Z8RwWuuwaKq3LKl0+Y
	 A+trnTwLB+iSAE5awIfq6lwSUX1MHK5kAvUkXQG+8RXa+IRH63WKsYXNJ0PgPKI1oDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbvQn19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4578606A32A;
	Thu, 19 Nov 2026 04:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbvQn19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181271F000C6;
	Thu, 19 Nov 2026 04:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060988;
	bh=/t75wy0G8WfebSnt+QqVgjifOkMa2OxFZxvWkq5L6pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMbvQn19FSjXNuUkJ8dTEkBCMRerAr2cfvbVO0/106iGb8oFncDmrJ+Xpdu0t2xfF
	 fGpOR1dc+Y8A22bcVlWS1wreeAi32nC7yDMca8r/slQP+4K4PdB98Lu1AWRXXRqEhR
	 A0dstKFJjDoup7m8iuiXzYT6HLIshzynZqseXCFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1396/1848] swim3: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:57:14 +0100
Message-ID: <20261118150017.957641995@linuxfoundation.org>
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

[ Upstream commit ce054fbe9a4bf4ffefef0f8e2504ea54da058ed2 ]

The eject command from the util-linux package does not work with the
swim3 driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY after fd was opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/f4cb43726ee6f1cf159a6208f77b4cceea670a3c.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim3.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index c2d922d125e28..f9f0e946bcf85 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -869,7 +869,6 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
-	int err;
 		
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -880,10 +879,9 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
-		err = fd_eject(fs);
-		return err;
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			return fd_eject(fs);
+		return -EBUSY;
 	case FDGETPRM:
 	        if (copy_to_user((void __user *) param, &floppy_type,
 				 sizeof(struct floppy_struct)))
-- 
2.53.0



