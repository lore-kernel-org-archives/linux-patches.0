Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062000;
	b=oG3Wi7yfp2T5BiZYgLSPtf5lFKF+BrrXpowIL82Z8peag9ToBzAtIZ492fOE966AS65p
	 Gb99ZXjtIMFDe0N/e2qu1AW05jvqTcqqwdIXYd2/GgaSviehka3DS3Aoky9253xjIFycO
	 0f6Ulc0Jdy3gjm4gva+fAzlge3bTqhnpWPV+YEzyrcHawdrZYEjyDaNraEpBfRL4wbt6Q
	 eBsOfEReDhVwIjF1Kulx7k51i1HgG/qboWwjjA1FxU4oEpcnA+v8Q4MttgvBOT2dTQJEW
	 kkbhthRzuAW8svjXjP20tAavCP58J/HIymcj9eNSAtF5AdZZimxd7n3H7cawJqqTKKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wl6nQypwpg7JnuLValALvwXNWgEV1xFoirFhiOcypJY=;
	b=YGl3fEVYFn9CALQ1RziTmjDgPgjEar8SncBBtlgvWriDSk2GPqmf9pQZ58MDIvtQ6cey
	 L6A6fyLEHueUQDIXvmgTg5E7sbGasVzpc+FG5CL37lZkc/h7cztQJZgZF9GbxUzMIVW1f
	 +T+8vZQHfT1559rrY1M+ylPbog+tQCtTaPxsxTSbPrDUGJQA/NrpDPDMEoD+LdvM/sWEB
	 JFhBhcI/QdPGI9pCtTAih0IBz9ylEVexF9XVhmpnsODtPxp0hBwm0FCQf0ArA3ox56CLs
	 FBF5MhQOFVfgBLy5CUfNWpn6Z2Tdygce15D4Hc1p0NXfIyZGodHGWj57l9iiFY+1J4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMz0w1tg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5141606A332;
	Sat,  7 Nov 2026 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMz0w1tg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7246B1F0089F;
	Sat,  7 Nov 2026 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061999;
	bh=wl6nQypwpg7JnuLValALvwXNWgEV1xFoirFhiOcypJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMz0w1tghTil1LACp4y4I5PsH+r2tOmGMsSNJO6wCuEnCww/Q+LfUC6zd5F/s8fyk
	 kgtq6JYJTL8o2PS2jVV1HPTWtEOiQi24hyMPi0RRYhwCiC1L1lHiLvql5ekGkAEnd3
	 oa1TIO1+k6pQnGt2go6ZYKfAwkuMbVGcjT0OH4lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0952/1536] media: microchip-isc: fix PM runtime leak in AWB work handler
Date: Sat,  7 Nov 2026 08:49:28 -0500
Message-ID: <20261107135024.394430583@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 21ad8225822a892c4c273bf1368d477a83a19dbb ]

Early return when streaming stops skips pm_runtime_put_sync(),
leaking the reference and preventing runtime suspend.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index bd58d65a7c273..97cd1f74ff2b9 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1434,7 +1434,7 @@ static void isc_awb_work(struct work_struct *w)
 	/* streaming is not active anymore */
 	if (isc->stop) {
 		mutex_unlock(&isc->awb_mutex);
-		return;
+		goto out_pm_put;
 	}
 
 	isc_update_profile(isc);
@@ -1445,6 +1445,7 @@ static void isc_awb_work(struct work_struct *w)
 	if (ctrls->awb)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
 
+out_pm_put:
 	pm_runtime_put_sync(isc->dev);
 }
 
-- 
2.53.0



