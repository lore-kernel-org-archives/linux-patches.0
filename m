Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060570;
	b=U3iAV2Z/PNpUpZ4DivL32Zt9BU5zku+MsU8koVNEzgKtWw3nwpLd5x0eMDb2R5oDUvIi
	 GLEitrDKFL2o9uI/VvhPpXysuUZvOYH2rcVux8Qowbjc+KEoWoQxDFXP3Wj8U3n0JO6CP
	 G5WuDH3GQ+y7wsZjZL2Piqf3m0oYR7jV4f9NjrjG1QGPcDneUNJ1s69AJOxW6Yve9LHnP
	 CZ6aGYsnrkRGuP+p7PLs4iGN4vHM1MPWfOu9IqIamBnRms4OpqjsaRRD9APCmsYaGUO/p
	 32TPNHlaCIemeR27Wb6FH4R+rB87Qcz14QNcTJSoa00/hAmJO3ujrNaRvo+vH6Y7EMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=myAULB9RaFnGtJzii9/3+FXwr7dpG6lBVJYk165M0Pk=;
	b=4Fb2t/PaNlBgFPSiEAwOzyeIShSBedzUubUG6Gk2J7/9a4+xbZ1M2wdtiz0+cnz1+zow
	 1l0+qcdXYpK8Y8KB/ZNzCkPiciT6knunaF8Um3qutXmbEUb8Y6ryQgbqkswHXJL3GKhUk
	 /m+5KCCdEmJSuxeTVLseMn5oUmw9ZTVp7sJsf8dZY4DIowDdkv8wPNCmqRP5Zny1URV8V
	 RGYjPG/+B4kpu7FbXMbcH7Z+Sp+NlnO++CXoqhg6cOdsqQvFTspXFiTM2Je99RO+DvMPB
	 rdo0s3wacCRgFb6PbRSVMQsb4Xm9MUAGmoBEi8cYOALHpRxzv9A4ahQQw3xN7wBZWFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgX98bbY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45702606A325;
	Thu, 19 Nov 2026 03:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgX98bbY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937311F000C4;
	Thu, 19 Nov 2026 03:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060570;
	bh=myAULB9RaFnGtJzii9/3+FXwr7dpG6lBVJYk165M0Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgX98bbYqJi03d0Hb1lNciaOpmqVCWPzhuDQHEIazhpsPzME2cpOqq0CCSk+EOQtv
	 ZVlrP4pcBEj2E0DsPtggXffadCWGwfJXUDrH3DhK6T+zeiIml2HPujFdpBz9NnZ6N1
	 qzJWs6viJv9PQ6oompvoVdKy+htpJdRMgIGyZBUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1194/1848] ACPI: utils: Adjust message printing macros for ACPI objects
Date: Wed, 18 Nov 2026 15:53:52 +0100
Message-ID: <20261118150009.527252605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c5b51d8dcbe18..2606438f182bd 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1052,34 +1052,34 @@ void __acpi_handle_debug(struct _ddebug *descriptor, acpi_handle handle, const c
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



