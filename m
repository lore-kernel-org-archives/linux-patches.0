Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023748;
	b=Sw/khHK9MaHmA6/BIhQ+k1oWN2LdeHax8bOIHSepB8airc0WSfpK/zYZtWaMD1VV1VyR
	 SddNXg/Dt0YYjTCIPkcr0ygaZPuN6Nd+dEC1DzeYFQF179ZzthKLS4ZWsVy8Dwmi+Jk/d
	 nkNFpokKScqEzkAjWfSjn9na6x7y6aNf6PBIOHuPCKooMmedv2MEmDgZI781yKweDpU67
	 czeALZE6suuRfEXSaATRFx52I+cbGjJuuiN6isWGjOqYSTAEgxoMxvkUFEiOmtTTRZAT+
	 6+dp2ibcWhJ5pUGfWw8UqFi/SJdz/MC0YyUfB7chPXYFYzM2aDc6vy/+RHYLjeBQ8Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKEE7ceJrXmJdAaIW2Hgb/x/m69GjcNVylsWRl2DpEI=;
	b=Newh5iiZ1JauJP+rly3FKpegSOwWP2Le3VDTATeK4M9poFxEamD1Gw1XWVqd8pECh3wI
	 2qKXTBLdAIaKdTei9LkFyPdh/Zym6P+fDTCs60CL8o42d4D7tp1SJS+vj0uQloOG3FRsb
	 6VHARKeBgCeo8X9p4EQWQWLxuit8/Y2aJxODRFPnk+lN6MEJ1tEzLnXBVcNWQFdpJgqJB
	 /4dXXSLXjvt9UXcPpaNwgWDZH1umTafwhF1z5l9z+kBOcghw8PmGIBYDn451QeiVPPc3z
	 aUZ9bfCqnF0wxxBxre6YfqIemSva/IUpIR4iMGO7kKMJyF8V/VYEsyTAvkOy/ExAG6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRty9DfM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C616C606A31C;
	Wed, 18 Nov 2026 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRty9DfM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DD51F000C4;
	Wed, 18 Nov 2026 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023748;
	bh=HKEE7ceJrXmJdAaIW2Hgb/x/m69GjcNVylsWRl2DpEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRty9DfMJzFcxuvFr1OWsrxtY6TTMlPnM9hxaHoOiCgwIuy7kbtkqW0vlPPIggbCK
	 wC5K5KhYDD7DhI9sOpNMngeiA78Nn5BRooy4R9RZ1COjfNGA+e6JUn41V7pmoX7yFQ
	 AlRjY4ZflJqr91YVmnUg4CDqxc0rfX2BEq9I2pbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0481/2151] md/raid5: reject raid4/5 arrays with too few disks
Date: Wed, 18 Nov 2026 15:36:56 +0100
Message-ID: <20261118150139.572898769@linuxfoundation.org>
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
index 8e4b5532c22f7..6f71c0c3dfd74 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7509,9 +7509,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
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



