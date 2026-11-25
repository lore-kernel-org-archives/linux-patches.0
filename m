Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618451;
	b=gmSwr3oD14M7jGpjk+SiLysBS4q30eDrwvHHKGVLhphKkzkRueQwok3zy6NpBRS4NbWz
	 hugg+z/ejqfBiojP5MLAp+QaZAmKJn9smsqZnKqwaPlc/gY2fEp8BXhsLVvGgBLgdXprk
	 EdB0Wd+bIdmg7vu+IDii2Q08lw7errNz3JrR0jqUJSfqSCrNGHB4JZgQrNOoVrCd3UehO
	 Hk7wXvnjBCe3V57iYiSHvz46yXpKz/QO1dpM+nr4GrHoRCnfwGWc2p+ihOg1D2s28b0gy
	 xbN67aLgkEeCLAY+YlqFS6SpBK1qjhUkSzkdRWp4cJnLl1GjXovh2gtvw1RmrZxGEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I833XxBbH2D/2G26wv2DgYlZkYkevmx4BRv8rzt3Rz0=;
	b=JuYw4nuWfKvd5TtOJeusaoyTfwqzNt8hIDlINvhyY5FYJYxNKrDxD1Y+MHDjD16SIY1+
	 Xs9acU8J9fVCYkfLddlwlWnvLbZcqF1cRgBo3tBUibF2EN3EsRNq3+XjMqcrt5KlM2pkV
	 d1vVMwP+W1l3Trv+BebfjV7hyiT/QvOUOAH/0HIvvP6pdXhSdgIEAVv2Z3FHvdFNY8ba5
	 2cCS173WDKGfyMAlSUuCuRJeC9yETbup/id0XEQQGwHDvoEFPVowyvS7HPnsf56BkgFuE
	 IiETiTzRLjBS2/sk8/RI39mhKccdn1TDdl4Zn8zFQoN8i2G2J5klFN23dj+s5zqTkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hP4pEklT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148F606A32A;
	Wed, 25 Nov 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hP4pEklT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5381F000D4;
	Wed, 25 Nov 2026 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618451;
	bh=I833XxBbH2D/2G26wv2DgYlZkYkevmx4BRv8rzt3Rz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hP4pEklTx4Ynnak+lUjj9a6mSh1qhVhYcYpc16uEYFoTfCB9VYV0W3jg0hFApUBGC
	 7XuqsAgwTVlavm/azihdA8lYyBP97Ald3sjV8JKuvkrycgaIkyRlIZggt2EZqAE/91
	 6B5XN3CG0CVIrUyW6Jg1UZs+aQyrQFWuI+CAqWxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0284/1005] PM: runtime: Add "Section" hyperlinks
Date: Wed, 25 Nov 2026 15:27:02 +0100
Message-ID: <20261125143828.395441029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 86122467eea539ac13d40b6938abd1fbb40fb640 ]

Add reStructuredText targets for each section, and use them throughout
to make the generated HTML more navigable.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20260929194956.v3.4.I7666a5802ea59359afce4ff7d0b1af668e5f5292@changeid
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7a93f7e30a3f ("PM: runtime: Update runtime_pm.rst for non-fatal resume errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/power/runtime_pm.rst | 48 ++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index 2498e4495daf8..b0741412d3bc2 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -8,6 +8,8 @@ Runtime Power Management Framework for I/O Devices
 
 (C) 2014 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
+.. _Section 1:
+
 1. Introduction
 ===============
 
@@ -37,6 +39,8 @@ The runtime PM callbacks present in 'struct dev_pm_ops', the device runtime PM
 fields of 'struct dev_pm_info' and the core helper functions provided for
 runtime PM are described below.
 
+.. _Section 2:
+
 2. Device Runtime PM Callbacks
 ==============================
 
@@ -80,8 +84,8 @@ the PM core that it is safe to run the ->runtime_suspend(), ->runtime_resume()
 and ->runtime_idle() callbacks for the given device in atomic context with
 interrupts disabled.  This implies that the callback routines in question must
 not block or sleep, but it also means that the synchronous helper functions
-listed at the end of Section 4 may be used for that device within an interrupt
-handler or generally in an atomic context.
+listed at the end of `Section 4`_ may be used for that device within an
+interrupt handler or generally in an atomic context.
 
 The subsystem-level suspend callback, if present, is _entirely_ _responsible_
 for handling the suspend of the device as appropriate, which may, but need not
@@ -105,9 +109,9 @@ knows what to do to handle the device).
 
   * If the suspend callback returns an error code different from -EBUSY and
     -EAGAIN, the PM core regards this as a fatal error and will refuse to run
