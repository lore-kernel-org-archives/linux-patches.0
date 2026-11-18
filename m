Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047995;
	b=Set1FcSklY4GsGDp72HJr27i7xv/YgfE8JSdrZ97udZMHUYcQjF7plgRJbkVyLxwUazT
	 Ryw0LSCtT1VgVQd9FKlgIkKA9mnTpw0S9V9DiY9Blet104B/6SErVdcJHOrNoj7Yo+K46
	 tE07ksYPKuVhRV6MK6QGU5MTRnNueQX1N2iGi5Q8TNysnMKJg0+HrU8O3d4Ex/ludw1IG
	 CClOfhETNniGnogOBiI94j4A/whH+Mf3vEaWzOre+SOnfAqcFNQtiSPownCX4ERIOWmdi
	 jjwOFG8AiN/yvqEh32KmYKY5lYqEN6AyKr8PXHNGdQjeJMMuMXyJ+RteS4UvC+HJ/2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zc9QYqEP4wAkl/lj+oury4fFTXlx0L6SRl/THySk+VQ=;
	b=Oa51azHo3ZkvbptcJN1AQVi4s0LypU4ljT8uC+cCzJszbz6BTUzSqrmkYck+tpcnNhv2
	 HHeIsOGB7WQAiw5HQhzK/y85fUplRqEEMMKqbZtMtvMfdYW06CYv4pGibJceuIm435qmo
	 viaLdvrdTFtcbD+jLBIQDI8whrjEEM1RPplTkmqp51GvG110iLKWqtOgZwozQYrkyvlQP
	 Ln85zSccXyvSL+zam0a3E7GbfI/vl4O3wg8n0KsnzsIhtKGMcykyePTzXUSX0zChU2MGx
	 /pvO+4xeycDrrMuucxpReg+bUoKZO1HX6MxM6UaF3PrZOgdcwjyfDE0k1aobqw5tDtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUwkhBEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8997D606A32C;
	Thu, 19 Nov 2026 00:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUwkhBEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88E91F000C4;
	Thu, 19 Nov 2026 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047995;
	bh=Zc9QYqEP4wAkl/lj+oury4fFTXlx0L6SRl/THySk+VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUwkhBEolOImmobKWtLXGDTzQ3LmmHGgWTtfvPSaneV0NjZxIQIWzQ/m7c14YKqNe
	 JfptFKBhEkL7hS+T7D05p7JDKnT2PmBS7Q9qo7OMrQiIhj7pcP/S1tdQGndhsXQZaK
	 4knUjFfQlZVhL0za9cZWLM/U/UKPLMObxwWJGnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1837/2857] ACPI: utils: Adjust message printing macros for ACPI objects
Date: Wed, 18 Nov 2026 15:47:51 +0100
Message-ID: <20261118150307.392612164@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 78ddbfaa72d68acc98cd5ba12eca071d452702c4 ]

The majority of acpi_handle_<level>() macros use neither pr_fmt() nor
dev_fmt() and acpi_handle_debug() uses pr_fmt() like dev_fmt(), but
only if dynamic debug is compiled in.

For more consistency, redefine all of the macros in question to use
dev_fmt() because they are more similar to the analogous dev_*()
family of macros than to the pr_*() ones and make all of them use it
in the same way.

While at it, rephrase the comment documenting those macros for more
clarity.

Fixes: 45fef5b88d1f ("ACPI: add dynamic_debug support")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2300525.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e4e7b2cfe72af..f4373d64ff289 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1168,34 +1168,34 @@ void __acpi_handle_debug(struct _ddebug *descriptor, acpi_handle handle, const c
 #endif
 
 /*
- * acpi_handle_<level>: Print message with ACPI prefix and object path
+ * acpi_handle_<level> - Print a message with ACPI prefix and object path
  *
- * These interfaces acquire the global namespace mutex to obtain an object
- * path.  In interrupt context, it shows the object path as <n/a>.
+ * In thread context, the global namespace mutex is acquired to obtain the
+ * object path.  In interrupt context, the object path is shown as <n/a>.
  */
 #define acpi_handle_emerg(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_EMERG, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_EMERG, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_alert(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_ALERT, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_ALERT, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_crit(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_CRIT, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_CRIT, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_err(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_ERR, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_ERR, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_warn(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_WARNING, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_WARNING, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_notice(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_NOTICE, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_NOTICE, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #define acpi_handle_info(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_INFO, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_INFO, handle, dev_fmt(fmt), ##__VA_ARGS__)
 
 #if defined(DEBUG)
 #define acpi_handle_debug(handle, fmt, ...)				\
-	acpi_handle_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__)
+	acpi_handle_printk(KERN_DEBUG, handle, dev_fmt(fmt), ##__VA_ARGS__)
 #else
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define acpi_handle_debug(handle, fmt, ...)				\
 	_dynamic_func_call(fmt, __acpi_handle_debug,			\
-			   handle, pr_fmt(fmt), ##__VA_ARGS__)
+			   handle, dev_fmt(fmt), ##__VA_ARGS__)
 #else
 #define acpi_handle_debug(handle, fmt, ...)				\
 ({									\
-- 
2.53.0



