Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2DF3BCD04;
	Tue, 21 Jul 2026 21:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669533; cv=none; b=CP//p3FfB/biv2nEYXYS9XIXGK18Ixp19esbO+IyDsadQTqYH5R0HZsywEzvGzlr66CVGQ9u6++eXfyGnJkAtpV/9macHtRKORQ3ImJbRPgK8quxNmwDkQ993Yp78FoO6TEAXEyCpH/8eT79Mwf/jwTFGQmfNQQQcuzMOtQUjew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669533; c=relaxed/simple;
	bh=4YphJ5G7UC12kfJMXlGEPfUuVZUs6/E4J7PO3T3uHbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4W3uTfn2f7fQzoarsIrvFrPVcfdmMyJMGEorzIUHJeE/nc/nGVZT13AJFlYabvGr8j6SGTtb6upqRx6KoPe9DhSoVmUyIJ04ahztw3Wbsf6jDK6AzOj+YlnUI7OlhPvHsXSYcIzG5z4t5dn98RMVpRre9lKFL24ye11pWtpnPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysMXkCmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysMXkCmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007B61F000E9;
	Tue, 21 Jul 2026 21:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669531;
	bh=q5B0twCIxvQxpytponuWaO0+l7X/fEQQbyvbh0TjuaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysMXkCmUv763juBtUUK5kPSBXUEf0h9m3Wf+7IBGHgDusPDg99EVUqT8ypz6kXBBT
	 rg9oaqm2Pc3wxfvy+jQSlBw5Dtz5vEFN21nbAu2eyNLV/kBaQyUdbjHCn4lU7OaDia
	 YRUz39H9FSLW//kyahEH193iVPY8P/izqibKXPCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0590/1067] ACPI: resource: Amend kernel-doc style
Date: Tue, 21 Jul 2026 17:19:51 +0200
Message-ID: <20260721152437.803736721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd513335f08656..a3d40503e7964a 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -810,7 +810,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
 
 /**
- * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * acpi_dev_free_resource_list - Free resource from acpi_dev_get_resources().
  * @list: The head of the resource list to free.
  */
 void acpi_dev_free_resource_list(struct list_head *list)
@@ -930,7 +930,7 @@ static int __acpi_dev_get_resources(struct acpi_device *adev,
  *
  * The resultant struct resource objects are put on the list pointed to by
  * @list, that must be empty initially, as members of struct resource_entry
- * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * objects.  Callers of this routine should use acpi_dev_free_resource_list() to
  * free that list.
  *
  * The number of resources in the output list is returned on success, an error
@@ -971,7 +971,7 @@ static int is_memory(struct acpi_resource *ares, void *not_used)
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



