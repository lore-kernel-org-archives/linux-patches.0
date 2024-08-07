Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF7823DE;
	Wed,  7 Aug 2024 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043610; cv=none; b=SCM4uSV1NOIUboSTZdKHAL/z+D3zayvwYfrCjow9qWJ9Eph9J0P93+1wqlTUigAO+bhBy/E6p/6imQDvUWei+6aynJfmwumlgOHx3DLcirX+NLCZWwqVmQ2ONBWJQE7CIXYCa7oeBIM5NZGMMQMMwFv2vUorP14gtQlYWsqh1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043610; c=relaxed/simple;
	bh=LyfqdU2N5GF/ZixgrRL5mebBQJCFfF1RWX9HY3HWXLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maqh8MO1bvB80hNB0U6ieMD8oxtZcQftXH3oKnYpKAzNPSjco13Q3MgfqXoRIy1PdDH9+dmN4HXPc+gaR+v0s2X8Z3ZFBXrxWRKku5V/P9Q4L6TOpyKLFErUcTIS4Cg0jIg22OazN53E1vkPw5C6zsi0NieZXf1iVp4d3pLv4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6on57e7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6on57e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90363C4AF0F;
	Wed,  7 Aug 2024 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043609;
	bh=LyfqdU2N5GF/ZixgrRL5mebBQJCFfF1RWX9HY3HWXLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6on57e7FCmaHF5sMbzEsoBdEpLWsZ0+ywnrCqC9zrsX88BMB7YtaJimy2hOMa3vc
	 WCJaa3GDDvx3vF7F+UPGs+4u9BL4pe2o+3CxMJQVWMezv6JC8B6ojp+XUEsobKtJI1
	 phVEitR1v1hSAowaR76u07FpXyC3nR5PLf9sqGNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/86] MIPS: Loongson64: DTS: Add RTC support to Loongson-2K1000
Date: Wed,  7 Aug 2024 17:00:13 +0200
Message-ID: <20240807150040.357339610@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit e47084e116fccaa43644360d7c0b997979abce3e ]

The module is now supported, enable it.

Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: dbb69b9d6234 ("MIPS: dts: loongson: Fix liointc IRQ polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index 9089d1e4f3fee..c0be84a6e81fd 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -96,6 +96,13 @@ liointc1: interrupt-controller@1fe11440 {
 						<0x00000000>; /* int3 */
 		};
 
+		rtc0: rtc@1fe07800 {
+			compatible = "loongson,ls2k1000-rtc";
+			reg = <0 0x1fe07800 0 0x78>;
+			interrupt-parent = <&liointc0>;
+			interrupts = <60 IRQ_TYPE_LEVEL_LOW>;
+		};
+
 		uart0: serial@1fe00000 {
 			compatible = "ns16550a";
 			reg = <0 0x1fe00000 0 0x8>;
-- 
2.43.0



