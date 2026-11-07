Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063312;
	b=X/IDq2DUZuMRusrSmedle/ZcSBhjjuEYzz2oM4oJC7ok/AyNl90jnpzofyIj+el3XfU3
	 6WYJcIuyiIvN8ZdNVNKRqHuaYXh9jYkTo3t+2VH0tlh6KmfcgjVf6VPaLFuNeLxBRlo7b
	 Yx95M4mMKDgxqD5all0rcdH5mb0e0pzFUR38SDNoUcrGZjDiJzZQXzTPuQ5CAbqfSm6dH
	 wWFtWYasb9Wr3u9B22ftuUAN+zDQA/ftNIau+vcDPjJ/J3I0EiBowWYaMHzshYfauGblX
	 ypUXgGAHaYLlWKqoH/Vt/BlbbZ5AYQ8/ZDxbtjcvXOuAvgRqDejG6ZJDzgmYt45PhuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y5+p5TqpPIVrA2iyZsmLHBsEvmeYDgg7xOvs/lqTTBc=;
	b=AKbiv75Gth9nK0tAzw5JzvA/jT7jbDk6BBJ+yGzjrHECyB2ik3NFRFoWyrg2w9G9Ng3n
	 mpoQSSfMUszo4lCDlzirpLPoJBCIoXFS6huuNaoRVurC4D7z3w46gRougcaWG8R1JVhAm
	 rqUE/7Ot88GEoAu9+MfilJJieI6sBo+u+KMgMaYpDObV5ju1ErQQytiXXe4Ah5r2Y6Yqx
	 Ck/OqOI1shQ3OFgjzqGQ9qLzaR0duajkkNipRzjUKuR3VvTxbXI2Y3JJLzp7bhmgPjHkb
	 gz+YVt0zqHTGi/PvIy6CHnUMoeEtlKvNb3qb+ElWTsmsAzTRrFKFZDbAwzQ2kWLHNBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwBlzUk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A1606A32C;
	Sat,  7 Nov 2026 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwBlzUk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B081F0089F;
	Sat,  7 Nov 2026 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063312;
	bh=y5+p5TqpPIVrA2iyZsmLHBsEvmeYDgg7xOvs/lqTTBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwBlzUk8XPlznEMzbeg6af5ncKJY1KQVWnr1G78CLbAMJO5gp5VsPoooQH4SlhYus
	 Eq5uhuoZBuoPAGG97C2LljujSc7NSC/ZeS6RdRdiF9W83i0cf3QV14l38MgmEScl99
	 RjfQVcwlacTEDRiwr2l0iTdm93cStVvlzgnuujWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/869] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:53:02 -0500
Message-ID: <20261107134910.586904890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0df3ac694f4e0..e4559312a9265 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -763,7 +763,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
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



