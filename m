Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2326478E36;
	Sat, 12 Sep 2026 12:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215166; cv=none; b=MFEJ1LZBbZwS+FcTnYhw7ezUbUeUKGs1taK5oOC9O5s4Q2ZC7dgPT4R5HmnW+GXmh7Y09Le0q9hHIGbkiYJemGrrXXiOVHroJU8fQiEA14OT4+UQK1MMjDFvaOUnFyPOWSELEoCaYKS992d0aGLuAyFLGjjnCpw3Y+U5T4T4CnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215166; c=relaxed/simple;
	bh=7h9Gb90HHNKZ2GgD5PdNziJ42Aw97XE6RL8IMDBCWHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBO8Hfh4KMLALbPHekfWyN/OckZoi7cxjUe0CFgDiFn9xLwYVUN1aXglEREzQP/7lXlfJXgJj+OTboQjTlxlLltF0jbWWJ1dmeu8PxsFYTLtGEahSFF3SejJfW4l7XmSSsjZB5SZPhBIkbEktxky72nc3I6KUrcnQPci/PdVoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JosZ5sOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JosZ5sOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1190C1F000FF;
	Sat, 12 Sep 2026 12:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215164;
	bh=suCvdvpCHGORL8NVNBmq+DdgmERsGhc/VQGxAsoeC/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JosZ5sOBE5/RyBi6OOXnAQxzlWtX8k+3xIL1KAyzNYzelOzCMzQ6hq1mkjileyJUQ
	 Rwtfs21auf6e66C6kfGRabiDqvSNpW/XtmCgDMw80ia2a547ZzjpqEyMr3iFeBmrlw
	 ppsJ8xegGoFGBLbsNHRqmVRgtHey/T48F4lA8Ygw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0476/1376] platform/x86: lg-laptop: Drop debug-only ACPI notify handler
Date: Sat, 12 Sep 2026 08:48:22 +0200
Message-ID: <20260912065618.143460616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c12fe0b2c12195e0d1c56e0f670a6bd792b0567e ]

To facilitate subsequent conversion of the driver to using struct
platform_driver instead of struct acpi_driver, drop the debug-only
notify handler method from the driver.

No intentional functional impact beyond debug.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3346280.5fSG56mABF@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 3e91964aa74a ("platform/x86: lg-laptop: Fix LED resource handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 6af6cf477c5b5..6a45e6270941a 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -269,11 +269,6 @@ static void wmi_input_setup(void)
 	}
 }
 
-static void acpi_notify(struct acpi_device *device, u32 event)
-{
-	acpi_handle_debug(device->handle, "notify: %d\n", event);
-}
-
 static ssize_t fan_mode_store(struct device *dev,
 			      struct device_attribute *attr,
 			      const char *buffer, size_t count)
@@ -886,7 +881,6 @@ static struct acpi_driver acpi_driver = {
 	.ops = {
 		.add = acpi_add,
 		.remove = acpi_remove,
-		.notify = acpi_notify,
 		},
 };
 
-- 
2.53.0



