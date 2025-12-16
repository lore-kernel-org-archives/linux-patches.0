Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93D350D49;
	Tue, 16 Dec 2025 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885750; cv=none; b=aa+kqDQqeRerfJp4YIWrvqn+NtGd79rt5mIcYsKjHm1B/ddA+c5wP7mL3T5PC3KLowibkbCCchhhhvxtIpV0qWnk7CEyk/5KtI2GOyVM7+v8bbcTuZr+uUeLpU/qWpbcaezXh+pK61K8ufU8ZCZqBGHH4l5sD+GSygLpZaqbDgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885750; c=relaxed/simple;
	bh=al96CQu/Gln0pbmKdwv3jFM3ygV5TZMqPlc/qxMaB+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiqyTdLCkdjPTlVLzCwh1JtjcAfLB5BY5qGBkVfk71CkruakY18P3kaxE5y9iLERBFTbvyxkxBDyQonARIAt4O7Ic2D457MGCt330+J68UAVgKRs4X/OfT0JCzfXEJhrYn1HajDUIBFkBXYVAKJZPeoKxhZk/QdQl66HQQfDV7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYrK8goR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYrK8goR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9813CC4CEF1;
	Tue, 16 Dec 2025 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885750;
	bh=al96CQu/Gln0pbmKdwv3jFM3ygV5TZMqPlc/qxMaB+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYrK8goRf8k3SeyQ1eEt+t6b5bucNpHVekYDsiB0OdBJsna8cGpBppkF4Fc8okgCd
	 H0QCbR+hYStrd+Usxc7wD+XAgJl3axdGU3c4ylgyvzq4AkHvITtb4mMTkMfs5EJOjo
	 SZldJfHctnbD3s33eAUefQ6rqbCX/MTgABp2z4pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 233/507] arm64: dts: rockchip: Move the EEPROM to correct I2C bus on Radxa ROCK 5A
Date: Tue, 16 Dec 2025 12:11:14 +0100
Message-ID: <20251216111353.943486266@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 92e6e0b0e595afdda6296c760551ad3ffe9d5231 ]

The BL24C16 EEPROM chip found on Radxa ROCK 5A is connected to the
i2c0 bus, [1] so move the eeprom node from the i2c2 bus to the i2c0
bus.

[1] Link: https://dl.radxa.com/rock5/5a/docs/hw/radxa_rock5a_V1.1_sch.pdf p.19

Fixes: 89c880808cff8 ("arm64: dts: rockchip: add I2C EEPROM to rock-5a")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-2-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
index f894742b1ebef..53df90b0eed16 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts
@@ -221,6 +221,12 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
+
+	eeprom: eeprom@50 {
+		compatible = "belling,bl24c16a", "atmel,24c16";
+		reg = <0x50>;
+		pagesize = <16>;
+	};
 };
 
 &i2c2 {
@@ -242,12 +248,6 @@ regulator-state-mem {
 			regulator-off-in-suspend;
 		};
 	};
-
-	eeprom: eeprom@50 {
-		compatible = "belling,bl24c16a", "atmel,24c16";
-		reg = <0x50>;
-		pagesize = <16>;
-	};
 };
 
 &i2c3 {
-- 
2.51.0



