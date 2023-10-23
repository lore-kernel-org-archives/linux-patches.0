Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105D414AA8
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXK/MD6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218ACC433C8;
	Mon, 23 Oct 2023 11:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059474;
	bh=LcvYcKcct5/2iCMgHmMxzEwr25EjxGvKlomJGIMUe9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXK/MD6hHJ8iMUhlrb/ZuxRtBwI8BRxfo3OZr2N0rqVUCXteb0khQ6z6pES9Mt547
	 h2arb4OwaNTFVWi0lLkSxr+qbVwgLo5CD6ZtCM4SEm+4+v7K9F8ZLI7OGIuKTU6lgG
	 baHXUwTAb4yZNxFpJ0UNQi9v74ohqCxl74ghRzx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	welsh@cassens.com,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.5 190/241] nvme-pci: add BOGUS_NID for Intel 0a54 device
Date: Mon, 23 Oct 2023 12:56:16 +0200
Message-ID: <20231023104838.510835827@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

commit 5c3f4066462a5f6cac04d3dd81c9f551fabbc6c7 upstream.

These ones claim cmic and nmic capable, so need special consideration to ignore
their duplicate identifiers.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217981
Reported-by: welsh@cassens.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3329,7 +3329,8 @@ static const struct pci_device_id nvme_i
 	{ PCI_VDEVICE(INTEL, 0x0a54),	/* Intel P4500/P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
 				NVME_QUIRK_DEALLOCATE_ZEROES |
-				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+				NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_VDEVICE(INTEL, 0x0a55),	/* Dell Express Flash P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
 				NVME_QUIRK_DEALLOCATE_ZEROES, },


