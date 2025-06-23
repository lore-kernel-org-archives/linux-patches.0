Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772E6C2E0;
	Mon, 23 Jun 2025 21:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714289; cv=none; b=dkYwNZHuXZNtUOKyoScFei11yiLnpZdhKNhpnkL4PGfFnnT4AmhIVcqwbekNTH0e2cjZuuws4gRHK+bb6gmLqw0i18roActKIv7mr5JguqCR8LOuWz/Bhv4pPMgyEG2d4xqHcXca1WqMedYcIjffDz2w1MEvzDpau6Ef5HBT0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714289; c=relaxed/simple;
	bh=7jNopkZbxCuyWk92S4h1UIaowHIjYqwzuuA/2Tm9yY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4edjWGNf1/OLd96bgEbb+OjSQ+EusSf4KXRCllpUxK5TPI1m4h0TzMywbQjFVtdZuxAalcM9xrAvJgW2D9rpnUYF0n/45xiklBKn4uJv3h0sN9mllr5l6tz6uQ9SG6HZvY7BwWfYq6ZIDv7s8FDXYrKD3aQ+VmlRNHdWIxAzC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0uZjj4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0uZjj4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4B0C4CEEA;
	Mon, 23 Jun 2025 21:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714289;
	bh=7jNopkZbxCuyWk92S4h1UIaowHIjYqwzuuA/2Tm9yY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0uZjj4Mh1/EU9rKTdhwFpYxeLv7bRCCpfxeKxxTAbKBQsI42LqN6Jd8FYqPyU0uU
	 1Gt9Uc7RAGy+Ob1V9fiAbJ27yxrV9FJ+7qOsQZBiygMkKhxy5dQHnDGyZSpF4W0ouC
	 I9CdqLXSwKOs7Yt/FKdtZbocgepgsZp8yXOD36JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/508] MIPS: Loongson64: Add missing #interrupt-cells for loongson64c_ls7a
Date: Mon, 23 Jun 2025 15:03:28 +0200
Message-ID: <20250623130649.287665085@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



