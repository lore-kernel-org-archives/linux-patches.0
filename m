Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861115D1;
	Sat,  7 Jun 2025 10:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291055; cv=none; b=N9J9GwlOSU/BfFI8CN9+eqRScixY0dtLc5xmcfVPP+0XplM5DSMn1hgz1Ks2iGGN4DCehyAsGz+h+OeHNXLlSb2qAUe8rUbvIT8V21L3RiAOjT6FeLCXrK8gCw6GaZdN9S/pKXcfvUCE+J7ZL3WBz+R+yqrghWZ+drbYdTIPDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291055; c=relaxed/simple;
	bh=XfrJ4/XD85+8J2mqZbwEwJZiIYc4S8kR1v2OF2yRJrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzxPlkmjeN6ZfphVRz8aO9c9sCkcUg3dgZdY0uJlBKhPnegauo7dbeO1fDAkVGrPsIaow7N7D1+RFW7Wzj8BJG6MLFhTn/kDmXruNRh3Hr2EWqqx0+FLf9MnruGv+zCoq2Ilbco8Wi9q8t6Hs1gWhlPo+RqI0qFJY2imAhPH1oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k18CwoMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k18CwoMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4161DC4CEE4;
	Sat,  7 Jun 2025 10:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291055;
	bh=XfrJ4/XD85+8J2mqZbwEwJZiIYc4S8kR1v2OF2yRJrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k18CwoMM4kqw0taj0TiMKXMUu3VHzh7tAyrZdyPcm66RUwJJfnSAR/6QpGlcee58r
	 JYQt4tu2rvcaK7GkzJC5aInx01IPSsk5iohTBxdTBHkQZNqFya4Vsdf0pLMiU8hpIn
	 e/EOLCobAL5pDQPv+tTSQ38BiPnoW65SaoFCoTio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Kees Cook <kees@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.15 03/34] ACPICA: Introduce ACPI_NONSTRING
Date: Sat,  7 Jun 2025 12:07:44 +0200
Message-ID: <20250607100719.848723752@linuxfoundation.org>
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

commit 6da5e6f3028d46e4fee7849e85eda681939c630b upstream.

ACPICA commit 878823ca20f1987cba0c9d4c1056be0d117ea4fe

In order to distinguish character arrays from C Strings (i.e. strings with
a terminating NUL character), add support for the "nonstring" attribute
provided by GCC. (A better name might be "ACPI_NONCSTRING", but that's
the attribute name, so stick to the existing naming convention.)

GCC 15's -Wunterminated-string-initialization will warn about truncation
of the NUL byte for string initializers unless the destination is marked
with "nonstring". Prepare for applying this attribute to the project.

Link: https://github.com/acpica/acpica/commit/878823ca
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1841930.VLH7GnMWUR@rjwysocki.net
Signed-off-by: Kees Cook <kees@kernel.org>
[ rjw: Pick up the tag from Kees ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/acpi/actypes.h        |    4 ++++
 include/acpi/platform/acgcc.h |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -1327,4 +1327,8 @@ typedef enum {
 #define ACPI_FLEX_ARRAY(TYPE, NAME)     TYPE NAME[0]
 #endif
 
+#ifndef ACPI_NONSTRING
+#define ACPI_NONSTRING		/* No terminating NUL character */
+#endif
+
 #endif				/* __ACTYPES_H__ */
--- a/include/acpi/platform/acgcc.h
+++ b/include/acpi/platform/acgcc.h
@@ -72,4 +72,12 @@
                 TYPE NAME[];                    \
         }
 
+/*
+ * Explicitly mark strings that lack a terminating NUL character so
+ * that ACPICA can be built with -Wunterminated-string-initialization.
+ */
+#if __has_attribute(__nonstring__)
+#define ACPI_NONSTRING __attribute__((__nonstring__))
+#endif
+
 #endif				/* __ACGCC_H__ */


