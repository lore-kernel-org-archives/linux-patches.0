Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052608;
	b=yGVegQzjaRxHJlFydYm/LMKvcTcoL4YK2sNLSqgchM6ohWec1jAdVRFy9GYp80xw7L2j
	 xpnVUZQ6fGsNa4m6ZZil3Mrg2SASBLDNTeHLNHa+21MGetTKCueLh2VIRf90aJime6YzR
	 ZZwFjrizfAdvBzwcx9xUCBI2LzbCnah4RKvEeDq6uyufv8VtwxULEDU3DymHVEEJM19gu
	 NrotnLRfSu0/3ia4dYlKPyq0vz7ZS+t/5joBO3RuUsm6qN37gIGaFP7AcREQZijtmMDQS
	 Eut+C7yf4ZSGdHzh7BHk6hjlg5miz1QINSMGYAwwsXq2RsIiE3LXFCV++Xlx72Cs6MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yLmQcdS4xpGm3h2EqbWpy+2+beoiI+1Ni1EEmx3wHcQ=;
	b=I8Xaj5B0Cg9VyMzQgmFzhFhNHT+wM3cnKG3mX9pjuaFMdVrUk78fX3Daqy2Eau9eb+jA
	 PMCqlFSYcwfluTW82hdLJaAZ/rdjehv1RLbRT6Uln3EhWKVHWyavkC2Y+ZW9Pd77X2NbY
	 UJDAUDGUWUNBQ7dsAlYCDS2vmPBcJJ8vn8X4Kdb5Mue8HoA6SQ7flwhYYZCT4dsOoPPR0
	 lFp5Q1J4lu6xFaD2ZXBUrFDJ/JNTXPBGPuxVDy5EElqh/9tTpeGBHgv21U1FXl2u7Q5JN
	 2HlAhrsa7t0gQpjBZP1ZggHRXdwXNLjbdGqXH4SsbJgDz7KQIFfT1oh5ae8qarK+9Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDH9QmLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148DE606A31C;
	Thu, 19 Nov 2026 01:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDH9QmLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A0D1F000C4;
	Thu, 19 Nov 2026 01:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052607;
	bh=yLmQcdS4xpGm3h2EqbWpy+2+beoiI+1Ni1EEmx3wHcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDH9QmLUSQbEpPS3PdKnbqR/Bd7LCG/PapHCBhANUhe2fkXhOx2M3fSGL2sRMnsnO
	 mpsmnspa33RSeQF9JlimEqevsf1+RiCl9rIO4c2eq62V+3r3nO6kq0O5o1/oZhNam9
	 tT6y0R4bbMI3T7cE7eknTfGDGETeQoX/b1Q8j2AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0622/2214] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118150036.265696913@linuxfoundation.org>
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
index 212494b0a4ba8..f35c097525b0d 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -753,7 +753,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
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



