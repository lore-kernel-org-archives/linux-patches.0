Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212433;
	b=PnAUq9iwfpycsgw5z+Aiq9+7ZAmSOwXJNqerTRlH/yPKPa0SZD7vmVnFH8wG4ELZPEgn
	 EXyU93giKkiatGTucsfpI83vEO0g0XjqmQm4XHabg4kuShVcAwVerGN8AYJzRxHZ6MRq6
	 Myshn0q1w8EfmT/kZUJNPVUVR/86BZqzLEDwGIAfQBNQcZ4FKxZJWY+FhA84yEuuqmuvu
	 5fBeMhrXmySArv5huEXftWTv496WZBciw6Tzh+Rcv+Q0MHrj5Pn61zljf0TD/4Fg8S9lo
	 eLIVQ6AKlmkLM5rf18tSuovzHYHkX7ONfQE5/q0m5p8txxDnOgLh4uZ+xzimum6ZEIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SPwJuRW+95Y4EXd5FEqQhA51SLTBwQli7bBUYpjsEWc=;
	b=m2ZJv5trKS4AijB8Mcmo9pTbsu3VqWfQ08LOcJDMi9iqKowauSTmecL53uOYuhVaBJ7i
	 4HvBiKvT8Z0tItFCSyxTF8fP9YH5rI+TcGt9UAnsiF7BbY+2/qQbvvRTvyZGdzyYzytWr
	 god5Xg1rk5tBv5FbiJNzcQvDgBORfh8+oHbIyqF5Z5XR3rhkOB28M48ADXdgzKBNJav/0
	 dxMZO/kkFvlm6Teopx7QFf0WhKFaoQWBQnBCqpwD8iqEDn6RaIlnTO64ZeIRYgiQ6sIx4
	 EzCt1RgPzLmN4HJYl+YRbxQqA0pWlYNM0eYiWfB1aK8/ZpbLSHogyoS3tOcK4f+RyKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4e+VvMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71467606A330;
	Wed, 28 Oct 2026 18:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4e+VvMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5211F01829;
	Wed, 28 Oct 2026 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212433;
	bh=SPwJuRW+95Y4EXd5FEqQhA51SLTBwQli7bBUYpjsEWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4e+VvMk2+85yW4g/AoIBHnhSPlD7Z9Ur3STI45hn1MOjd5PWVFVbDwsoxMrMMI8f
	 E0n9jm8gHaDH/usr1ULM1cBzOjH+Km7oOvMXioWbxUXiMhtb4XrjgsILRHUou7i5P0
	 TiEqfjk23scjJXruNUBRTpmU2InDVDgkedCMsXaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0150/1887] PCI: Fix BAR resize for devices on a root bus
Date: Wed, 28 Oct 2026 17:37:26 +0100
Message-ID: <20261028170502.647925186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liz Fong-Jones <lizf@honeycomb.io>

[ Upstream commit d58384c22739848efe14b34e9586e4f1242f33c0 ]

pci_do_resource_release_and_resize() releases device BARs that share a
bridge window with the BAR being resized, but when the device sits directly
on a root bus (pdev->bus->self == NULL) it then skips resource assignment
entirely and returns success, leaving the BARs it just released unassigned
(IORESOURCE_UNSET).

Skipping pbus_reassign_bridge_resources() is correct in that case -- there
is no bridge window to adjust -- but the device BARs still have to be
reassigned. Before the BAR release was consolidated into the PCI core, this
case worked for amdgpu because the driver released the BARs itself and then
called pci_assign_unassigned_bus_resources() unconditionally after the
resize, which assigns unassigned device BARs also on a root bus. Commit
db92e3fef53e ("drm/amdgpu: Remove driver side BAR release before resize")
removed that call, so nothing assigns the released BARs anymore.

This breaks amdgpu completely on the SolidRun HoneyComb LX2K (NXP LX2160A,
arm64, ACPI), where ACPI doesn't expose the Root Port so the GPU endpoint
appears directly on a "root bus" of its segment:

  amdgpu 0004:01:00.0: BAR 0 [mem 0xa400000000-0xa40fffffff 64bit pref]: releasing
  amdgpu 0004:01:00.0: BAR 2 [mem 0xa410000000-0xa4101fffff 64bit pref]: releasing
  amdgpu 0004:01:00.0: sw_init of IP block <gmc_v8_0> failed -19
  amdgpu 0004:01:00.0: amdgpu_device_ip_init failed
  amdgpu 0004:01:00.0: Fatal error during GPU init

No error is logged because the resize path reports success; amdgpu then
finds BAR 0 IORESOURCE_UNSET and bails out with -ENODEV.

When there is no upstream bridge, call pci_bus_assign_resources() on the
root bus to place the BARs released above, using the same alignment-sorted
algorithm as normal enumeration instead of a manual per-BAR loop. This also
walks the rest of the hierarchy under the root bus, as
pci_assign_unassigned_bus_resources() used to for amdgpu before commit
db92e3fef53e ("drm/amdgpu: Remove driver side BAR release before resize")
removed that call -- the core-side fix that commit asked for ("such a
problem should be fixed inside pci_resize_resource() instead").

pci_bus_assign_resources() returns void, so failure is detected by checking
whether the released BARs are still assigned afterward; if not, roll back
as in the bridged case. This is stricter than the bridged path -- it fails
on any unplaced resource, not just required ones -- since a root bus
typically has one shared window, and failing loudly seemed better than
leaving something silently unassigned.

The root bus path also had a locking bug that any fix here necessarily
touches: the old "goto out" jumped to up_read(&pci_bus_sem) without a
matching down_read() (as does the "goto restore" taken when
pci_dev_res_add_to_list() fails in the release loop). Take pci_bus_sem
before the BAR release loop so every path through the function holds it
exactly once.

Fixes: 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
Link: https://bugs.launchpad.net/ubuntu/+source/linux-hwe-7.0/+bug/2159596
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Assisted-by: Claude:claude-fable-5 checkpatch
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260918035633.566823-1-lizf@honeycomb.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 73427c09f983a..cd09f1e26b8a2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2306,6 +2306,7 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 	unsigned long flags = res->flags;
 	struct pci_dev_resource *dev_res;
 	struct pci_bus *bus = pdev->bus;
+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
 	struct resource *b_win, *r;
 	LIST_HEAD(saved);
 	unsigned int i;
@@ -2321,6 +2322,8 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 	if (ret)
 		return ret;
 
+	down_read(&pci_bus_sem);
+
 	pci_dev_for_each_resource(pdev, r, i) {
 		if (i >= PCI_BRIDGE_RESOURCES)
 			break;
@@ -2342,13 +2345,21 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 
 	res->end = res->start + pci_rebar_size_to_bytes(size) - 1;
 
-	if (!bus->self)
-		goto out;
+	if (bridge) {
+		ret = pbus_reassign_bridge_resources(bus, res, &saved);
+		if (ret)
+			goto restore;
+	} else {
+		/* No bridge window to adjust; let the core reassign the bus. */
+		pci_bus_assign_resources(bus);
 
-	down_read(&pci_bus_sem);
-	ret = pbus_reassign_bridge_resources(bus, res, &saved);
-	if (ret)
-		goto restore;
+		list_for_each_entry(dev_res, &saved, list) {
+			if (!resource_assigned(dev_res->res)) {
+				ret = -ENOSPC;
+				goto restore;
+			}
+		}
+	}
 
 out:
 	up_read(&pci_bus_sem);
-- 
2.53.0



