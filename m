Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A494534455;
	Mon, 31 Aug 2026 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183912; cv=none; b=kBNK91No3cUNTqSTd6qc/ETcTF4Ofy6sSRQXKHe6JZYeSN5ZtbWPqbUtJeySjnz2WmlKf26JZj+I6LpNTcmQ6M7mtsnNa8s7gaSv1W55PWS5DXembVa9see2UOk8xnWIS5osWXw9wHg05gdk2eqjhU97PAVbAGxaQlPR/PAnuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183912; c=relaxed/simple;
	bh=pGU4nFc5F5wt4HYuYt9y3KE2TCupWrAg1GDr4pczIaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmBhkS0b7GVpIYlZXBoO8+N+L/VSp5tHsGCcVmjXjnOnU7BASRq0R5wIb27/uA1b3ikwUsT0HRXPoaRiViklxg+vyfpYH2nuNJHSRahWu6niiyAm7y0JMDszqS9zMDV7pTun1uNXVmszG1vP+5PpoxplNpPkK0U/7AagNEuFcvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmCvfsU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmCvfsU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6201F00A3E;
	Mon, 31 Aug 2026 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183909;
	bh=VB+zg8yOh0NtNBNUbG4qqEaBZn7t5SU2TRbaRNR9sUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmCvfsU2HUrTNFntQ9XsG3KcJeAZNx3Y0AAWbC/D18eDvA1hMkYPzUr46K9u/TrbK
	 7MAQbJ211hHvcLeCgR4mHcbtmmsv7UWH9YOzZIxBb6l1E+VhbCYnAvhb3W4+GVcm//
	 Y6k98EHMzs8WvkEKcezW5pv0ZWDcTZN73E1oOIlutJx/t60lKqeRfR04WfedwZWLG8
	 1WlZlynXsK8fXzX6/HUixQhU3wZj/jX8+Dtwt6Spg36OVOP0If+gqqhoqs9eyLGJqQ
	 mJwtsuqeja4DGpAgpBszT9tzbvzvxNIcUWS9bhBhMEFcGjKpgiNl4xO0xQR56YKVUR
	 jqwWqhoVNtHnA==
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
Subject: [PATCH AUTOSEL 6.18-5.10] ACPICA: Add package limit checks in parser functions
Date: Mon, 31 Aug 2026 09:26:43 -0400
Message-ID: <20260831133314.4125787-375-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: ikaros <void0red@gmail.com>

[ Upstream commit d27d48a528e437aed690f977e69a6fe73fe82ab5 ]

Add package limit checks in parser functions to prevent out-of-bounds
access.

Link: https://github.com/acpica/acpica/commit/b31b45af2122
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3212937.CbtlEUcBR6@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished. Both came back empty:

- No commit matching **"Add package limit"** in this tree
- No commits from author **ikaros**
- No related fixes for **"Clamp PackageEnd"**, **"package limit"**, or
  **"package end"**

That confirms the package-limit checks are not in **6.18.44** yet. The
earlier analysis stands: this is a small, maintainer-reviewed bounds-
check fix for a real ACPI parser OOB read, and it should be backported.

**YES**

 drivers/acpi/acpica/nsxfname.c |  4 ++++
 drivers/acpi/acpica/psargs.c   |  4 ++++
 drivers/acpi/acpica/psloop.c   | 25 +++++++++++++++++++++++++
 drivers/acpi/acpica/psparse.c  |  8 ++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
index 1db831545ec8c..821fb4930e9d8 100644
--- a/drivers/acpi/acpica/nsxfname.c
+++ b/drivers/acpi/acpica/nsxfname.c
@@ -512,6 +512,10 @@ acpi_status acpi_install_method(u8 *buffer)
 
 	parser_state.aml += acpi_ps_get_opcode_size(opcode);
 	parser_state.pkg_end = acpi_ps_get_next_package_end(&parser_state);
+	if ((parser_state.pkg_end > parser_state.aml_end) ||
+	    (parser_state.pkg_end < parser_state.aml)) {
+		return (AE_AML_PACKAGE_LIMIT);
+	}
 	path = acpi_ps_get_next_namestring(&parser_state);
 
 	method_flags = *parser_state.aml++;
diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 064652d11d9aa..34d887e2211ac 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -867,6 +867,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 
 		parser_state->pkg_end =
 		    acpi_ps_get_next_package_end(parser_state);
+		if ((parser_state->pkg_end > parser_state->aml_end)
+		    || (parser_state->pkg_end < parser_state->aml)) {
+			return_ACPI_STATUS(AE_AML_PACKAGE_LIMIT);
+		}
 		break;
 
 	case ARGP_FIELDLIST:
diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index 35111ff2526b1..7c3caf0ccab62 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -361,6 +361,13 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 					walk_state->parser_state.aml =
 					    acpi_ps_get_next_package_end
 					    (&walk_state->parser_state);
+					if ((walk_state->parser_state.aml >
+					     walk_state->parser_state.aml_end)
+					    || (walk_state->parser_state.aml <
+						walk_state->aml)) {
+						return_ACPI_STATUS
+						    (AE_AML_PACKAGE_LIMIT);
+					}
 					walk_state->aml =
 					    walk_state->parser_state.aml;
 				}
@@ -421,6 +428,14 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 					parser_state->aml =
 					    acpi_ps_get_next_package_end
 					    (parser_state);
+					if ((parser_state->aml >
+					     parser_state->aml_end)
+					    || (parser_state->aml <
+						walk_state->control_state->
+						control.aml_predicate_start)) {
+						return_ACPI_STATUS
+						    (AE_AML_PACKAGE_LIMIT);
+					}
 					walk_state->aml = parser_state->aml;
 
 					ACPI_ERROR((AE_INFO,
@@ -436,6 +451,16 @@ acpi_status acpi_ps_parse_loop(struct acpi_walk_state *walk_state)
 						walk_state->parser_state.aml =
 						    acpi_ps_get_next_package_end
 						    (parser_state);
+						if ((walk_state->parser_state.
+						     aml >
+						     walk_state->parser_state.
+						     aml_end)
+						    || (walk_state->
+							parser_state.aml <
+							walk_state->aml)) {
+							return_ACPI_STATUS
+							    (AE_AML_PACKAGE_LIMIT);
+						}
 						walk_state->aml =
 						    parser_state->aml;
 					}
diff --git a/drivers/acpi/acpica/psparse.c b/drivers/acpi/acpica/psparse.c
index 55a416e56fd83..b4f21a8988795 100644
--- a/drivers/acpi/acpica/psparse.c
+++ b/drivers/acpi/acpica/psparse.c
@@ -300,6 +300,7 @@ acpi_ps_next_parse_state(struct acpi_walk_state *walk_state,
 {
 	struct acpi_parse_state *parser_state = &walk_state->parser_state;
 	acpi_status status = AE_CTRL_PENDING;
+	u8 *aml;
 
 	ACPI_FUNCTION_TRACE_PTR(ps_next_parse_state, op);
 
@@ -344,7 +345,14 @@ acpi_ps_next_parse_state(struct acpi_walk_state *walk_state,
 		 * Predicate of an IF was true, and we are at the matching ELSE.
 		 * Just close out this package
 		 */
+		aml = parser_state->aml;
+
 		parser_state->aml = acpi_ps_get_next_package_end(parser_state);
+		if ((parser_state->aml > parser_state->aml_end) ||
+		    (parser_state->aml < aml)) {
+			status = AE_AML_PACKAGE_LIMIT;
+			break;
+		}
 		status = AE_CTRL_PENDING;
 		break;
 
-- 
2.53.0

