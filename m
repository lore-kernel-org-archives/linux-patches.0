Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618061;
	b=p64btwsa3HhGtVkCi+JMGTGl1A5IoSB14zOKG9+sVG+DQ29ygYVqbJj3sWF5/CBHJ/l/
	 l1pB+ab0lLqJZ+2PQDtGINEyT5RYGSwM6x/fFf2YqvGfIn86SwoXtrcyrKxL6Cr0if0Ze
	 v0TwSO/i/vxB0E8btKNBXp5jtOnVNpFTQ/pOeMIZdfK/AZ8ZOPjm16o69DO5F9v/boKsW
	 gjjhFyk4BKCFy98D9YDMD9la4amCbRumh97HKFZMAEfzC6I81V6CVTRPjUiMlDK6WYjvi
	 vGnx0fpJAERccAn5WC5RA7rFVXf3jNkYVIwqGSX2kOvA3ec0BkXsQHa3YetiO3PrRzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S8Kjiu2xoUE8eVuavV2oRwm+mBUs0KcABjBL5v3aOt8=;
	b=sknx6ggGVhLS6Ht1yT1f63WpwdOpL/7pDjG4lSoXpepbxezZ2FzjeVavFcs++lZlgVt7
	 wVx3LalNJlTUh3VwEPqssShufUbwLiQU4ZKdp1Ol4944+dHz7aGhubjPvthJBBPfq1RwX
	 f/83X7d+xdsCgStIrPfodJTMa/xo3mRgkP3e649b8qZmB0dOELVxDPxEVOAAjxzd1R21c
	 8hkZRdOcb0U3Df4/Qa7JkRyN9SrsOdr6EYdjHWCDVHuovzzWQ5PWSCkAFXO3GjshfldCh
	 OgoyRWP5aks2z7Dq742LK93R20KXnb9PmsxTu82B5fFxgAaDKvanyTBsU/XzP5Kb1Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWyBUD2m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC6606A338;
	Wed, 25 Nov 2026 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWyBUD2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98E1F000C4;
	Wed, 25 Nov 2026 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618061;
	bh=S8Kjiu2xoUE8eVuavV2oRwm+mBUs0KcABjBL5v3aOt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWyBUD2mHN4A+q7QLjP4+fSOeB5VAZPv2Os53wjp54xk9/JlylbKramznEB6LPpf6
	 iVaH9AzVV1bsMkBgsivD0u4SF1EplG7TlY3Aa5utvXY9hyI8YEwbijVklpNAPfHsZW
	 jZxAmrz4egXti7Gir9VRXh1hwC5+M1842TSPlzMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoxia <2312891301@qq.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0158/1005] virtio_pci: add missing newline to the pmcsr error message
Date: Wed, 25 Nov 2026 15:24:56 +0100
Message-ID: <20261125143825.440115015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index b90c174450b20..24af84b0c6adf 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -633,7 +633,7 @@ static bool vp_supports_pm_no_reset(struct device *dev)
 
 	pci_read_config_word(pci_dev, pci_dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
-		dev_err(dev, "Unable to query pmcsr");
+		dev_err(dev, "Unable to query pmcsr\n");
 		return false;
 	}
 
-- 
2.53.0



