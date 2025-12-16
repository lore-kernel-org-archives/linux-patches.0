Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D8C341AD6;
	Tue, 16 Dec 2025 11:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884326; cv=none; b=D9fjYew2Gi/sggJ+6TpQ6ap4Q8bIOYTeXNDf+16fHrKI3p3mNz7nQv2oTXofjhlJ1Ac92jNGy2JeJzEQ8L/k2xnIEkNOztcyMNLKl3XLINzgBJT+MZGbxmLqWDTDiz9Eolb5kyI6OfedRRwqqfaV/sZXM8ZWr667cFyGOSAVego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884326; c=relaxed/simple;
	bh=5PvlkougN758/dYBdm5o2yEi9FnTOwgZ4vOy0gGAPIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnkmeRI+6vyeBl7AfcLAMLEpfTwQoKy2ABQpujEFoKZfk9Vrm6dNLTOlGFi5f1bifzxIY/4mDvclFSSazpkWLAKHDn6L9gDzWEav/NxkL9d6JAncMrEixH0ZVRo9a74RTI5lFpifot4g+aMuGTg+vKrr9JE1JjP7dohW2bwcdv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqEZXAYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqEZXAYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF50C4CEF5;
	Tue, 16 Dec 2025 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884326;
	bh=5PvlkougN758/dYBdm5o2yEi9FnTOwgZ4vOy0gGAPIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqEZXAYJKMUJ1yZh/QuakyGXNVmJMVe0eyxNLdydZcaY8uonef+ppnybW4n5OuP68
	 MAQKJT7ABjvdwvBcEOJcKzeY8KIKRDxf7OCLpCCUFZ44wNLtD6gIPLp2WI88FjXm2+
	 jmi1ZN9TePe0kPyTepLlOJsxrxJdezXuKi5KjDyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/354] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 3C
Date: Tue, 16 Dec 2025 12:12:06 +0100
Message-ID: <20251216111326.674332587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 260316d35cf8f8606c5ed7a349cc92e1e71d8150 ]

The VCC supply for the BL24C16 EEPROM chip found on Radxa ROCK 3C is
vcca1v8_pmu. [1] Describe this supply.

[1] https://dl.radxa.com/rock3/docs/hw/3c/v1400/radxa_rock_3c_v1400_schematic.pdf p.13

Fixes: ee219017ddb50 ("arm64: dts: rockchip: Add Radxa ROCK 3C")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-4-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
index 887c9be1b4100..0649812765900 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
@@ -466,6 +466,7 @@ eeprom: eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		vcc-supply = <&vcca1v8_pmu>;
 	};
 };
 
-- 
2.51.0



