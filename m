Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062233;
	b=LKFXtATv49aVd4bEl9WH75/HyLL1CBds6DSp9iu2dy3YSYwV4fcLrwqX1bYgULXKDDy7
	 3HoD4V3aUH2hoVd4zm309jueYHP231Xz27//2lnWv5ymw5KUaJTrI5ImvYH7v2nRA93tw
	 fbgvC/N0Ad1Got2eqNg7ckE/d+LnXg5CNBQ4nia5eNw/m+IY4TBRR6S/wRwhwfGsWLvWw
	 Vq/gB+CDwuQr2zNKf0XqXCxwLFgRwknNe9fND5WUQO9DFGhhrA0uPytLvEaNA7B4N5g1j
	 7CnP46xa54XZB2chaldZjw8F4XSMBoCGRk63B27pbDYDXQA8KYahkNTQXNGxwQPf1yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8C67s+JC6QDz1dRRCg9XtcOaiWp1SVoZzCanecd/S6A=;
	b=fS2oY9/B9+AE3QC+l+lquAxvBT6POzsNfNSqCJXW1Ct/mJV1zMcIteV2AgZUfY40FPEY
	 W52oz9UMxoCwtTRKx+wEpLk7Od6pRyCx89u80Y4nFkm+PCS5SPk9eDX1rrdnn648SphDe
	 CgdRmtQ33wbTtyvjpQs7eHycdoozu1LrOsrIdQJwMz8C+e+8kQWU1sIvUub5qFoXyYyNI
	 nx7lYHimTtDyGOgi5ZLAhxADuKs22Hc3Mh+jUi22OLufy3UTA1Q4Gx+oafBWg3n4X6IR3
	 QrhpmEPxj3GWCzkfPKnyUMh27o1CDcMtBmprmXjB2ggBpZxSRLFveHxIywHIelJrl5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aHvYQnDo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D9A606A320;
	Thu, 19 Nov 2026 04:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aHvYQnDo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8A51F000C4;
	Thu, 19 Nov 2026 04:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062233;
	bh=8C67s+JC6QDz1dRRCg9XtcOaiWp1SVoZzCanecd/S6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHvYQnDoRtraCi6L5q2DksyMgqn22V7jtIQNbMI4WSghPZXn3yYnBAzaYECHmlfa5
	 X5QweoznC5G9dg+CnxLa8CJAcwIYtXbUqMJNaxfKxmO8y7QwcxQLZgmcDyBG2bSqs0
	 hqmxigwAOTGP6bgzsc6TqN8BW8ZEWONgqq2iyQho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.10 1837/1848] mfd: Remove software node conditionally and locate at right place
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150036.505964996@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 5a23e8b0fd6010e25ae58362292235cc9213ca57 upstream.

Currently the software node is removed in error case and at ->remove()
stage unconditionally, that ruins the symmetry. Besides, in some cases,
when mfd_add_device() fails, the device_remove_software_node() call
may lead to NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 00000000
  ...
  EIP: strlen+0x12/0x20
  ...
  kernfs_name_hash+0x13/0x70
  kernfs_find_ns+0x32/0xc0
  kernfs_remove_by_name_ns+0x2a/0x90
  sysfs_remove_link+0x16/0x30
  software_node_notify.cold+0x34/0x6b
  device_remove_software_node+0x5a/0x90
  mfd_add_device.cold+0x30a/0x427

Fix all these by guarding device_remove_software_node() with a conditional
and locating it at the right place.

Fixes: 42e59982917a ("mfd: core: Add support for software nodes")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/mfd-core.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -293,18 +293,18 @@ match:
 			if (has_acpi_companion(&pdev->dev)) {
 				ret = acpi_check_resource_conflict(&res[r]);
 				if (ret)
-					goto fail_of_entry;
+					goto fail_res_conflict;
 			}
 		}
 	}
 
 	ret = platform_device_add_resources(pdev, res, cell->num_resources);
 	if (ret)
-		goto fail_of_entry;
+		goto fail_res_conflict;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-		goto fail_of_entry;
+		goto fail_res_conflict;
 
 	if (cell->pm_runtime_no_callbacks)
 		pm_runtime_no_callbacks(&pdev->dev);
@@ -313,13 +313,15 @@ match:
 
 	return 0;
 
+fail_res_conflict:
+	if (cell->swnode)
+		device_remove_software_node(&pdev->dev);
 fail_of_entry:
 	list_for_each_entry_safe(of_entry, tmp, &mfd_of_node_list, list)
 		if (of_entry->dev == &pdev->dev) {
 			list_del(&of_entry->list);
 			kfree(of_entry);
 		}
-	device_remove_software_node(&pdev->dev);
 fail_alias:
 	regulator_bulk_unregister_supply_alias(&pdev->dev,
 					       cell->parent_supplies,
@@ -385,11 +387,12 @@ static int mfd_remove_devices_fn(struct
 	if (level && cell->level > *level)
 		return 0;
 
+	if (cell->swnode)
+		device_remove_software_node(&pdev->dev);
+
 	regulator_bulk_unregister_supply_alias(dev, cell->parent_supplies,
 					       cell->num_parent_supplies);
 
-	device_remove_software_node(&pdev->dev);
-
 	platform_device_unregister(pdev);
 	return 0;
 }


