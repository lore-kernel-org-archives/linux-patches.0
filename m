Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3864431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9B2C433D2;
	Wed, 15 Mar 2023 12:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882517;
	bh=LqwQRxQJ8yM/tgpG0HtjBBaEWie9NUFFmB+B0q2b/o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtusAzn9DLg+IxycIFA3VUzIS9wtAedxTLePjydZAb2b0M1bzZAI6wUBiSfJliY4Z
	 aJ5+6kYWquhGPk221+PZH32y3MvYuR9WfjJRLfDzwezNlbwlRa0NfcWst9AUkJqEVr
	 XrKIlVPticmYlMjr5+Z1cTKaUrIvpS2ieTdmmBbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Karsz <alvaro.karsz@solid-run.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/21] PCI: Add SolidRun vendor ID
Date: Wed, 15 Mar 2023 13:12:39 +0100
Message-Id: <20230315115719.429277732@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvaro Karsz <alvaro.karsz@solid-run.com>

[ Upstream commit db6c4dee4c104f50ed163af71c53bfdb878a8318 ]

Add SolidRun vendor ID to pci_ids.h

The vendor ID is used in 2 different source files, the SNET vDPA driver
and PCI quirks.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Message-Id: <20230110165638.123745-2-alvaro.karsz@solid-run.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d4eae72202fab..0122286beda53 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3045,6 +3045,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2



