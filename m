Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062019;
	b=0i37I51S8bjXc+sRVxr0rP/YfPiyu1I2JkW/cVyI4pVZFJqiuA3sguK4H4X1eLVv7ULf
	 hkp+ZExP6snTHrEVJ85dZgyWlmDleT0rBfsUGMOeGGEhTY4K+SsCFQsBWu1Wf8ZLeVNsA
	 ov0q8R8Nt1xdTM5BbxWFk7/GQ4oEz6pj1JRkU9CZv5b24f7Z5j2yZdeOD8FYtIrKBROLR
	 yJ5x3FvJZaN99R7WfDSlXoMinVju3d3CIJ2+5s47HTyjk4hL99BvQ7ogMQAZemJeVJN9+
	 x3CPrnhV9aQ1jP8g2M5oT8inLHDb5oCxG5lGxIKhlsrr0k1ngcqfJHtvS4MGG1EP14A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kZquoRR+qDk3DBFCn1cFcLEk6+/SpZ5W2MwSnXpD/cY=;
	b=n1EjIPxH4a/DgurH/q7Qa7CM1/qpxwrHUFVI5fzetixa3dwv5PPppoqbMpJHEf28X6jT
	 aMo7JpKNK+PR+gCaw5boR8JEUn6YM1ZFSSuaaBtkD6qtGXF5CAGCImja5e6pxNKfr5Vay
	 tPwRI10ncn0A7zXHS7F/9sOaIVFtrnoEylisXY27jK29mnvfovrLvFAlTG2XfxFJZcr9A
	 QoyRPebML2nGjBmOops9lyrp2aeaQmHfUP9kDkQeqPHelDznytwmUb9Qc6sqvYYxqaeoN
	 RZEC4zCqXv45Jq/M48CO7M3F+kL+mAc8oM3ZTaIt1p7NaKVjz9B9a4Sz81A4JhuuWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTiAkECv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5C6606A320;
	Thu, 19 Nov 2026 04:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sTiAkECv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6FE1F000C4;
	Thu, 19 Nov 2026 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062019;
	bh=kZquoRR+qDk3DBFCn1cFcLEk6+/SpZ5W2MwSnXpD/cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTiAkECvowCWLQ1CRuVFZiMK1MhSZsxU1eilXS+XaA4uBWHAthMTmJSXCdSGM/uQ4
	 6GrSPAP4q3uxrqjEB/shOYteEGBvonVTRxuv6A2TKWowT25UZcwAz3m62VMQJZ1Di9
	 6Qyn25WIVvirDsxiQuuq1OTheO2aAlX+frepvMi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Leonard Lausen <leonard@lausen.nl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1760/1848] ACPICA: Initialize parser_state.aml_end in acpi_install_method()
Date: Wed, 18 Nov 2026 16:03:18 +0100
Message-ID: <20261118150033.125452848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5c846978c38af..4bfd001d62039 100644
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



