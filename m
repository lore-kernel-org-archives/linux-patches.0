Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024489;
	b=HZ+T8RBbJrebS9U3YUUdOwLx6lUsCeL8miWVijpkjsPcgprzrBqRlONjyxwRBQdCHP2Z
	 a5qqwQ7u4DdLT/+ZQAPpA+HMfnHXuKVV9sypIaaRzAumSi9o4XOgtbuPWFyRymO7kbUkL
	 boWTkGs29Zyd0X0SUb5HE2+x5KVwvzK/q7HkvUwOZ4qZXt+j5HCVNV21F2LrfAULI505M
	 PZoZZeBASqos05RIWoZ6tfUTkV44a2Qt3u7RPoSD8/FjBDZ+v+wXPeSJKnJ6kR8Qp1tT6
	 jkWtJCFLQispGmR/oyqkv9IBb7qk5xn+B7EtRCTYKsxIwvAT4nO0PcXkiOpoIHCHIPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAot4ljCgGy48Lf/hVqvuqImlHWThhdCzzArQrGc56M=;
	b=dQjs9AT8lM+Hu+/i7r62aIDPUZMge7zhndE/Fro8ZgBZRG5f383j2HX42C3P48rPu/Kx
	 mmjYPNtzLyXK5w1KPRdzfD3Tdp3ny1XUqNZcK/zBH7Sc/xN8n4cQpJHJbxkjQe1sbkLon
	 /gS8mlSlkRUKJ6+SasRnG8hWO+tZiNBBUVNPj8xjpwbCbUdbWFyDAYs3yd/DitsuIYerx
	 OmZrnwPWRq/hwWkvVxNKaFVM3ISrn/bImELbCFsq99zQeez+MkKK7u0U3UkeSeHumZtxF
	 q0rSf2vphOj49x7wXtfR5PdeI1DapmrP7NjrAsT03dUWfFXQPL5KuPm2vu0LxTsIG9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3ku1BEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA66660A2608;
	Wed, 18 Nov 2026 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3ku1BEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE1C1F000D1;
	Wed, 18 Nov 2026 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024488;
	bh=YAot4ljCgGy48Lf/hVqvuqImlHWThhdCzzArQrGc56M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3ku1BEcu1RKtpEMppXAKQS2Bcwd1qSwgtH4jRSmZwMCiQPQ1e/naEKgjVcFF7PZ6
	 oZlRUmqAUMCyfT4EB+nnq72oawCJ/gW7mrt+xLeKIRs8b/PoT1D1Oy3L7bd2QgIm46
	 IVSBrc34jGRbgCXpTlNNmY4uBHrWye9gZ1bNQxKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0744/2151] ACPICA: Fix PCC OperationRegion command offsets
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118150149.140068013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ced3ff9d0a86a..f0c525dedbd81 100644
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



