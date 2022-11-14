Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186654C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A860C433D6;
	Mon, 14 Nov 2022 13:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431038;
	bh=qT8Ch8T0CQRk9Wxj6UVwHjnXsqZRW8z0jOICmJbIuwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WVz7ViDCdim3v/+rMQHRPFqeuiVVatMXMo2ZLTbE/+evCZSqqvzjmdGtgGaaO1X5
	 k0NcAWlEocqae1QZdarxxarZXSf+znR9n5d7Lae88rHg5xnqTgLW8x33LgDX+BJtVC
	 gCvUydDBHSctM8wvWIjXHJLmKBGWru1jvuxvZx+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 047/190] KVM: s390: pci: Fix allocation size of aift kzdev elements
Date: Mon, 14 Nov 2022 13:44:31 +0100
Message-Id: <20221114124500.870551020@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit b6662e37772715447aeff2538444ff291e02ea31 ]

The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
'kvm_zdev' structs. Allocate the proper size accordingly.

Reported by Coccinelle:
  WARNING: Use correct pointer type argument for sizeof

Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20221026013234.960859-1-rafaelmendsr@gmail.com
Message-Id: <20221026013234.960859-1-rafaelmendsr@gmail.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index c50c1645c0ae..ded1af2ddae9 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -126,7 +126,7 @@ int kvm_s390_pci_aen_init(u8 nisc)
 		return -EPERM;
 
 	mutex_lock(&aift->aift_lock);
-	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev *),
 			      GFP_KERNEL);
 	if (!aift->kzdev) {
 		rc = -ENOMEM;
-- 
2.35.1



