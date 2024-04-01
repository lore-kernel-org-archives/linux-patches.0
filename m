Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF08A10A3B;
	Mon,  1 Apr 2024 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989312; cv=none; b=gVHZoAmtJdwSfby97zauKMAZE719AEi+YtzxGMpS9dInXxhmjmG+Lok32PS+QemaYb6kdqvfNQ7j4Pfdo6ea6DabDx5GqV9nOUMSJEaTw/bQkOEc0EebNGpy07c0Bct5g/rx0KCFbeffOKZihaifpv+n0eNKMRkHjNRZQekdcOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989312; c=relaxed/simple;
	bh=dRprHhcnpgh5Pq3PAhXKjigwRhp7MGbTW5hu3iDYRNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mW0BLNEWsfXGcqgE4CVqNWkXqRUxYow/uxf4ibYkrf7oEHF9XRGrP2x9sk9qjO8uB9aEhgr/l31QMi+0Oi9+2l3fCpS3SqgjnUBPs0uyCzirslkNzgQwcXNPHXwYXXugAxmj4pzsLQ65vvhUDOFDwGo0MPCB3NtJQZbQ+9JP17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNYgDyFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNYgDyFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30760C433C7;
	Mon,  1 Apr 2024 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989312;
	bh=dRprHhcnpgh5Pq3PAhXKjigwRhp7MGbTW5hu3iDYRNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNYgDyFxMttqgWdVKkWdVfdzQXz/a6HdIdc3ObCevqRCWzNZs2FN+LVJaFxBImibJ
	 V8VrDhLS5oOG3xaB+ZNldHkjuxMTdyHg+C05ouGs365xujwjoAVxFmLlbPu0saZhLD
	 mU2Z3ACcW6fodtb5cI0SP37/Iu4d9G4u+QxoDpEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/396] arm: dts: marvell: Fix maxium->maxim typo in brownstone dts
Date: Mon,  1 Apr 2024 17:41:01 +0200
Message-ID: <20240401152548.250797626@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Duje Mihanović <duje.mihanovic@skole.hr>

[ Upstream commit 831e0cd4f9ee15a4f02ae10b67e7fdc10eb2b4fc ]

Fix an obvious spelling error in the PMIC compatible in the MMP2
Brownstone DTS file.

Fixes: 58f1193e6210 ("mfd: max8925: Add dts")
Cc: <stable@vger.kernel.org>
Signed-off-by: Duje Mihanović <duje.mihanovic@skole.hr>
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Closes: https://lore.kernel.org/linux-devicetree/1410884282-18041-1-git-send-email-k.kozlowski@samsung.com/
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240125-brownstone-typo-fix-v2-1-45bc48a0c81c@skole.hr
[krzysztof: Just 10 years to take a patch, not bad! Rephrased commit
 msg]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/mmp2-brownstone.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/mmp2-brownstone.dts b/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
index 04f1ae1382e7a..bc64348b82185 100644
--- a/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/marvell/mmp2-brownstone.dts
@@ -28,7 +28,7 @@ &uart3 {
 &twsi1 {
 	status = "okay";
 	pmic: max8925@3c {
-		compatible = "maxium,max8925";
+		compatible = "maxim,max8925";
 		reg = <0x3c>;
 		interrupts = <1>;
 		interrupt-parent = <&intcmux4>;
-- 
2.43.0



