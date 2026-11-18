Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035939;
	b=VtNt1aWPj+R1WO3Tm+j2ygNe6EVZ7hzSl+V53m8As1h3OG+1LD/Im9LNjmnz7z0k1l/D
	 cw2fkG6yyTz6K95xR9Upkdfos2rXH4ipDT1nF659XBtMKSUBQwCFjGp6eUe1/hv+TDCwv
	 XRq8tyjD9jbYroMr7GZpI+bvFwGigJZy8Z23KKq938ogk7/avQEKyBDHfncqdoDeDvHbn
	 WpaMf+vuyGdGcg4/twnT1Qq07esueo2u3TczAnDcbixWP0vZxl0JmhIsPQDEuD8GHbsGy
	 fm8D2o9fiFsEMGrkclRqcScylQvAB4jBqVU2jUltxf1G8fWHhSyFh0pNbbfV+DseZxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2YS7XfGOS91+7TNIF4e3CUU9lpWwSk2f7S8hV6yg0M=;
	b=eMyqbFd76ScBaiVwicAOhKOlE0qNpG4TYVlXMkHUVifr9hCiCzetkSNmSKHeyqapGtWJ
	 alI/ihGvcUF/lbWubCBMTIag+rKm5ZvL2ojwip8835WELL2990QkY2v3acCmL5uRgKv1E
	 mrKW66PKTk5U3udqxPYVrowE5KZ/OsUMcKWvmvRGcA3WfTRzNlGskHN+J4y2llLIpSvtj
	 MxbeS+MklPTtnEAzIR2gSGq1LJx/X/q+Hs3q5oCgDgipzeZKPNDdDpFK7Chjwa7Fx+yU6
	 R/YJLXmqyKu1yT/mnBMqnvsX81ExX7+WdxJJBHZDX5dSqTgTlCdmKKlxv7PKPb8LbBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdjDiGqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DC606A320;
	Wed, 18 Nov 2026 21:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdjDiGqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091BB1F000C5;
	Wed, 18 Nov 2026 21:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035939;
	bh=F2YS7XfGOS91+7TNIF4e3CUU9lpWwSk2f7S8hV6yg0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdjDiGqGm8tIWIGEXYePjwYVCMcKKEIpKaxIU2Avlb7jtY999Pl+Xl/qu/bSMdgPR
	 r8qiX8jJkKrvIKKVvFf47dGXV0D96nheyy5cQwCORupAGOGdaBgMxCZJm6vLjohDqv
	 /dSPIRpNxJ5d5miYylV9tCDQbbvjO3SnjrfKyYm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0840/3318] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Wed, 18 Nov 2026 15:24:22 +0100
Message-ID: <20261118150344.370953367@linuxfoundation.org>
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
index 45242c7d7e23f..aca0cbb8f10e6 100644
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



