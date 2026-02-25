Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89C1E2834;
	Wed, 25 Feb 2026 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983174; cv=none; b=Pe0BzIetMO8yc0ZdVJ1Ln8HP1CHc+Sc9YSbPVWO6+x1S8dq02x4dSsmjjod3RExgnutSAF5hTR1zPrPxFVuX4IKqOBmLbDVD/YYeou+fLrOBQIjm0NHTOIcv2LetGvlY/JM8kMjpr+dWrT3GrEeltU9KVG/IwTVXu/uYUhjWvzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983174; c=relaxed/simple;
	bh=qa/CsHn7+JnWYDq0s2o00dIJ+caETMzqERIeSbI5tMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjavJ8IM0wjqRBGmgabtEv9g8obkY22FgRI+UE0Ilx81Sc2pOFfp4PVFYJDA+L8Kx1cEV8JKYRkrWUHpDrSUZq013z+WAG/h4KDpS8NAGDiZ/zcf/SYy9PjNL/J8E8fscCAp6Yp3lhKJGJUrup3qUq0rqg1qObP5UvuJoKC75Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WV+j1di8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WV+j1di8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185F1C116D0;
	Wed, 25 Feb 2026 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983174;
	bh=qa/CsHn7+JnWYDq0s2o00dIJ+caETMzqERIeSbI5tMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV+j1di8faXT2bno7PwbhJ8mS9KkBYxGakilojWRWF1wFiH+T2kFcwvLUVrTo42gz
	 sUwvR9DXoCz6kxmdGrQC/jFkXO3yyzSitG7oSlvnyN6Oo/5HBnm37Bwf8YaWmCgNne
	 VwGCI3+rXRJrnbxRfm6XxAHHEiCc9s3ln6/+5C/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 326/781] Documentation: tracing: Add PCI tracepoint documentation
Date: Tue, 24 Feb 2026 17:17:15 -0800
Message-ID: <20260225012407.703088842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b4a429dc4f7ad..0a40bfabcf19b 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -54,6 +54,7 @@ applications.
    events-power
    events-nmi
    events-msr
+   events-pci
    boottime-trace
    histogram
    histogram-design
-- 
2.51.0



