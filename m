Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAD546EF76;
	Tue, 21 Jul 2026 19:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660584; cv=none; b=mvkrj2IpNHSufTq+FMCHKXSqSq4Va8NNrJSghzgdCgg3TMmasyRxfEhEUMOhs554BkBmo5me5x2/1kbJwimdT0n00PDar7WUU4EWwYVdGuWIw3Wgm4ypKsye02ehtDjcdPJOqaQ5ufYzzO8JYvdQSYAlo0cCikOFYDXDf4gORMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660584; c=relaxed/simple;
	bh=bfhgLsTVZcwDNTEodU6inkIr73P1Ooxv8ClTov42XvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3iNjobibWZn/KbqC1X0CaAYDW3wOXguAXYsysM6TGYTVl9N8vxwJk5ZFjTY4ALjcq2MxjScqAXXG48ozD8ntlhBD5Af875xpoZQPE1vOuxtoYebpIiEJoPzWQx3jyktG0vrl7uw7VDpVYwoAJdGWkIb9vnhSKD9CASkjvrkLZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsKzYjvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsKzYjvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F77F1F000E9;
	Tue, 21 Jul 2026 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660581;
	bh=6pkwvmO/lPoNtgzkKtWEf22ZfMLjyYj3LzYTkk/U/Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsKzYjvBKp7xiFU0ZazAVWfparhRSnAnG/d9nJMqzPiq8clkjJwXmi5r7JWTcsLZm
	 bxwCSCgBZMua+IOUNZsrzSzvCbo7Nt6E7IlYNFomUl6kRkB4u7xff5jYBtLskBv3ew
	 yoKXllUIReOni+Ss9ur+QrZk2+OxZ3e0104AfY6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1034/2077] Documentation: ABI: sysfs-class-reboot-mode-reboot_modes: fix doc warnings
Date: Tue, 21 Jul 2026 17:11:47 +0200
Message-ID: <20260721152617.203669393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a888754e51e915731c8974c4d6d62709facb35d3 ]

Repair the docs build warnings in this file by unindenting the description,
adding blank lines, and using `` to quote *arg.

WARNING: Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes:36: abi_sys_class_reboot_mode_driver_reboot_modes doesn't have a description
Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes:1: ERROR: Unexpected indentation. [docutils]
Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes:1: ERROR: Unexpected indentation. [docutils]
Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes:1: WARNING: Inline emphasis start-string without end-string. [docutils]
Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes:1: ERROR: Unexpected indentation. [docutils]

Fixes: d3da03025e6d ("Documentation: ABI: Add sysfs-class-reboot-mode-reboot_modes")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260426232705.422938-1-rdunlap@infradead.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/sysfs-class-reboot-mode-reboot_modes    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes b/Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes
index a16c54ab841bb4..4306966b7fcc33 100644
--- a/Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes
+++ b/Documentation/ABI/testing/sysfs-class-reboot-mode-reboot_modes
@@ -2,33 +2,36 @@ What:		/sys/class/reboot-mode/<driver>/reboot_modes
 Date:		March 2026(TBD)
 KernelVersion:	TBD
 Contact:	linux-pm@vger.kernel.org
-		Description:
+Description:
 		This interface exposes the reboot-mode arguments
 		registered with the reboot-mode framework. It is
 		a read-only interface and provides a space
 		separated list of reboot-mode arguments supported
 		on the current platform.
 		Example:
+
 		 recovery fastboot bootloader
 
 		The exact sysfs path may vary depending on the
 		name of the driver that registers the arguments.
-		Example:
+		Example::
+
 		 /sys/class/reboot-mode/nvmem-reboot-mode/reboot_modes
 		 /sys/class/reboot-mode/syscon-reboot-mode/reboot_modes
 		 /sys/class/reboot-mode/qcom-pon/reboot_modes
 
 		The supported arguments can be used by userspace to
 		invoke device reset using the standard reboot() system
-		call interface, with the "argument" as string to "*arg"
-		parameter along with LINUX_REBOOT_CMD_RESTART2.
+		call interface, with the "argument" as string to ``*arg``
+		parameter along with ``LINUX_REBOOT_CMD_RESTART2``.
 
 		A driver can expose the supported arguments by
 		registering them with the reboot-mode framework
 		using the property names that follow the
 		mode-<argument> format.
 		Example:
-		 mode-bootloader, mode-recovery.
+
+		 mode-bootloader, mode-recovery
 
 		This attribute is useful for scripts or initramfs
 		logic that need to programmatically determine
-- 
2.53.0



