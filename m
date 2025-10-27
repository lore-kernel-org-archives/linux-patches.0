Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980171E47CA;
	Mon, 27 Oct 2025 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593285; cv=none; b=XFNjGE6ZimVrJXvG6MHbEFK3ibedtX+7t0gowkSYXscBgJ3wXIuZhz2Rj9370pZYabzdP69r+Xvm8/V21ajZwx/6pLQQE5o6xFHeln1IGdsyOSGRFkFql/oGzdKglEWWN6fNTBkpxSAZJJgpYHMkVB7On/71MxptygN1lpKQTjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593285; c=relaxed/simple;
	bh=iIWUYNF8eDqoc5NRVcbIDJb6yYPukK6lik/frzPmdwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXaSEgeoy3leg1gjkS3Jwyyx4eLTXS/LYFbXJMlkFeAdGIVL+eOt+VEEvXP2MYvYnDvy3BZfK4UbZrXeaxNKMmQKjgvM//19dilLbiJVs3bMNzV+6rIvg93lrhx7FAoFdIABscYqNIAsMv/EMMupHy8wkl82n94PKnrd1Ga/rFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHzyOhmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHzyOhmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4CAC4CEF1;
	Mon, 27 Oct 2025 19:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593285;
	bh=iIWUYNF8eDqoc5NRVcbIDJb6yYPukK6lik/frzPmdwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHzyOhmyxWKnTkA6oYhkoaMtHQ4Y4JDSzgKNEcqYi0+cBnrsRsQwSVNrobaeqgHjn
	 IpkWguWB3DeLeP3Eo5YFLtW18MTZ0ToQbiov+drwypWGjgdcIUothFT5V1rf56L3GT
	 kSplKUVsw06TJPYe62JwmHdrU1JfduDZ/rqfxHuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 085/184] ACPICA: Work around bogus -Wstringop-overread warning since GCC 11
Date: Mon, 27 Oct 2025 19:36:07 +0100
Message-ID: <20251027183517.185105946@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit 6e3a4754717a74e931a9f00b5f953be708e07acb upstream.

When ACPI_MISALIGNMENT_NOT_SUPPORTED is set, GCC can produce a bogus
-Wstringop-overread warning, see [1].

To me, it's very clear that we have a compiler bug here, thus just
disable the warning.

Fixes: a9d13433fe17 ("LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled")
Link: https://lore.kernel.org/all/899f2dec-e8b9-44f4-ab8d-001e160a2aed@roeck-us.net/
Link: https://github.com/acpica/acpica/commit/abf5b573
Link: https://gcc.gnu.org/PR122073 [1]
Co-developed-by: Saket Dumbre <saket.dumbre@intel.com>
Signed-off-by: Saket Dumbre <saket.dumbre@intel.com>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251021092825.822007-1-xry111@xry111.site
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/tbprint.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/acpica/tbprint.c
+++ b/drivers/acpi/acpica/tbprint.c
@@ -95,6 +95,11 @@ acpi_tb_print_table_header(acpi_physical
 {
 	struct acpi_table_header local_header;
 
+#pragma GCC diagnostic push
+#if defined(__GNUC__) && __GNUC__ >= 11
+#pragma GCC diagnostic ignored "-Wstringop-overread"
+#endif
+
 	if (ACPI_COMPARE_NAMESEG(header->signature, ACPI_SIG_FACS)) {
 
 		/* FACS only has signature and length fields */
@@ -135,4 +140,5 @@ acpi_tb_print_table_header(acpi_physical
 			   local_header.asl_compiler_id,
 			   local_header.asl_compiler_revision));
 	}
+#pragma GCC diagnostic pop
 }


