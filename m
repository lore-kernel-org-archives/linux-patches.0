Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039445;
	b=W+mkR9lBKiTQBOcrcZp/vtFhNVWJeh5kpU2jPrEDTx2y/iclbf9DZ6lUDDF+l6BfN6FJ
	 cacpMHuQ1XQlN1ZRk5q/pYR5ANbjGvvwhIP92caI7qe7ehZSffgqD+aYTaPjtARDTC47t
	 +xrZimX7Swu+H/iu/AIJ4H+iXXA9B7mG6SvTPu9/fhCaUNCd6wKkJ3FwOrq3VDZViPROR
	 F6hEi8z7BERBZL66Y0gRQp8sardcA/fvN4+CAe8HivsZhKf7A2LGkXlrAJYO8fAa8ezrL
	 TbG33X3T6sqnothZOksS8Usmppb9he0JlEeMwxwe9SfwAf78DVK00F1VEoEmAhQ9AjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6qrOYarSE4fzGHZiyzXD0zLZKaZf+Znlir+kVHpXGMQ=;
	b=kngPRmHtmUg7P6+vBOQXUuM9ni8MpkD75h8PICtG6DHl5S31xRl9hdtATDPYegw8Eq7Y
	 Ds+KcADwGkEf+NdSTPEUM6+jmcMdgfogezOyjTI3KBQWGE0s0MsbmpTmjav2uC40SaBi7
	 pGIFlU/bRYPuS8pMOtmMxP7r2ZIYVI0qUUAqhdQ0N5vbU0n6dO/3aVqRcP5qBUXlmLqAk
	 gJWOLuJ0+/gxfoC8qam3tGLjYS9Sx+uboTs7THEx/zppwFASOb6MjK6TRjJlht41/Be2a
	 Jbeoz2ALOyMI9eGzwjVUzuCo0NDK8MpSAjLI8SeyRrrTq5ueNT5gj8QbcocVp3zwE0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXgdY0cy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75B606A31C;
	Wed, 18 Nov 2026 22:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXgdY0cy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC11F1F000C4;
	Wed, 18 Nov 2026 22:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039445;
	bh=6qrOYarSE4fzGHZiyzXD0zLZKaZf+Znlir+kVHpXGMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXgdY0cy9Lsva6AkMXezktN3Jy+HOqcfsuP2Gt7aMbtSXxVmHM4FByFiqSlYz8se4
	 U0lilQ0z7g2pjgiL7nqCmDk/L6jHKG+dbWt/h3b0w9RE+SB8EOc4UyZJ2z/Jkg6Gjh
	 gC7CZIuG0EIUsbOV59Yu9Y9fotBpEOhYgh2IRngI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2104/3318] ACPI: utils: Adjust message printing macros for ACPI objects
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118150425.201315683@linuxfoundation.org>
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
index 7c6f4006389da..7686849eb5822 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1202,34 +1202,34 @@ void __acpi_handle_debug(struct _ddebug *descriptor, acpi_handle handle, const c
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



