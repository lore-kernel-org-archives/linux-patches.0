Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621337;
	b=V3Luf2BP6Ro2kvveHVPYrzxj8dfBSgpTtjSJjB3+WOXjuUF5Th/Hqf6Gb0udEXMGnf9l
	 LngkfhaOa04ZXFQb8qKcLqdczNL2ESgGu5F3waGjzjuW1NSk7kDDmq5wNECMfveU5iYRT
	 ednCP7ZE0KoCeSf76WE2ZgmgapL0y0kJ0amRYZXivQ0qZl4j65Ef4Et+nEHZcfupvMHSU
	 cdKM5TPa6PDQhIBflnOs1xK6Qv1C4f+Kw738eBo+xSF7aj/0iL8y7t2F7GAlNXqir/Uuo
	 BZSHEii6lF5Ijw1ZiNtj6BPklZNHzMPI7I9v43sUv5O0O065ZUrrcfUAtbylyIRJ1mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621337;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xrsD24iqP9BcnJ+m4SyhgJDWqDe/xNX2cexHWZXcXLQ=;
	b=AV72HS5+Osa5pHTiw/8auXZ0NWs1CslkTLGITXb7HuhEYsVgYd7QftNg6o7dxxhZH8Pg
	 OEFeR0L9YcX11nEM+aG1U537Wsbd7+VD03+AKv1hY0ImI5nJScRqEBjTZhdbmSxNAy1GW
	 G1sVXlSLcpNVtIwdEgo/kw9N6FvH/wQnyDhuqEQ76pTz5KjVG7gr8EilEB4ounZhuwfz1
	 UJg9/qK8JPACbwDo1sSmX+cUBAvwsI7B0B8E49uW7kibKFkJbcD8UnF/a9XpG1URyfA2M
	 i1mXaLOy0F0Y1rYZ10fI+jefhn+GctIknFak7DaJ7Clvxka8pk45tlO5wup9/Gv26Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SiicTOQ3;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B173A606A322
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 22:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B173A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SiicTOQ3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792621336; x=1824157336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DmYRawRuj7bsQmnCYT62WbVrUFTA/FdRxfX6js16pZo=;
  b=SiicTOQ3/2406TV1EYCyKoeToPz9RAE4MGkoWrRdJhCPJ8LTRTP0h95K
   6evAcXt0DVkT1GjBVSih5G1HBHFSF5lqhfMhFkWkz90HKvRb4Bj4Vw0Fn
   cL3JLdDxz9LTGK5gLSP8g9rXfsz+NpXnKuPZ0xVOaGCIiN5BlaMhjJQD6
   OhOyEXRCwSKhZYAsPmFFnpdQHdbcVPmh6/XhYkMEnK4h9aYIBAsfIOHMX
   W1NNvjCBjlu6u/TuRtd3hPChVkxoVjZi+ocTcZQwC8VJWqovqIhZqW7XT
   GUcjFZsllyV4o4kGs4MUiQ48tX9fnaQZXuA8J4AktAtyliPnYdTIwqiA/
   g==;
X-CSE-ConnectionGUID: 3HztIPH+SbS3VdWKwWWMLQ==
X-CSE-MsgGUID: epJG+4APRG62kR8LnAUuAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1346500"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1346500"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 15:22:16 -0700
X-CSE-ConnectionGUID: PoABvuNHT06unKb5OzN5Pw==
X-CSE-MsgGUID: FYhdS9y+T8KwCY5iIXyMwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3127900"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.213])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 15:22:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: tony.luck@intel.com
Cc: Dave.Martin@arm.com,
	babu.moger@amd.com,
	david.e.box@intel.com,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	hch@infradead.org,
	james.morse@arm.com,
	linux-kernel@vger.kernel.org,
	maciej.wieczor-retman@intel.com,
	patches@lists.linux.dev,
	peternewman@google.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	yu.c.chen@intel.com
Subject: [PATCH v14+ 20/24] x86/resctrl: Export interface to report telemetry unbind/remove
Date: Wed, 21 Oct 2026 15:22:08 -0700
Message-ID: <20261021222208.16324-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019205031.16977-21-tony.luck@intel.com>
References: <20261019205031.16977-21-tony.luck@intel.com>
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

resctrl obtains the addresses of the telemetry MMIO regions from the
pmt_telemetry driver at mount time and holds a reference on the module
until unmount, so the module cannot be unloaded while resctrl may read
the counters.

The module reference does not prevent a telemetry device from being
unbound from the driver, or removed. Either tears down the MMIO mappings
that hold the event counters, and a subsequent read of an event by
resctrl faults on the stale address.

Provide an interface for pmt_telemetry to report that the mappings for a
package are about to be torn down. Stop using the regions of that package
and serialize event reads with the notification so that no read uses an
address once it has been reported. Events of the affected package then
read "Unavailable".

