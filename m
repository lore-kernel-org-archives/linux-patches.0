Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98E4350855;
	Tue, 26 Aug 2025 14:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218801; cv=none; b=WK8BLCb4BSCjdk8LeBcKHTVF6+xRm+bNnXUdJlWHb75jBx62l2y5/mM9wAhPZWxBcyBn/sCZkUoC9MgnjGdMFd3sA/JPmNHojY3Mb79KSSZYOiCjnF9TkAraK3HFGMXVCCwVCVHfkDDG5x2WaKc4tSUIyM7NBmWaaLoQko9ys4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218801; c=relaxed/simple;
	bh=fkNDV/k+a3Hy1fHlrwAD6LWSwBwKnqI/lWe/kqJAMBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHhUeyGJ/dqG6lsgIWd5QnVw4ua3ny111lZmb7ElZ3VKoBn8e9Ou0tuDN6IhJizCXvIh5dobNUPlG62SGsCfRoy8xCKePsGlUI7BV+aMkz48o3ZVd+uLnCO51ziVo+VV77Ysb2NNegx5oVG9KSh8so+ik50A8KKX30U4R+Rr4Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mpcx6zsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mpcx6zsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DBAC4CEF1;
	Tue, 26 Aug 2025 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218801;
	bh=fkNDV/k+a3Hy1fHlrwAD6LWSwBwKnqI/lWe/kqJAMBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mpcx6zsinzypz+YMaXKDwHjW21/9DkRkftmEw/EJcNbw+aZYxhY++S/G2tpPVx9SO
	 EMjnAuIRVM97irHynMqN7A4ZYzUs7qj5iHyyxS1NTf/ZxAFOf728U0ZPl9/K4WLBGH
	 FSZ07BM+qDRkN/CoxSgmT8x7e4fa+QqD/S6EmEXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alastair DSilva <alastair@d-silva.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/403] pci/hotplug/pnv-php: Improve error msg on power state change failure
Date: Tue, 26 Aug 2025 13:07:44 +0200
Message-ID: <20250826110910.561331780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 323c2a26ff43500a96799250330fab68903d776f ]

When changing the slot state, if opal hits an error and tells as such
in the asynchronous reply, the warning "Wrong msg" is logged, which is
rather confusing. Instead we can reuse the better message which is
already used when we couldn't submit the asynchronous opal request
initially.

Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191121134918.7155-8-fbarrat@linux.ibm.com
Stable-dep-of: 466861909255 ("PCI: pnv_php: Clean up allocated IRQs on unplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index 382494261830..8223fe0b751f 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -341,18 +341,19 @@ int pnv_php_set_slot_power_state(struct hotplug_slot *slot,
 	ret = pnv_pci_set_power_state(php_slot->id, state, &msg);
 	if (ret > 0) {
 		if (be64_to_cpu(msg.params[1]) != php_slot->dn->phandle	||
-		    be64_to_cpu(msg.params[2]) != state			||
-		    be64_to_cpu(msg.params[3]) != OPAL_SUCCESS) {
+		    be64_to_cpu(msg.params[2]) != state) {
 			pci_warn(php_slot->pdev, "Wrong msg (%lld, %lld, %lld)\n",
 				 be64_to_cpu(msg.params[1]),
 				 be64_to_cpu(msg.params[2]),
 				 be64_to_cpu(msg.params[3]));
 			return -ENOMSG;
 		}
+		if (be64_to_cpu(msg.params[3]) != OPAL_SUCCESS) {
+			ret = -ENODEV;
+			goto error;
+		}
 	} else if (ret < 0) {
-		pci_warn(php_slot->pdev, "Error %d powering %s\n",
-			 ret, (state == OPAL_PCI_SLOT_POWER_ON) ? "on" : "off");
-		return ret;
+		goto error;
 	}
 
 	if (state == OPAL_PCI_SLOT_POWER_OFF || state == OPAL_PCI_SLOT_OFFLINE)
@@ -361,6 +362,11 @@ int pnv_php_set_slot_power_state(struct hotplug_slot *slot,
 		ret = pnv_php_add_devtree(php_slot);
 
 	return ret;
+
+error:
+	pci_warn(php_slot->pdev, "Error %d powering %s\n",
+		 ret, (state == OPAL_PCI_SLOT_POWER_ON) ? "on" : "off");
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pnv_php_set_slot_power_state);
 
-- 
2.39.5



