Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016416;
	b=b5mzX05el9Jcd6WVDJC0XLTaQWwUBE1dzMRBhQUQdyQkcWwPJ5nQcQMZVXUb2k/vgSmM
	 qlJMJBTwfLSEQ1wxRgDUXoOcqA/lkS0W1raud1BMUhCtXPSCn92G6JCfAsGLIXNf7bkeL
	 B2+t2J03TyoZYaTTi3DR7Pc8epCbcPemNy3TQ6MkAE+b/M8mrzIv6LbzyOZDLH+7lAp4k
	 Gb4nLBJmyyYxajuYfdygmRGotLz5rW8l1AZsQST44thg7zl/iTH4pusWpFA8hi/yZI1i7
	 JrV38j8joxkVbfgr0MvQBBxvk2JuuNHhGHDdh11VQsCDHKliOz0vc/6CFF/mFjSZLEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2IvhZLvgW7GYDP+7qtsfgZkfGTXlNdmYUzyXEUZ+bs=;
	b=YiI0IVSWVimzFhK0ZiMQTrrQGDe/JU8omOZCzhYOPMVhD2xRfGl+Bis8d3MNr/oo6+xE
	 9AU86ZQeBQwhWdejpB01y2N7bpv82g6DEUOFEDY83HDV3Y/pme1J22mBlWdhfa9ipG0mo
	 YDCxXG1O59wPGwjp73E8vmU8xhcbnzR/k5JSHewfOd6Yu2jgruc3sG4lrFk+WU6QkqtWm
	 q67QwYP2Wr9gM4ZZpcn52Hb1Rf3ldKYveoJLCp7exqVPpcNf6Dd9lJq3wwCk91Q5w5C05
	 +xe6MrPM2qPDhNOnHVCWOWpkA1fNdbk1HWVefrIVXUHEvR5/gyd39otgaKQzWCYYCgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNYVWz4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E63160A260A;
	Wed, 18 Nov 2026 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNYVWz4n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7222C1F000C4;
	Wed, 18 Nov 2026 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016415;
	bh=K2IvhZLvgW7GYDP+7qtsfgZkfGTXlNdmYUzyXEUZ+bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNYVWz4nD4T9nrHoATXQ4FYzcLjx8QklFSdZ4ha5QGTmrmuRxvmfIzBCJBT/PFKZ1
	 UYbtM3l5r4+HTnD8SoDX8S7D4jNAYI1+Cx1DJvZvQDBfPAk/ZkUWIXP1pHSTQKWjcW
	 uesPLIrKVMNbumq2sO8iOhurf/3es9Nc5jSDfQbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0514/2651] md/raid0: validate device count before allocating devlist
Date: Wed, 18 Nov 2026 15:29:14 +0100
Message-ID: <20261118150306.254027144@linuxfoundation.org>
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

From: Chandradhar Kumar <chandradhar.2003@gmail.com>

[ Upstream commit cf5963d6781ddee4c59a61debc459fcc7580f7b6 ]

create_strip_zones() allocates conf->devlist based on mddev->raid_disks
before verifying that number of devices matches raid_disks. Move the
existing device count validation before allocation to reject invalid
configurations before attempting a potentially excessive allocation.

Fixes: 078d1d8e688d ("md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations")
Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=a32ff75e417c0f49a8e9
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
Link: https://patch.msgid.link/20260907132936.6677-1-chandradhar.2003@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3e..453e8abda22ba 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -79,7 +79,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
 		return -ENOMEM;
+
+	cnt = 0;
 	rdev_for_each(rdev1, mddev) {
+		cnt++;
 		pr_debug("md/raid0:%s: looking at %pg\n",
 			 mdname(mddev),
 			 rdev1->bdev);
@@ -144,6 +147,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
+
+	if (cnt != mddev->raid_disks) {
+		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
+			mdname(mddev), cnt, mddev->raid_disks);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
@@ -200,11 +211,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			smallest = rdev1;
 		cnt++;
 	}
-	if (cnt != mddev->raid_disks) {
-		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
-			mdname(mddev), cnt, mddev->raid_disks);
-		goto abort;
-	}
 	zone->nb_dev = cnt;
 	zone->zone_end = smallest->sectors * cnt;
 
-- 
2.53.0



