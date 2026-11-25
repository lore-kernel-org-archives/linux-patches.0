Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620928;
	b=kmr1cB+vh+lqOV6JH6+Q1JppZU0p/jvKDkNt5qdMw7EFcyuwQRT4c4X8bk2AH1mXRynt
	 +ECPTXzbiWF7OOR3wayU9/RNQifYpHOLlogzx6MXRqWm3KCZueMVGcXZ8TPLCMeEWVv+R
	 3zlDDDx/n0zF3QolIkRNSEbioREC4DeM0YWb+yCe7Wx+9cFImQ4lCUGZfPlLS/0lJVZyZ
	 4ISKN7Plz8RFmODSjmb5FcCLkyBgh4G6ooeeRYipXBx0Btu3b+KKCvxpZqJcsbYri+eAX
	 VGpoApAOY7jaGMAtCZLnBkFSS73t5ndF3/kXeox4phZdGeI8ZE4SPm47dBXVkMTpdVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQwc3NR182Uz5Q0RotUt8Jg+/oGPUixgzRS3J6zyL+4=;
	b=lheE4CjUxD2jS2g+sISUwm4Lr6A9Ek8qJrUpOzN/e9otVOWmB0/ey19KF0Pu0H16+6vO
	 py4W4BfIdRe1xee3asYLOwMgzYtOWbsGlFWCSdJqAJ6Q45ycvyxJsJu1UFHHhGZe/WaDA
	 pjzHkdNXeJRR2GsApq1TO1R73OmzlMVXGme6gotLMXeYrGTHDZao6NVQFgrfkKtXumheZ
	 XAeR2/2zRiXsM2Eu2Gjab3jJxY2VNK19CzZ2uRR7mLZIyHYEB9xvQecZb4eSxVoEg0ReS
	 XEbHd+vnF5B1O2OTFVTDkyUUW/oW1qtY/uiWsu45X8r/823AIeARITlp+sHkDOiOYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUHXDvd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5461860A262A;
	Wed, 25 Nov 2026 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUHXDvd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700251F0156B;
	Wed, 25 Nov 2026 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620928;
	bh=oQwc3NR182Uz5Q0RotUt8Jg+/oGPUixgzRS3J6zyL+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUHXDvd5b46rjEy0tAVm8tJlcve60+Ie6GGIVEWNNUCcJ+NpA5RT8xlqtctSm5Cfc
	 EoLYVXCday/Eg3wDYvnq9fcYzZDJbTOU3UCgC6tT9zbMsBVd0WOU9GrWKgRSti1M4B
	 r/DsFTJTKYaR7oVOsYUA4JV78YFMKHRyh19VQwns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/990] ACPI: platform: Use acpi_bus_get_primary_device()
Date: Wed, 25 Nov 2026 15:23:09 +0100
Message-ID: <20261125143822.607994396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit a9ba4dd2f18bf3f439d9ef0d8f375f90360ba1bd ]

The acpi_get_first_physical_node() usage in acpi_platform_fill_resource()
and acpi_create_platform_device() is generally unsafe because in theory
the device returned by it may be freed at any time [1].

It is also inefficient because acpi_get_first_physical_node() is called
multiple times for the same argument which can be avoided.

Address these issues by using acpi_bus_get_primary_device() instead of
acpi_get_first_physical_node() and adjusting the code to call it just
once at the beginning of and acpi_create_platform_device() and drop
the device reference acquired by it upon the return from that function.

Fixes: 3b95bd160547 ("ACPI: introduce a function to find the first physical device")
Fixes: a252d881c558 ("ACPI / platform: Pay attention to parent device's resources")
Link: https://sashiko.dev/#/patchset/12955541.O9o76ZdvQC%40rafael.j.wysocki [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/3436112.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_platform.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 62ab6d7f37212..49c2d6734de58 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -108,18 +108,15 @@ static unsigned int acpi_platform_adjust_resources(struct acpi_device *adev,
 	return count;
 }
 
-static void acpi_platform_fill_resource(struct acpi_device *adev,
-	const struct resource *src, struct resource *dest)
+static void acpi_platform_fill_resource(struct device *parent,
+					const struct resource *src,
+					struct resource *dest)
 {
-	struct device *parent;
-
 	*dest = *src;
-
 	/*
 	 * If the device has parent we need to take its resources into
 	 * account as well because this device might consume part of those.
 	 */
-	parent = acpi_get_first_physical_node(acpi_dev_parent(adev));
 	if (parent && dev_is_pci(parent))
 		dest->parent = pci_find_resource(to_pci_dev(parent), dest);
 }
@@ -147,7 +144,8 @@ static unsigned int acpi_platform_resource_count(struct acpi_resource *ares, voi
 struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 						    const struct property_entry *properties)
 {
-	struct acpi_device *parent = acpi_dev_parent(adev);
+	struct acpi_device *p = acpi_dev_parent(adev);
+	struct device *parent __free(put_device) = acpi_bus_get_primary_device(p);
 	struct platform_device *pdev = NULL;
 	struct platform_device_info pdevinfo;
 	const struct acpi_device_id *match;
@@ -193,7 +191,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 								       rentry->res,
 								       resources,
 								       count);
-				acpi_platform_fill_resource(adev, rentry->res,
+				acpi_platform_fill_resource(parent, rentry->res,
 							    &resources[count++]);
 			}
 			acpi_dev_free_resource_list(&resource_list);
@@ -206,7 +204,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 	 * attached to it, that physical device should be the parent of the
 	 * platform device we are about to create.
 	 */
-	pdevinfo.parent = parent ? acpi_get_first_physical_node(parent) : NULL;
+	pdevinfo.parent = parent;
 	pdevinfo.name = dev_name(&adev->dev);
 	pdevinfo.id = PLATFORM_DEVID_NONE;
 	pdevinfo.res = resources;
-- 
2.53.0



