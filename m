Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063929;
	b=DycgDwhpTopqihxCl5TZA2kD74y1mBjJ/IafwDJpvX2Mc0S6OJqQEO0MA9Ar6Pw1LmAf
	 8Rw7dRduoUNeh7eCj4+sPD7b4PugT7Iyz9Uj42Uq3S4i4S81brYiC4JACRwl+RQo/NeXC
	 C8SNty6ARBKV3FPvHktVMJQ4zO9lrGiGxRvayq0hwXat09rAdWw9d8WNOWFLyvrkCCaeD
	 n+9rVDh7/HyKhandOADKTg86xUGikdkJa9HEn4K2jWvd5x2wZcyilPrXyoMVTVqoF7Uo2
	 emeR9UAedTT8QvifrBuCH6TqgBfrXrHCVvY423yA8DuxwF6XTj+MM3DfjGXGW42tYDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nCDc1GDp5OCovWnbnDFTq1Mi8n6GFME+4LrcaGOYhU8=;
	b=Gv4uNlE6Wm3TbU8aw/Cv8w6a1yXdHMfzCZfbTdkp7d+7z7giYkUkVAnBXzSi4JI4WLPA
	 QjcO43B9+n/RZ8XyrKQrMw5LeedpeN8KSi6UXGGZEu+Emh8XSq07qvsmv2JQXmTEB7Rq0
	 lH1g45Ose2L7CMCAjuQWDoBsSdSTi8gKxJmpqmUA1JWLitRz+qcex8c6gs5HrziqvG4ib
	 jnXC4bmRQQg4p0Vl4cGbgsln6cyUaIepzZTzfP8Qb7T3iRJjCEEG2b+2V644XXXHmjld1
	 jhi5+7lL2058eJrF9ev8chUiVWx51tMaq7598+vMvdM8sABYbWfgXMsfhcjD9JAcfwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hX0QaSEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4A9606D802;
	Sat,  7 Nov 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hX0QaSEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED7E1F0089F;
	Sat,  7 Nov 2026 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063929;
	bh=nCDc1GDp5OCovWnbnDFTq1Mi8n6GFME+4LrcaGOYhU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX0QaSEmJVAWxY1qUTpqqlQ/0VYvjJRsMqLclcLjX2f00f6CnHxG0DMRE2YCMDDML
	 bh+gGXBwKgP0xcIP0lwCJatrZIOK+5ncI9Bc3SphyNEhzlpgBBhLu8rE88JY99LPN5
	 Ek0KQvLhCfuRoCZ3r6GcACJtBNrsh8x5nOnObf0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ben Hoff <hoff.benjamin.k@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0087/1257] media: pci: hws: only init channels the device actually has
Date: Sat,  7 Nov 2026 08:39:43 -0500
Message-ID: <20261107134941.767200287@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit ad5390c35ccf98cec66ef1009351305f25b5a757 ]

hws_probe() initializes max_channels (always 4) control handlers, but
register/unregister only walk cur_max_video_ch (1 or 2 on smaller
chips). The extra handlers are never freed.

Initialize the same number of channels that cleanup uses.

Fixes: ba07fd2f5742 ("media: pci: add AVMatrix HWS capture driver")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Ben Hoff <hoff.benjamin.k@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/hws/hws_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/hws/hws_pci.c b/drivers/media/pci/hws/hws_pci.c
index 30bb7d34465b8..87ba27877f29a 100644
--- a/drivers/media/pci/hws/hws_pci.c
+++ b/drivers/media/pci/hws/hws_pci.c
@@ -441,7 +441,7 @@ static int hws_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	hws_init_video_sys(hws, false);
 
 	/* 5) Init channels (video state, locks, vb2, ctrls) */
-	for (i = 0; i < hws->max_channels; i++) {
+	for (i = 0; i < hws->cur_max_video_ch; i++) {
 		ret = hws_video_init_channel(hws, i);
 		if (ret) {
 			dev_err(&pdev->dev, "video channel init failed (ch=%d)\n", i);
-- 
2.53.0



