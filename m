Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021489;
	b=5pGrsGshEGM0iw70sDEWDwSQA5HmniFzfql6sJHCkrpGJ1cEB3BNqFltfq+ck+7juJM5
	 NyF9za7DZxqa+DKacqZRIt0Cpv028HEulFcZalgbNtXHnnO5piUTeel4fzpZ71LkHNCGZ
	 Ml8Q2+DJhaXZpinX4C2gekJDpXv67nv5Q4DsnlvNeKF5hFXPNybDCi2vQv4S7EqnyPId3
	 F8sUx4tt/seR6Vf7zAdd/BMAZ78vLHjRC7/N2czn1GHS4qunkQsqt7cLlvdcfhx1B4qhL
	 lbO51BA6+P7XMR+q4LBCGCVrmD2AlWJSBp2ZLo5i0iNhB4Z5gPFJlgpdePFz7VUcuOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXyM0UG6lzYfpv8r6tchCmWL+HmiV7yfkz3zoBYq29Y=;
	b=KrZzlY/xi2r9nlY68GNkxZEzsD1grej6iuOGOkYAiM9jIoCPK2aDS0dakIBcZyVcZgQv
	 hDwaioV25iIoBvVdl0A+FbZChIF/FRL/zYaCyFFvDPhLINfkNgT5rITa6xU+dmHyvOw7N
	 KiPOCdXCnYZyUIwvOhyO1BlJ0AIXRRh80rBrOFFzlKuSFonMFhpqppuEmY/4U8/SoB7Pl
	 o1+JM6fH0eIrwbIIr8+TUoBoUCNVnqr0V2as1cr+higsn9ykx1b6MwEIPlSg3g+ArzAlS
	 +he19ZsisQM2YKxEevPKP3FlfOEkwHek05CYmlI+zYpXXkQNvDNSTk+esOLzMgkTT/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YY1RqNZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC6E606A32A;
	Wed, 18 Nov 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YY1RqNZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF161F000C4;
	Wed, 18 Nov 2026 17:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021488;
	bh=IXyM0UG6lzYfpv8r6tchCmWL+HmiV7yfkz3zoBYq29Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YY1RqNZ7LbRe0KIhnwMHd1hxXSGJpVZfk+DOfL90aUpXginXO0a+T6YaWsfoMrMwQ
	 WCGnth9TDgt2qRVwQYr5Xba2kdzimMGKbQ/ygT3Eze+8/qLJC7sK6qNlO+VnT7L+V+
	 n7eswSB0zGDZwfJSAmAVcSooJ8E+Db9ehxHygYPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2326/2651] PCI/pwrctrl: Power off child devices on power-on failure
Date: Wed, 18 Nov 2026 15:59:26 +0100
Message-ID: <20261118150408.888192594@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit b6087ff2b7a4c9f98c78f56f0f357557fc008768 ]

pci_pwrctrl_power_on_device() recursively powers on the child nodes of a
device before powering on the device itself. If powering on a child fails
(e.g. returning -EPROBE_DEFER), the function returned immediately, leaving
the sibling children that were already powered on in the same loop
iteration enabled.

Since probe deferral is a standard boot path, this leads to unbounded
regulator and clock enable increments across retries. The error path in
pci_pwrctrl_power_on_devices() only powers off the top-level children
processed before the failing one and explicitly stops at it, so it can
never clean up the siblings leaked deeper in the failed subtree.

Power off the sibling children that were successfully powered on before a
child fails, and power off all children if the device's own power_on()
fails after its children were already enabled. Switch to a manual child
iterator so the failing node can be tracked and its reference released in
the error path.

Fixes: b35cf3b6aa1e ("PCI/pwrctrl: Add APIs to power on/off pwrctrl devices")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-pwrtctl-power-on-rallback-v1-1-412ef996ba27@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pwrctrl/core.c b/drivers/pci/pwrctrl/core.c
index c14df117ece37..0e2387cf46577 100644
--- a/drivers/pci/pwrctrl/core.c
+++ b/drivers/pci/pwrctrl/core.c
@@ -252,14 +252,16 @@ static int __pci_pwrctrl_power_on_device(struct device *dev)
 static int pci_pwrctrl_power_on_device(struct device_node *np)
 {
 	struct platform_device *pdev;
+	struct device_node *child;
 	int ret = 0;
 
-	for_each_available_child_of_node_scoped(np, child) {
+	for_each_available_child_of_node(np, child) {
 		ret = pci_pwrctrl_power_on_device(child);
 		if (ret)
-			return ret;
+			goto err_power_off;
 	}
 
+	child = NULL;
 	if (!pci_pwrctrl_is_required(np))
 		return 0;
 
@@ -279,6 +281,19 @@ static int pci_pwrctrl_power_on_device(struct device_node *np)
 
 	platform_device_put(pdev);
 
+	if (ret)
+		goto err_power_off;
+
+	return 0;
+
+err_power_off:
+	for_each_available_child_of_node_scoped(np, tmp) {
+		if (tmp == child)
+			break;
+		pci_pwrctrl_power_off_device(tmp);
+	}
+	of_node_put(child);
+
 	return ret;
 }
 
-- 
2.53.0



