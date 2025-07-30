Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78813635;
	Wed, 30 Jul 2025 09:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868305; cv=none; b=O2qQN9MPdEPKUroKr7r5kPr2dKgRvYE5lvsIZyCbP/IKVMa/C1DSLTJLkhDCDhZN+Gkabe6MJz7qjwQcDqiMcNAan6PF/UuM3ilgYEOWU6PrSoCLTJ6rz3qeLMckGxiJXIINoKTP6ftKcJLX+ydJv2I0hD/Gn0PYnzeLyoRErC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868305; c=relaxed/simple;
	bh=XGpitW5qk3+xLGEja6fPMTXdbOP1vvwbM+dlPnn2PYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucro9nP42yObSN5qH1PT60ARb+ZK7fqR64pRLnv7ucuAaHwnMHzC7hvZK50qRUjpJJJtT6n0eGDYNoUSYUmh8ZUgE7CuVwWiG+267mvJXSEucwN+hcpTLSjoKaKOcQAD3LEaczPsy+0s8s2mPNr88qMTk++3tUiU/t0/XiO4WOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAGWPx7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAGWPx7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5479C4CEE7;
	Wed, 30 Jul 2025 09:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868305;
	bh=XGpitW5qk3+xLGEja6fPMTXdbOP1vvwbM+dlPnn2PYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAGWPx7S/ghBFXibjv65o29u2vNiEwhl31HUQlCIbN+f+w7bk1qWaCEQhI7DgFlKl
	 wM2f59hbwDxhZZdxQsxKoay8mFwqIOuktVgvDYlqc4nJ6MJU1+6e33OUd8Rv+gWilp
	 z7z5XxnZT15LKRi6aaoX+ALU8c9Ru+Mg/kcY9pYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/76] platform/x86: Fix initialization order for firmware_attributes_class
Date: Wed, 30 Jul 2025 11:35:02 +0200
Message-ID: <20250730093227.213363839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

[ Upstream commit 2bfe3ae1aa45f8b61cb0dc462114fd0c9636ad32 ]

The think-lmi driver uses the firwmare_attributes_class. But this class
is registered after think-lmi, causing the "think-lmi" directory in
"/sys/class/firmware-attributes" to be missing when the driver is
compiled as builtin.

Fixes: 55922403807a ("platform/x86: think-lmi: Directly use firmware_attributes_class")
Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Link: https://lore.kernel.org/r/7dce5f7f-c348-4350-ac53-d14a8e1e8034@secunet.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index b457de5abf7d7..8012de299174f 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -58,6 +58,8 @@ obj-$(CONFIG_X86_PLATFORM_DRIVERS_HP)	+= hp/
 # Hewlett Packard Enterprise
 obj-$(CONFIG_UV_SYSFS)       += uv_sysfs.o
 
+obj-$(CONFIG_FW_ATTR_CLASS)	+= firmware_attributes_class.o
+
 # IBM Thinkpad and Lenovo
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_IDEAPAD_LAPTOP)	+= ideapad-laptop.o
@@ -108,7 +110,6 @@ obj-$(CONFIG_SYSTEM76_ACPI)	+= system76_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 
 # Platform drivers
-obj-$(CONFIG_FW_ATTR_CLASS)		+= firmware_attributes_class.o
 obj-$(CONFIG_SERIAL_MULTI_INSTANTIATE)	+= serial-multi-instantiate.o
 obj-$(CONFIG_MLX_PLATFORM)		+= mlx-platform.o
 obj-$(CONFIG_TOUCHSCREEN_DMI)		+= touchscreen_dmi.o
-- 
2.39.5



