Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E661D471273;
	Tue, 21 Jul 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657599; cv=none; b=FJD5+kL75i6Ro6KCO7GC0uIZlY9UL9Za2NsrchPsadS3pOGhdfUuXa+1xKL+HUXtBDleNWNewBa4WaQQrALl8jGvKOU5zdswY/2Xm8pgxsXor8AID3iloVSljvrbJCjUFFMPm5eaL4hStdGQG4gUCYYZ2WNc8prCRYGp972ykQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657599; c=relaxed/simple;
	bh=i3kAiToty831wZ9CTD8x7oDKFItraKo9tDq8zW/WYUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzvTAOqTWCyPVdr3v3Me4rNr4xRAieJQ4Hz6Ia1wtt1QpfSLL0+jp3ZLfMDRMlPpyi96A4ZbFM+iNx0xHOHoxQNn2Pzujd3U8qEK9E3dVJsh4w5RxOtcSG+54m8ZSZEONyLYi7HncbALlGNMf2qGoNmSz8K53SQ0C12RZcqS16M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gObBQHhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gObBQHhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CFB1F000E9;
	Tue, 21 Jul 2026 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657597;
	bh=EQYE49gr99jW6GP0zFxEmcNka5TwpiWrKtxO9rmfmfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gObBQHhVlfW7CoQW2As0hj7PMOiitHIH1wY1eJ4eMbY+bXFAPqdOYW8ZUaAEETEOB
	 PRNj08Jz1QhAvJiThhW6rxK2ViMQqU9HgwmXk/a8dB3+j8T9hAbXVKTdFClYEnIIbS
	 9F3Po0pKKJU520NYVL9KbfLNldmRdxiQtIzjn0qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0824/1611] ACPI: resource: Amend kernel-doc style
Date: Tue, 21 Jul 2026 17:15:40 +0200
Message-ID: <20260721152533.924208917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc8050d8a6f51c..56df4599d3604f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -871,7 +871,7 @@ bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
 
 /**
- * acpi_dev_free_resource_list - Free resource from %acpi_dev_get_resources().
+ * acpi_dev_free_resource_list - Free resource from acpi_dev_get_resources().
  * @list: The head of the resource list to free.
  */
 void acpi_dev_free_resource_list(struct list_head *list)
@@ -991,7 +991,7 @@ static int __acpi_dev_get_resources(struct acpi_device *adev,
  *
  * The resultant struct resource objects are put on the list pointed to by
  * @list, that must be empty initially, as members of struct resource_entry
- * objects.  Callers of this routine should use %acpi_dev_free_resource_list() to
+ * objects.  Callers of this routine should use acpi_dev_free_resource_list() to
  * free that list.
  *
  * The number of resources in the output list is returned on success, an error
@@ -1032,7 +1032,7 @@ static int is_memory(struct acpi_resource *ares, void *not_used)
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



