Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89250346771;
	Tue, 21 Jul 2026 22:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672106; cv=none; b=sUqu9MlAOxEXOOq1P1Bzpe15P77gZk6XyRQs3Xx3qVtUj5kjhNCxQnFpH9VYDqdyyuPWpGBbhmdhzZ8mH6foVwnnO2+PTdzplOJbcRGXjCksif3imdiQuamxf3Vt+cFCFfHY0OfApu9Fgn5zQISDa56OSKMmY3ZwH+FgG0bhFro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672106; c=relaxed/simple;
	bh=lvcQ5t3mLdtcJ4nLR5z3XlJc3vKQQIry3GIXit0Aabk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaN6RqwEK6RFR9ZZQtkNiv+Uv9yk+h2FTd85zZMHMTkYjUYeWuV1NCKW8D0H+rILZsNpl9jdwPb9ZdfQOxNaXPoQIDYok3fEtDf5S1d1yLPm/3CL6BZnYiZ3/dtCP29CUcbMfSPShtNVgd6kmivP/sVxweCujkbCO/u1jqfsf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8NgBQbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8NgBQbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4491F00A3A;
	Tue, 21 Jul 2026 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672105;
	bh=YuJVjnKxGFrB8N7zu8TOoAHEYNKiocGW/d9dpiaoERs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8NgBQbKoXigXlp6+P1drZiHiy0CXenNiySj3d3jkuR4nrgJPLvCqyNqFjXa6fLU8
	 a/3A9p6PEUXOcqJe5rrnNI8OdvWIT6wSfYwwYUmhO1Ja+FGTIaQz7dU9SuXKaDhME1
	 3Mynb8uaMZBjW6t8kG4pC5Ci/pUH39TMWj/oueVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/843] ACPI: resource: Amend kernel-doc style
Date: Tue, 21 Jul 2026 17:21:22 +0200
Message-ID: <20260721152416.083623686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 78ad5c7722b7bed9d35ffc5b45eb0f12e2c22fee ]

The functions are referred as func() in the kernel-doc. The % (percent)
character makes the rendering for constants as described in the respective
documentation. Amend all these.

Fixes: 8e345c991c8c ("ACPI: Centralized processing of ACPI device resources")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260617090555.2648709-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 7c08cf69ca3119..88221d67cfbd3f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -808,7 +808,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
 
 /**
- * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * acpi_dev_free_resource_list - Free resource from acpi_dev_get_resources().
  * @list: The head of the resource list to free.
  */
 void acpi_dev_free_resource_list(struct list_head *list)
@@ -928,7 +928,7 @@ static int __acpi_dev_get_resources(struct acpi_device *adev,
  *
  * The resultant struct resource objects are put on the list pointed to by
  * @list, that must be empty initially, as members of struct resource_entry
- * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * objects.  Callers of this routine should use acpi_dev_free_resource_list() to
  * free that list.
  *
  * The number of resources in the output list is returned on success, an error
@@ -966,7 +966,7 @@ static int is_memory(struct acpi_resource *ares, void *not_used)
  * The resultant struct resource objects are put on the list pointed to
  * by @list, that must be empty initially, as members of struct
  * resource_entry objects.  Callers of this routine should use
- * %acpi_dev_free_resource_list() to free that list.
+ * acpi_dev_free_resource_list() to free that list.
  *
  * The number of resources in the output list is returned on success,
  * an error code reflecting the error condition is returned otherwise.
-- 
2.53.0



