Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4724431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6208C433D2;
	Wed, 15 Mar 2023 12:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882746;
	bh=YeJprYBDUT+gZPBUFosifEW6+RYM19NGssR6oZrUJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDUBvQAcygGmLhEsjUNdqfMyyYxxl/T2MBbau5hx1urzatzeKGMqb+r6E+ekBZ7FM
	 eQ1QkXUWMAxnh9irUL8lCLQ9XU1QoUwMjTg+U+2DmLm36IEIiJUhTkKejn2kCbC+V2
	 4kA3FJ9MOK9pymOji0Pt1e7snXIWoichB2I5BNP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Karsz <alvaro.karsz@solid-run.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/68] PCI: Add SolidRun vendor ID
Date: Wed, 15 Mar 2023 13:12:49 +0100
Message-Id: <20230315115728.251720606@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
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
index a31aa3ac4219f..d35000669db5a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3106,6 +3106,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2



