Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048627;
	b=NqO8NTZg+N1u6vWeBz+9w9BdeDUbN6TMBrXWlfRXQNAiDVZL9/8SYbY5esY7+nRtfJRI
	 t5KgIF65GmreKosXyxllB6E1MGXo0r0tl03RIxup2qsixCA3sfc+dTGvoKTyvrjJ9GHSo
	 aDEJQnV1X6sjUMllK9RdwGJZlnv0QBq32edVu0BjHaPTgpDVMX3Dp/RmZMe1jsKoUO5Um
	 gcfvap6OA3JPPTvjo14EdEd/UAt47KPCO14eGRkq1LHOze9+qTC1zoRh3Ymd1VikEUys0
	 0w8+YyYl68kk27PKKazFYU7BL/tTNr4BaFlG7EeaWiIL6YWS9vME808+FQaQbpgl2bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YVIb5ZgZhdtsiuO9bpqwdUyHddZAtunLVzKBXKgTxjM=;
	b=dBey9fMx0PgqducazfB3MSzaVQhh5S3Lb1HSdIkUVcnSDx43ElhGN3ivwyV5KtI61BEd
	 45J8PkpHbqfp9n4QCNoZhqsq1QBA+cHzXxIyULAasletlF7vk8xW0mCV0KrehZcMVe22z
	 ykY1+BYuMwAXO9X/D0Gn2IyBMVHOFaLSkbO2bgVixN6UekISoW5HompWSgdf67F6jL5GG
	 DNPrwTYttsE+y8kNHuscdFBJZ1EWLh1inRvSi5rKiUK69JqdwaUpHDdSuUjiwlwKxhZjF
	 +9Gpu4Ayc98XyE3WgeXXdAOt1ZGUo99XDBNEJVV1dCFdkYIWZRm+NfJlMTlz3e66ENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O711hcQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C095606A320;
	Thu, 19 Nov 2026 00:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O711hcQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F001F000C4;
	Thu, 19 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048627;
	bh=YVIb5ZgZhdtsiuO9bpqwdUyHddZAtunLVzKBXKgTxjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O711hcQEG6OEyfu9RUmLVbo10pNxwKoj9DuUB5rUoxo72nOHUjEJ3osyYYQYnoQHa
	 8B6AO7kPLkROvhuonT6ovXG4ZPPMwx4NJB8YxCBsl5di/0ZpFdg/SmyZ7w3pL3n56C
	 N8/vY44fQbBIIAbKb2Z+f7hXLdv0lRWN9+EeTuk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2061/2857] ACPICA: Fix PCC OperationRegion command offsets
Date: Wed, 18 Nov 2026 15:51:35 +0100
Message-ID: <20261118150315.623077899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 888dab4b04ea8725168c6d50d0bfb8057fccca18 ]

ACPI 6.3, section 5.5.2.4.7.3, states that the PCC Operation
Region is associated with the region of shared memory that follows the
PCC signature.

The generic and extended PCC shared memory layouts include the 4-byte
signature at offset 0, so their raw shared memory COMMAND fields are at
offsets 4 and 12 respectively. Since AML field offsets for the PCC
OperationRegion are relative to the region after that signature, ACPICA
must look for those COMMAND fields at OperationRegion offsets 0 and 8.

Adjust the generic and master subspace command checks to use those
OperationRegion-relative offsets. Otherwise writes to the COMMAND field
can fail to invoke the PCC address space handler at the offset described
by the PCC OperationRegion definition.

Link: https://github.com/open-acpica/acpica/pull/1205
Fixes: aa6ec56b574d ("ACPICA: ACPI 6.3: add PCC operation region support for AML interpreter")
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/20260922144302.3847593-2-sudeep.holla@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exfield.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index 2b89a496de65c..6cd7fb790b183 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -45,12 +45,13 @@ static const u8 acpi_protocol_lengths[] = {
 
 /*
  * The following macros determine a given offset is a COMD field.
- * According to the specification, generic subspaces (types 0-2) contains a
- * 2-byte COMD field at offset 4 and master subspaces (type 3) contains a 4-byte
- * COMD field starting at offset 12.
+ * According to the specification, the PCC OperationRegion begins after
+ * the PCC signature. The raw shared memory COMD offsets of 4 for generic
+ * subspaces (types 0-2) and 12 for master subspaces (type 3) therefore
+ * appear at OperationRegion offsets 0 and 8.
  */
-#define GENERIC_SUBSPACE_COMMAND(a)     (4 == a || a == 5)
-#define MASTER_SUBSPACE_COMMAND(a)      (12 <= a && a <= 15)
+#define GENERIC_SUBSPACE_COMMAND(a)     (0 == a || a == 1)
+#define MASTER_SUBSPACE_COMMAND(a)      (8 <= a && a <= 11)
 
 /*******************************************************************************
  *
-- 
2.53.0



