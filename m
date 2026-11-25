Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624399;
	b=xGyCivZHPSBPeMmg2ThAxnm5bXT3U86DdQdWEPHBeZCOBDcAvlrdRENhHBDi8RwvFLS7
	 KixC2nlNCATjNRTxTEJNpGKhBeEYPwst7M8bsd8SsbzfeyyBndA/PZEGjedlJ2HthPSGE
	 rSwZ0fKkxnNXmETkAJFTjun2ct+ZCCv0MzAGJ1yIJiuMuu8B9m7PBmAA9LQKD8Zj9YakC
	 I+1LHLbyhM+pAJgCf8utcQt1iYanuHDnfF0LjiCBfGucswE5iJvmQUrQETcWFJ3MvlbuT
	 NJjX+AOxKH89ilUSwZkbqzHjCRNL4wNbLsSwro3uQrpSUBintgLS/N9lv97MIDOhftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nVx+XlA9zM6+xe46bcSVOzDkXjfuHUYuXiw4vZA2wnI=;
	b=4aoKrxsiAKU+CuKn0/4kHxgrju55FQiX2ri5sWCXdUye1DG0e4MzrhO51DmHY1B1T+2w
	 hVSUXjQ6xyBlAX8Znm1RmK3JoLagXwl8kxWqIg1on+GJ0l9D25HjO4ENIaqv+ff2JO/sF
	 /BbosL0lXo6aWSU8DdvSenEYXDg2VwbMJhrvBkfMXGtO2MYeu5M2rLU7htvPFyNOiLkYO
	 CXD9Gl0w20TnFE0BN2c8MP3raLPq7vSeEoPFhg4Af6xn0V6+5XE2YuSt/TUAJ9Hu5P4Sg
	 /BeCQVLXA3wAqzVpsPPJOlago0m7M+7PgphIr2n8RatouVj4LtdYj9LSfR4gzhL4m1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRIeltS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C412606A6AA;
	Wed, 25 Nov 2026 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRIeltS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B71B1F000D8;
	Wed, 25 Nov 2026 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624399;
	bh=nVx+XlA9zM6+xe46bcSVOzDkXjfuHUYuXiw4vZA2wnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRIeltS2wuq1TvIPDD8BMinBc9K/Ill/7Q6nhKqePx42wHeKfOFmLlrJp8bCjwFVX
	 flwlWUYLTPYknr/HmZLVJPNsXs3t/kUL74ZU5f/OMbvK9Xp/dxy30kEV+h6YcyEnec
	 UVaq+YfaFFL8Fqv64C6Pfc5Z/Jqt4tZ8y8zIphB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoxia <2312891301@qq.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/816] virtio_pci: add missing newline to the pmcsr error message
Date: Wed, 25 Nov 2026 15:28:03 +0100
Message-ID: <20261125143852.328508158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d88f62d0fb7a2..77f81a000637e 100644
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



