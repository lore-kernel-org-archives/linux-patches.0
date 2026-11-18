Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054591;
	b=vpTOrgE4n7fCJ4z84Bv/jwHkPWlMCisS8y95aUafAjbBlmekC/9pzXnYxmVqzaKid8ap
	 Ldlrpr/Fv+JJH1sejv8u74cM69oZ92jzQRx2KEWGukoh8UiL8M5zJ4zQ2h6sUjHW2RNm0
	 f5kGK2FtPUmBI7j4ZXOUL2tvs1sn5f2aewu4QYsVXPdBpaUKVADl+Dgd0jzLXAoF0mct7
	 PvJ19I7D7roUNT18D+jELW/FOoacdzyarIDbi/PB46AIUeIXArbJBLlEpkOQqhnzEIf31
	 ZG3jIs4CMKUCyyenlfj5U/HtZ7teyD/bpti9huPvaWHVP0OuIe12guAA7kR3AkPHt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=r4sYRoESaiRBXegoZ0b6VDtAWhjfJgu8ft4hbUcdtU4=;
	b=rX5xpnwsDM7bmxGNmC8K0clMEfi556mzTSUHnrmipeTBk6E/RVz7gWu5m1IWfHEvKrby
	 1yxWXRkpWhPA8sBB1Y2SiS9vOwKAWA1ykg/nfx+8F4FrysGeMsUBidKKowefRRyosWAaG
	 6UV4++5cSBT+4la1C8+HeBYWoI+OTQ5XX5FED5XwDyOG0fUNTYVNcIzihACDRk7q+f0bK
	 Z2WGx4Mg6CB1SbCR4gQdLBKayt6J5Bqi5puBA89KG9/7FzgKR7Bo2MkVyzHvFrx0UjoPn
	 SABd/9YMCGAU0GUjb7xrhX16fPDuZfpkmS8xgpJ7f5EezpOIuOXk5Mdl2Tn6OqTE3UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpcseIJE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640EE606A32F;
	Thu, 19 Nov 2026 02:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpcseIJE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB5F1F000C4;
	Thu, 19 Nov 2026 02:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054591;
	bh=r4sYRoESaiRBXegoZ0b6VDtAWhjfJgu8ft4hbUcdtU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpcseIJE8tIwPrOUo44cXae2BfDOBa3YV7DC7rriiteTkv+s2iEawjX+FpLT0sPU3
	 BJAABhZUMTkT7GtSq5uG1YXUmuG2vGp4OjmDHBUAGLsbj1S5Y3i5QFDlJeOMMUDGZz
	 WJFwA7/iQ9uxCzAFoVnbHM76s4k9LS8MPcoekKjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1327/2214] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118150104.512231982@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index be36dd060a2b4..91692fdd00009 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -69,7 +69,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



