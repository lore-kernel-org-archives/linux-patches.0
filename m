Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B493C060F;
	Wed, 30 Sep 2026 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796634; cv=none; b=aSfWL5G3dPuvmsRjGfq5z5KbdthZFNgFSQ62uYRPwiKVacL0pGTiXRXMWaBA+ib+SNMDzrqS/g+o6dHBXvzqdyJS51xSJfKAaKH/hpskt5oIOUDccLMiOA+oS3JT8FLwtYGqy1gWjGt5ClIEWjzmG7hjzMfU2wl+ZlKlB5/h3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796634; c=relaxed/simple;
	bh=FoaLIcN9RFQ1jvcuRpkWEz8698ZHNaPzuBHBeKY65kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0618VRmIw5eZ9/RPpMKJBPWSfQw1rfoDdknQlPjj23haCqXMDZx3V+lv9b/NcXrmuJkqQk1t48ArQGx0H4ZO5c6XRPclkMlrZFZnCsu2os9bEVpjLMh5YB+2aAczperkV+be86w9RZlzZuw/ZbCRc9D4wewOVCsNGIi39cUFDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIMTPdny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIMTPdny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627961F000FF;
	Wed, 30 Sep 2026 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796632;
	bh=UESOpBvEQuZJLaWuAbhSkgqbPqbfCFyM4k/e6EiJOls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIMTPdny347cXcP395ozFbnB/WCmK0z5WO7uhZAznyFES98a5JGojQUEXEP+LP9QD
	 VwIHOHn13NXqqQXMqj/+1oG9+MIEj1GkmCdT+RPg3N+2BSbliGvTunD4nxoAtDrld3
	 zZTm7W7MkyyrWmaRrxvzsghMB0B0w0nN/cMOmVS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0981/1193] docs: s390/pci: Improve and update PCI documentation
Date: Wed, 30 Sep 2026 17:27:45 +0200
Message-ID: <20260930152456.040596154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 737c4f4a241ca85c597ca2ef1a6f8446bf681ab5 ]

Update the s390 specific PCI documentation to better reflect current
behavior and terms such as the handling of Isolated VFs via commit
25f39d3dcb48 ("s390/pci: Ignore RID for isolated VFs").

