Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021637;
	b=2vyVGPqCr4x3nLDXFA8An5T3PAQem5fFcvbQ6OSAxyDyWvQfUUj6jYR4QxJK0ZXdp8f5
	 uLSpOJ7qdlvEnewDOe9vJWrmBPUSf9b1RBd6kvzwBHd+ckhbRoPojCEjmPfwVTDLYjPRj
	 Ed8pH1K2PzWDlLg+WFT0O9GEY5VIaeb2slrpVjEPmGntgPXJnuwqOGO7yVnPBjdyc0b72
	 ZRq8gF9xGf3esisXFUo4svrWRG4vFtQPUv/CB2ph8eY8kqXnGbK4HcstjPOUs+5KusGp9
	 0j0KpwVSCkWUzpTRgioxwKMrRSbJM/8/VTgtCMLPXWbK5HfXriVCRiDP87pGBauQEnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aGUIXUS8v0dUQWo0TlKcE/5eVvUfiqtdXLoRZLF8ahk=;
	b=oMK1WAfW5XJx3svdeDtpg6n6cYi7HWefSU+NKAC2H/+ievr20T19mOimeYdKmPdsY6nb
	 E8BYRmFgDj7yrzQYp3gzaQnBjreDbBR7OUOp1T50WCMHB930QmQVSfhnq1rPprNPd6BFA
	 DMRN6Me3tudHLIwHgFnul13NvzYV5knzVIzi7AQmhO6WKxVjSoN77i8uoFtFRA1emk+iF
	 riIdbtYg/pCV1v+TR2RmLBQsOvSsJDy9cXyk0tTTeBEmmUAGDTSBt/dhj8290CBJlxdcx
	 roHgzLvq9tTHKyERg/ziDlVHxbTKt0VgZ1HWNK4YxrPBN5FGm+VcP/dKGt0EwbtHhCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kamPnTRy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887AF606A320;
	Wed, 18 Nov 2026 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kamPnTRy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E691F000C4;
	Wed, 18 Nov 2026 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021637;
	bh=aGUIXUS8v0dUQWo0TlKcE/5eVvUfiqtdXLoRZLF8ahk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kamPnTRyexEqqMiLKzhooLWO6eNmixmGtN48+Grz1Ua38dWkFsAwy1rrTiBPN8c7g
	 eOYZYTSJU9N/ulfhS6RyCAdtFcMjklgnEOuzg8HJpHXnov37H6GwOUXU0vy9GjHUfx
	 CTwx3YQmE8PkLJDzh0CoQdHJ5m4kNI+3qK1nT5Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Leonard Lausen <leonard@lausen.nl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2361/2651] ACPICA: Initialize parser_state.aml_end in acpi_install_method()
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150410.552658858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Hu <ivan.hu@canonical.com>

[ Upstream commit ec696f34774db985841bac9a2df179c0040ef073 ]

In AcpiInstallMethod(), the local ParserState is stack-allocated and
only ParserState.Aml was initialized. Parser helpers called by this path
read ParserState.AmlEnd for bounds checking: AcpiPsPeekOpcode() reads it
before validating the first AML opcode, and AcpiPsGetNextPackageEnd()
reads it indirectly via AcpiPsGetNextPackageLength(). The subsequent
package-limit check also compares against ParserState.AmlEnd. Because
AmlEnd was never set, these checks operated on an uninitialized value,
which Coverity flagged as an uninitialized read (CID 1684785) and which
could lead to incorrect parser bounds decisions.

Coverity report:

*** CID 1684785:         Memory - illegal accesses  (UNINIT)
/src/acpica/source/components/namespace/nsxfname.c: 712             in AcpiInstallMethod()
        ParserState.Aml += AcpiPsGetOpcodeSize (Opcode);
>>>     CID 1684785:         Memory - illegal accesses  (UNINIT)
>>>     Using uninitialized value "ParserState.AmlEnd" when calling
        "AcpiPsGetNextPackageEnd".
        ParserState.PkgEnd = AcpiPsGetNextPackageEnd (&ParserState);

Initialize ParserState.AmlEnd to the end of the table
(Buffer + Table->Length) so the parser bounds checks operate on a valid
limit.

Link: https://github.com/open-acpica/acpica/commit/19429ef91ebfb2144c918038dce13e297b4ef051
Fixes: bdc357540129 ("ACPICA: add boundary checks in two places")
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
[ rjw: Subject tweaks ]
Link: https://patch.msgid.link/20261019145421.47181-2-leonard@lausen.nl
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsxfname.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
index b6534187cd43c..fcd94947fedb8 100644
--- a/drivers/acpi/acpica/nsxfname.c
+++ b/drivers/acpi/acpica/nsxfname.c
@@ -503,6 +503,7 @@ acpi_status acpi_install_method(u8 *buffer)
 	/* First AML opcode in the table must be a control method */
 
 	parser_state.aml = buffer + sizeof(struct acpi_table_header);
+	parser_state.aml_end = buffer + table->length;
 	opcode = acpi_ps_peek_opcode(&parser_state);
 	if (opcode != AML_METHOD_OP) {
 		return (AE_BAD_PARAMETER);
-- 
2.53.0



