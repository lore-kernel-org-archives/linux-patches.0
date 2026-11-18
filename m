Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023267;
	b=NtHw+hcEC8bN38nZCAGnlgtYh3MezmdlRv1TBuz129JWVMKv9zPfZh+rftMHXOdkc0Vc
	 yFDHqokCYPYmgZCml+EM+y+3kUezEqK0YV0W/o6I5O9d/uhjOq8AoIUKAV1QfwWx/KDGt
	 B6zeiPS7R6vXieCaoxNE+7NG8LgmEBs6W6igDo0gVbTKysFsGAfVPydQ/hS0Y5PF194En
	 m+NaOlOqFdIWbSzw9THBT5vgGSH/b1ArcoBQHCMC4t21Z7McSH9QizWs8jh1sIbVFJykZ
	 BjzWBa7mCT4JmEwDXDto7NBxf/CbX0lKoSxBSpk3LSeFE7O5cB0OtnNLD7snEF/JHUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k+bkINcYknXscPgFoVr26r0xOQ7fj9RdFtuNCb3ju58=;
	b=5fzBKCo3ntj3jMGumUATTEFgMiP024ugtnKcCpWacbtasxQqpPZgoCPAnES1kJoPWzXn
	 DWTe+j4SXL6W2F4bKa2NTdMDpQZNXprziVBuzBWjecOVMTXtVQ8VfT0xnYmfiy7p7eMRr
	 ZMukoX4UpWSuRU5rjEBylrFYKfnBEvU3zJaphynR2q5rjn8v965DzP7lAA/Oqz5YT3LiI
	 RRM57V9OEdzK2EQGbzio0cC+gW40LnJ3BvCbsTTKoTlERysOzP9gsoNn6YL1xCvHkcR1Y
	 doyeoYZKAgAVmYc5KO3pFzw3hOmF0T+gDTn8z1qGB1vF38OCN3dn01DXQ5J/nT7+wTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vStJwsIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3E8606A31C;
	Wed, 18 Nov 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vStJwsIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B41F000C4;
	Wed, 18 Nov 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023267;
	bh=k+bkINcYknXscPgFoVr26r0xOQ7fj9RdFtuNCb3ju58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vStJwsIUbM9gn52SF97va7lPl6+eEAFfVWUUJ3oVpHqaXwrZ0dzPb/5jEUuA76WY5
	 85YYymKqHSoxCIbsbehWUENgKfbJUTaAR6OrDDpURRhUI+02D2CqEXUs3SCpSbNXcf
	 4lxr3WHcAUxp/OWT6mb0Ub2oQEQFzs7RhpoYkWh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Peixin Xie <peixin.xie@linux.spacemit.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0309/2151] ACPI: PM: Drop parent state update from acpi_device_get_power()
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118150133.169226261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e0583274b8f4..2b0d248f6394e 100644
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



