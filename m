Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033805;
	b=LovzVKxaIcmrdxR0x6Q9Php/WA0dE1XkoIZ8OvV49v3C8ssAM4TswpgK8+KDUWzoIZ5+
	 /JWD/BgpdGdoZoC/6pCq70CO0q91ZAjpszgSMY9CMprA2BnxyUM3H9Ke1otfIUXOFjCiD
	 D5sVv/ul10d1WLmAc91tYbb128lJKSHhdFKXIsrpv6jMYasmqT8PWxSshHx6V8DYhK99C
	 UDQ0wonD2Hoa2tARi2x42cevlxn4cOD+ZEmd9GII3YfQFghbZ2JbhrxyCuhc86w421vRh
	 WsQoaGFjcs0oHQUpLMoPlzceMoF0/M8SuZtu6ih5ifk23o23vkhV1hWEpriXwnciRVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VraiaG0OJFT3pJJ/svkdZDnmv9Y9i77iQX3Ds8dd9DY=;
	b=460KvqiCMURRzaWiur3m+akffrXzmSYa8e8Jfbissr1ODb9ninc0GWL3eCrnhY0oMuhs
	 oEMP+xr8OwyZwx/arURvyf1ebTI7/3861TNZQ2Pc2MacN+sNZXQw19laE1iumrmygTXcV
	 Ie2A/om3jXylFkqwzToBW8Qnsp6FkURbG1CgautsKP5C3O7ugLWTNWwWjefJuu0RibCyI
	 TzhsmdY5KrXRpxvpCNc63z3nwuOhM1OQWJS60328pap1Xb9l7Bq/tUp0YRXZTvpCWl4ZD
	 WevJ16ZhV1CnzorbtHfx1j7/FnMBSJEMqpg+rIBZf1dPuCeBQol1Bl1sAlUCiWuoYmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nphQiqCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F0606A325;
	Wed, 18 Nov 2026 20:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nphQiqCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC711F000C4;
	Wed, 18 Nov 2026 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033805;
	bh=VraiaG0OJFT3pJJ/svkdZDnmv9Y9i77iQX3Ds8dd9DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nphQiqCywFGgdmB1M3NCL7pYfU/TpFaJT+4P7mztjSYVXSluSlT8NoxGgFRiDShLa
	 Vteamr47NIyj6eKwmRAOQ0EDfXcoi3BvmbW3KB0uLfkRZaretS3Wq4oaBLyaPLWIsD
	 gcHwuZFvWHbGWqplSEaC1yeUvxSIIIdEE7S8oDPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0144/3318] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Wed, 18 Nov 2026 15:12:46 +0100
Message-ID: <20261118150318.796484195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rituparna Warwatkar <rwarwatkar@gmail.com>

[ Upstream commit 9fa26c971ca310dd10a3bc0014f2fc7ea7167bba ]

dvb_dmxdev_add_pid() allocates a new dmxdev_feed, links it into
filter->feed.ts and, when the filter is already running, immediately
starts the feed.

If starting the feed fails, the newly allocated feed remains on the
list. Subsequent restart and rollback paths may then operate on this
stale entry, leaving feed resources allocated and causing leaks in
drivers that allocate resources from ->start_feed() and release them
from ->stop_feed().

Remove the feed from the list and free it when
dvb_dmxdev_start_feed() fails.

Reported-by: syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9a1f5e196de6663631b
Signed-off-by: Rituparna Warwatkar <rwarwatkar@gmail.com>
Link: https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-ID: <20260714141059.63582-1-rwarwatkar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dmxdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index a67cce02d1577..93fc040cfaddf 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -870,6 +870,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -887,8 +888,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	feed->pid = pid;
 	list_add(&feed->next, &filter->feed.ts);
 
-	if (filter->state >= DMXDEV_STATE_GO)
-		return dvb_dmxdev_start_feed(dmxdev, filter, feed);
+	if (filter->state >= DMXDEV_STATE_GO) {
+		ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
+		if (ret < 0) {
+			list_del(&feed->next);
+			kfree(feed);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-- 
2.53.0



