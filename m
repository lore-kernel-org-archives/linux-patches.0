Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051883;
	b=x9MPfFvZoMgSROX6/UB3lOW0gwQgbMhazhSva5ppN8KU7zhHWx411UO/qSCEsTx681MO
	 G+GieESnuHAtougBeKgEHAA1RqAzx8DqwghoIzdZ+1Gu7Ub/8XNGgWLGlntEC/PXFqcgJ
	 m/g8hgq1178DABo2gMU5ZmmErMs7CEYvVi+y0M8VqUxeB6HsN8P4McehvoGdGAL/DIMvL
	 mlJJGUFeV2vOuM0sptImRu9MyojX6ICO47U/rU/GjxGXYXG63HkwTIqYnGbng0bbnvB9U
	 3uzItMhN0HiZ2p+7I/XX0nXDErvxPvBEppgqHOCyYKCt+iNk15jIBy+DnWEsYkP2D+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Rx7gO12jsA0YyfuZbB28tZmqby3KGLFS9qQukMhj2yA=;
	b=Y8T/q84gaQcDfUOaWlL25+yZCDHPaQ6s6F2tY+2v1XSpFygi//WoI77PvjBG3de7u0Xj
	 IBfIn8Q+lWX8pAF8DyWrJ/nvrawymBH3QN6EC+E8X2CCH+3lrRZqCRc+UtfQ9X3Hlax9v
	 9849naG3UBZfCPHpDG2KBIbWanVqh5OFeLRxhI1JO7D40oHUV6DFRY64LsYwvSOFs2RJ7
	 Wqd6iHgCKA4cs0/wB3EAhm1XzgAlkx1SX+PXoF5nWe1WxlIkmVLoJVyP6CUzqRzbQt6jt
	 wPuBxN6Pb2Dt0ROEcuVsv0d+BVgd2nDatv2MU42Gbc/NJaw6uzmrUn8vbQ/J26MbpOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgDUtQeo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9A2606A325;
	Thu, 19 Nov 2026 01:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgDUtQeo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AC91F000C4;
	Thu, 19 Nov 2026 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051883;
	bh=Rx7gO12jsA0YyfuZbB28tZmqby3KGLFS9qQukMhj2yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgDUtQeoVSSAXaRZD2HhwIJYPqFv9eZ+wDIJe/knE2RD0W274eGwNC+gfWQAi8WOR
	 Xud07UmiC7izpXZWWHjn6NIxSCcdSc6M24zks8iaE01GZAmM7CWL1ninJ8J/KaAxk2
	 /BH+XslUxhUmv3Ecw02g0TYmBFiftFuxkIzSpqv0=
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
Subject: [PATCH 5.15 0317/2214] resource: report a devm_request_resource() conflict under the lock
Date: Wed, 18 Nov 2026 15:33:13 +0100
Message-ID: <20261118150022.813483543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1521,10 +1521,15 @@ int devm_request_resource(struct device
 
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


