Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621218;
	b=CegnOYsmIoJ0lm8Z8Sm7YTT5MJmkxJESWzjBELQFzumZr3ETPIHR//ejzzdgC5tOMcSl
	 msNTh3jb+GFT2RokLWqRaVG9iFRu/fSUwSVWnbGENkvOfmWpDreFkkzWR08s9vpkblg0D
	 Q3dr8e5Uvlu2BHGh8CPWMNgjvr4xutVDEwTu/sNEevtBDz36qmjOtrjKAtAPVYPfRvBnw
	 RHR/+ZcpzMB1pbz6kjJXrfFomOxQEFF6LhiqH+zlh9wtAtVgk+1V/CUkePck1+g13qIxY
	 Bz9QKhoFjfh3t2eOrOE3oFlVqyxaO58giMzN8xJjV4RTH3gLHuB2y97f4TtjqC65j/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+bVybbkR6moKoB+P/28rV5jidpvN/U7+kv1///msBM8=;
	b=qzT4tGM7d09AJXQ/QvTq5c0m0I2H19NKM0F3oNFnj6h3bsteQV800L7xDmz8LWBi98eO
	 TWZwgCO7sYE0rdOWwklJDCXwjmkfhvotVTnElL1Z5dv4Qp31ixA5aJL3UYkGcJeyw4EhJ
	 kExArldUceCErGiPXOouzKLnCZOyYhevGq096dt6ff/R36WHA998kUhtDk/gfmjkLMD6Z
	 2qkfA1ny7T36GpMn/RWNsvBPQsUPAUf7IAldGNhPe4d1sMHHBiB1bM27FXq/9RLOkdhBN
	 u1qPbBgr0AVNHXwM2EmvLg/ScAFwEWjYlOzy3BdTL7L9vjgUKsVsF2p0lH08qGdJSHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0YvdU3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC0560A6F60;
	Wed, 25 Nov 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0YvdU3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1D81F008B2;
	Wed, 25 Nov 2026 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621217;
	bh=+bVybbkR6moKoB+P/28rV5jidpvN/U7+kv1///msBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0YvdU3OqD77mTvf/4+GqjBogL+t7oz5IkPI6Y40aRUvIrR1gsKklRQ5Y3jZTsRrB
	 5srFetlRF2KVnMfkU3nXA+kR94uMN9vpUi/AXvPsA3iDLt0nPuYhBwHcDuvvl3yTVQ
	 00JzVUmzegEuiu2Dm+0a1gjAV1e5Nw9BL9TkhfHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoxia <2312891301@qq.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/990] virtio_pci: add missing newline to the pmcsr error message
Date: Wed, 25 Nov 2026 15:25:23 +0100
Message-ID: <20261125143825.748546164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Maoxia <2312891301@qq.com>

[ Upstream commit 104d58a6d2592898fbb6989732600b07d543a8e5 ]

The error message emitted when the PCI power management control
register cannot be read is not newline-terminated, so the next kernel
message is appended to it on the same line.

Add the missing '\n'.

Fixes: dff4fa0e5785 ("virtio: Add support for no-reset virtio PCI PM")
Signed-off-by: Maoxia <2312891301@qq.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <tencent_031B923A83E0DEE884BD05D49030890C0406@qq.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 64806d042dbb2..9d4f0f0d70879 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -636,7 +636,7 @@ static bool vp_supports_pm_no_reset(struct device *dev)
 
 	pci_read_config_word(pci_dev, pci_dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
-		dev_err(dev, "Unable to query pmcsr");
+		dev_err(dev, "Unable to query pmcsr\n");
 		return false;
 	}
 
-- 
2.53.0



