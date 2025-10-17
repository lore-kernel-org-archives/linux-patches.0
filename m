Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2652F12DE;
	Fri, 17 Oct 2025 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715044; cv=none; b=UvZOJpvI10/VRWp4p5gHInPX010MowjbEGcPLo+5BvZQ/YNuQIrdulInTTQ6qcBrTkTtw4SgopQW/3EHiW5hfCq4YlwtVtdopvrT/NBs2Hog/lYBSr37b5aih0BQfLYKMw2QvSJgmVWxXT5vWtstkRvLswJa0p0CH8g1L9ScsoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715044; c=relaxed/simple;
	bh=rtzKmJEidc5FKwD84nh9Gh/ZXmuGnY0wuVTcnti0Fk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIiVOVb50MgiKy4i/KaBNSLh5onhGSHPUSO/d8OQpEGUb/PERSe3UygJthqGojnLbwxvYIZR71CxlaeOHEvwVIzdXZPT83xQ3f+nUJsEU4uawaRWl5i7tLzyZLj83taJgSojaq8ZxV2f+YGwDllUb+osDbcJfB1tri8BdDBETGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCPOqKYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCPOqKYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9779AC4CEE7;
	Fri, 17 Oct 2025 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715044;
	bh=rtzKmJEidc5FKwD84nh9Gh/ZXmuGnY0wuVTcnti0Fk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCPOqKYo2Ima03MGG5wtXobkUwtCuJQtPQ25dtLKaF7xqEkif1XUrRDzTwypYimEH
	 GavIFu7dityif8llSUCpQlKJzyFWS6P40VAtY5XdWUWZYKYWkGb0xxCfLglX4up7Px
	 Wi5WVgmQA9ZbUxeFWvAEjZKq4/0enYVT1uV1BmPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/371] LoongArch: Init acpi_gbl_use_global_lock to false
Date: Fri, 17 Oct 2025 16:50:53 +0200
Message-ID: <20251017145204.762992603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 98662be7ef20d2b88b598f72e7ce9b6ac26a40f9 ]

Init acpi_gbl_use_global_lock to false, in order to void error messages
during boot phase:

 ACPI Error: Could not enable GlobalLock event (20240827/evxfevnt-182)
 ACPI Error: No response from Global Lock hardware, disabling lock (20240827/evglock-59)

Fixes: 628c3bb40e9a8cefc0a6 ("LoongArch: Add boot and setup routines")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 075b79b2c1d39..69c17d162fff3 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -355,6 +355,7 @@ void __init platform_init(void)
 
 #ifdef CONFIG_ACPI
 	acpi_table_upgrade();
+	acpi_gbl_use_global_lock = false;
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
-- 
2.51.0



