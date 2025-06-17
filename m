Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E3F2ECD3C;
	Tue, 17 Jun 2025 16:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176048; cv=none; b=NPnT9ACHrvpYwD9AeZ4Z4bBSACEFaG3MBMyz/uxULnETQYRFbwM2EWuZ/BBzKhiAACPptNvVq374p/CUpKuxFkGL5kAAWZeRVBov89L2jLlA723cqAkrYsfyfIgGaY2RHPkrWVu8EpbqrXyee4c19+Osoi1sACp7JqynQtAMNio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176048; c=relaxed/simple;
	bh=14m5AmUWxkiNw6Iuwlk5VE/IHbPdoxZQx9EMg0W5SX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1RfPs48rHfbUobNTGP0TfHgHK7e7g44OYoGjVMjy5unI+DnhUEq5hwrOgujRFdUPnKFdrdJSLs69caS93h4EECoFxEXkWoOu75GWJ7wGbut4nSwJTdpaV/Y4B/aJGImvUSaUgQnIDDn+0bZA1qlUQe9WWGyEo1FK5gHIYQsR/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1uVw6nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1uVw6nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E9CC4CEE3;
	Tue, 17 Jun 2025 16:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176048;
	bh=14m5AmUWxkiNw6Iuwlk5VE/IHbPdoxZQx9EMg0W5SX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1uVw6nT3fNAX509yCARvD0oNTNeJhhKVUyJ/KyQLz1UTH8ynhKPupQ+MIijBejto
	 lkswFQ6k9ZJWcTBhsogz2bdbF0OLvDG9ZqwjEY3ezFOfZF0zdBi/ArXOYCxzwAM6oP
	 AXWEfkTv/gLIFUe4wsAiYr31UjPF8qS4Ok3yaQnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/356] MIPS: Loongson64: Add missing #interrupt-cells for loongson64c_ls7a
Date: Tue, 17 Jun 2025 17:25:53 +0200
Message-ID: <20250617152347.788036713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 6d223b8ffcd1593d032b71875def2daa71c53111 ]

Similar to commit 98a9e2ac3755 ("MIPS: Loongson64: DTS: Fix msi node for ls7a").

Fix follow warnings:
  arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts:28.31-36.4: Warning (interrupt_provider): /bus@10000000/msi-controller@2ff00000: Missing '#interrupt-cells' in interrupt provider
  arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'

Fixes: 24af105962c8 ("MIPS: Loongson64: DeviceTree for LS7A PCH")
Tested-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts b/arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts
index c7ea4f1c0bb21..6c277ab83d4b9 100644
--- a/arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts
+++ b/arch/mips/boot/dts/loongson/loongson64c_4core_ls7a.dts
@@ -29,6 +29,7 @@
 		compatible = "loongson,pch-msi-1.0";
 		reg = <0 0x2ff00000 0 0x8>;
 		interrupt-controller;
+		#interrupt-cells = <1>;
 		msi-controller;
 		loongson,msi-base-vec = <64>;
 		loongson,msi-num-vecs = <64>;
-- 
2.39.5



