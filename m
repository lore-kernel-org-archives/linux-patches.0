Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87BB246BB7;
	Mon, 27 Oct 2025 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592901; cv=none; b=tv8frGJqfaGC5Anmb2r1QRgbX6sCTvWgBRhD0JrJEuPaH/n8656WVppOGn7hJs6jDA9fKt2tyx/J8uh5QfSK39FmGf2bS9gyQ1YVSNrkYurrFMlT2jQknVi+bQ/vom9lQG3eWVL83kCz+rvaA3CkGtuZ1G1i8KxjWVXLjVx9+5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592901; c=relaxed/simple;
	bh=M8aehLe1JfsD4orsT2RnOdq9Ko+uwrexnkhK6ErZP28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWaIlt1WEU0l4hE6sktLJFQqlEGP0TOAZykpwmdcmJzwdXP8DYrXOuMbGL57h6un9vJnkgkknc9y4AOD8i0pwPr/KDZx2DBPwVcxKNu0MwRNQsgeVcKw/aQSAFPfz/7OyLYQtlZBHN2kfuE0GwLTP1eQ08GV9+kGlXGhAEHIIrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4ZAU62O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4ZAU62O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAADC4CEF1;
	Mon, 27 Oct 2025 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592901;
	bh=M8aehLe1JfsD4orsT2RnOdq9Ko+uwrexnkhK6ErZP28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4ZAU62OmnUZo0lJkFWeK8iUtq6eC/DGewAsZ+5SKWHQUdvlRkPgok1oCzNG9cSs1
	 53fz02xIFSEJ6n2hyDM+sFO1OGOnRlhpXnNgsXW+ujKXSQlGi963xxxewn4/Rhkcec
	 Jr+Vy3bv0lPIPc/jUcuaHZLnJuidwzE9YbxlOig4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 055/117] ACPICA: Work around bogus -Wstringop-overread warning since GCC 11
Date: Mon, 27 Oct 2025 19:36:21 +0100
Message-ID: <20251027183455.501519992@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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


