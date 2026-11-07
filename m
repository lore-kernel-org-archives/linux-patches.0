Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064690;
	b=AJc/dil4j6gQYOw9eQSDm2dCs84XpQEE0YG2URMzBIm3rQy77MukE0RFBWx8698grpW0
	 jmoJ5x+J16WDK3oCkWlAEmttT/LTuSsAMsfef/5gNwQYrv3P786gTIhyRd3iQVkBE2EJy
	 5CUX4328s9CSmfGwgNYP65eZOSc7D2fTjoAM9MalgjTwkgGOsuG++IBN0VKY2YBCHawyz
	 B6Qcbveo2gBN+Sh2KtpTiHRpdgp0vXnD+Ei3sJI0usovAkonAS3+/T34pPNSmxhsYUB3t
	 nSgXEWRooo3CBetp8r0/WJ71NaYwvDrdd7M4gJqTIwxCDNf5bOar6oQ7S43QTycZF+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7L3JUI8Kyx8AjJcbamRZtbP5HpLTtmmQZAsFsMi/m70=;
	b=fjl0E2NI++4S0nvZ4oKDSRnJLFwvEogKxiOFdwAmhauEUoGkKBCtcrifkQq8S2Ed+HhM
	 y4z2eIBeNwCtUpt10uB66Xtk9F4XQq7UMOAVr4B2z5n49T7uUz5yYiP/Yow5UtPm4/n6R
	 x1nQEO9Z9wQMxZwQGtM6gGbM2syrjz4SfonKp/VqgrmvlzCB7WLjTFvsJzrskEcjYk9tv
	 IXw7lxYapNjM5NsL3Gcs0SsPG33RX8yZ6C6wVZhbXpQSj0jc3krEdgdr64i3x/Kv0aT/w
	 JDrWv1esEMoyKDX16lPt+NDNWgwUuGpyT/Z8ZGbAkrJXX1u+BfW97rU+WLkoQ1EoTNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEZR0bhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0D1606B8AE;
	Sat,  7 Nov 2026 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEZR0bhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936A31F0089F;
	Sat,  7 Nov 2026 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064690;
	bh=7L3JUI8Kyx8AjJcbamRZtbP5HpLTtmmQZAsFsMi/m70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEZR0bhgfWMLdg6wMr9oNyscqDvEQdt2q3t37EGmSG3qEREkejcp9kuv/wVtFJZiB
	 hO8jamPSoQg6tqu/1LKPPnUxws7Z/mJOWvAKmY9O4b+HHeqh7nbYnQwww3vrtHAtfL
	 1dZNjdzTR42EGdpyAp1rJCChlNLbs/sBwupg8oZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0683/1257] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:49:39 -0500
Message-ID: <20261107134958.131925111@linuxfoundation.org>
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
index 4d185c7542843..8fd96c37ee1ab 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -767,7 +767,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
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



