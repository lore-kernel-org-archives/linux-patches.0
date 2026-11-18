Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030373;
	b=Tvubz4eqDLbsk7yiURZhpf9691uFocVJohc/ME6siLzBfgPfYsYgaRsT1JGHmJFuJSHz
	 PPi9Wvy+LQ6dLaP30ZQrW5riWsgnLTre9hXqk39IbhdLmrIYrfw61JGTBKUdHLIGPY85k
	 wz50To+alzR9oJNpw5RjN7odh5oEBM2xEwrABZTuBuYqUu6OEGbQ1oTav80/6gpl3t+D+
	 9kBwS09X8xS1XVQ3efCi2pgeL9y8Q1+FFrjrsevP2dZfBx4GD/1uUHxr/u3NpYsgKH2Kn
	 UmcO6+S2h6e2ib+pgTLJbSP6z47Hic/nNikaS03nSlc05ChPYBUgwYGpp6+lxEt9VPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9a0EShuu4L2erv62OOJGYIxJQAYhwcwpR43ARgj1Sp0=;
	b=z7w9KnuGysgRoTDNW9rIVBWX+brxz1VKCKYRv1eUdJgl1Fu4eS5kx4O921Y9YVavUTDB
	 R9Mm2X8xpoEDpbI9SkRJplO4HtD0pptcehz/zONVOb6gwviu38VFmhZYrR4rl+P+v6Pg/
	 sZ31oTJwq1B5BGF3PEiZ9/A4/2DBZy5c/JrxeeKI1Dzg/IJ6rpSvqdyx+FCusgepR9E6i
	 gqNiLKKcUjcB5/BDsHMmBtuNDTZku8rghxBf6vj/dJqWPqELuKvx23eO+JmVYUqTnryhU
	 +9x+scB8HtmyKNLMTGrGJ1x0Doj496flsLDYKovKDvkcum9Rpd0b6POgxck2ebWXcsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpPKmbxu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6BC606B101;
	Wed, 18 Nov 2026 19:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpPKmbxu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3A11F000C4;
	Wed, 18 Nov 2026 19:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030373;
	bh=9a0EShuu4L2erv62OOJGYIxJQAYhwcwpR43ARgj1Sp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpPKmbxuYlQWFBNqEhVqUvMtaFfDjiNIrIQNIgxo/R0ggyoJj/NCIraZrCftGmMFm
	 2rqKtwX5FlAMvp6VvgdeExbwwMi3QZUDLLYit86B0nXwykWQwBLRLxq9WIyLvP5S00
	 aIJPlXEWuNs5lvmPxomio5kTF++OxMbdUwOeTdoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0680/1756] swim: Return -EROFS when opened with BLK_OPEN_WRITE flag
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150036.322902157@linuxfoundation.org>
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

[ Upstream commit d8fe777978a12a96cb5d10d6d888720fcba2da2b ]

Write requests are not supported by the driver and produce IO errors as
shown below. Avoid this by returning -EROFS when opened for writing.

[ 4111.690000] I/O error, dev fd0, sector 2 op 0x1:(WRITE) flags 0x800800 phys_seg 1 prio class 2
[ 4111.700000] Buffer I/O error on dev fd0, logical block 2, lost async page write

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/327be6ca3c92c3411b5dfaeede014ed65a2d0f0f.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2b324b67b9ef3..0271e59f25ad7 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -630,7 +630,8 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 	if (mode & (BLK_OPEN_READ | BLK_OPEN_WRITE)) {
 		if (disk_check_media_change(disk) && fs->disk_in)
 			fs->ejected = 0;
-		if ((mode & BLK_OPEN_WRITE) && fs->write_protected) {
+		if (mode & BLK_OPEN_WRITE) {
+			/* Write support isn't implemented. */
 			err = -EROFS;
 			goto out;
 		}
-- 
2.53.0



