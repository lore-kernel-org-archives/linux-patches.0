Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024193;
	b=KkUy/qdV4KwQ6uDJLIf8zFLWeG1tP7rIiBUhPsGRr3p4UhYSmTVJcpKAoe497RV5hnos
	 Z8Uka67hh4hxfBJUC4rjV2OU1/H9sIAhA0W7GJg53+/6UK4icZ9ToWplPMH2DIGGBI6Nx
	 Th+jiFwjzaB+Zta6PJK6UGELsAXlrsbBGh4a62u44EgI5q5i4co803p/6BDwimjb0Wtb3
	 Xkyw0VKGOYTM7FxuSN3h9Qmml5mo5CTkJPw0bpdJKBRDtRSidzEH8q1mQTrtZ9BaFQ1P2
	 /MGH3ipp76ptyfUarWrrxn8QaP3x3nuKC2Ru5/FV407ArFdFpXrgGz7sgYGq+iSES9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JgQPJyXLhumDhZz9gaBeyjzFD7zMowEFTab67Emf0eY=;
	b=on6/6tWDHbuPb2+ylx+7mne6l21DJpYoKCbGYJiopG52dBYdEw5eR4ZbgDYkXN2uW0wX
	 XuD3h3hsSYZz/gBy8vE1ZckuNOlcWFmylvxYx0IaxWmZ/hSIAU3IEOUNydUpHmQqZTU5N
	 dCmn25WQo9knbEH90h2HdONgVmI0zt0Zihm+bihpp8sKQhCfBlALqcVH7XdeEjfffbgPG
	 U492ElSiEdRrQ8hmJj3dJu2Qzh4O237oBUkFGOwcHpekvYHKpX37gyWtL1sJ7UzpIgxjK
	 hQnrmTLXj65SZfvK4eJ4ypGJ8fqfy+HWq9VxwBKyvRSXM5Q+rNQTiEHLO8mxMg0szjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCJPlIRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1DF606A31C;
	Wed, 18 Nov 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCJPlIRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AA51F000C4;
	Wed, 18 Nov 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024193;
	bh=JgQPJyXLhumDhZz9gaBeyjzFD7zMowEFTab67Emf0eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCJPlIRcfpIRKt1pVNGpQhL9FvLoEUcxM5wqCI8KirF5gQuRXpKgymnZnPwxTSUhK
	 zuXxgATlrGzyv3q5qKLktUej8OxtrbKR3AtsaLpIU1X9LHdjFGAN+5mJqu4Lqd9E6R
	 sGa7YMhws1t6ilzFSgeBPh3FjDAbImoDr8+8NuBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0637/2151] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118150145.083592644@linuxfoundation.org>
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
index a2303e2e24ff0..4b8d5268c900c 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -630,8 +630,7 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		fs->ref_count++;
 
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -639,6 +638,9 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & BLK_OPEN_NDELAY)
-- 
2.53.0



