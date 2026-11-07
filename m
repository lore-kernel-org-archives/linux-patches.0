Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062833;
	b=VheyDhmm1v8CPC6bcEiKNLnXEtuyGlFyPsiqzC7u3y+hBaLMFTZkSp+nMYUq4hGW97vn
	 QeYn2NQE/gcFZnu+7GpygKvuF8cckXy4xkV2OlY/cSLLBf5vg4+oB6yke7pMmrcbTC8mf
	 Se8G9LMzHj3xhxV8BN+/3vhJMtnC92IBw9xqpZju5O3i8joLUMd6VY08MqNl4XOaEwiD1
	 urpKh5uBXf2vTFavihlOevJZD05QoPpfFU/j8U67kxclnk/PbyqMWlwpDrginW8wG/0tC
	 RPdaHO+H7z8hoMCCDoYKKcp48oL3kVZEuOHeVknH4HCsfwDH/l2jtu44YHEwaFk+xvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UrS4zz5LB3ixmeJQbmcxW50eaMvlqXww1ujpUkqpY7o=;
	b=N3TeI0eYeuwNuKE4pBOepRAl4f2OH50QENH/BHaM2BU7SFXkYpi6PVrntFSWHyQplqa2
	 5yE+gqQVRaRyBYkTndFHpSFSqzEcfyg6DeumL9NWojb06/Mi/RHaQnotlE8Xcvv7iTYcw
	 +KsvDwupWITB6TtDquRzudK2Ic2ZZrMltXvp0jRZGB0jFkYSHChAgmQaA6UrNmFKFqMdx
	 cVouO5hYDD3jhDP5r7/hMU3LCWcy2PMjMX+AjARPkOBBtbtERyOg7RByp5woGFNtTR6t5
	 /WVcOlfomB0f4dLyQy+R4sP+9gI1TZFNwTJJvOcvp8F4WNom1HVHZapTgDjxsSNJEpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReBOlIBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53C0606A334;
	Sat,  7 Nov 2026 14:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ReBOlIBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7491F0089F;
	Sat,  7 Nov 2026 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062832;
	bh=UrS4zz5LB3ixmeJQbmcxW50eaMvlqXww1ujpUkqpY7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReBOlIBGtLKM4alcDGl8rwEWO+V2L6piZtVZYZOM6oCooR/kFtT2TSvUdYzKe/ZEm
	 oBqOyZegQ7Q8f4tIUxBVJj+tqTBvIh/J73vYVITdhY4c/FpF1Zclnh1PgpHaVxZeUT
	 UbOOLP7MQwLcBS1Avx1xZs5NfVtjmVknKHsrt964=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/869] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Sat,  7 Nov 2026 08:46:10 -0500
Message-ID: <20261107134855.715353458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d6b90290bd4dd..60310ece35302 100644
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



