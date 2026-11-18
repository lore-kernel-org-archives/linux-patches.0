Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028654;
	b=MfkzZ5Jkk8rK5uI6Vg4GEqtIFy9k6ODffX9njGHlihGgrqPmVRLqWCo7k5gsfP8wkN60
	 nCx5Pr3oQgDRNVANr44r0jnkbKZOFpM9C5PTrfumdFN/LQDsyWK9IGx89Y/OvYV1Xbjk6
	 b8yFGGTni0sKuXHINXukRl/fKLTXCFldbBJipGnGiHH0yzSlS7LSPtCv5uVnOxCiz0knP
	 W87z0WY28L9zERYsJQplGjShsAO+Qp0mN3KNwgiyNttHLqQDytWn1uWMoCDd7FGYSj1Te
	 10Ah+x+P5fr3IV6zYpXeqWmN07rpQspn7h+VOFsggxx35F33rZ68cs6RoRLdGv8GWnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xnr25ByqzRCOmFTV4S5nXtd5sZ17CH9mAWzz0wVnFCM=;
	b=VEajOElHoqEFVsOU0/coRkm4slJOuG/8LxM+TwL4UCv1zRHCD5hMeNgFNHMl7ehnl8iT
	 Qw8xEF2SVV2xIOTpvKk0Vye7hQPYDxZFoxnm+HzG1NSKQ1mvf8+wZL2CdtQtlxECA6qaf
	 rQiVJFE3Ua+82sSPHEteegXOlpRyxfUU6s8D9xkQAxXro8EmG5UAQqZypOEHOW6H7vie6
	 J3HYox+33t5nvM2sn+uL4pwc9U2/VtVim9402rMD9jR/XzkDxXc+UzwGvSQHr7M0dJRkl
	 Dhpb4FV7W1Hm8SE6GapVSxjrTA00gLYzFl/ztytN96U7qzAKIRK7fn5iRrrPduE1EIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz1BMPTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65D606A31C;
	Wed, 18 Nov 2026 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz1BMPTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A491F000CB;
	Wed, 18 Nov 2026 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028654;
	bh=Xnr25ByqzRCOmFTV4S5nXtd5sZ17CH9mAWzz0wVnFCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oz1BMPTqPMLKoYyCyqBgNF5kj9CztVYuv8T6NRVnS+jUTm0TCYu5pZKToBul9Ewgh
	 YJfFBPqhNNPyzjn5EmCGJ9+2ENFhj5ErCHmek4DAwx9/RyTURsTtkk2YhAFx4iN8yO
	 aCCgjtIBhEzXN5Buc3yeXSSBlR8flPSR2M3BWudU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linlin Yang <yanglinlin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0019/1756] wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150008.690627840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Linlin Yang <yanglinlin@kylinos.cn>

[ Upstream commit d92bac6b6af2602516ee82ae112709c71af27cf6 ]

pci_get_device() increments the reference count on the returned
struct pci_dev. In mt7996_pci_init_hif2(), three pci_get_device()
calls are made but their return values are only checked for NULL
and then discarded. pci_dev_put() is never called, causing a PCI
device reference count leak.

Fix this by storing the return value and calling pci_dev_put()
before returning, following the same pattern already used in the
sibling driver mt7915/pci.c.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
Link: https://patch.msgid.link/20260824092937.683240-1-yanglinlin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: adapted device lookups to use only the two existing numeric IDs instead of named constants for three chipsets ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index dbd05612f2e4a..3cb5678932427 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -61,11 +61,16 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
 
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x799a, NULL))
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x799a, NULL);
+	if (!tmp_pdev)
 		return NULL;
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.53.0



