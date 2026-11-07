Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062094;
	b=xX9PviLWG/CqFgWYswxHDwRcwik+OZEOExAnut7yJXOziFrGdvMzE8yp07ryPPB1ymh9
	 HSjLT6la/oRqdPFJhSmdS98bO5WqkCFbymv1n+tSDQbC6uhrlO2qvoKM521mzYrigiqb8
	 fJQZjBmnn4t1sE5h98dmAZ0PtoZzAD/tKf/Z2P9xaInXLPlwX4m5hrxqUg8NoUVoY+1As
	 2W+QMJkKN70+YdbjfeF1HU9UqNRVC/MK2PJexH5nyUytjW3bx4i9zVTMt5he1bS7mg6QQ
	 1PCDoYPdo9L15DTR5RnTaZJQcZxlSjaw6I4VBHHDIlMlmnSV6wtzQa36Am3VT2tuHgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/fos0N+7LQ6/MjmclIjS61G8a5YkkW0F3OFVe5aKWCQ=;
	b=QLDQe4dIocHr7euaBfNfr1ucsI4SZFBdm8wQ5z/6gvlrpkNuhCQ804voUhDjTiNoBBeu
	 4DtbPMpuO4eqg0FgOd1W2TRTgsNIgvljl6iYNjZgj4VoYXYlXwl3Jm2kxiELMpF0R/gKC
	 T8oXaVpnNYtGakqkeUYvvIPyDJs+iAIf3vzkf0Z2bD6Z7jSRqXJnhKkSSpwTmzHMqGAxt
	 JEIRaH8k8A3arDCw8lcbwvgT9rYHczIv0jF8x0cNbO/cCt4LB9FpWHqjaTgkvGmDVPx7J
	 Be1UmsP1HVrCkrh+WimwWk4OpnkYhcP5lGPbD7UDU0zEXD1sfPnxDP3WlWfjF0nqoqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0caIPwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DFE608361A;
	Sat,  7 Nov 2026 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0caIPwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC421F008A1;
	Sat,  7 Nov 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062094;
	bh=/fos0N+7LQ6/MjmclIjS61G8a5YkkW0F3OFVe5aKWCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0caIPwKbwzT8OM9tRGneT+tj7JmZFiUTPzznjfJPA6yiWj5ZIaZ9sjEIfrpjNUMd
	 qtp6Vv3druG83s+7DbuBJEd3vjKHznZpXdsZJcztf+NWY5HQC1IFzIthN/cGKV8wuu
	 GA1bIRRyIc7/AsF+/aZM87fWz+u063ZIjJOsiY/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1067/1536] mtd: maps: pci: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:51:23 -0500
Message-ID: <20261107135027.658925633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 3be16e5d4990bf96309ac5ba35cb369c6015bce7 ]

mtd_pci_probe() leaves the PCI device enabled on later probe failure and
mtd_pci_remove() does not disable it either. Use pcim_enable_device() to
release the enable reference after the existing map and region cleanup.

The imbalance is already present in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index ca00d211e73e4..c6bbce6aed417 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -256,7 +256,7 @@ static int mtd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct mtd_info *mtd = NULL;
 	int err;
 
-	err = pci_enable_device(dev);
+	err = pcim_enable_device(dev);
 	if (err)
 		goto out;
 
-- 
2.53.0



