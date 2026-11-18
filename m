Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029243;
	b=qgXhu6oXj/QPiToJJXeu5Q4JmWh8j7UBsMmGngHvxg1HAgsfXJ9ph0C4tp4B8JRWPBmY
	 eRX0OcgZ43Fg2se7sItz4OLLrMgm449w/Kyw862mDe2kKxO0XufCxy5tnTZU5FbQbc2FR
	 wD8bQxHISoSgN/PVSUI9VJvOhFCPmUIHM4c3uOtA/LToRTaWMU0FqRP3VfDPj/0jwXJbu
	 eERcfHhpNQousmDZQ02Q00DDrhhNplNjkw7/Zzs2nerbB+ME8GUw7ngGBBrsj0suf4GXM
	 le9TZz+PX8XzSqgnirC41+A9VU3ueYYraMq/5v9fzBEuRpH0c85R5MYWUBmpMzn1uiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JTQ+UvRzOrUSOE4gCtdis56C86kvymJTaK8UMQCqAt0=;
	b=pmXr3z9FXoZ3lmzLT788myzTRc+2qSpD35VxF0V6t6PORCGOgsV90HTD5rYL6JHVjUAK
	 DaCLaXwxKVjUXctmnVKPV/2QgHnpxLCZkv386Pwcp1KeBHFyPF3KGgJuiCMaQnAJxm09k
	 02g5Y7CIfFcyEvBPY4eUCgFgM3wlF5VBGCjaTDIl35n2Axnv3MRb6hJEe9VOjm3MoP5EJ
	 lLQc/PLYlfqKR0qFw4Lt+fUlPrs3BLup1N+pKmFtAyFI9dJ4B9/UkXcKHtsVqdsiONRDW
	 UHGuj+6ZvDW+iC3kKjsDhbp7L9HDocPXbmFkTPyXEm8NQqvQGD97qCMzKo+t2byrvpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuvXmw8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F0A606A31C;
	Wed, 18 Nov 2026 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuvXmw8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094AF1F000C5;
	Wed, 18 Nov 2026 19:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029243;
	bh=JTQ+UvRzOrUSOE4gCtdis56C86kvymJTaK8UMQCqAt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuvXmw8dn3ieMl17viRiSvTe+MOlb/t07V/4ge0tIGBuJMaOaYNm+YUBxDF/q9PHt
	 SB7X7dbKLEyyXRdFyR644/EyNVEymzz9U9Vun4Fe4dTu6GKkGZzDQcp//6k61P3MEc
	 V2IebbKBfgWphAbX91o3SX4NOsIYcZs6vLjVaU/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Peixin Xie <peixin.xie@linux.spacemit.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0282/1756] ACPI: PM: Drop parent state update from acpi_device_get_power()
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118150019.641290887@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5636eebb7bb1c6f06f0058d48353686304d4bb47 ]

The parent state update in acpi_device_get_power(), that occurs when the
child device turns out to be in D0 and the parent's power state is still
unknown, is highly questionable because it may cause the reference
counters of the power resources used by the parent in D0 (if any) to
underflow when the parent goes into a low-power state later.  Moreover,
there is no reason to do it on reads from the real_power_state sysfs
attribute of the child.

That check had been added by commit 8f7412a792bc ("ACPI / PM: Infer
parent power state from child if unknown, v2") before starting to
handle the "missing _PSC and no power resources" case directly in
acpi_bus_init_power(), as of commit b3785492268f ("ACPI / PM: Do not
power manage devices in unknown initial states").  It is not necessary
any more and commit b3785492268f should have removed it.

Drop it now.

Fixes: b3785492268f ("ACPI / PM: Do not power manage devices in unknown initial states")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Peixin Xie <peixin.xie@linux.spacemit.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/5147279.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index dbd4446025ecd..86301f094e4b8 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -75,15 +75,14 @@ static int acpi_dev_pm_explicit_get(struct acpi_device *device, int *state)
 int acpi_device_get_power(struct acpi_device *device, int *state)
 {
 	int result = ACPI_STATE_UNKNOWN;
-	struct acpi_device *parent;
 	int error;
 
 	if (!device || !state)
 		return -EINVAL;
 
-	parent = acpi_dev_parent(device);
-
 	if (!device->flags.power_manageable) {
+		struct acpi_device *parent = acpi_dev_parent(device);
+
 		/* TBD: Non-recursive algorithm for walking up hierarchy. */
 		*state = parent ? parent->power.state : ACPI_STATE_D0;
 		goto out;
@@ -119,16 +118,6 @@ int acpi_device_get_power(struct acpi_device *device, int *state)
 			result = psc > ACPI_STATE_D2 ? ACPI_STATE_D3_HOT : psc;
 	}
 
-	/*
-	 * If we were unsure about the device parent's power state up to this
-	 * point, the fact that the device is in D0 implies that the parent has
-	 * to be in D0 too, except if ignore_parent is set.
-	 */
-	if (!device->power.flags.ignore_parent && parent &&
-	    parent->power.state == ACPI_STATE_UNKNOWN &&
-	    result == ACPI_STATE_D0)
-		parent->power.state = ACPI_STATE_D0;
-
 	*state = result;
 
  out:
-- 
2.53.0



