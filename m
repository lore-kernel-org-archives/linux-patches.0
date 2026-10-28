Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209623;
	b=iJBWnQV4ad/LCGY+z9MaajogK6PEbeAWLNQ9pwQjkK23yht+D9v7SY53Sbz6AwLYSp22
	 wAmpbJOdsb/FrlkHUFGBOgFIyQOz4YRLZOjMhvuJpyLQ3x0diJmUSh1ANpMAV2zk9gvyJ
	 Trryso9wPRMUKw+K83lsUrLSQGiJH94+BdYp32SxMFYeAfwZlW4WNlS0+csblTpJELtwk
	 /U02C3dOsWheI3GBX/8IEa4SAJMa9Q4bokyPyu7BxGXA/6q27nqalJjQstWkTx+Ufayb6
	 5VDkj7v1WBK6Vcy4Lm3qSJYqiM7LY5+CLmlCS6sPKskf+sLJ5C6rsZouM2IiHQzLsPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=caQ7K0BQ/wDjG0mjR+tU//c/95MJgBZmpB/HktYQoaY=;
	b=QWeOap1LE9WRAmo88kkJPGRT3kxp8CbpczIR1xCb7NpGywqvQBjXve0QjPgvnb1OVbwt
	 hNJkPobWPAZZaTgD4AtAPm80hl+NpVKYhAGt2B4KRyvjNc2+99FRRSc/plpvUQUDicafN
	 pFEAFPCTmAnTDSKBd1pbdnmjEJQieRETn+GFnPqV1BDjO01tzPYAWQcT/VJ1FC5tMQVwv
	 F4+aE+uG9qwN5cfXdd/Ak55BNgH4o2fB0X6GfrEL08JOJY9z5eCarchIH76gtVQPWJqmo
	 t1/Y8E3AwN+jDjxoPz01qYzNqd/3IzCtxhAKYTM+yZQ8U8qPqt+PVJl9jwbcE/E+B4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1OOB/eY1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDFB606A31D;
	Wed, 28 Oct 2026 17:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OOB/eY1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190D01F01825;
	Wed, 28 Oct 2026 17:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209622;
	bh=caQ7K0BQ/wDjG0mjR+tU//c/95MJgBZmpB/HktYQoaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OOB/eY1n8Delq2kbx5fD08h5IhxTVMEiK/V7d565jtPN5bJ7POTMgpGmx77Qc4MA
	 BEhxTlqW7woZU+fXQrYihY0wpdScLzIHvEzjNKtwIQOaUvQ6VLTvWM0i97PZtV0xbg
	 RO5J5EbXQxDrYBXP6jgLOyNj16NGB4ifJLZ2u0tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/109] ACPI: scan: Register platform devices for fixed event buttons
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028165942.416640735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit ab06eb9204010c61e754bf4e71ee6f554584714d ]

On platforms using ACPI, power and sleep buttons may be so called "fixed
event devices" in which case they are hooked up directly to the Fixed
Events register in the platform via dedicated lines and there are no
corresponding device objects in the ACPI namespace.  Nevertheless, in
Linux they get corresponding struct acpi_device objects with special
device IDs, either LNXPWRBN or LNXSLPBN, which are then used for driver
binding in a ususal way.

However, the function creating those struct acpi_device objects for
"fixed event device" buttons, acpi_bus_scan_fixed(), does not register
platform devices for them, unlike the generic code handling device
enumeration based on the ACPI namespace.  Consequently, if an ACPI power
or sleep button is represented by a device object in the ACPI namespace,
it will get a corresponding platform device, but if it is a "fixed event
device", it will not get one, which is inconsistent and prevents the
ACPI power button driver from being converted into a platform driver.

For the sake of consistency and to allow the ACPI power button driver to
become a platform one going forward, modify acpi_bus_scan_fixed() to
register platform devices for "fixed event device" buttons and update
ACPI platform device registration code to work with non-device ACPI
object types, so it can handle the buttons in question.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3731144.R56niFO833@rafael.j.wysocki
[ Ting-Han: 52d864019636 ("ACPI: button: Convert the driver to a platform
  one") was backported to 6.18.57 as a dependency of fe80251152fe
  ("ACPI: button: Fix ACPI GPE handler leak during removal") without this
  prerequisite, so fixed event power buttons (LNXPWRBN, e.g. on QEMU q35)
  have no platform device and are no longer bound to any driver. ]
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_platform.c | 38 ++++++++++++++++++++----------------
 drivers/acpi/scan.c          |  4 ++++
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 48d15dd785f6e..52c8d602f3a57 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -114,10 +114,8 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 	struct platform_device *pdev = NULL;
 	struct platform_device_info pdevinfo;
 	const struct acpi_device_id *match;
-	struct resource_entry *rentry;
-	struct list_head resource_list;
 	struct resource *resources = NULL;
-	int count;
+	int count = 0;
 
 	/* If the ACPI node already has a physical device attached, skip it. */
 	if (adev->physical_node_count)
@@ -137,22 +135,28 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 		}
 	}
 
-	INIT_LIST_HEAD(&resource_list);
-	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
-	if (count < 0)
-		return NULL;
-	if (count > 0) {
-		resources = kcalloc(count, sizeof(*resources), GFP_KERNEL);
-		if (!resources) {
+	if (adev->device_type == ACPI_BUS_TYPE_DEVICE) {
+		struct list_head resource_list = LIST_HEAD_INIT(resource_list);
+
+		count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
+		if (count < 0)
+			return ERR_PTR(-ENODATA);
+
+		if (count > 0) {
+			struct resource_entry *rentry;
+
+			resources = kcalloc(count, sizeof(*resources), GFP_KERNEL);
+			if (!resources) {
+				acpi_dev_free_resource_list(&resource_list);
+				return ERR_PTR(-ENOMEM);
+			}
+			count = 0;
+			list_for_each_entry(rentry, &resource_list, node)
+				acpi_platform_fill_resource(adev, rentry->res,
+							    &resources[count++]);
+
 			acpi_dev_free_resource_list(&resource_list);
-			return ERR_PTR(-ENOMEM);
 		}
-		count = 0;
-		list_for_each_entry(rentry, &resource_list, node)
-			acpi_platform_fill_resource(adev, rentry->res,
-						    &resources[count++]);
-
-		acpi_dev_free_resource_list(&resource_list);
 	}
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7f9dd2704f638..c382bed50d6cb 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2644,6 +2644,8 @@ static void acpi_bus_scan_fixed(void)
 				device_init_wakeup(&adev->dev, true);
 			else
 				dev_dbg(&adev->dev, "No driver\n");
+
+			acpi_default_enumeration(adev);
 		}
 	}
 
@@ -2656,6 +2658,8 @@ static void acpi_bus_scan_fixed(void)
 			adev->flags.match_driver = true;
 			if (device_attach(&adev->dev) < 0)
 				dev_dbg(&adev->dev, "No driver\n");
+
+			acpi_default_enumeration(adev);
 		}
 	}
 }
-- 
2.53.0



