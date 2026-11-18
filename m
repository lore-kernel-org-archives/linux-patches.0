Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061364;
	b=1OTPC6ZNZIZGdNXHukEnYPfsKqK99u1dI6+vXZ+hI3Bl6lLPFq379sflxX6QAwt+6Vuk
	 9/9FZTA3q4T++VFcsS8qvLLgWtwGXRaYzcMBSihzoeuYs3Pfy4DZY7oiP2lUacI5083/e
	 Trn7xUdOe8UMz8pvgSB5AxegWUB9xYjkSfFyP+0u/y+HLkGuapKc+E/xaA66wmuIxGLZF
	 6uxLrPnEq4L1R5HC/O08NKLB7oEgRaGjUwfWdtxFzz5/8whu0o/BugI0tTyFNMGsLiObo
	 1EmLpq38FEqD0tXz19Ken9FMuFLJpeUXMxPuQBbrrtgj4L+PIUGH8kNuPK3c2XveN/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQ1icKMHM5Sm04qym/I/3jfWWAR6TMX+wvn3/6Q+Sw4=;
	b=uSudprazZTUu4JjyeyIT4FbtJIlk31/zmiHTt8VqcskAXHxJQSlrCVXrJuCE7PP1yEtc
	 3McffY1xu05YwkAUsvDEdsWAEotkePNSptCge0chW0UUS/Hg798j+yiKKcs9X0I2elD80
	 lkiJ3gmwDC3zf+Ta+O8C5Y/qFEa2I4EtIRdvg8NRRbQ2g1vf5cKTS7tji2xf89EItM4sc
	 2MySsfakd/IY0/gQcPiN1CqzjXuEBg7JAKZJD5VMZwnv6Tquzqtj2+e9M1akMLkIPdV7F
	 iy68M7vpkY2ZshEopYeXkYf8sCQlTcSvZyqAwA1NzkDIjKzsVIvJVNK+GfIq663kfyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPrxspem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19084606A32C;
	Thu, 19 Nov 2026 04:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dPrxspem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAF31F000C4;
	Thu, 19 Nov 2026 04:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061363;
	bh=MQ1icKMHM5Sm04qym/I/3jfWWAR6TMX+wvn3/6Q+Sw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPrxspemTbGVNgiS6oAWLEkCUn9YlmZNR7wga2TcCL0YSZz39mITXdIl3yvI2y2Vd
	 WCnaPxZb4WmV++eHCJ5viOc2CNH1PBkb+Bv4Ot9fs46E30vbV5X9rtmSoBzZQKQWZU
	 A/se+OKG+ciubby0Dmg+Bka2JJTVVKw3w5nkr50U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1526/1848] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150023.292193546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e873c665e503ebfb6dafaf9346c3956695686226 ]

sprd_dt_node_to_map() reserves map storage before adding mux and
configuration entries.  If a later operation fails, the error path only
frees the temporary configurations and leaves the map allocation reachable
through the output pointer.

Free the partially built map on failure.  The caller ignores the output
parameters when the mapping callback returns an error, so they do not need
to be reset after freeing the map.

Fixes: 41d32cfce1ae ("pinctrl: sprd: Add Spreadtrum pin control driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index 08dc1931b358d..c59ac62456b5e 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -327,6 +327,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



