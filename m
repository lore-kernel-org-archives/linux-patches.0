Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052463;
	b=OAuvSW5OZBT5EwumNc+3AVa7oCpqlh5nn7fbDe79Hevx5XKSjx/X1o3P4m5DikW+LgZm
	 tX8uJENZlVKVvOD6F6CwA+PscWnI4RNaTubWU2xMgUuZGevpOfvygmYy4Ze7p367sCWvh
	 KeS0mNOViSAifQfMQN8R8RdMwfXIgm2YrFAYAbj1qwdrnLXbENgy3gATX2uVvM/Qd6A/E
	 TeEWHiyf+eb1OFtNlQEm+YGmpjxjJ/oz9JyREjeI3ff3A9CNg/8fYRZ1mAlGaORCBK+0I
	 nlgWrYTLGiootIthisGDqnTztuHuV4D3bilP4Dd8AWSBtyzarN6zLIXGl22eX1Xu3tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcjoruaI3iaBUQzBdjf4xzQPGYw8+5KDz0Exsnys7mY=;
	b=h1RLMTc5Lobd63Hh/NmCm+EMDkQDUjLe1T/Sgvu/AosJg3C9qNMAiA+GDZNZHblE9o4L
	 Og2SXx7fbWJQSfavFF1D1dj9g2Augk6w8vQYcpK72wE91tkPLVfZ+PxwQMeewkyZBxef+
	 VFG1ivAbql3Az2l0pwoz/LUcFyhP8CeyD7oC8NX03WbMgBnJkYgTZhONxpHt+/J3p8bmP
	 epNhMbgvXc9swOtkgx03hy9U3sARMhHIfSJizoOgUmJ9xwssTylJFP5CZCI29WsxWWwky
	 kQND8Pl0Y3NrlwFsOy87bidQgzRsnEYNgaic/V1toF1ChBD8W0GceSQk6BaNPdhAGWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H0NH/wJ8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CB606A32A;
	Thu, 19 Nov 2026 01:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0NH/wJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FB81F000C4;
	Thu, 19 Nov 2026 01:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052463;
	bh=zcjoruaI3iaBUQzBdjf4xzQPGYw8+5KDz0Exsnys7mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0NH/wJ8MKLG5PKJCiH/aOjGL6dmkFnHfbi7WKLy1aHsy2wdjxTIL271pllZQeSUR
	 RKG0zLqmNaVRNEWvfSqus2+yIIytQZzwlEMcKwKdYJL8CeFh8YMUxHv2T9fKAVRU40
	 DwwF80McuTvtnIy9U/6MxS+0pNSB18q1ZPyNkAUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0526/2214] media: tw68: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118150032.120638532@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit fc02261fdca3ea95e4dcb6b38ab77f0f197c3750 ]

tw68_initdev() leaves the PCI device enabled after a later probe failure
or tw68_finidev(). Use pcim_enable_device() to balance the enable reference
when the driver is detached or probe fails.

The managed disable runs after the managed IRQ has been released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: e15d1c12c587 ("[media] tw68: refactor and cleanup the tw68 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw68/tw68-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 35dd19b2427ec..577035fdd7c2d 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -228,7 +228,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	/* pci init */
 	dev->pci = pci_dev;
-	if (pci_enable_device(pci_dev)) {
+	if (pcim_enable_device(pci_dev)) {
 		err = -EIO;
 		goto fail1;
 	}
-- 
2.53.0



