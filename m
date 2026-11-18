Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047046;
	b=P78HidvgO6JW6Nch9uDvpejYLobDMhocpPTyuTTdmkJQEtLKB3NHsqU083kdAwW8ppYP
	 rIyTirtkBKvt6/RcgizU3E8QMhsfwoZ6pTpf1vpMG3XcsJfpQYbsMtX7FeCMwivxFh5ev
	 ubOJzEGAxzSVTdFWODDmK/S+vVlHphG/YTKoEx4NT1kRa8Z1tnSn1KN9WNXQAiSBd3pGq
	 4HODaRBmY+GOu4xk9tcyFkPvieZV7/JLNqjIyKpLnZRZVkfeNaJBCeiSCfVVaer86V/bE
	 3ISZi71Oj0bo2Kf7EM72BYJsCcALHmGNHKWZzF61S9AqdFMMruz3hGQBGkMq45WxAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5abIlZybKHeh79HD3DPwEqcdwoXc9zTt34ojCpbc9k=;
	b=bHZ3d+2roBZl6xBup9DrKsy5f1NO7loj2ODSnVJFV+ka9Ut7+QEjmZQk4dHkBEV+qzyd
	 fCMDl0Nse/6UYuZf39NQQqTgj8X+CvT8b3VYZl5HLMQSObAd6f/wU1lyPORLBNL1J3S8J
	 PYO6P8u3kKHLdLUGpqd1XQ7qlKpIaEf0fBqjHvcYuhlQF6400OqT/zanbq5Vq9A1amOfL
	 EmfbuTAvwD0iX4UrW2n5R8psi2wq+uRYeuDc1ARD3Iu6dPl236TqHXY9VgbHIk6/hPMRT
	 Ai8h0mRxbBNIX1raww26bhwKwRFTd+FTGuFLMQ6BP9HCeR9h5TsW5F25WHMZ1wlwPIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWzjMp2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B260A2617;
	Thu, 19 Nov 2026 00:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWzjMp2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603961F000C7;
	Thu, 19 Nov 2026 00:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047045;
	bh=n5abIlZybKHeh79HD3DPwEqcdwoXc9zTt34ojCpbc9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWzjMp2KP4b13auzHOiZcIHHssSl2yckVLddWQ61YUYwgZWs6aWbOFsuVLtJZJdRj
	 JVB0YmwPnd1olscocPu0g7qDSRJPwBMoH5Qd/2aL2yt4/vlGMu2vtbAoomoGJbsRTa
	 FLrfvdD1WWe9KfCVg4hR7hkNL4AA7D2/Ps5ZWRM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	James Seo <james@equiv.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1497/2857] driver core: device.h: add some missing kerneldocs
Date: Wed, 18 Nov 2026 15:42:11 +0100
Message-ID: <20261118150255.228712898@linuxfoundation.org>
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

From: James Seo <james@equiv.tech>

[ Upstream commit cd00bc2ca42705bf141a2bf6fb5224c7ae628dbe ]

struct device_attribute, struct dev_ext_attribute, dev_name(), and the
DEVICE_ATTR() macros lack kerneldocs, preventing them from appearing in
the driver core documentation and from being cross-referenced elsewhere.

Add the missing kerneldocs (except for DEVICE_ATTR_IGNORE_LOCKDEP(),
which is only meaningful on debug builds with CONFIG_DEBUG_LOCK_ALLOC
defined, and is aliased to DEVICE_ATTR() otherwise).

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: James Seo <james@equiv.tech>
Link: https://lore.kernel.org/r/20230509024702.1977991-1-james@equiv.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3d9a175707ee ("platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 111 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index b35162a3ab8b3..da53172bf3c62 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -102,7 +102,12 @@ struct device_type {
 	bool need_parent_lock;
 };
 
