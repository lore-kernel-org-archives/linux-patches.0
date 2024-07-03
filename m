Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B7413776F;
	Wed,  3 Jul 2024 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005409; cv=none; b=fJOy9XcNUYor19U8WSUPMwRcIXRFrKcxpMwrvKFZLbNvvj2Oha2zlCKyPkmZj/Ub1j5VmNDa0plUT+PxYB0sngHSWECTUAtd9iEcEyhgZmY08epnMs4fhD/4ua5wN8+fCvvvupK96y4JG8TZIXIyjf5cF7QnVcFkpDPH9gRR8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005409; c=relaxed/simple;
	bh=qLWbr8MxwSi+GbIFujEvHpak02CHXX7mXmqaSPG2Jko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4kFD3Bny2b+9Lggy73v0rfV9AdEx+UItRmKrTvVyvqLeAcm/NGi0nNmt+ew3pKukigmS1CyudMlF1QE8D2XNp4z/a1B5jxxqn2vUEH/KEtd0gqFlUWNA1RcalLoG5ySPnxUrqA7/2+SNnyZlIBAK7qY5pGB5X4uL2iMXJUpC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGbVdnLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGbVdnLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BBCC2BD10;
	Wed,  3 Jul 2024 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005408;
	bh=qLWbr8MxwSi+GbIFujEvHpak02CHXX7mXmqaSPG2Jko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGbVdnLEThxmaPF8R1DBgke1XBFJPMN7vQi88bj4SViSL7hFosPNsfT7lkT80xCbE
	 nzaQ9SI6MDi/76gSfqPZKXKLPvoBzfVKvW8RQZWzdzab2HQQ/Ekir+IXOocqdFc0hN
	 pzLJlOSwApTvjc7mmklcQ2S5N7Hjc5lqL25f1B60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/356] pvpanic: Keep single style across modules
Date: Wed,  3 Jul 2024 12:36:20 +0200
Message-ID: <20240703102914.763129825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 33a430419456991480cde9d8889e5a27f6049df4 ]

We have different style on where we place module_*() and MODULE_*() macros.
Inherit the style from the original module (now pvpanic-mmio.c).

Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210829124354.81653-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ee59be35d7a8 ("misc/pvpanic-pci: register attributes via pci_driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c | 14 ++++++--------
 drivers/misc/pvpanic/pvpanic.c     |  3 +--
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 741116b3d9958..7d1220f4c95bc 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -22,11 +22,6 @@ MODULE_AUTHOR("Mihai Carabas <mihai.carabas@oracle.com>");
 MODULE_DESCRIPTION("pvpanic device driver ");
 MODULE_LICENSE("GPL");
 
-static const struct pci_device_id pvpanic_pci_id_tbl[]  = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_PVPANIC)},
-	{}
-};
-
 static ssize_t capability_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -99,6 +94,12 @@ static int pvpanic_pci_probe(struct pci_dev *pdev,
 	return devm_pvpanic_probe(&pdev->dev, pi);
 }
 
+static const struct pci_device_id pvpanic_pci_id_tbl[]  = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_PVPANIC)},
+	{}
+};
+MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
+
 static struct pci_driver pvpanic_pci_driver = {
 	.name =         "pvpanic-pci",
 	.id_table =     pvpanic_pci_id_tbl,
@@ -107,7 +108,4 @@ static struct pci_driver pvpanic_pci_driver = {
 		.dev_groups = pvpanic_pci_dev_groups,
 	},
 };
-
-MODULE_DEVICE_TABLE(pci, pvpanic_pci_id_tbl);
-
 module_pci_driver(pvpanic_pci_driver);
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index b9e6400a574b0..477bf9c6b6bc5 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -107,6 +107,7 @@ static int pvpanic_init(void)
 
 	return 0;
 }
+module_init(pvpanic_init);
 
 static void pvpanic_exit(void)
 {
@@ -114,6 +115,4 @@ static void pvpanic_exit(void)
 					 &pvpanic_panic_nb);
 
 }
-
-module_init(pvpanic_init);
 module_exit(pvpanic_exit);
-- 
2.43.0



