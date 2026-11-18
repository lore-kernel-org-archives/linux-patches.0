Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048498;
	b=Fn++gJ91OSCNsP2aQRoxQP/K1v7c/0CRAXzuEOd2/vIumuuDIy2+yOd4QV6tIL7KNeNn
	 oEQfTFQypAo0pIZVeUnrZiVzNF7LPWMSS91WU4uPiK1mo/N40q1lDONnLvB32yfsreo0p
	 UT5qpb9tmW6Z+tOYboH2dxo8IiG6hRHfdH4HHAvqknA8Zkig7AZTpcKqQvhLlUchX49QH
	 xHUX9pfrFrI8cFrflNF8UKIoKhvWR/QskhCvZhKrL/HW96I6IAV46uBDZlgmafoFIdQIv
	 F7pzhrI1NV5sXfBWZd+4g8E1CydblNjS3zaIjTa+Sai0Pw5NSaZowvWQhY+QUxK2j1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApxbNFjrFIYWrZ1rXZjHN8HrmXrNedVHbdYdLzjv/KU=;
	b=yNlfhLd/p7IMu5Cooynwm6B45blW0Lw4TTlbXLFg5LPVoxpp+tzW2GWbKszpow18cDPC
	 Xz13/6VJjC4TLK5XQt+TfrslhXCJR5WAhEvJ4Pr/c8gVY4dnFQo0i+ckpvivZSV1Y2AG8
	 qDKEXIM/doTU6F7vNhjhb6edKvnPEqhJNl3Lqbxh3eysL2s1ZVhjE22Ks2I51QgMxHbAp
	 ueHwv6AXBZkQjBeUmvK6TTmMLyncWxYPEW9PU5+GhvP6lP3qWCK+ADGs1vG+zcrChEIXo
	 bfeRcjKhCGm0hTUkBbPIIE+rTdf47qQGjexUD6qDkITkIILn4lHP0X+ZKwwmj6Zp0Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhI7V1bk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62FF606A320;
	Thu, 19 Nov 2026 00:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhI7V1bk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE57E1F000C4;
	Thu, 19 Nov 2026 00:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048498;
	bh=ApxbNFjrFIYWrZ1rXZjHN8HrmXrNedVHbdYdLzjv/KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhI7V1bkAw20BQH3Rb2vWjKRQpPZJW5nYBjAKJ0jzUn7opD7bmvG6OG8tBukO9JuL
	 keoGYpz9marO7BqsUOesgDcg9g6PP4lyYB6t8qMKX1cfMcto2jgmvbIWon7t7nhzT9
	 2wlP5dbSziovOZmlc15a7cRPG0o7C3KWD0lJdOKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2016/2857] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:50:50 +0100
Message-ID: <20261118150313.990387692@linuxfoundation.org>
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
index 7096fac6cd1b8..f2ca35ed0ff0c 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -633,8 +633,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	swim_write(base, setup, S_IBM_DRIVE  | S_FCLK_DIV2);
 	udelay(10);
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -642,6 +641,9 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & FMODE_NDELAY)
-- 
2.53.0