-/* interface for exporting device attributes */
+/**
+ * struct device_attribute - Interface for exporting device attributes.
+ * @attr: sysfs attribute definition.
+ * @show: Show handler.
+ * @store: Store handler.
+ */
 struct device_attribute {
 	struct attribute	attr;
 	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
@@ -111,6 +116,11 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
+/**
+ * struct dev_ext_attribute - Exported device attribute with extra context.
+ * @attr: Exported device attribute.
+ * @var: Pointer to context.
+ */
 struct dev_ext_attribute {
 	struct device_attribute attr;
 	void *var;
@@ -129,30 +139,124 @@ ssize_t device_show_bool(struct device *dev, struct device_attribute *attr,
 ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
 
+/**
+ * DEVICE_ATTR - Define a device attribute.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_show: Show handler. Optional, but mandatory if attribute is readable.
+ * @_store: Store handler. Optional, but mandatory if attribute is writable.
+ *
+ * Convenience macro for defining a struct device_attribute.
+ *
+ * For example, ``DEVICE_ATTR(foo, 0644, foo_show, foo_store);`` expands to:
+ *
+ * .. code-block:: c
+ *
+ *	struct device_attribute dev_attr_foo = {
+ *		.attr	= { .name = "foo", .mode = 0644 },
+ *		.show	= foo_show,
+ *		.store	= foo_store,
+ *	};
+ */
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
+
+/**
+ * DEVICE_ATTR_PREALLOC - Define a preallocated device attribute.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_show: Show handler. Optional, but mandatory if attribute is readable.
+ * @_store: Store handler. Optional, but mandatory if attribute is writable.
+ *
+ * Like DEVICE_ATTR(), but ``SYSFS_PREALLOC`` is set on @_mode.
+ */
 #define DEVICE_ATTR_PREALLOC(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name = \
 		__ATTR_PREALLOC(_name, _mode, _show, _store)
+
+/**
+ * DEVICE_ATTR_RW - Define a read-write device attribute.
+ * @_name: Attribute name.
+ *
+ * Like DEVICE_ATTR(), but @_mode is 0644, @_show is <_name>_show,
+ * and @_store is <_name>_store.
+ */
 #define DEVICE_ATTR_RW(_name) \
 	struct device_attribute dev_attr_##_name = __ATTR_RW(_name)
+
+/**
+ * DEVICE_ATTR_ADMIN_RW - Define an admin-only read-write device attribute.
+ * @_name: Attribute name.
+ *
+ * Like DEVICE_ATTR_RW(), but @_mode is 0600.
+ */
 #define DEVICE_ATTR_ADMIN_RW(_name) \
 	struct device_attribute dev_attr_##_name = __ATTR_RW_MODE(_name, 0600)
+
+/**
+ * DEVICE_ATTR_RO - Define a readable device attribute.
+ * @_name: Attribute name.
+ *
+ * Like DEVICE_ATTR(), but @_mode is 0444 and @_show is <_name>_show.
+ */
 #define DEVICE_ATTR_RO(_name) \
 	struct device_attribute dev_attr_##_name = __ATTR_RO(_name)
+
+/**
+ * DEVICE_ATTR_ADMIN_RO - Define an admin-only readable device attribute.
+ * @_name: Attribute name.
+ *
+ * Like DEVICE_ATTR_RO(), but @_mode is 0400.
+ */
 #define DEVICE_ATTR_ADMIN_RO(_name) \
 	struct device_attribute dev_attr_##_name = __ATTR_RO_MODE(_name, 0400)
+
+/**
+ * DEVICE_ATTR_WO - Define an admin-only writable device attribute.
+ * @_name: Attribute name.
+ *
+ * Like DEVICE_ATTR(), but @_mode is 0200 and @_store is <_name>_store.
+ */
 #define DEVICE_ATTR_WO(_name) \
 	struct device_attribute dev_attr_##_name = __ATTR_WO(_name)
+
+/**
+ * DEVICE_ULONG_ATTR - Define a device attribute backed by an unsigned long.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_var: Identifier of unsigned long.
+ *
+ * Like DEVICE_ATTR(), but @_show and @_store are automatically provided
+ * such that reads and writes to the attribute from userspace affect @_var.
+ */
 #define DEVICE_ULONG_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_ulong, device_store_ulong), &(_var) }
+
+/**
+ * DEVICE_INT_ATTR - Define a device attribute backed by an int.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_var: Identifier of int.
+ *
+ * Like DEVICE_ULONG_ATTR(), but @_var is an int.
+ */
 #define DEVICE_INT_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_int, device_store_int), &(_var) }
+
+/**
+ * DEVICE_BOOL_ATTR - Define a device attribute backed by a bool.
+ * @_name: Attribute name.
+ * @_mode: File mode.
+ * @_var: Identifier of bool.
+ *
+ * Like DEVICE_ULONG_ATTR(), but @_var is a bool.
+ */
 #define DEVICE_BOOL_ATTR(_name, _mode, _var) \
 	struct dev_ext_attribute dev_attr_##_name = \
 		{ __ATTR(_name, _mode, device_show_bool, device_store_bool), &(_var) }
+
 #define DEVICE_ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store) \
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
@@ -750,6 +854,11 @@ static inline bool device_iommu_mapped(struct device *dev)
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
+/**
+ * dev_name - Return a device's name.
+ * @dev: Device with name to get.
+ * Return: The kobject name of the device, or its initial name if unavailable.
+ */
 static inline const char *dev_name(const struct device *dev)
 {
 	/* Use the init name until the kobject becomes available */
-- 
2.53.0



