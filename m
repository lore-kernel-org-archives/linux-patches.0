Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9E2EBB8D;
	Tue, 21 Jul 2026 20:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666624; cv=none; b=gARH2TonSgdizIWFdft30Gxk8xke80TlOnQURWAdHE22AsBypPMYI4JKahuceaGacKqtaCqyhxOCNJ2dQu9TAoiJb+dIqsspFQ+XG4/SGS5Nl3qTnj8qJi8JAB3uT/1AkfYO/SYXPmf0O8D31HfsBykfOtORM+pXAHQllEoyUCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666624; c=relaxed/simple;
	bh=G9S4rBR9Du8wh2kmKN0gkTWxheVnG/mgTG23iou26Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taWxybavUOVoByv0uMq2Q7rRK/EWKvkOflXNDfrq7/iR+doO0AzE45EWqrVOfFuNhK/U+bXZWPiNjl4+6I5kgf+Di0NSlMIxuZWYd81NmuWaweeS8gup41RUC60+kBeG4J0KRrEv6oI1aMIW7SdRI0pQR2kyYUGirG1ueUWkv44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOf+pxT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOf+pxT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975E81F000E9;
	Tue, 21 Jul 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666623;
	bh=HjuKoGTlTkY7UrQ3PhUqnIWdCyrNoZ8a6fAvzFWwPbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOf+pxT4eCPzq7eQHgKMufyAhx692kjnGuRHwGbvF5n5ETPlhyZWb9k1FNamdTbkL
	 IvAHi1LgQX+BrbzTGsDjx6fxrXtnIv3lH+5VNboJBd/ExFc9EPMDjVGnjj9CGJXYl8
	 VMiT1tsjLjrEdbIvhEC+W52u2cd2Ep+q/q++kZAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0736/1266] ACPI: resource: Amend kernel-doc style
Date: Tue, 21 Jul 2026 17:19:33 +0200
Message-ID: <20260721152458.342807924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 531684a69c645d..672ccad447ccda 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -839,7 +839,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
 
 /**
- * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * acpi_dev_free_resource_list - Free resource from acpi_dev_get_resources().
  * @list: The head of the resource list to free.
  */
 void acpi_dev_free_resource_list(struct list_head *list)
@@ -959,7 +959,7 @@ static int __acpi_dev_get_resources(struct acpi_device *adev,
  *
  * The resultant struct resource objects are put on the list pointed to by
  * @list, that must be empty initially, as members of struct resource_entry
- * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * objects.  Callers of this routine should use acpi_dev_free_resource_list() to
  * free that list.
  *
  * The number of resources in the output list is returned on success, an error
@@ -1000,7 +1000,7 @@ static int is_memory(struct acpi_resource *ares, void *not_used)
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



