Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208949;
	b=Z1o+4X/YxwzvtKW/GTJlq0Sx53Zs8Dd8N5YkS3hTCDiv+ogL/aaIJ0bomowhqYXz0LDX
	 v3z/cW0ixZWk56ZmJHNOZ0N+5TRUTkPeFuh21JwVCg7cX33tmgt3vpRXOKk2DkFdutttJ
	 1yP/f1M8cEDsbGux5fz82qIr1d3lyHAq95oUC/OGZAbbuwtWcpumJgCr7HrPCt/Eu7/x2
	 6MyMu6mpMf9oP6oVlDDRvpnPL1IvI12q0fTOc7+1/6otospwjXSQ3C8hEDLSZgrJBIGvD
	 K7dnn+WXt4n5mxRVmLC/oCI9o8SwNKMWIuMP8wodxADrlnx092Zmquvh45/caSlw0uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVwlHc/cEAu4rcq05XRlOBbLtS/qN5a+eJ8hnRhO/Bw=;
	b=o5/pBElpSM3t6b3rLLaYJjqwAho/nAMF1nC3RwVRDSeg/hZ2QKw86C/EpCrNz8l/YizH
	 rHvmdXrWJ5G4stqDKgQbx7ZvFxqhN6AquEwTVbUiEsqZFCgw74UtSRMgBeUVQNu2f/Rya
	 u+h/cBrxKvBnSJ12FRVkrRji7/82wrH7iLyfVYEYObsVlXiJxgnwbcRLqSc3bpW7GXLxc
	 vSY8qMfEYOOpGAF0tW4L41jmN+NnxXUgel10k1sTF+vhwi4VRdGYJuztQMQsyvXIUEC1Z
	 LhhhtSrYXQLnqbL9jARyql/abzl6qfzgEQ1Z1/5ZOyUuePLdCZNpgd6FrbSeQhViYwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mh2IqA0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA59606A32D;
	Wed, 28 Oct 2026 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mh2IqA0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416931F01825;
	Wed, 28 Oct 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208948;
	bh=bVwlHc/cEAu4rcq05XRlOBbLtS/qN5a+eJ8hnRhO/Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh2IqA0wyh9pIsp4TUS16O6ix7EzFX7XXVemTTlF049zDtI3TOYdSzfIkiZApnRbf
	 mwcOFN4dWHdVo17BJoXmXK6amwHikIgGkWYRfOi04G4rV7k+/XYb7blnJu/+cP98qP
	 1R1LDtKljXWPBegkGD0ArtwgfLM0yt8L8XhgjDzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/516] usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()
Date: Wed, 28 Oct 2026 17:57:14 +0100
Message-ID: <20261028170010.172742753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a891b9aebcc7406fe2f439d184bac3948fb08645 ]

clk_disable_unprepare() already checks NULL by using IS_ERR_OR_NULL.
Remove unneeded NULL check for clk here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250617042050.1930940-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b0f8bdbbc8 ("usb: ohci-spear: disable controller wakeup on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 5cc05449281c8..ed019c459ea0d 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -105,8 +105,7 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
-	if (sohci_p->clk)
-		clk_disable_unprepare(sohci_p->clk);
+	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
 	return 0;
-- 
2.53.0