Add a descriptions for /sys/firmware/clp/uid_checking which was added
in commit b043a81ce3ee ("s390/pci: Expose firmware provided UID Checking
state in sysfs") but missed documentation.

Similarly add documentation for the fidparm attribute added by commit
99ad39306a62 ("s390/pci: Expose FIDPARM attribute in sysfs") and
add a list of pft values and their names.

Finally improve formatting of the different attribute descriptions by
adding a separating colon.

Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://lore.kernel.org/r/20260407-uid_slot-v8-1-15ae4409d2ce@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 4525a9110495 ("s390/pci/docs: Fix sriov_numvfs attribute name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/s390/pci.rst | 152 +++++++++++++++++++++-----------
 1 file changed, 101 insertions(+), 51 deletions(-)

diff --git a/Documentation/arch/s390/pci.rst b/Documentation/arch/s390/pci.rst
index d5755484d8e75..c3476de4f0327 100644
--- a/Documentation/arch/s390/pci.rst
+++ b/Documentation/arch/s390/pci.rst
@@ -6,6 +6,7 @@ S/390 PCI
 
 Authors:
         - Pierre Morel
+        - Niklas Schnelle
 
 Copyright, IBM Corp. 2020
 
@@ -27,14 +28,16 @@ Command line parameters
 debugfs entries
 ---------------
 
-The S/390 debug feature (s390dbf) generates views to hold various debug results in sysfs directories of the form:
+The S/390 debug feature (s390dbf) generates views to hold various debug results
+in sysfs directories of the form:
 
  * /sys/kernel/debug/s390dbf/pci_*/
 
 For example:
 
   - /sys/kernel/debug/s390dbf/pci_msg/sprintf
-    Holds messages from the processing of PCI events, like machine check handling
+
+    holds messages from the processing of PCI events, like machine check handling
     and setting of global functionality, like UID checking.
 
   Change the level of logging to be more or less verbose by piping
@@ -47,87 +50,134 @@ Sysfs entries
 
 Entries specific to zPCI functions and entries that hold zPCI information.
 
-* /sys/bus/pci/slots/XXXXXXXX
+* /sys/bus/pci/slots/XXXXXXXX:
 
-  The slot entries are set up using the function identifier (FID) of the
-  PCI function. The format depicted as XXXXXXXX above is 8 hexadecimal digits
-  with 0 padding and lower case hexadecimal digits.
+  The slot entries are set up using the function identifier (FID) of the PCI
+  function as slot name. The format depicted as XXXXXXXX above is 8 hexadecimal
+  digits with 0 padding and lower case hexadecimal digits.
 
   - /sys/bus/pci/slots/XXXXXXXX/power
 
   A physical function that currently supports a virtual function cannot be
   powered off until all virtual functions are removed with:
-  echo 0 > /sys/bus/pci/devices/XXXX:XX:XX.X/sriov_numvf
+  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvf
 
-* /sys/bus/pci/devices/XXXX:XX:XX.X/
+* /sys/bus/pci/devices/DDDD:BB:dd.f/:
 
-  - function_id
-    A zPCI function identifier that uniquely identifies the function in the Z server.
+  - function_id:
+    The zPCI function identifier (FID) is a 32-bit hexadecimal value that
+    uniquely identifies the PCI function. Unless the hypervisor provides
+    a virtual FID e.g. on KVM this identifier is unique across the machine even
+    between different partitions.
 
-  - function_handle
-    Low-level identifier used for a configured PCI function.
-    It might be useful for debugging.
+  - function_handle:
+    This 32-bit hexadecimal value is a low-level identifier used for a PCI
+    function. Note that the function handle may be changed and become invalid
+    on PCI events and when enabling/disabling the PCI function.
 
-  - pchid
-    Model-dependent location of the I/O adapter.
+  - pchid:
+    This 16-bit hexadecimal value encodes a model-dependent location for
+    the PCI function.
 
-  - pfgid
-    PCI function group ID, functions that share identical functionality
+  - pfgid:
+    PCI function group ID; functions that share identical functionality
     use a common identifier.
     A PCI group defines interrupts, IOMMU, IOTLB, and DMA specifics.
 
-  - vfn
+  - vfn:
     The virtual function number, from 1 to N for virtual functions,
     0 for physical functions.
 
-  - pft
-    The PCI function type
-
-  - port
-    The port corresponds to the physical port the function is attached to.
-    It also gives an indication of the physical function a virtual function
-    is attached to.
-
-  - uid
-    The user identifier (UID) may be defined as part of the machine
-    configuration or the z/VM or KVM guest configuration. If the accompanying
-    uid_is_unique attribute is 1 the platform guarantees that the UID is unique
-    within that instance and no devices with the same UID can be attached
-    during the lifetime of the system.
-
-  - uid_is_unique
-    Indicates whether the user identifier (UID) is guaranteed to be and remain
-    unique within this Linux instance.
-
-  - pfip/segmentX
+  - pft:
+    The PCI function type is an s390-specific type attribute. It indicates
+    a more general, usage oriented, type than PCI Specification
+    class/vendor/device identifiers. That is PCI functions with the same pft
+    value may be backed by different hardware implementations. At the same time
+    apart from unclassified functions (pft is 0x00) the same pft value
+    generally implies a similar usage model. At the same time the same
+    PCI hardware device may appear with different pft values when in a
+    different usage model. For example NETD and NETH VFs may be implemented
+    by the same PCI hardware device but in NETD the parent Physical Function
+    is user managed while with NETH it is platform managed.
+
+    Currently the following PFT values are defined:
+
+    - 0x00 (UNC): Unclassified
+    - 0x02 (ROCE): RoCE Express
+    - 0x05 (ISM): Internal Shared Memory
+    - 0x0a (ROC2): RoCE Express 2
+    - 0x0b (NVMe): NVMe
+    - 0x0c (NETH): Network Express hybrid
+    - 0x0d (CNW): Cloud Network Adapter
+    - 0x0f (NETD): Network Express direct
+
+  - port:
+    The port is a decimal value corresponding to the physical port the function
+    is attached to. Virtual Functions (VFs) share the port with their parent
+    Physical Function (PF). A value of 0 indicates that the port attribute is
+    not applicable for that PCI function type.
+
+  - uid:
+    The user-defined identifier (UID) for a PCI function is a 32-bit
+    hexadecimal value. It is defined on a per instance basis as part of the
+    partition, KVM guest, or z/VM guest configuration. If UID Checking is
+    enabled the platform ensures that the UID is unique within that instance
+    and no two PCI functions with the same UID will be visible to the instance.
+
+    Independent of this guarantee and unlike the function ID (FID) the UID may
+    be the same in different partitions within the same machine. This allows to
+    create PCI configurations in multiple partitions to be identical in the
+    UID-namespace.
+
+  - uid_is_unique:
+    A 0 or 1 flag indicating whether the user-defined identifier (UID) is
+    guaranteed to be and remain unique within this Linux instance. This
+    platform feature is called UID Checking.
+
+  - pfip/segmentX:
     The segments determine the isolation of a function.
     They correspond to the physical path to the function.
     The more the segments are different, the more the functions are isolated.
 
+  - fidparm:
+    Contains an 8-bit-per-PCI function parameter field in hexadecimal provided
+    by the platform. The meaning of this field is PCI function type specific.
+    For NETH VFs a value of 0x01 indicates that the function supports
+    promiscuous mode.
+
+* /sys/firmware/clp/uid_checking:
+
+  In addition to the per-device uid_is_unique attribute this presents a
+  global indication of whether UID Checking is enabled. This allows users
+  to check for UID Checking even when no PCI functions are configured.
+
 Enumeration and hotplug
 =======================
 
 The PCI address consists of four parts: domain, bus, device and function,
-and is of this form: DDDD:BB:dd.f
+and is of this form: DDDD:BB:dd.f.
 
-* When not using multi-functions (norid is set, or the firmware does not
-  support multi-functions):
+* For a PCI function for which the platform does not expose the RID, the
+  pci=norid kernel parameter is used, or a so-called isolated Virtual Function
+  which does have RID information but is used without its parent Physical
+  Function being part of the same PCI configuration:
 
   - There is only one function per domain.
 
-  - The domain is set from the zPCI function's UID as defined during the
-    LPAR creation.
+  - The domain is set from the zPCI function's UID if UID Checking is on;
+    otherwise the domain ID is generated dynamically and is not stable
+    across reboots or hot plug.
 
-* When using multi-functions (norid parameter is not set),
-  zPCI functions are addressed differently:
+* For a PCI function for which the platform exposes the RID and which
+  is not an Isolated Virtual Function:
 
   - There is still only one bus per domain.
 
-  - There can be up to 256 functions per bus.
+  - There can be up to 256 PCI functions per bus.
 
-  - The domain part of the address of all functions for
-    a multi-Function device is set from the zPCI function's UID as defined
-    in the LPAR creation for the function zero.
+  - The domain part of the address of all functions within the same topology is
+    that of the configured PCI function with the lowest devfn within that
+    topology.
 
-  - New functions will only be ready for use after the function zero
-    (the function with devfn 0) has been enumerated.
+  - Virtual Functions generated by an SR-IOV capable Physical Function only
+    become visible once SR-IOV is enabled.
-- 
2.53.0



