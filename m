Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039901;
	b=r4ieIM+v802ESlWeN54MksRWN1hcFLWnazPlDnOgYUVSNg/ZSpPOkId+bAWNZrLEtAga
	 8RpPmI6c7vDkNmyJi7bBINY8ysVLuog8XrfXZn5KzvWrnfeiKQMpVSWqsSRyNsJhWAHn4
	 2F0FFOfa20c4F3wAFvBPm/5//30L9K2X9XtnYUGE0HhWTJIRIActfTPOUXUjItQPdYBKg
	 dmdimiQPd2ARqFiMr0Vs3hT3MtCg/aXM3z2EksDAuH1ZBth6jMB9L39VvS0yL7xwZZrfJ
	 KtMtMXH/jHGpolT+zGfQBngj8r8LgtsDY8P/UTdbaXtSMRbvpJMRTKqRKJ2ZlGbWXhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vm7Fav1QQpZmDe+B5czFXDeT/kE7DWHSUb6oPtaR2DI=;
	b=bikdPbWvGcKbHGw8SF36Iqn3Qu11fga9xCImbU/0rsmo6hdKWqfgJ2i5QUkhXwXWBvzg
	 qnZXLoIJ1lX9pt/fSw3afB7THNaTUHmMRpUnxt6ioVJmdWBhA9scpIpWKZ0J7YraaDHfG
	 hrOx4ntlrLmZam8oUwpLhsPIVJVkhWYTWlU2/ZcHpptLpQY+sGi3wGppgTXnBMjfmZkQ3
	 uKBJQ+d5ovym4ljOtTpBuKv05xwwD+3ap1QM+oKR/69xqkSC2BAv1MeToYL3DCe0y8sFq
	 cvP3Mo1Xzlq9oOY9jRusYO0vMbiJ3rQoK9EjfIVEpvvD0BXS57T8CM9RwDHdVg6v56Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8CWrs5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD215606A32A;
	Wed, 18 Nov 2026 22:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8CWrs5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5851F000C4;
	Wed, 18 Nov 2026 22:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039901;
	bh=vm7Fav1QQpZmDe+B5czFXDeT/kE7DWHSUb6oPtaR2DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8CWrs5AoUUVmHV1SScYnYFgDNBk5bxGlRYbjLX2KDSrdCt7STjIfiMxjCA33B30P
	 C1OlLQSlXvT/RXvdurSiQPpzkB2xF+sPNIWIXZn013247pI3mQY0Epkq0k0IPYR6Vn
	 B3cy7cwdZBy36C0Ka0Wftd9QZAD1ZwvoFQnLaUJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2265/3318] ACPI: CPPC: Validate the _CPC package header
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150429.759434399@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit fb345025f161d17fe7c8a6048c7e80e467fa8ddf ]

The _CPC NumEntries field includes every package element, including
NumEntries and Revision. acpi_cppc_processor_probe() nevertheless reads
those first two elements before checking that they exist and trusts
NumEntries when walking the remaining elements.

Reject packages with fewer than two elements and NumEntries values which
exceed the package count before accessing Revision or iterating over
register descriptors. Although the specification defines NumEntries as the
number of package elements, tolerate additional trailing elements because
ignoring them is safe and avoids rejecting padded firmware.

Revision is specified as a BYTE, but the parser assigns its 64-bit AML
Integer to an unsigned int before validating it. Reject values above U8_MAX
before conversion so, for example, 0x100000004 cannot truncate to revision
4.

Fixes: 337aadff8e45 ("ACPI: Introduce CPU performance controls using CPPC")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724134251.1632824-1-christian.loehle%40arm.com
Link: https://sashiko.dev/#/patchset/20260808082644.1251332-1-christian.loehle%40arm.com
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index c4184619c76c9..424cee8a32ab2 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -723,6 +723,11 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	}
 
 	out_obj = (union acpi_object *) output.pointer;
+	if (out_obj->package.count < 2) {
+		pr_debug("Unexpected _CPC package count (%u) for CPU:%d\n",
+			 out_obj->package.count, pr->id);
+		goto out_buf_free;
+	}
 
 	cpc_ptr = kzalloc(sizeof(struct cpc_desc), GFP_KERNEL);
 	if (!cpc_ptr) {
@@ -733,12 +738,15 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	/* First entry is NumEntries. */
 	cpc_obj = &out_obj->package.elements[0];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
-		num_ent = cpc_obj->integer.value;
-		if (num_ent <= 1) {
-			pr_debug("Unexpected _CPC NumEntries value (%d) for CPU:%d\n",
-				 num_ent, pr->id);
+		if (cpc_obj->integer.value < 2 ||
+		    cpc_obj->integer.value > out_obj->package.count) {
+			pr_debug("Invalid _CPC NumEntries (%llu) for package count (%u) on CPU:%d\n",
+				 cpc_obj->integer.value, out_obj->package.count,
+				 pr->id);
 			goto out_free;
 		}
+
+		num_ent = cpc_obj->integer.value;
 	} else {
 		pr_debug("Unexpected _CPC NumEntries entry type (%d) for CPU:%d\n",
 			 cpc_obj->type, pr->id);
@@ -748,6 +756,12 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	/* Second entry should be revision. */
 	cpc_obj = &out_obj->package.elements[1];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
+		if (cpc_obj->integer.value > U8_MAX) {
+			pr_debug("Invalid _CPC Revision (%llu) for CPU:%d\n",
+				 cpc_obj->integer.value, pr->id);
+			ret = -EINVAL;
+			goto out_free;
+		}
 		cpc_rev = cpc_obj->integer.value;
 	} else {
 		pr_debug("Unexpected _CPC Revision entry type (%d) for CPU:%d\n",
-- 
2.53.0



