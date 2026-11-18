Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036500;
	b=tp3x/SDOM6O9zuvNXpa43YP55VafG9EI7MmDauk2l8jPoDXL7n6C4KtkSMbKEvc6xLaj
	 sQGFWHk1jEr3cR54wjx9fxGhVNui7kmiQGiV6MT0SEVgEWchxPCRQUdJSuXrEcA1CF/+4
	 dx2QrZiqIPv2Ke8IDylZZtYJPU41EFVw0cji8KXFmf6aDayMIVKphO3fRltxzcj93IpBC
	 W4ILXHy1HB8oe3OMJnr32sgE14dfVZQrHAUla6vrD3W0a2oN4zTr89hKCrcs6dSof0hpx
	 qUextkmgankko8qKUBANUceHqopXVn1ytOOpKSZDNMRrf9eEbki5CJstLKiFIjhC6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eDPMYB21FoGv6dLyjD3bt66GDKrVkSBFVw+llaWW73o=;
	b=cU6DLTUDBdw9ljy2O8Y1ggdeBJcJw5TJjM14dMCDV9sLc12S9VukIlvteMAiFHSeLL9b
	 2TQ0mN/79+pls7iGR3RPoNLeizJKMud4F3eANQ9fCuIpUQf0aVJWrOyW+nwIsWDDXf90T
	 WrEdxBpfWzJkksuKzDkA9Z617MoH+WSfgjGSaKcqCQAv1DiFiDMLu7AiwT9D7sIm2dej3
	 ZK7f0p9nChLb1Eyk8VeBO6oGIcQHANa175QNjqdaoqxkuA4jdnhuS0Ct3m5yHkz3wfYgw
	 YWZHupEDtRedq6AKKI2TwKyb7z2cz9fxew+EHDO4//IDjUHBYouX2gTmTfC7OiHZzOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiXpyWHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DE5606A32C;
	Wed, 18 Nov 2026 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HiXpyWHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA01F000C4;
	Wed, 18 Nov 2026 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036500;
	bh=eDPMYB21FoGv6dLyjD3bt66GDKrVkSBFVw+llaWW73o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiXpyWHWYNct9R6ZRvAddaG1NAiBMeFBlEj3cdv7WMCBj+K0vQdsNToZ4xrv0KFCM
	 kh76w29YCLmfwpYCN8IEmV1xLsBnxyNMECtzThfWq/TtkH1QXcg+NLAk+XhlNwdc8E
	 iHEU3y0hVGOKVwSX9WV1ZgKudSrQACO6EPp1xplE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1082/3318] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:28:24 +0100
Message-ID: <20261118150352.431436887@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 81ae1f9a6c850efab3e5dec6b7c9aa5c587f92b7 ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently ssd1307fb_probe() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 219160aa6e9cc..e4dbdc3a78008 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -771,7 +771,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
-	fb_deferred_io_init(info);
+	ret = fb_deferred_io_init(info);
+	if (ret) {
+		dev_err(dev, "failed to init fb deferred io: %d\n", ret);
+		goto fb_defio_error;
+	}
 
 	i2c_set_clientdata(client, info);
 
-- 
2.53.0



