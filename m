Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029680;
	b=aQ56ZN+RiC/HELHIBCCFFfSq1JLATSnIfn3dq3aT5LjEpb6Uw7FuLjuslJ0Kh4yUi5Ao
	 hdZduqFqjmLXKzk4lc+Xq711jEUV89lTHF4Aw5ST6+wVsHzBVoRBnk0NMoWiYpNDcGrpR
	 K1M6vbYTpVE2jZYb0ZLaP/8iPGYewe8NSksp8TQLHtg2d5RuFbrW45uVxNt6VUdoqEYsX
	 /BCN2ublVhHGf9gF/h/5o/UJznCJTpvritiuXH5gTApmZKCR7h682mBYoTpDEP34XDBXZ
	 0QQMb1ypSmk8zEL08eWsnus62mbfkxXJ4YJ5t4pXneJTyBcARoDvvMsqO7tUVOLEZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ro23ynrUKAdpoqNaNcUvxrVtpFbInzxzSW357Gi5wAI=;
	b=XuoVswWS1mpHUZ+6U/BnJPTdBKTMNjSYrIKWu5UOWvv4GDuEm0xzH+qdE9+9YcRSwUdN
	 vSIuCDCNZofw5lIFz++UL55aQeSQ9mpYLfAHVk1dgdNpP0Xi9KgBiBgtkHEqY3YBL1+uE
	 Goyu7JK7pUSbXCYD4UcMLLq8IF2p9zwwUlY9hdEtrtknn90QPiIH/dFPcDMHnWL8o2Fcx
	 drgtD3+rTedl8uo9k1L9Q7XXu95lMUQyFhbkkizl2hOemP9u0t/EVgzzlOyFhLHFxAgns
	 iUP/fmYuecNM++hoCilSVjPHSYlQKo4O2+RdRQkaz3QYqkRW8u1TbFKLayD819NlJxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+LefjER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22341606A331;
	Wed, 18 Nov 2026 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+LefjER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A841F000C4;
	Wed, 18 Nov 2026 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029680;
	bh=ro23ynrUKAdpoqNaNcUvxrVtpFbInzxzSW357Gi5wAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+LefjEROT20m8KSnf835RxElGpW80KtpGMC3ZfTbi+vaJPQ9LoTpXOlD3zelYVIy
	 laypRUc3oRpTV/l30oAEJBu9fGO8wdOu0TeJZ5grqI6Yjgn8v38DMKI2TqK4rwCs4v
	 GORS54H4XegYgL9p8VyvMTQ3Ri4Hmtck70ZkdIdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0437/1756] md/raid5: reject raid4/5 arrays with too few disks
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118150026.138358798@linuxfoundation.org>
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
index 399ed941ed9c2..3a4f949e95c11 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7514,9 +7514,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
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



