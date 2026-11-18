Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028494;
	b=wW4HudvfGJnm+rhWF/KX7fTewgkag7WLYH1qPDxI1B3wmBMEWnB09nl9TdHmXIYQw/p4
	 Qir7dOw+/X0N3PSJik12YhYlk+XkkI25yQOGJAyNgwvJW/JA1pbjY5il/dcB8M6Cx3o5o
	 Qu+wx6adZ/Yuq2kOV8RPiRlzjyfvEOFxOZn0/TY32ccEYAaUsCsL34y+6hpc0gcEUWSPA
	 ZYVLoDp+/CJoK8mNtsl9Z5mlTxGrij3Ll9GMHAJIVdZGHljINFt9PeepI43iudWKRnHK7
	 +DBzLiNDxcwSvdmpB1wF2bnidkPIbwIjHYFKJco/H34NmGRb3ELC7iTOqHdfblRdrZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=l3bqSpXMUpDJQkZenWxVAYhiRxVCS8aiwa2jsZaCSQg=;
	b=jAtLa7QDyTclzrqlEZGN0yF7DN2n33H6hy2qzCXEERruqH+1vBPShDXjtVPFyTLC/GDS
	 gpilzMDW28asKjN5PLGUdN0Ek+3E2aUe1VRE+IS7YW4DWxZiaSrpEvw2sP8RiZjreyfNG
	 Ws5790vWomAz7guB7rWfGZc2atknjarGiuisxp8G1IzELoBYg23vEDlHnK/TVFMKwQ/RJ
	 PwmzoS6T26h8ElPuAmKIjd9JRtLuPtovwcgZ1O7bPaItBeHMaEFUECxgJi+IdkAXk+7dc
	 yfz8vZsFGaPOgUsMrCVJ1NR18nlQJrIesmU8WF7TFD7UR8xptAS6acXbzHfaENLTMEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvROaHf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073E6606A325;
	Wed, 18 Nov 2026 19:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvROaHf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583BD1F000C4;
	Wed, 18 Nov 2026 19:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028493;
	bh=l3bqSpXMUpDJQkZenWxVAYhiRxVCS8aiwa2jsZaCSQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvROaHf9AlK07eQRhb/XQMLMk2sUf+qrtAliSyLjkEfpLZBbKdVeovUJ9W8WFxICV
	 aVczwWRuo1Buyd6KOh3dT0qmYYPdAzxakT2DtoVOjzGxgUNaMAMk4xE4KmqaWwpmId
	 IgjIXLbOWLjsuHtTsN2LumA6+ciRNeMed6eqgDhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0016/1756] ACPI: utils: Add exclusive AML evaluation helpers
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118150008.588371258@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit 80892972ff23bf0b9049230ef0931b34163aaed3 ]

ACPICA drops the interpreter lock while AML waits, for example around EC
accesses, so two methods can run interleaved.

Some firmware relies on methods not interleaving, for instance by
switching an EC page selector without taking the AML mutex that the
other users of that page hold.

Add acpi_evaluate_object_exclusive(), acpi_evaluate_integer_exclusive()
and acpi_execute_simple_method_exclusive() which serialize the
evaluation under a global mutex, for callers that are known to be
affected.

Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/all/CAJZ5v0gS4agVUkCO6M=VW4Wi2y1-s+k23bpzmX9aAZ0Rsv4z9Q@mail.gmail.com/
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Reviewed-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20261018122220.678822-2-aliamemis@disroot.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f91c2cd6dbce ("platform/x86: ideapad-laptop: Evaluate ACPI methods exclusively")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/utils.c    | 41 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  7 +++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 6de542d995189..219d3d23aee8a 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -243,6 +244,28 @@ acpi_extract_package(union acpi_object *package,
 
 EXPORT_SYMBOL(acpi_extract_package);
 
+static DEFINE_MUTEX(acpi_exclusive_eval_lock);
+
+/**
+ * acpi_evaluate_object_exclusive - Evaluate an object without interleaving
+ * @handle: ACPI handle of the object or its scope.
+ * @pathname: Path of the object relative to @handle.
+ * @arguments: Arguments to pass, or NULL.
+ * @buffer: Buffer for the return value, or NULL.
+ *
+ * Same as acpi_evaluate_object(), but serialized with other exclusive
+ * evaluations.  Use it only for methods known to break when interleaved.
+ */
+acpi_status acpi_evaluate_object_exclusive(acpi_handle handle, acpi_string pathname,
+					   struct acpi_object_list *arguments,
+					   struct acpi_buffer *buffer)
+{
+	guard(mutex)(&acpi_exclusive_eval_lock);
+
+	return acpi_evaluate_object(handle, pathname, arguments, buffer);
+}
+EXPORT_SYMBOL_GPL(acpi_evaluate_object_exclusive);
+
 acpi_status
 acpi_evaluate_integer(acpi_handle handle,
 		      acpi_string pathname,
@@ -277,6 +300,16 @@ acpi_evaluate_integer(acpi_handle handle,
 
 EXPORT_SYMBOL(acpi_evaluate_integer);
 
+acpi_status acpi_evaluate_integer_exclusive(acpi_handle handle, acpi_string pathname,
+					    struct acpi_object_list *arguments,
+					    unsigned long long *data)
+{
+	guard(mutex)(&acpi_exclusive_eval_lock);
+
+	return acpi_evaluate_integer(handle, pathname, arguments, data);
+}
+EXPORT_SYMBOL_GPL(acpi_evaluate_integer_exclusive);
+
 int acpi_get_local_u64_address(acpi_handle handle, u64 *addr)
 {
 	acpi_status status;
@@ -686,6 +719,14 @@ acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 }
 EXPORT_SYMBOL(acpi_execute_simple_method);
 
+acpi_status acpi_execute_simple_method_exclusive(acpi_handle handle, char *method, u64 arg)
+{
+	guard(mutex)(&acpi_exclusive_eval_lock);
+
+	return acpi_execute_simple_method(handle, method, arg);
+}
+EXPORT_SYMBOL_GPL(acpi_execute_simple_method_exclusive);
+
 /**
  * acpi_evaluate_ej0: Evaluate _EJ0 method for hotplug operations
  * @handle: ACPI device handle
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index b8cf06904fa20..f46464d1430a2 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -30,6 +30,12 @@ acpi_status
 acpi_evaluate_integer(acpi_handle handle,
 		      acpi_string pathname,
 		      struct acpi_object_list *arguments, unsigned long long *data);
+acpi_status acpi_evaluate_object_exclusive(acpi_handle handle, acpi_string pathname,
+					   struct acpi_object_list *arguments,
+					   struct acpi_buffer *buffer);
+acpi_status acpi_evaluate_integer_exclusive(acpi_handle handle, acpi_string pathname,
+					    struct acpi_object_list *arguments,
+					    unsigned long long *data);
 bool acpi_evaluate_reference(acpi_handle handle, acpi_string pathname,
 			     struct acpi_object_list *arguments,
 			     struct acpi_handle_list *list);
@@ -49,6 +55,7 @@ acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld
 bool acpi_has_method(acpi_handle handle, char *name);
 acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 				       u64 arg);
+acpi_status acpi_execute_simple_method_exclusive(acpi_handle handle, char *method, u64 arg);
 acpi_status acpi_evaluate_ej0(acpi_handle handle);
 acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
 acpi_status acpi_evaluate_reg(acpi_handle handle, u8 space_id, u32 function);
-- 
2.53.0



