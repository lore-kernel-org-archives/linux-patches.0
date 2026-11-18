Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060798;
	b=capC7U63Ouf6ps3MDqy3+htjKWECVaJYtUziNQmOjaRQ9HR3hYhuI9QEGxp+oVVm1fMc
	 zkuhO1tocc0Tpszr4X9r8jVY3RNJfI6t4/O1EyWTw/MeFtyq0WlW4NkevxUHYo4c83yTv
	 jXt4iqpIzwLaqo3tCCj1P+c0lr7yiOLs2wGLeTaI3PgdPqPuar3V7lIBB0lNAW0OCAg1u
	 1QEBm1edqIx5WkGm3ypIEsJvQuDOsRIQ9lldHtRiPeSgoiay8qW8n0ucdN4g9jmPzGB4H
	 pCsjO4TcUJYdXf9dGk7FmgfuhaD7RvKqnB+3xZPzjtAYU/5k8+VaaJ+Zqfb6pCB65wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=InC90Q2OR5jb5YxMg/G6Tx+XyuZP1Gugwm29GURYSao=;
	b=aW2UCYKk6ipaZUpCKP6+ihRwFkRdy7FWaOTBNEPKrI3yP/Jc9RhF7PgAEGjXNmw4pjHh
	 Eludev5pf+bOHJUQwpsAojoofC64SRtS5vr4qEr5nRsCtttLvSZXfrRoOWGkyXDKBQWCo
	 Qe0cY0h0O3g/gPX/PC1S3pgBlHzwvxSTXRBZkiYpHTJYcYSqrXHr6E5Zx7pCIcCljebvq
	 UYTFf4FMJH4SJYLLNLICGO/GqbbuU42CRYdFq7s2lRcGROJw9wZal6CmGC3eRbtBG3AEP
	 vr0bpI7/kQLRGDVD/r4EnK81uniSi6RtQAILr76ssgdzRihvHAEn7he7wJMjHtSSldw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q1/6sMj7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9C4606A320;
	Thu, 19 Nov 2026 03:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1/6sMj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F731F000C4;
	Thu, 19 Nov 2026 03:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060797;
	bh=InC90Q2OR5jb5YxMg/G6Tx+XyuZP1Gugwm29GURYSao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1/6sMj7tIzCQaQ3mZMK9NYjhGMKyhEI+yu1FBXiVJeSwwyEWhRk9NbFZru0kDbKX
	 lAUxrMHHXhAnOpi4XVECh03CTY/NM2HAGuFHeDmUqleG5AryQFrtJKUPQbW+zK9jJf
	 uFEdrEH0gDGFpb/dFMMOBFEJD9wZ13soNXIdY/Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1326/1848] mfd: core: Add support for software nodes
Date: Wed, 18 Nov 2026 15:56:04 +0100
Message-ID: <20261118150015.276117208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 42e59982917a25ad254b74e6e8decee5e684763d ]

The old device property API is going to be removed and
replaced with the newer software node API. This prepares MFD
subsystem for the transition.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c   | 9 +++++++++
 include/linux/mfd/core.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index c0083e38d5273..0eb9cacbcfd44 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -253,6 +253,12 @@ static int mfd_add_device(struct device *parent, int id,
 			goto fail_of_entry;
 	}
 
+	if (cell->swnode) {
+		ret = device_add_software_node(&pdev->dev, cell->swnode);
+		if (ret)
+			goto fail_of_entry;
+	}
+
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
 		res[r].flags = cell->resources[r].flags;
@@ -313,6 +319,7 @@ static int mfd_add_device(struct device *parent, int id,
 			list_del(&of_entry->list);
 			kfree(of_entry);
 		}
+	device_remove_software_node(&pdev->dev);
 fail_alias:
 	regulator_bulk_unregister_supply_alias(&pdev->dev,
 					       cell->parent_supplies,
@@ -381,6 +388,8 @@ static int mfd_remove_devices_fn(struct device *dev, void *data)
 	regulator_bulk_unregister_supply_alias(dev, cell->parent_supplies,
 					       cell->num_parent_supplies);
 
+	device_remove_software_node(&pdev->dev);
+
 	platform_device_unregister(pdev);
 	return 0;
 }
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 8974c7142c94c..7a29d5389982c 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -50,6 +50,7 @@
 #define MFD_DEP_LEVEL_HIGH 1
 
 struct irq_domain;
+struct software_node;
 struct property_entry;
 
 /* Matches ACPI PNP id, either _HID or _CID, or ACPI _ADR */
@@ -78,6 +79,9 @@ struct mfd_cell {
 	void			*platform_data;
 	size_t			pdata_size;
 
+	/* Software node for the device. */
+	const struct software_node *swnode;
+
 	/* device properties passed to the sub devices drivers */
 	const struct property_entry *properties;
 
-- 
2.53.0