Update AET enumeration to handle races between enumeration and device
unbind/removal.  Count invalidations in a generation counter protected
by aet_lock.  Sample it before calling get_feature() and, under aet_lock,
check that it did not change before enabling events and publishing the
copy. If it changed, drop the copy and retry. The new copy reflects the removal.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14+
	Handle races between enumeration and device unbind/remove by
	adding a count of invalidations that is updated & checked
	while holding aet_lock.

 include/linux/intel_vsec.h              |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 87 ++++++++++++++++++++++---
 2 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index c04b1d0f3143..bcbf4937c71c 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -262,11 +262,13 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p));
 void intel_aet_unregister_enumeration(void);
+void intel_aet_invalidate(u8 package_id);
 #else
 static inline void intel_aet_register_enumeration(struct module *module,
 						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 						  void (*put)(struct pmt_feature_group *p)) { }
 static inline void intel_aet_unregister_enumeration(void) { }
+static inline void intel_aet_invalidate(u8 package_id) { }
 #endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
 
 #endif
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 4ba27586fb50..589666e12b78 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -339,6 +339,8 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
  * Serialises AET's view of pmt_telemetry:
  *   - pmt_module, get_feature, put_feature, pmt_in_use
  *   - every event_group's ->pfg
+ *   - the telemetry_region::addr entries reachable through ->pfg
+ *   - aet_invalidate_gen
  *
  * Lock ordering with pmt/telemetry.c's ep_lock is ep_lock -> aet_lock.
  * AET therefore must not call get_feature() (which takes ep_lock) while
@@ -356,6 +358,30 @@ static void (*put_feature)(struct pmt_feature_group *p);
  */
 static bool pmt_in_use;
 
+/*
+ * Detect MMIO invalidations to resolve races between device unbind/remove
+ * and mount or resctrl file system.
+ */
+static unsigned int aet_invalidate_gen;
+
+/*
+ * Confirm that no MMIO invalidations occured before adding the feature
+ * group to the event group.
+ */
+static int aet_publish_events(struct event_group *e, struct pmt_feature_group *p,
+			      unsigned int gen)
+{
+	guard(mutex)(&aet_lock);
+
+	if (gen != aet_invalidate_gen)
+		return -EAGAIN;
+	if (!enable_events(e, p))
+		return -ENODEV;
+	e->pfg = p;
+
+	return 0;
+}
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -373,24 +399,36 @@ static bool aet_get_events(struct pmt_feature_group *(*get)(enum pmt_feature_id
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
 	struct event_group **peg;
+	unsigned int gen;
 	bool ret = false;
+	int err;
 
 	if (!resctrl_arch_system_max_rmid_idx())
 		return false;
 
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = get(pfid);
-		if (IS_ERR_OR_NULL(p))
-			continue;
-		if (enable_events(*peg, p)) {
-			scoped_guard(mutex, &aet_lock) {
-				(*peg)->pfg = p;
+		do {
+			/*
+			 * get() takes ep_lock, so it cannot be called with
+			 * aet_lock held. Sample the invalidation generation
+			 * first and retry if a telemetry device was removed
+			 * before @p could be published.
+			 */
+			scoped_guard(mutex, &aet_lock)
+				gen = aet_invalidate_gen;
+			p = get(pfid);
+			if (IS_ERR_OR_NULL(p)) {
+				err = -ENOENT;
+				break;
 			}
+			err = aet_publish_events(*peg, p, gen);
+			if (err)
+				put(p);
+		} while (err == -EAGAIN);
+
+		if (!err)
 			ret = true;
-		} else {
-			put(p);
-		}
 	}
 
 	return ret;
@@ -416,6 +454,35 @@ void intel_aet_unregister_enumeration(void)
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+/*
+ * pmt_telemetry driver calls while holding ep_lock. This is for unbind/remove
+ * operations that will invalidate the virtual addresses of MMIO registers
+ * provided by intel_pmt_get_regions_by_feature(). This simple interface may
+ * be overly broad if there are multiple telemetry devices per-package. An
+ * unbind/remove operation on one device will stop resctrl from reading
+ * event counters from all devices on the same package.
+ */
+void intel_aet_invalidate(u8 package_id)
+{
+	struct event_group **peg;
+
+	guard(mutex)(&aet_lock);
+
+	aet_invalidate_gen++;
+
+	for_each_event_group(peg) {
+		struct event_group *e = *peg;
+
+		if (!e->pfg)
+			continue;
+		for (int i = 0; i < e->pfg->count; i++) {
+			if (e->pfg->regions[i].plat_info.package_id == package_id)
+				e->pfg->regions[i].addr = NULL;
+		}
+	}
+}
+EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
+
 bool intel_aet_pre_mount(void)
 {
 	struct pmt_feature_group *(*get)(enum pmt_feature_id id);
@@ -491,6 +558,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 	void *pevt0;
 	u32 idx;
 
+	guard(mutex)(&aet_lock);
+
 	pevt0 = pevt - pevt->idx;
 	e = container_of(pevt0, struct event_group, evts);
 	idx = rmid * e->num_events;
-- 
2.56.0

