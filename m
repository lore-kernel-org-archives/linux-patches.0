Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8F1252903;
	Mon, 23 Jun 2025 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685769; cv=none; b=j5VqpL4CvQun74cQFKQRY7op3th3h90OYjDWLh1QLV9nMIQo537qc7kRL5gzTLjvG6rLRpm6Xa2lpSsFBt80eMbqloj1tnearxrvn+y/OZBqhgsr7N6pUorTFE0rU1CDhbAWX+J4T+6Hq+3WQMfnuLz5cpq1Ov/t9QQaDkuV9Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685769; c=relaxed/simple;
	bh=3HOG8ig37Oo1mgHlShFD0aE5WpHKfaeW9YcuF5WvOFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZI5kq0m39x8gfjq1mETWhc7boezzIG8/EmsgWvWmeRo9n42caO3RFdWzcKl0xuvZBNGkQixQWdmnXAJ9TsylZJJ5vn9AOvcWRNRl8MKrllxBxtCPuFBNcfELwU0sVFbcszp8bWHPJ55MUkqPStne8xzBTcoNJA0hBlMxiI3K4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scTbO/JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scTbO/JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D28C4CEEA;
	Mon, 23 Jun 2025 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685769;
	bh=3HOG8ig37Oo1mgHlShFD0aE5WpHKfaeW9YcuF5WvOFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scTbO/JGd/yTB/9OVpcSMkxPqUincpp12Q81MbBfuf8Mo47ZLf1mYEda8qMDXiOtT
	 WP5IjGm/M9EWOFfvjyMdRCs51ezAKpMINuwIOju4SYHaIBhMJSMTMpsk4UIykeUSnq
	 W7RLGkefNXim4thvBUF+YbMOlx+xDB44D0Hvo0P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/355] MIPS: Loongson64: Add missing #interrupt-cells for loongson64c_ls7a
Date: Mon, 23 Jun 2025 15:04:54 +0200
Message-ID: <20250623130629.591893826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



