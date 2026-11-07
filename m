Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064699;
	b=XhyVRqpQeJVHvjw0aJs/UPrsSUO24cF6VENWeCJ4ACSqgYxtQTnZ3h/PMZ6fK3o5kdaF
	 LzV+adIkO6uJ6PrsgCD3V1JfjW2wT6oklTwuI/YI4VtrDTNR/gRxQpyCewn6u5Co3a9DO
	 1Q4OI/MmmQOS1Q4iv3UMlA9kRwiSdFt2acxlulmdsIdCOMpO9GVYGjXZLa4V2yBd4pYUY
	 /zyMLPAFuF7QYY3x4wrg61bPBJSdYLbVWiq2IZAfOp6Fqb326SxoYoA2Ek34twGSbAmQG
	 eP5xOkwIBvGgsM6UzA/2rc+q5zQf23hgjETrk+hQet9sGVbnafywX9d7NGj/VDqWnQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0sDQpG7/uNVDfesNCek0/+SC2TuxRtOyGv1A/rskwIc=;
	b=qiWuA9s2h514vZh283Pl6iDGQRaiIYGziJUBHSALH9NNtFBM+MPgtiTFs/B+YX5VILCA
	 oLXyK1fP7aBIrq6G7yeP2FPEHDzHZhbkgJt/2i1Es96AqlkG12T1PiIq8P+E6d2izC5TB
	 0MAfQKrAaYLOTlYzYPV8SNJHWIxD/K0HDlRvpS4vDgBn0NH8l9UOG3ZY4sqoCfM85symN
	 kWC2VZ7f8biIH+5jNP0iOBuMz8qjTTvGW1KhPGuILrHzuWimNmAfW8c8sI59r1r2mLCOr
	 BLrumrJdqVdpBi/5dzaSkaUWTGXxEvSmspkRBhSpGPl2Az+RN33BT5+JNYApkAdwHHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgjLH9lj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C8C606B8A6;
	Sat,  7 Nov 2026 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgjLH9lj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7901F0089F;
	Sat,  7 Nov 2026 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064699;
	bh=0sDQpG7/uNVDfesNCek0/+SC2TuxRtOyGv1A/rskwIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgjLH9ljmNuD1TKH3KITM8VMuKr34wl8N7o8ywKOzRl3DsN8slOPbL06GP4qTxA6b
	 VOlPkyPm/Noe69ayJ2sLTEttINKpiIiYBY/h/xBp37xsbPAwXxHhUES33M43sQZe1B
	 6NpikkYIvcdIN4dFeWQjebm8pOsYNs6NpGVcz8ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0689/1257] fbdev: nvidia: Release write-combining handle on probe failure
Date: Sat,  7 Nov 2026 08:49:45 -0500
Message-ID: <20261107134958.295544022@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 8710af6a35201a6d01b5af8f7e4bad29cc40467f ]

Failures in nvidia_set_fbinfo() or register_framebuffer() leave the handle
from arch_phys_wc_add() allocated. Release it in the shared error path,
as nvidiafb_remove() already does on normal removal.

The missing cleanup was already present in the initial Git import,
when the driver used mtrr_add() directly.

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
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 4ef7a5ba43cc4..395f5d0455fa4 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1423,6 +1423,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
-- 
2.53.0



