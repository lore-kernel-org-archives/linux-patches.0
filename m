Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6134379EDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301772; cv=none; b=IuuAPmwSmNBJsRXGY6mxE77Xd3xniJ7y3XGDju6qD0OVeW75/tVMeGTEd5XFHw3P7RdF/GHwNOl21T0AxYsHXopaktYPv4GdjgPg1/64i55ubYi0sQQEg70DIGUQo6uEcXQ3AGPVykD2Y1Vv4PY9B1lU0SrQ/4tLXScE/Ak5Rj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301772; c=relaxed/simple;
	bh=8iQ4g32YihEMRy3IvpSSa6KrWie9NXLzbYVuL/hmR0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWfGqfqtt327sM9ctTXGf+GzSV+Fn+XgF5BuXToqu2gRcF2dsXLY7YGL/lLD9h1VU1hpKhWIdUIdDzix7wnvE595XqQjcv+odO+RbcSaHOgBL+aRVklLh6F2sbroC5yq8Zuq7HNenHHlCNE7bR4TgzCJFhjzcUOuKj1ObcuXzDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAfbxwH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAfbxwH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEF8C19424;
	Sat, 28 Feb 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301772;
	bh=8iQ4g32YihEMRy3IvpSSa6KrWie9NXLzbYVuL/hmR0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAfbxwH9BaEylB0PrJOe0+6dgfvgzRfeTMx5C9R5C/3scuP2HazP1ufLJ3O3iH9NI
	 R2Xh9v3/jxEUT1EHiZwTIZaFrRZWRSME3APPd/C1Ym8ThBaJaW0hPGsWe4DaYCHCpf
	 BIQkaObkA4Zqcqmwj0wAeXKYJEufEsfy6byuYdZGzi+GD8PZsCBN/ap6PtLcIqoV79
	 GiThGdhFLER3y+zzrWYvn+t6r6PY/VHoKBVONZRLW2oalEUdfa9LDwbUBuFucTQ47A
	 kbwH9+4IZZ2VWDbF1EYuo2pjNzFGryb5LCPfiZPTmvSU0mLPXHw6puYmuukSAJ3VdM
	 1e4AYkIvEcMag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shuai Xue <xueshuai@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/385] Documentation: tracing: Add PCI tracepoint documentation
Date: Sat, 28 Feb 2026 12:56:42 -0500
Message-ID: <20260228180011.1568201-180-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

