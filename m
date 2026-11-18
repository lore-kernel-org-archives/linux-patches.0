Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032751;
	b=o5dZvWeoJzAy1DwmpdvV8yZIBLwKUuljpnA5uwygtA7DC3oBu9BDk4P2nrfhQv23PC4m
	 r3gZZzEakk1DJupNBGmwjIN38ntnW/qtaGery/31C8fxPyV1ckczlXkx6DzqPvD4ORYES
	 D80R5P2JsweXcW48AGcurCFEilWLSzPF/MyKohbPa0m/v6Hwqxs15Z5tEcRBH0utk0F0Y
	 3Lv4wL9K8S2vcJMEd1SRBEOc8oZQhGA200O62mwRSyr6/43BwX5bNKkFmpTHgtJZToBos
	 9gx7Ruq3qbJrlmxXKE5lwc8jCb++dgu6PCWXGlXDTE6KzJf03zeBDfGkhPRdxmRf7RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1jH3eey3etfE8/7I6y7e02h8w5U3a7ucQoJ3Zh1cA4=;
	b=Hx1h7KeBYyhwFFWhn7JsXjpMLkE0i4yH4HWzZTHQJA9kalYO5oFitbPahbsOZv0e9MVv
	 TW0PYutN6jskwYO3UJUH/OfChk14wCXZSMS2IwxyvbUCU30++QD3nzgY+DHMMB801qKz1
	 mNewzs8lDHqj5BWIO9X4QbiDd2y2LIps0LlmA89DxHIVzNS/MTyI7O+MmtiwGS4UBcY1G
	 snbfzPP6kPiCfPGotaFqIM9b6KEAGFRrQHXcYBExHUoGVf/CpD1Z+vDySi6MO1+aRCpt9
	 M9bnG1mIVkSxNPPnRCWoiICCJlEI8f/+q0kNj9fk6FhwpDDs90qWaCtqGa2L81DihEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ov22qqqP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60157606A31C;
	Wed, 18 Nov 2026 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ov22qqqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A421F000C4;
	Wed, 18 Nov 2026 20:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032751;
	bh=g1jH3eey3etfE8/7I6y7e02h8w5U3a7ucQoJ3Zh1cA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ov22qqqPPqwjJV1q2zex5BMJ2Lr4AZcbpqj96L6jjZcDcYVke0pirMwa9Rkgvg1Mj
	 cThk2iYBVjOX5/045gwD09sXg1R/PHNXEmnNHzq9T/Qp69kRm+Y1pfF1M7+bzzRpJN
	 hKR524IkQ7Qnqc0ODLIv5wl8FT5EiG42S8h7VDVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Leonard Lausen <leonard@lausen.nl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1524/1756] ACPICA: Initialize parser_state.aml_end in acpi_install_method()
Date: Wed, 18 Nov 2026 16:00:51 +0100
Message-ID: <20261118150109.518548872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 835bf4810c29e..55166723e1fc2 100644
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



