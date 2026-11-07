Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063899;
	b=pPvHzIrlZ6UsLYiU8fJ1PB39B1ArUPkFdFmh225XJsPeCHoVN09rv1wixXhNAhz9HXvE
	 Ae5QV0MiRmclbeYrpi2WyyQbfnTwMdSWt6Gs07bOQy668jul5lRrud5xGeItl7kp6H6xC
	 gYSy+3leuQJqwwqeBVkJ8X1Uqr5C5B/MV7xVbxJenVN3QEgP8Fj3zGjC9oFik26EhJXDe
	 QcD/spJHFtihfi/gtneRboUpZkHxaFDd4IRcYpDS70fp2tDuzvONevh9fEnscajtBqRj0
	 Pu8pwIUlBWlJTJJ5ghVvSciUzUHk7SjHa2LtoY5fwe8qMasnqzibMC2+kGQPtt24kyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+rcmJTqrtOHqKw8/ci5/4frIDq2oTNp3Mc0RMzCVu8=;
	b=MbSpuix6iU77iLpd5CZXsOx0Wq4gsgBaavbLaGjKlGqKFEbuqLJPYXJJZK4aI8uVp0y3
	 YkROyNF+yeN8v4AoMwf9fFZJeuNi6SECPC69Ja8eiY/hJBkKuDikPv3g8CH2+7Um6SuxR
	 hiLcOwpqtG8JjM1c7WvePif7mdNJM2Na8SqbTbzT5Tt3zInxvh2aGWw06FTCbynqIXy6S
	 EMTLn1fBVgrN+s0bKkGu0z/nyClMMmFcywMHXr4T6XuqumHn1DBUPWwUkYP8EZD/5nfZW
	 zkvWWNV9SC5ZhwAxM1Zsjm4HlEup/krGURZcJxGqK1ppVJlIlRNe53ueoD6YnnfgTLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNvzWily;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDE606D80F;
	Sat,  7 Nov 2026 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNvzWily
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5261F008A2;
	Sat,  7 Nov 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063898;
	bh=7+rcmJTqrtOHqKw8/ci5/4frIDq2oTNp3Mc0RMzCVu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNvzWilyWpQmWzafSn5F3j4adaci5EsfOOg4PphhjJOdfJNW1KMrbt5BWe+iU5CQT
	 Lr3vr3I8SezftiY69eV7rAc3p9UZy1uDieVb+pPZ6KL2tSWNaCINmMTGRKJy2Uvaea
	 CQjaYmhzMWPwW5m+v8qJpJQJkApiabmwGV/MFgTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0100/1257] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Sat,  7 Nov 2026 08:39:56 -0500
Message-ID: <20261107134942.120777636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 9887860b01980..f951b877ada6a 100644
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



