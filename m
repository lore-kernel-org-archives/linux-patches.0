Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033973;
	b=VZd80Vz/ey3XZnTmqJDzgINntfXyB0pC6sIkfCg+evpE8whSVe8FZudXrrW7EgaiQhWD
	 pUJ6Yp+TFFVO2xpv1dwu1arvsZQm9+waDOBq1E++pPiya8w+RHD5ilPNEVvbtvoq6lODa
	 FHSo2/sp9ARk5xMdNitBx2a4paQWNcZ+AM9bsuud0n7VdS62ISJxB2eWeJzuM1C08sJHg
	 hZwr+WYyO8Ghk8/yhiLj4uz02d0FI1ry0aL5y1MDngBIS1Lt05k+dufZuwFWOYooY9BfH
	 3O24rhje4bi7QL2A6LKpB1y4GIlxFB1S7QKA3SuwEf9FfK5J48PMdzX6MGo02dhTg8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KgDHY5iWTdf2mmYH3sNIakvNlDN8dT2+alRHkCwqg+I=;
	b=F0WfC01QvgDJmu0AWkMNB9WMxs4j5x2nUFGPvKMu2KeMufxXOAjnBMYSHOsWZi2VBrDo
	 B01MvcKpwcNqtyLC+Dqg8ztbebBoN3WKo4NwoZU2CA7eFZAa8Ox0VeLreavItNaSiZQUv
	 RCDS1F8xA/hnWplsRbbGLYrV6CPQLNfp8/OMh8sn3UatqF7uRkvcHVXUHQDetjp/4VCy9
	 pzgRRtrZO9Be6moWrKW/6prNpSo4OYzNhlmSSTqfvt4UylH00rVZKUfyS22aKjE1g4OEq
	 5tlXKQR108o/yBMmE3kM6bZsqV7D6xAipeQBPZ9M+SYkEG+ogtlbVN3Q2PDzLY0p/jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEcq1yEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85CA606A32F;
	Wed, 18 Nov 2026 20:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEcq1yEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB291F000C5;
	Wed, 18 Nov 2026 20:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033973;
	bh=KgDHY5iWTdf2mmYH3sNIakvNlDN8dT2+alRHkCwqg+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEcq1yEUXUpivRmyu7Bwy1xi5gitk9D6j8RpiWsixEI04hrxQiWLXjGMDa7bJR8uR
	 qUflDXRKdLa5zQoLUtPgNcAV+u7q5KYSBVIsiWH6lvpndANNSm/oN4BbWr0d+SJXGi
	 2zB3+/ggm9ZHeydRCK7OmlT3VrVflf+bCAzS1P0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0164/3318] thermal: intel: int340x: clean up RFIM groups on DVFS failure
Date: Wed, 18 Nov 2026 15:13:06 +0100
Message-ID: <20261118150319.517200803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28f34d7dafa6dfa657efd6760b7c78e98c9b2f6a ]

proc_thermal_rfim_add() can create the FIVR and DLVR sysfs groups
before creating the DVFS group.

If DVFS group creation fails while both earlier groups are enabled, the
current error handling removes only one group: the FIVR branch returns
before the DLVR cleanup branch can run.  This leaves the DLVR group
behind even though RFIM setup fails.

Use one DVFS failure path that removes all previously created RFIM
groups before returning the error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_rfim.c    | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 8bcac4adb9ece..15cc513110aab 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -357,12 +357,11 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DVFS) {
 		ret = sysfs_create_group(&pdev->dev.kobj, &dvfs_attribute_group);
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
-			return ret;
-		}
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+		if (ret) {
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR)
+				sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR)
+				sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
 			return ret;
 		}
 	}
-- 
2.53.0



