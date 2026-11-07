Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061581;
	b=tDwnmgRl9+I1PswyU8WIGg+aWynmGhO7d92i8RRcdu5IekRPZUKCzx0vihzIezJMS1kw
	 se4RT+Pe+Ito74XKueWwFty1tJ3hfr/UrAbP8VZCHk410WOgxjb072KEwu/2tKEPUxtda
	 0ACmVUwgREAWo6yGYk+w++7N3UGZ56rD2ENOo17zUpH+5cZBsq0M507F27ejrVDPdjvxc
	 GHrv+CBY2aL52asiD7cnZRgK7opDu0HZU/9jW9cVmFiU+V4Lmj+l8cYTTCiPg617hOugB
	 VWXLclMqS8/BHLjzeafI3RJPjViji+Q2KDG7PrDupVMXj0zvRteJhCp2uqd2s8DoncA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k7QhFUs+ALsJDb2AvHf6ppfrje5shoZhUqd438zlvEI=;
	b=vC2/MxZ5LjdIxDO/yk7ViJh+SjNSG0HlJizrBKom1RGou/4jtRIUaDn0duhDV1tqB8C4
	 XR+fCML4ceuBmQK7yn4G/3ClraPJpU9PMjykzTMyhU+q2o8KBLbP5gH9Hz/in6utKo2t0
	 3uVbIf+0Q+AQ1rsRZtTSN2h/4POufSoaP0D5ujnPn1YrmDK185XBKD6E1gNEcU6E/Zusa
	 qxV3zRZWsw/QUReANPfJPFh2n0nLzwDTw2l6iRE1eYd3tp+bT7QrxJYyRIljVJFMWbdbi
	 5szPXewUfNRTy0u/2QPlsNwPyvgih8QHQkdCEvTPec7vGWcm5CZO4lHv8K2QWzrQY2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhTCKGRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B583606A32D;
	Sat,  7 Nov 2026 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhTCKGRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451D51F0089F;
	Sat,  7 Nov 2026 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061581;
	bh=k7QhFUs+ALsJDb2AvHf6ppfrje5shoZhUqd438zlvEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhTCKGRFsAXTM67OT37bA8JXBGT8wEgj7lWCN8UxIt2jQwLImmx/qCALGBEuNzd8C
	 c/YqDDJH5hzzf16wpgyAmkkwSN92fOTV60OX8lkwQuhgiGcwYknZucCoQTrp0Lk5X7
	 Ehy5zAaz/TmWtoo3Vgtt+nHchRWtnI9sUzQkWHe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bradley Morgan <brads@mainlining.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 0657/1536] resource: report a devm_request_resource() conflict under the lock
Date: Sat,  7 Nov 2026 08:44:33 -0500
Message-ID: <20261107135015.980313878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

commit d2f7bdfdeac8137e942b32e0badc40e181127d7b upstream.

devm_request_resource() calls request_resource_conflict(), which takes
resource_lock, tries to insert the new resource and returns a pointer to
the conflicting resource after dropping the lock.  The error message is
then formatted from that pointer: conflict->name and the %pR argument
read the name, start, end, flags and desc of a resource that nothing
pins any more.  The owner of the conflicting resource may call
release_resource() and free it the moment the lock is dropped.

The conflicting resource normally belongs to another device.  With two
devices whose drivers claim overlapping regions (two PCI host bridges
whose "ranges" windows overlap, two instances of a controller on the
same aperture, or a stale claim an administrator is replacing), the
following interleaving reads freed memory:

  CPU 0: driver B probe                  CPU 1: driver A unbind
  devm_request_resource(devB, root, resB)
    request_resource_conflict()
      write_lock(&resource_lock)
      __request_resource() -> resA
      write_unlock(&resource_lock)
                                         devres_release_all(devA)
                                           devm_resource_release()
                                             release_resource(resA)
                                         put_device() -> kfree(resA)
    dev_err(..., resA->name, resA)        use after free

Both halves are reachable from userspace on any kernel: a write to the
"unbind" file of the driver that holds the region and a write to the
"bind" file of the driver that wants it.  One in-tree path is
drivers/pci/bus.c devm_request_pci_bus_resources(), called from host
bridge probe for every bridge window; the windows are the embedded
struct resource of kzalloc'ed resource_entry objects that
pci_free_resource_list() frees when the other bridge is released.
In the common case the "resource collision" message is garbled; with
the slab object poisoned (CONFIG_SLUB_DEBUG) or reused, formatting
conflict->name oopses, and KASAN reports a slab-use-after-free read in
devm_request_resource().  All of this happens in a probe that is
already failing with -EBUSY.  The window is a few hundred instructions
wide and exists only when two devices actually collide, so the race
has not been observed outside of analysis.

Do the same here: take resource_lock, insert with __request_resource()
and print the diagnostic while the lock still keeps the conflicting
resource in the tree, then drop the lock.  The return values and the
devres handling are unchanged.

The change was built for x86_64 and RISC-V; the resource KUnit tests
pass on both.

Found by formal verification of kernel/resource.c against the kernel
binary.

Link: https://lore.kernel.org/20261016140043.790048-1-nickolai@csail.mit.edu
Fixes: 8d38821cbcf5 ("resources: Add device-managed request/release_resource()")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Assisted-by: LLM
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/resource.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1588,10 +1588,15 @@ int devm_request_resource(struct device
 
 	*ptr = new;
 
-	conflict = request_resource_conflict(root, new);
-	if (conflict) {
+	/* Report a conflict while the lock still keeps it in the tree. */
+	write_lock(&resource_lock);
+	conflict = __request_resource(root, new);
+	if (conflict)
 		dev_err(dev, "resource collision: %pR conflicts with %s %pR\n",
 			new, conflict->name, conflict);
+	write_unlock(&resource_lock);
+
+	if (conflict) {
 		devres_free(ptr);
 		return -EBUSY;
 	}


