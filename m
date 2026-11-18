Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055603;
	b=FU0m5GalpR4G240IP/26BSws6M0P18Z0Shr7a26k0k2zUvCkQdq8j+Ut+yz5xAh9/goY
	 bS0XP/mdtJDdY32dZbPzPqmONFVp17eDeDs/QHfpfE8/xvfI4rjSfyxll/Bsd91wdNan4
	 tQsX2Ahj60XwUyRxItV+7aj1eF8S8u4+rSBhZf3VDvbiS9pU9Jzks5KM2/cc/wlJtd/AJ
	 d5z3e547REvZsBx2hwd4B4YCzuVm2hvLgzxt8PdHlvjxZK3n8fF5ZHGL+wCHYHDqx5Am5
	 EIJyDq16/yOO0J/6gBg20/P7ik98hzCcarLw5MPzEcUgQhEmil1DyqzIJVbdajbQgkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zubY1dhQr9jJmbdj/wHq4/aa9HV0IxQJrwHzlamWL7A=;
	b=YpNFAd1wqmWbgcm7/SjFaNNyAVnYPcyzWlepR8WG4ABkpTtUB+RK1WHziU1YwMhqlH67
	 44fC36clL1qwud1NiTJDimFZayhNwbIsNAzPX3FfKTIfMmqqUzm1QBmCsdRvyT92Gc7IY
	 76nreiHrVcw27craL8WtvXrZcwyrzbuIxNWmsQVb1CTAZGewEmA3dHHkNepQgGWMiRB9u
	 Utqy/BRGPt5b2ZT6oPtjhc7HS98t+A881QyQUUvSqisfRMfadwcWYPmv0OQOG/fWJah+A
	 6ieXSAPd5QEBR1HFfTLDNzMesulHAoiwBtM6x35b8cgM4InJp8kxccgPtGQBvEslSOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SM69Mf4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC8B606A33B;
	Thu, 19 Nov 2026 02:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SM69Mf4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305CB1F000C7;
	Thu, 19 Nov 2026 02:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055602;
	bh=zubY1dhQr9jJmbdj/wHq4/aa9HV0IxQJrwHzlamWL7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SM69Mf4Kk4rqh6OX5bFN//ALbykf8ivEKK+uwH1I/onIpiQrvezYN574XGvWkgLoI
	 8bfq+Bt+UySINMTYc2Bhc4333SD9RqeOxr/fXur3+xiTew3S8Wok4DBoaXY9IgALtI
	 /vVBRTOjnMZ6xnvmmSRlEQvDcL4hBD4ZO1B6BRXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1691/2214] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150119.473335528@linuxfoundation.org>
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

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit b7c885194b81a0376d1fdb457eac40d21d6fb65f ]

The cmap is allocated by lynxfb_set_fbinfo() but never freed, so it is
leaked when the framebuffer is torn down.  This happens on every unbind,
and on the register_framebuffer() error path in
sm750fb_framebuffer_alloc().

Add a lynxfb_unset_fbinfo() cleanup counterpart to lynxfb_set_fbinfo()
which deallocates the cmap, and call it on teardown.  In the alloc error
path it is only called once lynxfb_set_fbinfo() has succeeded, so the
cmap is only freed when it was actually allocated.

Fixes: 81dee67e215b ("staging: sm750fb: add sm750 to staging")
Suggested-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Link: https://patch.msgid.link/20260922142851.46724-1-2000.costalucas@gmail.com
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index c92db34b2ad6d..f8841032a3ae6 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -865,6 +865,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 	return ret;
 }
 
+static void lynxfb_unset_fbinfo(struct fb_info *info)
+{
+	fb_dealloc_cmap(&info->cmap);
+}
+
 /*	chip specific g_option configuration routine */
 static void sm750fb_setup(struct sm750_dev *sm750_dev, char *src)
 {
@@ -951,6 +956,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -977,12 +983,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
 	err = register_framebuffer(fb_info);
 	if (err < 0)
-		goto release_fb;
+		goto unset_fb;
 
 	sm750_dev->fb_count++;
 
 	return 0;
 
+unset_fb:
+	lynxfb_unset_fbinfo(fb_info);
 release_fb:
 	framebuffer_release(fb_info);
 	return err;
-- 
2.53.0



