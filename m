Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712CD40587A;
	Tue, 21 Jul 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655043; cv=none; b=CnV7U25UkbJlGYkX9eZ9B4/eUNmVnNkSrBlHa+YssZTou3WFwF8mHTwdjQEOXqEFCg/4XQGwSiAEC5Hyu8/YQNoIG/pOJ1pEn5meeopTrDpONt6jT7AZZ208K5t1LFT3kwvzDo3l31b+n+PKgzDeS9Zv4MgZbqZefC33cIQAcE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655043; c=relaxed/simple;
	bh=XIyDUDJ9Byi24m06+ICrBw8dpr8ensAebLOUl0knh1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTs7h/2Kfz/P4zBFAsMSlwi1dCNQCLLJBf35rvbwN0jmS3iIOLk3JW8THReqIG7pmhW1GDO5w+KgXLQDmmPc3RHjum9wscuIOZb+EJ+JcfW2DwYxxbsubnCj17CvtNqH+x/rPun72arFdfWDpDiNMQLHSVVsazBEE2VZ5nCW578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvYFAzFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvYFAzFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77321F000E9;
	Tue, 21 Jul 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655042;
	bh=Q01HYeeHqc3+D2VxxbG1/UapwcX0JylZterTAZbJGF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvYFAzFvP1egb3jwsg2y8If1l44Ypr7VewH6AzexDs82MYRklgSs9UBgdoClVwmvK
	 HhnFS0HjtdoeIJAlI3FmkT/e6GG5sjoJBAayrRgDRhRNHZA3ip+CG+/dFyxV8F4y1b
	 q6ZQ6f8kbQdmvPQLkDCpebTKMLFjGlQxCMOCPXIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 1932/2077] ACPICA: Define acpi_ut_safe_strncpy() as strscpy_pad() alias
Date: Tue, 21 Jul 2026 17:26:45 +0200
Message-ID: <20260721152638.278462155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9825cf2cb59fac7480e7fac9eee13ab9af3f1ea8 upstream.

Commit 292db66afd20 ("ACPICA: Unbreak tools build after switching over
to strscpy_pad()") added an #ifdef based on a __KERNEL__ check which is
sort of nasty to the acpi_ut_safe_strncpy() definition to unbreak ACPICA
tools builds broken by commit 97f7d3f9c9ac ("ACPICA: Replace strncpy()
with strscpy_pad() in acpi_ut_safe_strncpy()").  However, that #ifdef
effectively produces dead code when tools are built because they don't
call acpi_ut_safe_strncpy().

Accordingly, drop the existing definition of acpi_ut_safe_strncpy() and
define it as a strscpy_pad() alias.

Fixes: 292db66afd20 ("ACPICA: Unbreak tools build after switching over to strscpy_pad()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: Tweak the changelog ]
Link: https://patch.msgid.link/12941764.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acutils.h     |    2 --
 drivers/acpi/acpica/utnonansi.c   |   16 ----------------
 include/acpi/platform/aclinuxex.h |    1 +
 3 files changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -626,8 +626,6 @@ void acpi_ut_repair_name(char *name);
 #if defined (ACPI_DEBUGGER) || defined (ACPI_APPLICATION) || defined (ACPI_DEBUG_OUTPUT)
 u8 acpi_ut_safe_strcpy(char *dest, acpi_size dest_size, char *source);
 
-void acpi_ut_safe_strncpy(char *dest, char *source, acpi_size dest_size);
-
 u8 acpi_ut_safe_strcat(char *dest, acpi_size dest_size, char *source);
 
 u8
--- a/drivers/acpi/acpica/utnonansi.c
+++ b/drivers/acpi/acpica/utnonansi.c
@@ -164,20 +164,4 @@ acpi_ut_safe_strncat(char *dest,
 	return (FALSE);
 }
 
-void acpi_ut_safe_strncpy(char *dest, char *source, acpi_size dest_size)
-{
-	/* Always terminate destination string */
-
-#ifdef __KERNEL__
-	strscpy_pad(dest, source, dest_size);
-#else
-	/*
-	 * strscpy_pad() is not defined in ACPICA tools builds, so use strncpy()
-	 * and directly NUL-terminate the destination string in that case.
-	 */
-	strncpy(dest, source, dest_size);
-	dest[dest_size - 1] = 0;
-#endif
-}
-
 #endif
--- a/include/acpi/platform/aclinuxex.h
+++ b/include/acpi/platform/aclinuxex.h
@@ -134,6 +134,7 @@ static inline void acpi_os_terminate_deb
 /*
  * OSL interfaces added by Linux
  */
+#define acpi_ut_safe_strncpy	strscpy_pad
 
 #endif				/* __KERNEL__ */
 


