Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DCA44A41F;
	Mon, 31 Aug 2026 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183673; cv=none; b=ZUkhvdj33s6pQpDiuylCBK7ZMt4QfhBlZHCTot3gbhIVE4+29WGHcRe3AjNsjrUVtRlBTxJDAv8jCGkN4b324Fnz5FRPBAbPf2yyqaCdl9JGN2XmR6adqoxZhSxj14yhGb9rtlzzqV8UaQBXL3TAxIWs6UsbQMJab9l9eJAv094=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183673; c=relaxed/simple;
	bh=sh9sG8+/pW3jQl3qGFuSdZZ2W0OJk79pYjFshIpTtKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mr0bHTTG8UPTGC159nrQrYEn36rm6WrfHlJrPH7tcBGTg0IDihafdyZDoOMyFI2ZwVwAMxAvJJC1YOiu+75JO0flDsljXO9tKaGCEiQoFW5/q4gcyorquUkafkWLmG73IJmBsU4DX4NUBoU1p7jkdzRRo/oufErUh2a9w7Ca2Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHG9Jjka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHG9Jjka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEEB1F00A3D;
	Mon, 31 Aug 2026 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183672;
	bh=Ju6Hd6b7JOmJSG5iHK8RoZrqhhzjy7tPwhoJXKSwWxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHG9JjkaLfTmrsTWelyw9gY7QXLK3ShrNBQdLauQ4PxB3/Gqqz2tBUir5ZHKxjesE
	 aDCzsMOXqjhRKydB7DLvMxZrKrA+vN9fE4xRMPTMFEdvFZw3BkgTbMaL+bisXM9OW0
	 shmWOQuJ8CIIzuHeTm1SoMWJ3IW4/tlbQ4FW+TlHYLDrCC9gONKPADcIcpCSo9imUI
	 BeYIvJkP4E0MSCOsYTZTDN/9MHsg41AEI4JXGMeeNR+yALZdsZ4L4I+nuIuT3HN8BC
	 i4GO2g/aTBPkhId3SQpok8Fya6/qtZ8jtfbeJzhmJTL1xYhiuH7Lrp4+eKdnxEtyxT
	 bXnTlBPy5K34A==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: add boundary checks in two places
Date: Mon, 31 Aug 2026 09:24:23 -0400
Message-ID: <20260831133314.4125787-235-sashal@kernel.org>
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

[ Upstream commit bdc35754012906dbf094be104b103ca3adfef6f7 ]

Add boundary checks in acpi_ps_get_next_namestring() and
acpi_ps_peek_opcode() to prevent out-of-bounds access.

Link: https://github.com/acpica/acpica/commit/cfdc96896d8d
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5180044.0VBMTVartN@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and matched what we already found:

- **Author/grep search on stable** — No hits in linux-6.18.y; the fix
  isn’t in this tree yet.
- **linux-pm web search** — Confirmed the commit lives on Rafael’s
  linux-pm `master` branch; we already identified it as `bdc3575401290`.

The earlier analysis stands: this is a small, self-contained ACPI parser
OOB-read fix that applies cleanly to 6.18.44 and should be backported.

**YES**

 drivers/acpi/acpica/psargs.c  | 18 +++++++++++++++++-
 drivers/acpi/acpica/psparse.c |  6 ++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 34d887e2211ac..a7293332197aa 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -148,10 +148,16 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 
 	/* Point past any namestring prefix characters (backslash or carat) */
 
-	while (ACPI_IS_ROOT_PREFIX(*end) || ACPI_IS_PARENT_PREFIX(*end)) {
+	while (end < parser_state->aml_end &&
+	       (ACPI_IS_ROOT_PREFIX(*end) || ACPI_IS_PARENT_PREFIX(*end))) {
 		end++;
 	}
 
+	if (end >= parser_state->aml_end) {
+		parser_state->aml = parser_state->aml_end;
+		return_PTR(NULL);
+	}
+
 	/* Decode the path prefix character */
 
 	switch (*end) {
@@ -176,6 +182,11 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 
 		/* Multiple name segments, 4 chars each, count in next byte */
 
+		if ((end + 1) >= parser_state->aml_end) {
+			parser_state->aml = parser_state->aml_end;
+			return_PTR(NULL);
+		}
+
 		end += 2 + (*(end + 1) * ACPI_NAMESEG_SIZE);
 		break;
 
@@ -187,6 +198,11 @@ char *acpi_ps_get_next_namestring(struct acpi_parse_state *parser_state)
 		break;
 	}
 
+	if (end > parser_state->aml_end) {
+		parser_state->aml = parser_state->aml_end;
+		return_PTR(NULL);
+	}
+
 	parser_state->aml = end;
 	return_PTR((char *)start);
 }
diff --git a/drivers/acpi/acpica/psparse.c b/drivers/acpi/acpica/psparse.c
index b4f21a8988795..41587ee0a9c78 100644
--- a/drivers/acpi/acpica/psparse.c
+++ b/drivers/acpi/acpica/psparse.c
@@ -70,6 +70,9 @@ u16 acpi_ps_peek_opcode(struct acpi_parse_state * parser_state)
 	u16 opcode;
 
 	aml = parser_state->aml;
+	if (aml >= parser_state->aml_end) {
+		return (0xFFFF);
+	}
 	opcode = (u16) ACPI_GET8(aml);
 
 	if (opcode == AML_EXTENDED_PREFIX) {
@@ -77,6 +80,9 @@ u16 acpi_ps_peek_opcode(struct acpi_parse_state * parser_state)
 		/* Extended opcode, get the second opcode byte */
 
 		aml++;
+		if (aml >= parser_state->aml_end) {
+			return (0xFFFF);
+		}
 		opcode = (u16) ((opcode << 8) | ACPI_GET8(aml));
 	}
 
-- 
2.53.0

