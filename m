Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042344;
	b=Ho5yVHLJ0JYI+ynfjZp+PD5kXgOrDN+4nt0hfKvnRUQK3h/SmSd7vzNRHzC8qPgdglW7
	 C/SMrQy50Y0FIFhYbCu0OATvVuD8lmIuCL5/gUseNMy+mdUMkpNNkIgqEfWjxZqQagQmu
	 ZzSWSlR7jkKlMfBskK4jxgzMjtJUdo54rjuP3DAXhPwT8Vhl7916PXHaYBNBC9AZUZURl
	 imP0MFsOqEcT7ZjV2DYIfY2tdwzYC26xGboAb+iMol5PIQn6XQKt15eGYsgL2k6ftA0v8
	 AkWPLgFq/5BKhUyhKlCE8h9au7SduXb8iUpB+zTAdeqZhcU1D9RJvuOJzGy0+HsUv/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6cNToDSmDE340WW6g2Rv2c6em2YMDtL5q2bppRUdZU=;
	b=LRGxCwida4RhdjEgJR19GShzAUpivejFxvrO+fegrDavXGxxHftK/7TkZEnuO8/4azyu
	 4XT96+cy5OvtZWlfzg1WxGNmCpJSj5DnTsGQWEsZ1HLqaThLpZ/ai1CmMC1ePfNgysNdX
	 sBMfjkJGhe8UUyMQrYyCdAceGSVpUJS5WzQSLkOuaumwiNFISaTKuLPJzskZFE+MPDC6q
	 Cb1yb07ongf37BVZoIipUUf/+vJ0TqE08+tj2fT1Gn0AVwBlE9/Wgiy4Y7dfmWaI4PFXn
	 Bsma+pgKKvhk0IWGMIla3MUglBu8JL6CSRCktY72x7pM2GA28jqdUhrM+9L1eKavEpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfcDNrEl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684BA606A325;
	Wed, 18 Nov 2026 22:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfcDNrEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E63A1F000C4;
	Wed, 18 Nov 2026 22:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042344;
	bh=p6cNToDSmDE340WW6g2Rv2c6em2YMDtL5q2bppRUdZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfcDNrElmYQBp/lT1Z0P/oeySZ8ENUgO1+qi7zt8EZjh0k3QNjLa1gig4TFS5TtCo
	 KVWF0fHeqTHIIrKUbnydPn9Zvc00glmX4agzI9CVhVEYWxh+I1GklxZ0Itr8sa2J6b
	 UYfU5w4F84GZOtW/62Rc9Fuu0BmdsmXkY24lQuhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Leonard Lausen <leonard@lausen.nl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3137/3318] ACPICA: Initialize parser_state.aml_end in acpi_install_method()
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150453.994139443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



