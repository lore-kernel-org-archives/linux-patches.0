Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020706;
	b=vVnrZ7wH5Alv16KMLLhRna823Ldwqvtd88LKwLZ8P4QlQSQPkBXv1Os0alkQZAwizYAm
	 2ReGzfVRQsLtR3qu5qu0/ptp6aldky0v6d/Xfo0xLua99+3ZSqk5fOoBEo7aURTEkNLuj
	 dmMqGb5ZxV/1wtEhRDiTfqU9M1LmEZpQyv23kjS9WYganO7t8e3DSMmY5KdiJzjHUgj4L
	 q2NxjQFWOgpslbP55+sUlUCzuPrNtTA4YA7aDN329nZWbAYe+BMnMQqbypF13g/YZMnu3
	 4AGOWTyA+nR4bTeJ5mUOI/7wq85mta8BRxTVvYzLqSqEhCVH0tR/c1GNbR7pF6tLAhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bsndqKQy14H1+yn+M3pHnH0I+nfBwVB0osBoatONYpA=;
	b=F9fvQcC079l/7gRJumfISpoxXdlZk9ufTQlOguR6OmEtNffB42GCGO0WXNZE9SILe7eN
	 yxoabiE4uMK+kvYc3kDFqHo7d8G5W+T27Ku5Gku5imoJ783D146rVmNYkVL13I10BB2hX
	 GNo9/YqtTLv2b1JubtZQExNo3SKrs1VoNH0JeVHc1wWNWpYGKGuyDkThEliKhybY7PDvw
	 AoGFyJ5LdALDStvfZ0DvmIaaNUjqMPYuR+HC+Wk7GiZeSfwaCHXsFPfVSyN6WSOweoEeA
	 KST0ZxuwVgzb1R0PrV5sG9nrB0azlzqTJJY6ntNF5jbxCT1Tt8awZpTdCp49S9TMGVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKCMuksE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF160A2623;
	Wed, 18 Nov 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKCMuksE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2731F000C5;
	Wed, 18 Nov 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020706;
	bh=bsndqKQy14H1+yn+M3pHnH0I+nfBwVB0osBoatONYpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKCMuksEJ0EdORbCqmqnTeF+2gL3ChSSc+C6irYevSy6hTo8uifuJtYAeW+2T5/z3
	 2m7oZtWDsqxP39AOD7+M2CF8+YRX/LicRvVy7Kdykeww5vK9D1sdO8+mONo4BnCuf6
	 onvztrwuaZ+dfXBS8CLvRjfS1+QwuJycwM9Lvm2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2046/2651] power: sequencing: pcie-m2: Add Foxconn WCN7850 subsystem PCI ID
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150359.739962628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit eadea156f11b2c9a780b60c1699c2da145c9d1f2 ]

Add a new device match for the PCI subdev id found on the Dell
Latitude 7455 laptop.

Fixes: a39ac4651e3b ("power: sequencing: pcie-m2: Match WCN6855 and WCN7851 UART BT variants by subdevice ID")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20261016051745.577777-1-val@packett.cool
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-pcie-m2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/sequencing/pwrseq-pcie-m2.c b/drivers/power/sequencing/pwrseq-pcie-m2.c
index e42e85f47629e..a745dc81003f4 100644
--- a/drivers/power/sequencing/pwrseq-pcie-m2.c
+++ b/drivers/power/sequencing/pwrseq-pcie-m2.c
@@ -199,6 +199,8 @@ static const struct pci_device_id pwrseq_m2_pci_ids[] = {
 	  .driver_data = (kernel_ulong_t)"qcom,wcn7850-bt" },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x1107, PCI_VENDOR_ID_LENOVO, 0xe0e9),
 	  .driver_data = (kernel_ulong_t)"qcom,wcn7850-bt" },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x1107, PCI_VENDOR_ID_FOXCONN, 0xe0ee),
+	  .driver_data = (kernel_ulong_t)"qcom,wcn7850-bt" },
 	{ } /* Sentinel */
 };
 
-- 
2.53.0



