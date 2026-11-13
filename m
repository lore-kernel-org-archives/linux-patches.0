Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585931;
	b=BVexMS6F44m3hQy7smj3Hh2+0ID3US7HJbj5RvmzgM+Gw7UkCr39tMJwnjVlTBqEdZYZ
	 diAJOQ9MK44UWbgoCTOK50XfGDjrhZ6sgfLvMEdAuhkiZK8mLBPNkTaBmB6Wh5I9wCWDM
	 8OFfXoQ8cMHWO7+In7SCZjObcAbVoHbn9pv1MTOqCvcmo+Vh908Nb4Yb2j13IKOA/0/pS
	 +U/Acr3cMR6tXxe6s9DkIJYSZi+mCH+y273MkYAdW+Rwg+BwRjreDVyX0vw68ibcmaoPv
	 07/8Np9esvx7gkg8T2dYhm0eRjhZPlKRoVmGif1g6u3nUnGay+dxgVyrsR5oKVVAlbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4kQVp6o0izMNoec5lIYog+9hTt7iqJfCGMhtcq+fdL8=;
	b=4PQPBzgKnlnXZ1CAO0gFKzj+op3b7MZb1g3/skkIvg9V0ycJFYyoYDKxAqOrR+Wp1wym
	 sAZLcjQHSbr+YVP66U4fTP/00GjX9Pcp3YB0cVnHdxs+4LwFjjKLa67gbLVmtgG+pG0WF
	 eyuAY/GRQMnNdS9piKGL+12Es7vMQMAd3BhuvolOSLA3KLl0CBGP2YR6w2Crs9Bo/y62T
	 /QtMIcfogIoQHoDmqqrGdYwTRW0O2rqx/YaEJrATruavC2tzLdRLYFc4UW7t4f3nVDc5y
	 W4MaM1AUuyJ0jCBqQ0c1NhyUmkfmAKDhYdMVdtBmwqWrEr1vogGWj1xCq8sF5AqqsYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmSSEXlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894B2606A33D;
	Fri, 13 Nov 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmSSEXlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3607B1F000C5;
	Fri, 13 Nov 2026 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585931;
	bh=4kQVp6o0izMNoec5lIYog+9hTt7iqJfCGMhtcq+fdL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmSSEXlv7OToZlGIN6STOKswY2YsP1OL4buc5b9AujIbtfSbHoOn/JxTApWTuduIO
	 iFoFr+pw0GHNr9ICo5A9GVJZaVEGVs7JhV7OvE4Pqw6IH/4unq7t1pkFn5fA5P+k1H
	 Tn6c9GVMNhYV9BVVsPW/uLU8hW4OobsGl5EBJMUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 489/507] ACPI: utils: Add exclusive AML evaluation helpers
Date: Fri, 13 Nov 2026 10:53:13 -0500
Message-ID: <20261113153813.645140570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 645f370c932d ("ACPI: battery: Evaluate battery methods exclusively")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/utils.c    | 41 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  7 +++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index d499b72574ab2..ea8cb876c12d2 100644
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
@@ -685,6 +718,14 @@ acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
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
index a10a591c18b23..8b1d329455f7b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -32,6 +32,12 @@ acpi_status
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
@@ -48,6 +54,7 @@ acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
 bool acpi_has_method(acpi_handle handle, char *name);
 acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 				       u64 arg);
+acpi_status acpi_execute_simple_method_exclusive(acpi_handle handle, char *method, u64 arg);
 acpi_status acpi_evaluate_ej0(acpi_handle handle);
 acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
 acpi_status acpi_evaluate_reg(acpi_handle handle, u8 space_id, u32 function);
-- 
2.53.0



