Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056758;
	b=suNx/FNE+hbv2xiT8DZz7yIoWqCAbdVEgQZTwprmokDuXSgeW+MwQF2tNklInZVs9j1M
	 BD0Fc7ZHHPWtM+AxS/NApHYlz6RJC1H5fJRVAAL+WIPmv0FR1XU6sRIa9uFPnjlO54nTM
	 AuCPBzAhRO71eO5M8RI73/YWED/5Ty8qlifwa/gc6dnQcAnliFN+uFkUUI2nrpGzhrLcY
	 HSD+wakDi7u4pDaN3rlgoieYlBdh70LDMzY9hUwgB7lqMNhuozyCjWd+Y4XXBZj3UvSqV
	 IwAtm//8feF2MNFAUix/veVR17CSy/46efItQEeefyrvm5a/i37EhnqIlE8Dg676xXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nuZhdJnBWxGXBsbZHSfsiraY/7Aq+DOm6eb/x1kUjYc=;
	b=x6w+zTZ4VUNHwQoAyal0UCmXbzzUXjklC7RJDpzmj5JXd7aswUJQU2mpIoO0pk4Y1eCr
	 AnKZyPrg/VlPi7FwdMhnVodxZgP5GLZ9yrLRoDSe7N3Ui8wkpVC8RYceOTkFbHUj9zC4r
	 MtGhrp2PAJY29Podys//dKsrKOAvszmtje5vpUW6Tea12bcTPt2pkHg+1vm+yuO7bDs3G
	 twSv3TPqndq4wlmg5laextro3IdSdfRYcXCswyvyDBBHNYoPN6AmgPm0kHoo9bWEmjS9N
	 MdSmIP74UYZj5BSL3GxInozNbJ8jMWjvvtxUYPWtkKQb5MiCqGWbFO2gmE+BOZeT6og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eer2wbN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0FF606A320;
	Thu, 19 Nov 2026 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eer2wbN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5E41F000C7;
	Thu, 19 Nov 2026 02:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056757;
	bh=nuZhdJnBWxGXBsbZHSfsiraY/7Aq+DOm6eb/x1kUjYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eer2wbN1pd/vYQ3t304K2Q8S7ca6VsFkGtbgUcLFN5+8iIgaAOFPF7lyWw4AvbXiX
	 gvLeLzaDYryzpwHz5yRYU/5T1jzxEpxs4eXkGj//B4u0FMKPLDWT4e+RVDd/K6Cf3L
	 8kYeZXyi9Cm1z6keCXuG+wJb7a+K5nOu+Epp+t3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Leonard Lausen <leonard@lausen.nl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2102/2214] ACPICA: Initialize parser_state.aml_end in acpi_install_method()
Date: Wed, 18 Nov 2026 16:02:58 +0100
Message-ID: <20261118150134.742147933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be69c4b70f710..9863e89385439 100644
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



