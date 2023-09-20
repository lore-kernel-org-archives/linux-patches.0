Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757E715AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F62C43397;
	Wed, 20 Sep 2023 12:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212215;
	bh=/Vzj87T8/s8q8JKOBJ81PZHk7bGhuWrOZwov+im03kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvX00CveTWsdJYwLgCfZmuHXxaQuhNyW68vboaA92EuanCKeGopSlPw02RTQWm8Kj
	 wjTfK2m6KZ7GSMFBeKxplYebVU/fKok0SJJiBgwRd1kYL0xsJY0HZvRlLzxbP0bhiT
	 zlTct92A2HGpUbk4lVZqfYtzdj+owml9s1V+7l6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 192/273] PCI/ATS: Add inline to pci_prg_resp_pasid_required()
Date: Wed, 20 Sep 2023 13:30:32 +0200
Message-ID: <20230920112852.440135003@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

commit fff42928ade591969836ff49888d063b829ac888 upstream.

Fix unused function warning when compiled with CONFIG_PCI_PASID
disabled.

Fixes: e5567f5f6762 ("PCI/ATS: Add pci_prg_resp_pasid_required() interface.")
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci-ats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -67,7 +67,7 @@ static inline int pci_max_pasids(struct
 	return -EINVAL;
 }
 
-static int pci_prg_resp_pasid_required(struct pci_dev *pdev)
+static inline int pci_prg_resp_pasid_required(struct pci_dev *pdev)
 {
 	return 0;
 }


