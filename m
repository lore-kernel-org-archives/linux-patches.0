Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E161246BB7;
	Mon, 27 Oct 2025 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591255; cv=none; b=Z70WeE+9leihEZL3+mp9y9YIQ+eSet/yCA49RyfbD37LD6qdciqLDIKCc6pqZeZ+YQXQaRlBpe0dSiFM1mKnMAfQyvTf1Qw8JKP79L0xFj8rTnBLM2w7DqUQLuDJTVCUopnMTmv+wDiJFcW8hwOOkXD8K0Odq4bRXJyKLVJ5s3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591255; c=relaxed/simple;
	bh=roBlNR6RNMqTHJRopVl4kMQ8Won8J2w/TFGyJNY+DW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKI/R9FrnHm4c8OdhwVTQtm1lnqrzFEgtByY1BtHZYtI88tBJXimtrfIJOsYXSd/a7kDiI8oSii9nzv3Tg8VjwsQLrw7lvoyKXU6A/L7YEJK0HKGoVXd0YuXEDdTB/wEWcPM6Eix7r/cBljakmIOwePdB3G/+pk2cr2id3BzAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbXPwyC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbXPwyC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50F7C4CEF1;
	Mon, 27 Oct 2025 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591255;
	bh=roBlNR6RNMqTHJRopVl4kMQ8Won8J2w/TFGyJNY+DW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbXPwyC7+1BhZcni4Dr8WjkZ9JgyBXq5+ScgWvp2zCvQf52xj7st5XkjK6oA0THGm
	 7zInAz/jfd9NUDNJYfVkJKLg3NR3ia4uYaoZziu2A8KhiRLZks6zdZiq8pOd2IM3ag
	 iLaCWPcV1C3syjNGMSKZ9xuxbRzN7tuTTFfBKjwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 127/332] ACPI: TAD: Add missing sysfs_remove_group() for ACPI_TAD_RT
Date: Mon, 27 Oct 2025 19:33:00 +0100
Message-ID: <20251027183527.963006337@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Tang <danielzgtg.opensource@gmail.com>

commit 4aac453deca0d9c61df18d968f8864c3ae7d3d8d upstream.

Previously, after `rmmod acpi_tad`, `modprobe acpi_tad` would fail
with this dmesg:

sysfs: cannot create duplicate filename '/devices/platform/ACPI000E:00/time'
Call Trace:
 <TASK>
 dump_stack_lvl+0x6c/0x90
 dump_stack+0x10/0x20
 sysfs_warn_dup+0x8b/0xa0
 sysfs_add_file_mode_ns+0x122/0x130
 internal_create_group+0x1dd/0x4c0
 sysfs_create_group+0x13/0x20
 acpi_tad_probe+0x147/0x1f0 [acpi_tad]
 platform_probe+0x42/0xb0
 </TASK>
acpi-tad ACPI000E:00: probe with driver acpi-tad failed with error -17

Fixes: 3230b2b3c1ab ("ACPI: TAD: Add low-level support for real time capability")
Signed-off-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/2881298.hMirdbgypa@daniel-desktop3
Cc: 5.2+ <stable@vger.kernel.org> # 5.2+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -563,6 +563,9 @@ static int acpi_tad_remove(struct platfo
 
 	pm_runtime_get_sync(dev);
 
+	if (dd->capabilities & ACPI_TAD_RT)
+		sysfs_remove_group(&dev->kobj, &acpi_tad_time_attr_group);
+
 	if (dd->capabilities & ACPI_TAD_DC_WAKE)
 		sysfs_remove_group(&dev->kobj, &acpi_tad_dc_attr_group);
 


