Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F015D1;
	Sat,  7 Jun 2025 10:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291058; cv=none; b=HQqXcG3SiqbjTW5aoSWtV1XvSeFXhVCvZ0wASjf5eF4LFS5K18B9TMlmQdN4CUxNfzcR3+zm5C5714PPTW0DahlM8921cOBGBIQGQMyEmKoxS7vQxDkLg7LI2faVS+y7GQcsVm15oXsT6EJV8QbuF8EgpepDBeu9fUFrQ+j7GF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291058; c=relaxed/simple;
	bh=oFsPZzRxBuIqj1B4fpT0TmJMx2JQsZLL+POQCHf9l80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdki7838X5ufkBQfyWKZ+ugJfLUldkE/K3XhbM1HsNa8fB0fspvh/uXph17RpRb9FoPlG4jCQxnw6hTwmkOIxK6aVEalUnzOKSOWRX7wRZkdJ1cB9QHuOsJPaFHyiobH/8kbDBmNOB/220Vz95L/1cXKKNUmW/hQCivfMNGarME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynokt247; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynokt247"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF82C4CEE4;
	Sat,  7 Jun 2025 10:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291058;
	bh=oFsPZzRxBuIqj1B4fpT0TmJMx2JQsZLL+POQCHf9l80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynokt247SKGThVIOfWPWl1QPFi6uRJ6RcdM8lNhdh6FkOeieP+cnS5i87oG1D8qv1
	 x4ddi/TrYA6efs8Ety17JGAkvIOnWQuPsQEs0p8gqSPXBL2OjZVsGKzYIPdtqVQY4s
	 CLm2vOg5Yi+ejRUtFLQXLqUSXwkTXOC5gYKSOIE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.15 04/34] ACPICA: Apply ACPI_NONSTRING
Date: Sat,  7 Jun 2025 12:07:45 +0200
Message-ID: <20250607100719.885500042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 2b82118845e04c7adf4ece797150c19809bab29b upstream.

ACPICA commit ed68cb8e082e3bfbba02814af4fd5a61247f491b

Add ACPI_NONSTRING annotations for places found that are using char
arrays without a terminating NUL character. These were found during
Linux kernel builds and after looking for instances of arrays of size
ACPI_NAMESEG_SIZE.

Link: https://github.com/acpica/acpica/commit/ed68cb8e
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2039736.usQuhbGJ8B@rjwysocki.net
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/aclocal.h   |    4 ++--
 drivers/acpi/acpica/nsnames.c   |    2 +-
 drivers/acpi/acpica/nsrepair2.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -293,7 +293,7 @@ acpi_status (*acpi_internal_method) (str
  * expected_return_btypes - Allowed type(s) for the return value
  */
 struct acpi_name_info {
-	char name[ACPI_NAMESEG_SIZE] __nonstring;
+	char name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	u16 argument_list;
 	u8 expected_btypes;
 };
@@ -370,7 +370,7 @@ typedef acpi_status (*acpi_object_conver
 					      converted_object);
 
 struct acpi_simple_repair_info {
-	char name[ACPI_NAMESEG_SIZE] __nonstring;
+	char name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	u32 unexpected_btypes;
 	u32 package_index;
 	acpi_object_converter object_converter;
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -194,7 +194,7 @@ acpi_ns_build_normalized_path(struct acp
 			      char *full_path, u32 path_size, u8 no_trailing)
 {
 	u32 length = 0, i;
-	char name[ACPI_NAMESEG_SIZE];
+	char name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	u8 do_no_trailing;
 	char c, *left, *right;
 	struct acpi_namespace_node *next_node;
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -25,7 +25,7 @@ acpi_status (*acpi_repair_function) (str
 				     return_object_ptr);
 
 typedef struct acpi_repair_info {
-	char name[ACPI_NAMESEG_SIZE] __nonstring;
+	char name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	acpi_repair_function repair_function;
 
 } acpi_repair_info;


