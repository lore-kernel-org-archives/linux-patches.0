Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016477;
	b=SrpkjtCUbYWhOta8XjVQrIWHiNlu+6q7mFEvl71ATBPgvvEa482cfP2DydyivdSNIrOh
	 GkOASS0CXmWT/b0kpkQ6QeM0AiUI8OeQ16QlVLi10IDEOypxFOBhIABQjUGG1ol0Gx6vM
	 GAN2SUuW/ciR0ff71a8xHKUVhh31rJR+rcHmNLYbL3KQ1daUmGJwWfoFQ7EsBAtaCYo6a
	 lOqzW8f/yzzmwkSotaP0WA3HVMLu6xSBbf23qYfACV1ENlYo4NVG6BVS20eFS/P4UMOGM
	 R+e7oXeJZs0fL1fIH1/MGa880dKhEcP/K6njbHG5N7VGJ+KkpRTj8+V+56LyGw3n0Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKENvF9B/SHCRslSPO8APNVTuErkem9zPf+F1MVQteE=;
	b=racT/Pr2plGWg4VSxibTL4ms2CDogGkKe7weWNhPVncUCH0hPcu5vKHznhM99dmcEt80
	 2nRIldRfepRIjp+3EUhSx2fQ/dMmeQVSPNJTHOymjWRAv1dKWJujs5QXrP+8qZTVLLr1/
	 ZhxmWLpZwiWXiVRSHS29w3touTs+NK07Oi2AhTKTkH/pCu1hpVBZyLc2VuUe0WGoqTUU2
	 OTedYXP87cyzz5HClNpDZ+G+nv/qoMCcf85f1VCIJRkkJAejMRDqujlRAEU4Ejp2Bk9sw
	 6bT8WfaHiu4YgMMGNk/6uYXr6lSfBoztbgbwvDoRFQ50CnwXXG15DmxY0+jidRe3m8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zta7kNvt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF75B606A32A;
	Wed, 18 Nov 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zta7kNvt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE96A1F000C4;
	Wed, 18 Nov 2026 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016477;
	bh=JKENvF9B/SHCRslSPO8APNVTuErkem9zPf+F1MVQteE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zta7kNvtHWw4CSmEENgHy2YCxpptZFnautm1IP/z6Rps8cp2lv7NzR3eF35J6cBq4
	 Kpj9puFM3KDHQwNU1ofX+PHhoRnuve9mq5tTeU1s+7vOeR9iOoexBNkdOhYMYqArTF
	 kqWeObvDUxbxqQki1+PTe16SHiI0djb0bo4MPYmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0516/2651] md/raid5: reject raid4/5 arrays with too few disks
Date: Wed, 18 Nov 2026 15:29:16 +0100
Message-ID: <20261118150306.330766261@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 0d9bbbb6fafa22659ccd4d7ab94329a43c2632d0 ]

raid4 and raid5 require at least two disks, while raid6 requires at least
four disks. setup_conf() only rejects raid6 arrays with fewer than four
disks. As a result, an invalid raid4 or raid5 array can be assembled with
no data disks and later reach raid5_set_limits().

Reject such arrays before the r5conf is created. This prevents the invalid
geometry from reaching queue limit setup, where roundup_pow_of_two() can be
called with a zero stripe size.

Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google.com/
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260911041521.2433222-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 63e2bc9f329ed..d5a8428778e36 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7659,9 +7659,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
-	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
-		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
-			mdname(mddev), mddev->raid_disks);
+	if ((mddev->new_level != 6 && mddev->raid_disks < 2) ||
+	    (mddev->new_level == 6 && mddev->raid_disks < 4)) {
+		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
+			mdname(mddev), mddev->raid_disks,
+			mddev->new_level == 6 ? 4 : 2);
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
2.53.0



