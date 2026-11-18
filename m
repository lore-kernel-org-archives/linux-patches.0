Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047049;
	b=KLyBMMeZNi/qqpNj4QokHJKOiqc4kzHvV1i+XRW4nE3T/KQGpNL3cAQZc5qwczMMvSkm
	 /kw5ydvTIGenKfCpdhBu7iZcATNEO/ObSK/IE97SF1nuLhb7KKyZ/m+vehElD08kFIoyQ
	 VA87CXYEkDPkr0Ae1N4XfB8NhAwfS9fLDUvWQ+kMRoel67rbSvrdNAsOtu9ReXrqDQTxf
	 Rdb5Y1vpP0reiH1BlHWZG2AXbpMkOSuVUXpQg9OQHcUAho1F/xNf1Z2+9OdRcHlh3iFsW
	 /E1xtpL0LEkgTrtCURFWO8hDfKCqmvmOcUKOYqWBj3mdnPYtZOo3vrIR7qt0sxbtotw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVU1xXC0I/4jMCnvHNNFMwDCCkFTCfnkjXhFZlu6P9M=;
	b=g4o8vGZ07+jHiryRTrFkhhnJWHwIlwGTwF4ZjQP3nD6OVCZCkSe2sGwe8rostgHl29o4
	 K/sAXAHbiZETXU1N0rkaYqSplUH9ho5SpP+I3+OPJ+N1M0fKXhBFMMj7VAQPWlwE2T9HY
	 pCoiMzVqklD+ibdNP0mSC5J/NNGLIhJwIMjw021eWlatBI2i1NVUtxttVFl41cFv1xqDU
	 qEowrb7wjRRMC3esuRnrI3qYXAnxFuUFlSQSIthqXw24dUbrpscv5hNu/OSjABpWaiE4z
	 miCeygJlf4B8xXYw+v+Al9CSJ6cTVQFzFSeWF4Ck4qbr0IfQUklMHFhLgyIKjqLaAww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2z21OlT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4060A2624;
	Thu, 19 Nov 2026 00:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2z21OlT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309921F000C5;
	Thu, 19 Nov 2026 00:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047048;
	bh=oVU1xXC0I/4jMCnvHNNFMwDCCkFTCfnkjXhFZlu6P9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2z21OlTq9wSDz9G6Of4yle+pSBTosoZZysc06JwbuGOMlFZM9+1+ER0Ntsylc6RI
	 cTPJ08PVIdnWPOWHv4YyV8u6HfuopJxLM5ovqUvg1ik5Fix3op9hmPkOB3gJxD9c4B
	 piLlicLvMJUmzh9UnR6T1ShzcxoJcI2tn4hzUTVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1498/2857] driver core: Add device_show_string() helper for sysfs attributes
Date: Wed, 18 Nov 2026 15:42:12 +0100
Message-ID: <20261118150255.271312651@linuxfoundation.org>
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
index 7dda59923ed6a..d33c4c9a145dc 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -438,16 +438,6 @@ static char *memdup_to_str(char *maybe_str, int max_len, gfp_t gfp)
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
index 84019bebd901b..32cb9ab16695a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2474,6 +2474,15 @@ ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
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
index da53172bf3c62..70fbcc437360b 100644
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



