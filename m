Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7242E438;
	Mon, 31 Aug 2026 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184358; cv=none; b=W2eYgiR12ISQmRcZOWkDsPh8RNUwtB8wl9u0gD4DcRh6aWWLluAvAQWKwnMnejBNQ/7gdEKP4mkD3ExM920d7wE4Dd3oKVNki0rrxh9DILBaePyjvMcUrFGkzxEwKJcnHxg/n/0vHSM3M8P/9gzWv1ZPSOgkrM5y3MGJa5Ze274=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184358; c=relaxed/simple;
	bh=1/z23o2+fzpZfmqQCn9jN7CKltgLBeigCvttiLqrk7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJqhUUllsOJxbdaNArBNkRlsfx3qWMpj7DfnwcskSxgoE4uIBevo3HEgwZEB/V6T1pFjgOAFx2dWLTOClSM6PVRPMm0iqxYT0M1Tx+axlpnQbxe0Ywv/vpr5RXMesaE3f4H2Vx3py7898Sx3GHBO0CNG/lHg7neDDCy6Zk2Gi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqA3cHyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqA3cHyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0A81F00ADF;
	Mon, 31 Aug 2026 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184356;
	bh=Z0oiydacuf7Q/AtvbagycNRU7gH5/nkNX2qYj5ifzFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqA3cHyfsrL6elLFCOIOCupL4tlTQ5do49/CpLbj6OygaVMXISYBotsl2Jiot3QmD
	 mdEoVN+7lp09x1jdnrt7794wCCNXItWre1rVVXjdTVWlSFNuJF/py3J2G3AvlGpWVO
	 CxA5C/hrF9UBf5a9mD8R/ImVbR5/tU/XQ31jhQr/4n6VCtgDrVNaRpK5g0gUQ65KsT
	 qCbRt9+TG24Cy5EIYQnishTyBn1g0zrDj6aESCtauVcN1PLLDThmIUDCujI3cAd2kU
	 tXgAeLSSToBfjxO9/1Z2V19zWD+2q3DpC97koTjoRMH/0FBrw7jJQDe+ugDU+Rt9nR
	 +npBiR9yAmxiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	maciej.wieczor-retman@intel.com,
	pawel.chmielewski@intel.com,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()
Date: Mon, 31 Aug 2026 09:31:13 -0400
Message-ID: <20260831133314.4125787-645-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ikaros <void0red@gmail.com>

[ Upstream commit b2e21fe8c3361c3d0d57ee56d359bea9b51fda3d ]

Enhance buffer validation in acpi_ut_walk_aml_resources() to prevent
buffer overflows.

Link: https://github.com/acpica/acpica/commit/975cb20c7992
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2481429.NG923GbCHz@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished and line up with the earlier
analysis:

- **No matching fix in 6.18.44** — searches for “Enhance buffer
  validation” and `AE_AML_BUFFER_LENGTH` usage in `utresrc.c` found
  nothing; the patch is not in this tree yet.
- **Prerequisites are present** — `AE_AML_BUFFER_LENGTH` is already
  defined in `include/acpi/acexcep.h` (since 2018); recent `utresrc.c`
  churn is only pack(1)/alignment work, not this bounds-check fix.
- **Vulnerable code is still there** — the walk loop in
  `acpi_ut_walk_aml_resources()` lacks the new validation.

That supports the **YES** backport verdict for linux-6.18.y: a confirmed
heap-buffer-overflow fix, small and self-contained, with no dependency
blockers in this tree.

 drivers/acpi/acpica/utresrc.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index e1cc3d3487508..86ebd9fb869af 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -165,6 +165,28 @@ acpi_ut_walk_aml_resources(struct acpi_walk_state *walk_state,
 	/* Walk the byte list, abort on any invalid descriptor type or length */
 
 	while (aml < end_aml) {
+		/*
+		 * Validate that the remaining buffer space can hold enough
+		 * bytes to safely access fields during validation.
+		 * For large resource descriptors (bit 7 set), we need enough
+		 * bytes to access the Type field in serial_bus resources.
+		 * Small resource descriptors only need sizeof(struct aml_resource_end_tag).
+		 */
+		if ((acpi_size)(end_aml - aml) <
+		    sizeof(struct aml_resource_end_tag)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
+
+		/*
+		 * For large resource descriptors, ensure enough space for
+		 * the header plus serial_bus Type field access.
+		 */
+		if ((ACPI_GET8(aml) & ACPI_RESOURCE_NAME_LARGE) &&
+		    ((acpi_size)(end_aml - aml) <
+		     ACPI_OFFSET(struct aml_resource_common_serialbus,
+				 type) + 1)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
 
 		/* Validate the Resource Type and Resource Length */
 
@@ -182,6 +204,14 @@ acpi_ut_walk_aml_resources(struct acpi_walk_state *walk_state,
 
 		length = acpi_ut_get_descriptor_length(aml);
 
+		/*
+		 * Validate that the descriptor length doesn't exceed the
+		 * remaining buffer size to prevent reading beyond the end.
+		 */
+		if (length > (acpi_size)(end_aml - aml)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
+
 		/* Invoke the user function */
 
 		if (user_function) {
-- 
2.53.0

