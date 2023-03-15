Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D3D4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E02C433D2;
	Wed, 15 Mar 2023 12:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883019;
	bh=S8POfWpTMGqgZNVN6cqtn6k3LcjJgKzPDpgYFoPhBv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa49I8dTCnYXRX3uI1qd9SJEqZwwFgdJkuIymf+6licxYLDc07lnUzzPeSCJ0KaPL
	 sCoNvjVHWLDxodkj8a52OsC6QmK9KfB43/EbrTBcLhQMQ5Kihsd/9maxeH8FlNcc+a
	 6nYnbmP69wkhnKbgOsMUeP5Ib6nOhrJxPzAE7gsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Karsz <alvaro.karsz@solid-run.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/104] PCI: Add SolidRun vendor ID
Date: Wed, 15 Mar 2023 13:12:43 +0100
Message-Id: <20230315115734.943466354@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
index 2e1935917c241..4b34a5c125999 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3115,6 +3115,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
-- 
2.39.2



