Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787513370F7;
	Fri, 17 Oct 2025 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713046; cv=none; b=i73qJMVBoq902nSFIKpPEf4F7Iy8Q8l5DxZBMtsL/v5rN2FFmmFdyx7sWMnPOrzAz1nNNVNKqAH2BXJ49b4yUmrzKqQNFTwTL0vfrNXo4K0hLcT/RJYiOdF79E5dFTevLiMrw1SJoGKKniGpaC7w12J6Wt3R8epAyZ84lzCj52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713046; c=relaxed/simple;
	bh=q7F0duG3v4YT514+G0ChC2ZLhUz4aGuIPwZ9TjlGQTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVWkEuym3hhLcW29Dy3s/CEO4Fx+MPu1S7d9NmFiP0DqlhaZrdwnDuwdXbVJ7yOCa2pu34l2p+LfQc6tJMbqNunsPHjn+ufu0ckKvWdMrz8Ax2Z5HwGPL8/at21rQ7kpYEfvMQKYCKYTpiQJPQatzuDOyGF7S4c+aNc2IR4ImHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/+coq3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/+coq3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4E7C4CEE7;
	Fri, 17 Oct 2025 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713046;
	bh=q7F0duG3v4YT514+G0ChC2ZLhUz4aGuIPwZ9TjlGQTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/+coq3EKhABCPhD7OGDZJkbGFRM+I5MrIJfuSRqceMctqg4ZiXGe/NTBlSVDtW24
	 exm1tjdE4b+lR78HRefhjk/3hmwbuaAgfXP50ZoqJZVtCK09U4bQxeKP2q+9dfe/Py
	 dAZ8YQKZQag9Q8Stt5+Tbtm5QQ3odee3RhFy4p/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/168] LoongArch: Init acpi_gbl_use_global_lock to false
Date: Fri, 17 Oct 2025 16:51:48 +0200
Message-ID: <20251017145130.092318799@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 55efe2f5fa1c3..e2d294aebab2a 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -254,6 +254,7 @@ void __init platform_init(void)
 
 #ifdef CONFIG_ACPI
 	acpi_table_upgrade();
+	acpi_gbl_use_global_lock = false;
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
 #endif
-- 
2.51.0