-    the helper functions described in Section 4 for the device until its status
-    is directly set to  either 'active', or 'suspended' (the PM core provides
-    special helper functions for this purpose).
+    the helper functions described in `Section 4`_ for the device until its
+    status is directly set to  either 'active', or 'suspended' (the PM core
+    provides special helper functions for this purpose).
 
 In particular, if the driver requires remote wakeup capability (i.e. hardware
 mechanism allowing the device to request a change of its power state, such as
@@ -132,10 +136,10 @@ what to do to handle the device).
     'active'.
 
   * If the resume callback returns an error code, the PM core regards this as a
-    fatal error and will refuse to run the helper functions described in Section
-    4 for the device, until its status is directly set to either 'active', or
-    'suspended' (by means of special helper functions provided by the PM core
-    for this purpose).
+    fatal error and will refuse to run the helper functions described in
+    `Section 4`_ for the device, until its status is directly set to either
+    'active', or 'suspended' (by means of special helper functions provided by
+    the PM core for this purpose).
 
 The idle callback (a subsystem-level one, if present, or the driver one) is
 executed by the PM core whenever the device appears to be idle, which is
@@ -158,9 +162,9 @@ call to pm_runtime_autosuspend(). To prevent this (for example, if the callback
 routine has started a delayed suspend), the routine must return a non-zero
 value.  Negative error return codes are ignored by the PM core.
 
-The helper functions provided by the PM core, described in Section 4, guarantee
-that the following constraints are met with respect to runtime PM callbacks for
-one device:
+The helper functions provided by the PM core, described in `Section 4`_,
+guarantee that the following constraints are met with respect to runtime PM
+callbacks for one device:
 
 (1) The callbacks are mutually exclusive (e.g. it is forbidden to execute
     ->runtime_suspend() in parallel with ->runtime_resume() or with another
@@ -200,6 +204,8 @@ rules:
     scheduled requests to execute the other callbacks for the same device,
     except for scheduled autosuspends.
 
+.. _Section 3:
+
 3. Runtime PM Device Fields
 ===========================
 
@@ -301,6 +307,8 @@ defined in include/linux/pm.h:
 
 All of the above fields are members of the 'power' member of 'struct device'.
 
+.. _Section 4:
+
 4. Runtime PM Device Helper Functions
 =====================================
 
@@ -559,12 +567,14 @@ functions may also be used in interrupt context:
 - pm_runtime_put_sync_suspend()
 - pm_runtime_put_sync_autosuspend()
 
+.. _Section 5:
+
 5. Runtime PM Initialization, Device Probing and Removal
 ========================================================
 
 Initially, the runtime PM is disabled for all devices, which means that the
-majority of the runtime PM helper functions described in Section 4 will return
--EACCES until pm_runtime_enable() is called for the device.
+majority of the runtime PM helper functions described in `Section 4`_ will
+return -EACCES until pm_runtime_enable() is called for the device.
 
 In addition to that, the initial runtime PM status of all devices is
 'suspended', but it need not reflect the actual physical state of the device.
@@ -587,7 +597,7 @@ pm_runtime_set_suspended().
 If the default initial runtime PM status of the device (i.e. 'suspended')
 reflects the actual state of the device, its bus type's or its driver's
 ->probe() callback will likely need to wake it up using one of the PM core's
-helper functions described in Section 4.  In that case, pm_runtime_resume()
+helper functions described in `Section 4`_.  In that case, pm_runtime_resume()
 should be used.  Of course, for this purpose the device's runtime PM has to be
 enabled earlier by calling pm_runtime_enable().
 
@@ -638,6 +648,8 @@ value of /sys/devices/.../power/control to "auto" to allow the driver to power
 manage the device at run time, the driver may confuse it by using
 pm_runtime_forbid() this way.
 
+.. _Section 6:
+
 6. Runtime PM and System Sleep
 ==============================
 
@@ -730,6 +742,8 @@ out the following operations:
     callback and right after executing the subsystem-level .complete() callback
     for it, respectively.
 
+.. _Section 7:
+
 7. Generic subsystem callbacks
 ==============================
 
@@ -812,6 +826,8 @@ restore, and runtime resume, can achieve similar behaviour with the help of the
 DEFINE_RUNTIME_DEV_PM_OPS() macro defined in include/linux/pm_runtime.h
 (possibly setting its last argument to NULL).
 
+.. _Section 8:
+
 8. "No-Callback" Devices
 ========================
 
@@ -848,6 +864,8 @@ in subsystems/drivers, the PM core allows runtime PM callbacks to be
 unassigned. More precisely, if a callback pointer is NULL, the PM core will act
 as though there was a callback and it returned 0.
 
+.. _Section 9:
+
 9. Autosuspend, or automatically-delayed suspends
 =================================================
 
-- 
2.53.0



