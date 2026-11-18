Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035702;
	b=vy3zKGym4c4ibjCBvVGCfLtb+4y1Jv2L/3zfX3D71N8rNP4rZiIT5DvESZuR2DQWUJnT
	 xMw2j4zTQE9TPr0+aQH2osOMi1Ki8Xaw42cEuDVKCCOYxKabWg+wDDT1IsGRi7IWHwbku
	 Xz2v6uN8Pho/jP/H/BLsOIXtZeWFPufU8qtKmYzQAJ0jRt3UL8Qf9szneVSCZzU2BSRwJ
	 8cgFmJ9irmcwXs3rPsUeXid37SR5ILe3OFFx0+3cbD8ZObcowfkkLPAWnjKl7nJb3HtqU
	 g+7fRbQqob1Hj26OeueEOfgj89UvcjZNMG60a4VIFpV1YFl9VrNL5tQQnCMpPBgNLJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mn2N1ntwYae81FBgw/9s+4ph9ZlgnuDx3gs/hgBwAZs=;
	b=z95Oc05h29DeN0pU2Nht2ZFDM1Pv3puCk69U5jyGLy5r9olj6tlH38jNLPbUX0s9y8jU
	 j+XLFA/GzmifsL2cvrNSl8yGoHSBvfCDcqO4qy3dmkX6aHBrcjPVxGVqYuuI2SPx3yCHm
	 B+AIiLbKTPaPQA8eQcVBg1Hr43gORRxTs0Mgw1hBhxQ0JsuMmTIk89Ge7lHHqDZylyRJj
	 YAtPi+nyokRXSd/iPGT7w+IZY5eSldX2gl+TtQuaVZP+MnNTE6c0fWNz1EDsu6x9Ocvnp
	 zE3ZLb6HQiuoEutezWMU8O5y1bR5W/QNwWA43F/vVMttsPChVECGraGQVvMA9V69lVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBbOtiX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51C960A2602;
	Wed, 18 Nov 2026 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBbOtiX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A41F000C4;
	Wed, 18 Nov 2026 21:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035702;
	bh=mn2N1ntwYae81FBgw/9s+4ph9ZlgnuDx3gs/hgBwAZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBbOtiX5fp4mXILGbnelXYkKGPZV9QMGdu+YMhVcglE3AOaSkbq/yAjc7jLl5stem
	 eP68jBQ6dDRoJxSjY6MIIxePjU0FyCck262Nyg++8ZFYpH6OPWuqm2e1G2BnOVVSpK
	 70JE2iE/zlTGwXROtmCDZy/N47FSEe01/EozHE6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0798/3318] media: streamzap: Add missing rc_unregister_device()
Date: Wed, 18 Nov 2026 15:23:40 +0100
Message-ID: <20261118150342.852209499@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]

If usb_submit_urb() fails during probe, then the error path is missing a
call to rc_unregister_device(), which will leak various things like the
input device.

Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 8c85b9f30a3a9..e91cf2ffbc876 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -365,6 +365,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



