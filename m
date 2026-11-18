Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052339;
	b=OzONF7KtOz4jtz3b65AFORfXoFw5rtZ50GSUl/a01x/2mZoOBimSd0COxLOHDejrajbq
	 QIv0HEciI7/B4XLp9D0LrRHAaAhyoPYTqWoAjuLBpIe7x/K0U1v+uRhNVzbfR3knqMOSw
	 i8587dwhzNrEl7rs039q6gLj8Ox7gH63C/gZ4c6W4zjOhErCXboTS6hr6J0OCmq2vm1xf
	 Ye6BrPif7wqLz62W19BRh9xHJ0bsAYHFGnwsrBIuQimkIRNmkp8Rm/xqP8zJ/3S9HUUGl
	 WwTIQX/0nPP26JJ3LUSUTNrKmoVn8CLTsZRwrsuHyP3VQtiYHZZRXr/4Thgw1en294w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YG3tf819J0pLygazbTK3+P35QvcyA7H3d3qBZjlZebk=;
	b=TvXgiB/QzUQTXwezwxC6Sg8iWr0ATN+DpMONSrzQvN6W/Aac3Szf+BzNnGPiG24te/e7
	 FxzW/SL7cx3QfgQ0TIijGz1qVLS74RfYrAa3tARG9vZs+LxJEq1IoA+kEs2oKfmIb9pbc
	 cTuxQ3dr1qK6MClwoHaaKGTqXgcQmihUDsJjl64LJ/0R7xBEtsKvgXVaV5/g1r9owWMg8
	 SNclV6qtScnLBJkqhbuBILxO9cNO/465QQYF8Ulka/8G0kvziAZjQ4jM5kgxqaYy765U3
	 PNKs2kH0j4Au/bO5ZRYF9NLiJdAbBISJOGyv8IT+RzxPsGYCNdGJ1optjq9IN3VdVqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5Go50u1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46C60A2630;
	Thu, 19 Nov 2026 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5Go50u1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3341F0092B;
	Thu, 19 Nov 2026 01:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052338;
	bh=YG3tf819J0pLygazbTK3+P35QvcyA7H3d3qBZjlZebk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5Go50u1hzRbK6Q5xc71WjKgki5DM33cscE7M0N3TG6a/JhUEVUdg7IhDEWbIkbTh
	 Lt8tdvnPS+U8Wh+3YUCadJVh73jUT1ZwdYqIJUy7LsrOx0ds7ngugNTus8Mpw8AvfE
	 ZgW19Ok7C8Oa3rxojvdBQ8HqbMh77na0rgE++ojM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0468/2214] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Wed, 18 Nov 2026 15:35:44 +0100
Message-ID: <20261118150029.921440282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f3042bc5a6230..149a2d358750b 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -551,6 +551,8 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 
 	mutex_destroy(&dvb->feed_lock);
 
+	vidtv_stop_streaming(dvb);
+
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
 		dvb_frontend_detach(dvb->fe[i]);
-- 
2.53.0



