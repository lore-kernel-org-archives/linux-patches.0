Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9046AA6B;
	Tue, 21 Jul 2026 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648302; cv=none; b=YDJ5eikI6+0gmbHcVqRbZc1FZrAXuREemvmO2/hia30+/YxCGZhkJji/A2S1DAn1Z/i0bm9Gh8Exc1p0781H3odDhi4qCmHjiB4bpya+IiRClqW/oUcC+U93LWP2MZdEqfaghEFOTq9yUEA+2PTXJYeMBMTAO63ndPGkskiMkrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648302; c=relaxed/simple;
	bh=2AHAr4O7LGD/K5LtUPhcsh6CzpRESV+SoRWKvpkuK2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJrtKnU8Ix6ULEyctPYB5LsBwQ7g03FdiI/KG2BFkYLfDYK0jgKe22EUCxoH/pzJQUroR6nXpKCwEoCGrHaX8GW65k1cS5ki5hDskd2pUXePo7hS85AWdMJTdXE9GKpd6aKL4YF1G1hjbZQTlfRICn1yBs0z+J5RGRhKd6zu0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dkgxg85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dkgxg85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1E31F000E9;
	Tue, 21 Jul 2026 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648296;
	bh=swy/kMHEMIdiUSHYiuhD67nTNWs+EQpd6ZxlA5gD00Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dkgxg85JYjohJKzkV8aQ3GGFPv4OH8PcsY7jOSLipzx1ppXcHGteaCfk5qHjgV2y
	 ZZ/Y7/O2KYsvWACtDAsy++8+/AyffDCnl94Omt0U6YM7rxvKIiWwqIyXpKiHlcSPeh
	 xRKHhSYlnQxeeVDzlTteWisMiMz8sa9rpH89HaQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje@dujemihanovic.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0147/2077] arm64: dts: marvell: samsung-coreprimevelte: Increase touchscreen voltage
Date: Tue, 21 Jul 2026 16:57:00 +0200
Message-ID: <20260721152556.152417643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje@dujemihanovic.xyz>

[ Upstream commit 4da515eca1b8de56c9e8a17866626f99d9bccbc7 ]

The old 1.9V setting was found to be insufficient in certain
environments (in my case cold ones), causing the touchscreen to register
ghost touches and mostly ignore actual touches. Increase the voltage to
2.5V to correct the issue.

Fixes: ec958b5b18c8 ("arm64: dts: samsung,coreprimevelte: add touchscreen")
Acked-by: Karel Balej <balejk@matfyz.cz>
Signed-off-by: Duje Mihanović <duje@dujemihanovic.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/marvell/mmp/pxa1908-samsung-coreprimevelte.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/mmp/pxa1908-samsung-coreprimevelte.dts b/arch/arm64/boot/dts/marvell/mmp/pxa1908-samsung-coreprimevelte.dts
index b2ce5edd9c6ac6..bb0a993996241d 100644
--- a/arch/arm64/boot/dts/marvell/mmp/pxa1908-samsung-coreprimevelte.dts
+++ b/arch/arm64/boot/dts/marvell/mmp/pxa1908-samsung-coreprimevelte.dts
@@ -460,7 +460,7 @@ pmic@30 {
 
 		regulators {
 			ldo2: ldo2 {
-				regulator-min-microvolt = <1900000>;
+				regulator-min-microvolt = <2500000>;
 				regulator-max-microvolt = <3100000>;
 			};
 
-- 
2.53.0



