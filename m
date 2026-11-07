Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063436;
	b=IOiFicQhfc04vVO7Yx9uSbb12JGkG7NXt98tINLMDnqVzxukcElDf8GDi5iVd9C6UsGb
	 pjgzMgW2KBtcgtbRfRAyJ0QJJNQk9h3O4NEHF9NzPV4tsEuHr7uXkefmneYJO9hcU+Zo8
	 jYbYf+gJEVi53zCmOttBVJ0pvVaFVGqTLb5PGYygNI0TRX3ZDhi0hmvBW25DTUesjpioz
	 WKG4nuzjDWKIjWRp++NOk6TBEefDgbPRyi1seIZ+4bfaqdsgcd/rfjaGRR2f5O53JVovS
	 xLAPPjxGfg3WeWO+mIRPW2nTyhh1R8cMGiaeqH2sNZtv5PmJx5bXvj++C/q59FuhaLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tcajINutfoWWq+Yp+nh2rt9PE5ek7Q9SrkxiAzJ9nGU=;
	b=g7ZV6Nh/K17BSwgPw4CC4efD8IX75O+7xXrew6F19ukmY/Y/E50mF88jeId08p3doVGT
	 e31Bb4bpGb73Gaws1pkZtXNQ1sn60aD4ZnzkIhGjDpyfPZWGpTI6gz32a2BokfCQT/WFK
	 pbXdnlrj1HvkRyXuNKzZRNN67LU2miYhpjBdIVv/B7XXulWcvOa3B7GDDfSnp/FmBjK2A
	 TfqzOcItFyCVPAWEUYQmVcwes6ExhiRfzK4tgrKg/vACEsy3NsTS16XxNR6tcRbyoeb6y
	 v66L5jPHsmU32beHX+5vRAvBVHlkP06vClZdEyhmCSsEHbOzKna6wa3M90QXg6mrQLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a6BLCzT3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA91608362D;
	Sat,  7 Nov 2026 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a6BLCzT3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7221F0089F;
	Sat,  7 Nov 2026 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063436;
	bh=tcajINutfoWWq+Yp+nh2rt9PE5ek7Q9SrkxiAzJ9nGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6BLCzT3GFOglU8doKuFk5EuDOLQA7XzVIoISlwFl2QD8FS79mEGhJ/obWLoEi91o
	 76nEohqXWvvkeg7Z8K+dc4ULZWoiUo0IZCO1mQUUhFXKumwRMjS47K9C+KXhur+pdu
	 8UMkyC7n+CpJqdzexwW2vJrkeSLzt6tUEQGtFlPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stian Halseth <stian@itx.no>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tony Rodriguez <unixpro1970@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/869] PCI: Set supported_speeds in set_pcie_port_type()
Date: Sat,  7 Nov 2026 08:54:04 -0500
Message-ID: <20261107134912.353545069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stian Halseth <stian@itx.no>

[ Upstream commit 926767a9be8866d26cc27ca46c46c03d921e2193 ]

sparc64 and powerpc create PCI devices from the device tree in
of_create_pci_dev(), which calls set_pcie_port_type() but not
pci_setup_device(). Since d2bd39c0456b, supported_speeds is only set in
pci_setup_device(), so it stays 0 for these devices.

pcie_get_speed_cap() then returns PCI_SPEED_UNKNOWN, the sysfs
'max_link_speed' attribute reads "Unknown", and the failed link retraining
quirk passes PCI_SPEED_UNKNOWN to pcie_set_target_speed(), which warns on a
SPARC T7-1:

  WARNING: drivers/pci/pcie/bwctrl.c:125 at pcie_set_target_speed+0x284/0x2e0

Set supported_speeds in set_pcie_port_type(), which all three paths call.

Fixes: d2bd39c0456b ("PCI: Store all PCIe Supported Link Speeds")
Closes: https://github.com/sparclinux/issues/issues/109
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tony Rodriguez <unixpro1970@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261007131304.309511-1-stian@itx.no
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4e4e38e626912..082c51ce88936 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1661,6 +1661,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 		pdev->aspm_l1_support = 1;
 #endif
 
+	pdev->supported_speeds = pcie_get_supported_speeds(pdev);
+
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
 		return;
@@ -2046,9 +2048,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	set_pcie_untrusted(dev);
 
-	if (pci_is_pcie(dev))
-		dev->supported_speeds = pcie_get_supported_speeds(dev);
-
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
-- 
2.53.0



