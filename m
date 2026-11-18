Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038478;
	b=kR9RGTcJhF2mHMNounDoRQ6TKO2sP5lflbEcVaWKs1y7QVFR2HNfWc5nJaQDg53S4h8/
	 Bis5oNANtdTgr184fMtiQWecOGHnDwouZVelt/7GwYFc6oKazUeVTDgYyMtpCMGENWo8R
	 KlH1Nf8NEYMNwMC7oYU499shtVCt91ntlsc3yDhYHClrHVEJTZwX6E92azCfyLG0bKLE5
	 1CKICj1rT99duJpsWqxj2T9zUQnGTkNMM0MkeT+IJtmht+IBhXbidLbdSEFPHK5hB7kpb
	 YCSl91bG6O4+gmDbLxGpRxW50iuamDro+ixooleTDnKAIdfhmrQSP24u85SrYIU0K/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YoaNGstXB/XshezwvgLsBssT0FNJyI1y8PQ3U6FW9YU=;
	b=mSp1WUPwYPWO09RZoc9HIScCGN/qsSx8G9TcjJAaPU6sKrOODBOb4XjLStvJpEhW3SoK
	 YYYV+zDgiLxAoMKhkd0olEWHFh58nQJOkYv3nTVv5sJBXVQSYUWir+ODl2yw2y3vbHcFY
	 pwlhjd21dnQMSEZjdWr6nfAil0ppE1ZX1oPyq1iB3ZI8P3pLitctxvxFmQXzATma8rya6
	 mXKU+pdxOO7BEBSkz3nmVA56NE4qyRc8F0LURACGNakzc+d+n6oMboAhPx9CqDs97GTGm
	 XsN9Ola8E4tgY1V03uH1trNFtXPFA07/CxeLUPBJPiLgCRbTptn7IPdh0GAq2mG8HVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whJT8ZV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A799606A325;
	Wed, 18 Nov 2026 21:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whJT8ZV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC3A1F000C4;
	Wed, 18 Nov 2026 21:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038477;
	bh=YoaNGstXB/XshezwvgLsBssT0FNJyI1y8PQ3U6FW9YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whJT8ZV74hJ7h4YQhZ76w4I028Vj/EkvpaAKsiW9oTgSImjZiPFqX1IihG2IWa6BG
	 1uTLVsP5V0R95cwO/VM5vUFlS4pY694/B1PdVivg4/gk6rGcD6iZqZ9n/OCj+kP0PS
	 whX5/IFhWDJWp1kIuEffTh4JKSJ6+pfUSzfBxOPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1757/3318] driver core: Add device_show_string() helper for sysfs attributes
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118150414.566240023@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3cc50d07be10f67aff836f8247a240ec132c6a67 ]

For drivers wishing to expose an unsigned long, int or bool at a static
memory location in sysfs, the driver core provides ready-made helpers
such as device_show_ulong() to be used as ->show() callback.

Some drivers need to expose a string and so far they all provide their
own ->show() implementation.  arch/powerpc/perf/hv-24x7.c went so far
as to create a device_show_string() helper but kept it private.

Make it public for reuse by other drivers.  The pattern seems to be
sufficiently frequent to merit a public helper.

Add a DEVICE_STRING_ATTR_RO() macro in line with the existing
DEVICE_ULONG_ATTR() and similar macros to ease declaration of string
attributes.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2e3eaaf2600bb55c0415c23ba301e809403a7aa2.1713608122.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3d9a175707ee ("platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 10 ----------
 drivers/base/core.c         |  9 +++++++++
 include/linux/device.h      | 15 +++++++++++++++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 3449be7c0d51f..cfb010dc285b7 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -425,16 +425,6 @@ static char *memdup_to_str(char *maybe_str, int max_len, gfp_t gfp)
 	return kasprintf(gfp, "%.*s", max_len, maybe_str);
 }
 
-static ssize_t device_show_string(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct dev_ext_attribute *d;
-
-	d = container_of(attr, struct dev_ext_attribute, attr);
-
-	return sprintf(buf, "%s\n", (char *)d->var);
-}
-
 static ssize_t cpumask_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3e722d2d5dd3c..69d9115fec0f0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2548,6 +2548,15 @@ ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
 }
 EXPORT_SYMBOL_GPL(device_show_bool);
 
+ssize_t device_show_string(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *ea = to_ext_attr(attr);
+
+	return sysfs_emit(buf, "%s\n", (char *)ea->var);
+}
+EXPORT_SYMBOL_GPL(device_show_string);
+
 /**
  * device_release - free device structure.
  * @kobj: device's kobject.
diff --git a/include/linux/device.h b/include/linux/device.h
index 15eb24877a518..85f0412ca0668 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -138,6 +138,8 @@ ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
 			char *buf);
 ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
+ssize_t device_show_string(struct device *dev, struct device_attribute *attr,
+			   char *buf);
 
 /**
  * DEVICE_ATTR - Define a device attribute.
@@ -257,6 +259,19 @@ ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_bool, device_store_bool), &(_var) }
 
+/**
+ * DEVICE_STRING_ATTR_RO - Define a device attribute backed by a r/o string.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_var: Identifier of string.
+ *
+ * Like DEVICE_ULONG_ATTR(), but @_var is a string. Because the length of the
+ * string allocation is unknown, the attribute must be read-only.
+ */
+#define DEVICE_STRING_ATTR_RO(_name, _mode, _var) \
+	struct dev_ext_attribute dev_attr_##_name = \
+		{ __ATTR(_name, (_mode) & ~0222, device_show_string, NULL), (_var) }
+
 #define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
-- 
2.53.0



