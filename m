Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39EC38CFE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302118; cv=none; b=dml0+KE9gn95kPBSxw839ZCjchdWegsLSEuOxkstgqeZ/LJ9QVq+/0tg+exYNUT8tH0W3gxmK91wJNpPjjfBO46JV4PUDv5+bhVjDbkF6oJYaiHvKnFzYA5b/1hgwCxy2DwrXwisO/Ol0U6fLPPXk+3MRq7eWL/xu5kOKCQLM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302118; c=relaxed/simple;
	bh=8iQ4g32YihEMRy3IvpSSa6KrWie9NXLzbYVuL/hmR0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQ2MD43+3uVPOBLwTHDy0LjT+PCgZa0QOfkZpc06Zb5TI4g/cAbaokrgxeCxTSqZ4Bd0g1T4V/NQXE3G0F9bYOJ/VRMq1QHqyZ2MuFiAXgLe0U9kV3uyi6ryMs/EHk1VQ28vKu95dQADwkXj6yP3jVG5oVYkCMv2F2vugD95cy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIn+o8s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIn+o8s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD8C19424;
	Sat, 28 Feb 2026 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302118;
	bh=8iQ4g32YihEMRy3IvpSSa6KrWie9NXLzbYVuL/hmR0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIn+o8s1YeSyem2aw2tqJGlL2dbsTpDI1MD/5V27yM5+jo2oUkdleweFwbQqgJsmX
	 Bi12TSBFIyC/re5ZR7JClNThYTEpvCIlGVWpoupODhXsidRJx6mAmM00TItqfP5h0V
	 d+4WM+a3lqv7YBn14g8Pwn54V1KeL1FkTx0bOX2RiP4FdAflFTnU2CdzF6VR7BwNzG
	 tPb0mUw7lp5e7OgOaAqruSKeVTOvLY1TzjxsLAuGfVkUXodDxaitJ4C68eT/aZ3tLN
	 F+T4oialwB+5A//1VmP9qWifnMO1WuAImV2ZYDRL/TBBN6lUkwRJRietj+NU1lk0St
	 UDxhXwuhOgt9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shuai Xue <xueshuai@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/283] Documentation: tracing: Add PCI tracepoint documentation
Date: Sat, 28 Feb 2026 13:04:10 -0500
Message-ID: <20260228180709.1583486-108-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 8236fc613d44e59f6736d6c3e9efffaf26ab7f00 ]

The PCI tracing system provides tracepoints to monitor critical hardware
events that can impact system performance and reliability. Add
documentation about it.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
[bhelgaas: squash fixes:
https://lore.kernel.org/r/20260108013956.14351-2-bagasdotme@gmail.com
https://lore.kernel.org/r/20260108013956.14351-3-bagasdotme@gmail.com]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20251210132907.58799-4-xueshuai@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/events-pci.rst | 74 ++++++++++++++++++++++++++++++
 Documentation/trace/index.rst      |  1 +
 2 files changed, 75 insertions(+)
 create mode 100644 Documentation/trace/events-pci.rst

diff --git a/Documentation/trace/events-pci.rst b/Documentation/trace/events-pci.rst
new file mode 100644
index 0000000000000..03ff4ad30ddfa
--- /dev/null
+++ b/Documentation/trace/events-pci.rst
@@ -0,0 +1,74 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+Subsystem Trace Points: PCI
+===========================
+
+Overview
+========
+The PCI tracing system provides tracepoints to monitor critical hardware events
+that can impact system performance and reliability. These events normally show
+up here:
+
+	/sys/kernel/tracing/events/pci
+
+Cf. include/trace/events/pci.h for the events definitions.
+
+Available Tracepoints
+=====================
+
+pci_hp_event
+------------
+
+Monitors PCI hotplug events including card insertion/removal and link
+state changes.
+::
+
+    pci_hp_event  "%s slot:%s, event:%s\n"
+
+**Event Types**:
+
+* ``LINK_UP`` - PCIe link established
+* ``LINK_DOWN`` - PCIe link lost
+* ``CARD_PRESENT`` - Card detected in slot
+* ``CARD_NOT_PRESENT`` - Card removed from slot
+
+**Example Usage**::
+
+    # Enable the tracepoint
+    echo 1 > /sys/kernel/debug/tracing/events/pci/pci_hp_event/enable
+
+    # Monitor events (the following output is generated when a device is hotplugged)
+    cat /sys/kernel/debug/tracing/trace_pipe
+       irq/51-pciehp-88      [001] .....  1311.177459: pci_hp_event: 0000:00:02.0 slot:10, event:CARD_PRESENT
+
+       irq/51-pciehp-88      [001] .....  1311.177566: pci_hp_event: 0000:00:02.0 slot:10, event:LINK_UP
+
+pcie_link_event
+---------------
+
+Monitors PCIe link speed changes and provides detailed link status information.
+::
+
+    pcie_link_event  "%s type:%d, reason:%d, cur_bus_speed:%d, max_bus_speed:%d, width:%u, flit_mode:%u, status:%s\n"
+
+**Parameters**:
+
+* ``type`` - PCIe device type (4=Root Port, etc.)
+* ``reason`` - Reason for link change:
+
+  - ``0`` - Link retrain
+  - ``1`` - Bus enumeration
+  - ``2`` - Bandwidth notification enable
+  - ``3`` - Bandwidth notification IRQ
+  - ``4`` - Hotplug event
+
+
+**Example Usage**::
+
+    # Enable the tracepoint
+    echo 1 > /sys/kernel/debug/tracing/events/pci/pcie_link_event/enable
+
+    # Monitor events (the following output is generated when a device is hotplugged)
+    cat /sys/kernel/debug/tracing/trace_pipe
+       irq/51-pciehp-88      [001] .....   381.545386: pcie_link_event: 0000:00:02.0 type:4, reason:4, cur_bus_speed:20, max_bus_speed:23, width:1, flit_mode:0, status:DLLLA
diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 770d3bece22c3..e9bcb9d9f7f3b 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -53,6 +53,7 @@ applications.
    events-power
    events-nmi
    events-msr
+   events-pci
    boottime-trace
    histogram
    histogram-design
-- 
2.51.0

