Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063320;
	b=AOLdpGicG9P7sSPsFB1NpbkzjAf/7GRj0TNABMusD9no1adxpIiVp3ub7F0TLqDJOfnC
	 NQJCbgO28GCi2Qh4u2z/lo83Fy0VEERQVq+Ez3LrjmC3H/nRhrBNIPsezalyiV7YHwcM3
	 kLbbc2iXe/bixig2woXKAXbKnSkP8bQiU9dga0cYwXsI9JulDGmKE1oNWux+hY3MH56o4
	 BG/uTXJz2Ssl7O9VGxZjvvRMHvMd/tmatFgdBat2Tb7ff6NGmwu0fTws61hD/ngCjbA3s
	 XBHBX8FQ3uDff9BISra1C9mLfzmf+IT1B56lNHfmPYk9GT+kRyT8qUohZ/7ynHdg0cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PzL4mDatguTcyxG/RAhEgyZwN62jNCZ+pp5Mx72k5NI=;
	b=Qw40yk2YPgPqqavi3ROH0cpfiWNBJvD0ITHRvJmfnTZlCR7E70JkxnTdxSEhIHY2MnCB
	 d2EB63cJoPMatKbKDB8/u3n1/WSkSHOBcvEKRQRtBTZIKqXUCjd2nwdl4rWNhcsybE5Xl
	 t5plW6rPw9+8L5GQHkzgUfpxP61v2uym+a1sJGjhZU7fUivqBC1g+coKxJMW/7WKyZfgh
	 fVYsPVgn3OjVsXWUVySijMZ6FuDfsa2B3/vTwa4s/xLKmKisjL3swYY7vpqsRKRsx1ZdJ
	 HYTwh8rCpTB6JkTzPJOR5tzgHoyYQbvnzyVcsJetZi3evTNh6U2MiPdomY+8nZiI71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8ANwe0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D02606A32C;
	Sat,  7 Nov 2026 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8ANwe0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA081F0089F;
	Sat,  7 Nov 2026 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063319;
	bh=PzL4mDatguTcyxG/RAhEgyZwN62jNCZ+pp5Mx72k5NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8ANwe0GZKYJD/fwsmoWMCEFuL3YhytU4k0DUCbFYjWwStduLQ36faI+W9EadfsXV
	 PnLaZcgayyQLpiwbbqmsWz/VXfL6w6A0wz7nk9X1bZOf8nZQPnRtl45kPk4W2t/3cH
	 mxQQwEgqwtZnQMHZyADrux2xXJH4wdv1MJdlqfF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/869] fbdev: kyro: Release WC setup on registration failure
Date: Sat,  7 Nov 2026 08:53:07 -0500
Message-ID: <20261107134910.724052016@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit d3bc005a62945aec57059201092b12b7c955e5a7 ]

If register_framebuffer() fails, kyrofb_probe() frees the framebuffer
without releasing its write-combining range. Release the range before
freeing the framebuffer. Earlier failures still skip this cleanup.

The missing cleanup already exists in the initial Git import, before
the conversion from mtrr_add() to arch_phys_wc_add().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index c44d6809859e5..fc350edb41a82 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -766,7 +766,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset_io(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -777,6 +777,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



