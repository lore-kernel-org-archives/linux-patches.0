Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3235438E8AB;
	Tue, 21 Jul 2026 19:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662815; cv=none; b=aYJB/3duJtmoWN2N+NrP3+4R5WFcvKEs3WeJ1fTe4rh0/9RwSPgQFV+lm8EtYwkBxri9z/h2P6PIJ8tgnX/7eg9y1lmnBPeM+q0hwbO0GHbN0kW/VcKWl1lSgig1HS8dtUw2Glf6nt+kWA4tSjnEGvlZbJ3OWE3VAb48xoqXVyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662815; c=relaxed/simple;
	bh=lzLBcLQoEAy9BAnye9jQRSAVYeqWPUzM39UqBoea3qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPBJoyWi1qWklcT1LM8sYhjn/V9eoDLLawLCt79ANEKn2+Hla8WHmKHCm+IyZTbNcUhwqXOk9XiBGnOrC6iPaTHvAvqowN3bjRpcUSFXnXJumrzY6lMsRXN3b2twWjc8FSGzFRKZbL3Y73xeM61jpdXpuo6DhcDeDWx0w3OFesE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze1JQ/Sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze1JQ/Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9874F1F000E9;
	Tue, 21 Jul 2026 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662814;
	bh=c41rybIv/cCW8Cq3oc49Ku9Uyvyk7PZ9CjSJrLkoXBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ze1JQ/ShuhSfr2inIHlGDkhmOAvumiQo1L8b76xL/ktYMkwJLWK0WHEUZioDA+54/
	 RE3pZe/ZRmzUYrJYcZjMTppswc1MrqehxvCNnHRNNfPU0aVHoUQVkMifu5rYTlpJzC
	 trsmtPXGdDQg1Sn9GCRe4WX4vut1/8+erC8MTSDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0586/1276] ACPI: resource: Amend kernel-doc style
Date: Tue, 21 Jul 2026 17:17:09 +0200
Message-ID: <20260721152459.229489764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a01a3718aa94f..a15f390fa360bb 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -863,7 +863,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
 
 /**
- * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * acpi_dev_free_resource_list - Free resource from acpi_dev_get_resources().
  * @list: The head of the resource list to free.
  */
 void acpi_dev_free_resource_list(struct list_head *list)
@@ -983,7 +983,7 @@ static int __acpi_dev_get_resources(struct acpi_device *adev,
  *
  * The resultant struct resource objects are put on the list pointed to by
  * @list, that must be empty initially, as members of struct resource_entry
- * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * objects.  Callers of this routine should use acpi_dev_free_resource_list() to
  * free that list.
  *
  * The number of resources in the output list is returned on success, an error
@@ -1024,7 +1024,7 @@ static int is_memory(struct acpi_resource *ares, void *not_used)
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



