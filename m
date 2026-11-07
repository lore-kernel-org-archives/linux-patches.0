Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061943;
	b=A29eFNfpwfaqu8lmsxpO6h0jDxbqH/jiKXp95BYWirYegGj51psVejRRn0XIkSD1fcMF
	 nFFuiW7GqbtXOEDe2kZ1kzNtnQdGZIDckIEVBYYie0tcmyqHuu0n89FRgNNkqsWIaUof+
	 T3hpcC5vras4R97O83eoz2IFUWDm+LuuPhsO2zSs7IypI7OlPIAngrbuimQ1tAhr8GVg8
	 f7tFI3iVXTHs1xSTum512R6g6aBbk5vGig0nnxrzwgm0rbPdFr/yex3++KKZWxGlCVPjU
	 vANRiHbAl8m/xV+vrDeRU/h7aDc2G3wPvAzfwSdiHwCZiyTSsv2VygK6ZdA/JM3sS0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90pxFOE05kirlsQEA9n3e3H2eJcf3xKBP9/bEooWDWQ=;
	b=oBEGvp37XW2of7WLA8wQKas/iWoyfHrax7/3Yq4gns/tepr/F0MtswK4l15lzN0qUFoi
	 g2DVEtH//oM7rDPKbo+0WFr06xdBHv6jVlCP/ncbGNZrrgOmEmWtSafPgiZV7pa5Tbvv2
	 ZqAy74ghUJ7lp9SjDScflaUGVaSvqHH6CntNLBjh6E3pCmlMDL929hIX0N5yLYAJ0GDG9
	 2+h+PkkKdjsUbr2VgDT3P78yGn1jgj49X/NjULZXKxtLq+ZROaiCErB20WKNTnOCGvRG7
	 ALa6SykfEoQ4fPINE577JoCtOec5AP5c8Dc1ACpmvN7PUuQ7o+SVdFbZclqtnJmPSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx3S2oa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE87606A326;
	Sat,  7 Nov 2026 14:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yx3S2oa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441161F0089F;
	Sat,  7 Nov 2026 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061942;
	bh=90pxFOE05kirlsQEA9n3e3H2eJcf3xKBP9/bEooWDWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yx3S2oa5LrY0xKhr9BFrdxqd2DPrjObrqj+qnOx7xHSGj8ejXGKeGERG5Nvbw36OJ
	 76UfrjJt3sn7AZtitpbOGmQU6Eq3iq7quZy5dH/Iycn+YpvhqT3+snBSuecmPhT7s4
	 43Zx+YfLiIrOc99+TRWyjEbjiD6Ka/LWBPJBXCpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0942/1536] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Sat,  7 Nov 2026 08:49:18 -0500
Message-ID: <20261107135024.110706902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 2af02ccd048b77713695d7817cf645ca50bf349e ]

Attempting to unbind a dvbdevice that is in the process of feeding
data causes a UAF as we free the underlying device without
stopping the feed first. Fix this by stopping the stream first using
vidtv_stop_streaming(). However, our codepath in the reproducer
(mentioned in the below reply) does not decrement our users
(dmxdev->dvr_dvbdev->users) to 1 after it has been incremented to 2
by our read() in the reproducer, that is only possible on .release.
This can cause a task hang as dvb_dmxdev_release() uses wait_event()
in the wait_queue unless we use a close(fd)(in the reproducer).
Is this a problem? Please advise.

Reported-by: syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c7fc4794e59786f5b4dc
Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index 03982fedf4579..a1e638b599c6b 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -551,6 +551,8 @@ static void vidtv_bridge_remove(struct platform_device *pdev)
 
 	mutex_destroy(&dvb->feed_lock);
 
+	vidtv_stop_streaming(dvb);
+
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
 		dvb_frontend_detach(dvb->fe[i]);
-- 
2.53.0



