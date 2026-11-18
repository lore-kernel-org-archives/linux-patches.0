Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060750;
	b=pab5aKR7cuvFipd3BNuJ3yhTMXwzFJwZ71EH26Oe/pNdflvLO3l1Z3dV6hPaxUO7VT5n
	 LJMYhhFw70WAWVRvnMTzcz8MXN0ICnNSWzA5bWxhj8VBYGD5XpZFsjBnvktVsdQVdWNCm
	 Ngp7reFqb3LHAN2EGjRvaXNDdrXKdkxc+yDxaiR8XVTNJU74QmJ987K5lGxqc3kD0GEL+
	 KXXjVNko1qqD6kZroZWEO5Fq5+2wTHO4o4wUvNSKyv8keCRNsbRFOLhY7vvUPAgrSYyyh
	 QeXMzyKm494y7uZj2ThwZx+cG1qKd3QyRpKqIWqPswJUS6XdoqWGjNInffU7QzYG7og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=47uNn8lefvtNx3X7KjFM9AqL+EkCvfYwfbSwzSIO53o=;
	b=vFNWkjUZJwnPOWpi9xm4kIlyI50shrbuLATw871jTDfRLHcwSUy/BVEIwtM/D40VCM6k
	 7jLHmOiAU1p3dR+oRKApQijWiib8NZin1EOEVmdyhPKRZPeQDvS+rLvpjUiAROyCCnYou
	 0cJQ/m02PwkgrstLsL5j78vQ4OveTue9qzK9P5l4HK09Qet9VptlPo6fFRpCI1TVLuD9C
	 ggftMWy28MLouidW/d5C4ZHniCpu8goar64Dvh4+0Sve55NNwlPEqQyzowhzQzL1xwOW/
	 TAtskEFf/u1GDY5AlbV8etRlswlCm/RltxzyJb91DDSywfpJKSxv4MCLaGkIGeL/hkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJeL8Qd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918BD606A326;
	Thu, 19 Nov 2026 03:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJeL8Qd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DF21F000C4;
	Thu, 19 Nov 2026 03:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060750;
	bh=47uNn8lefvtNx3X7KjFM9AqL+EkCvfYwfbSwzSIO53o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJeL8Qd90AtKwxN+JROw8Ei9OdDtdiWwryeXPjqMymnHlN3bOx6C77SebbCwMYuKt
	 wHNL6XTtm3d1do0SgXgw5g5Pjco/sA15M/NGXAEXv8pd7iB8nL+knd62oUPp9gQY0p
	 n6KniG7sQ+b/albSGmaOH7YzRCFDFApNRmIHbRsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1311/1848] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150014.348774974@linuxfoundation.org>
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

[ Upstream commit dbbaaae83cb277d76e70426c0f0ce289e867ed77 ]

The spindle motor should not be running when a disk is to be inserted.
Don't start the motor while the drive is empty.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/7ea60e0bf6135b9bcd4be0991a257d4c5de22bb3.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index fbcd9b41455ca..c70fca530f888 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -631,8 +631,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	swim_write(base, setup, S_IBM_DRIVE  | S_FCLK_DIV2);
 	udelay(10);
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -640,6 +639,9 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & FMODE_NDELAY)
-- 
2.53.0



