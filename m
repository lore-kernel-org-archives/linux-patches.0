Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328EB2F8EB5;
	Sat, 30 May 2026 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159354; cv=none; b=Az3bJhqK0fKyb/c71g0+6Uo7KoLuQ5ffjqdePjoGU0NbqrshFMRJDDqxepEZoPVtdB2Ch/+edz3m2VOR+PebNhyCkleGC1v4AnQ7BRQdrBLbCaVgedBN59zRZGdQWSf28azTE+9LLy48Yo/5c9oQmG+P13KR0ysVk15JgnVwfFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159354; c=relaxed/simple;
	bh=HQLSyWlTj+dnQYPL5Cv7DLqldyHKt2tGT0fI8kriUWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUdtVB7YrP4hgYSXEPVG8U01/aHLzTN9hXC6W6oMKPAMZqfo+Le5GL+WQui2gPHB+ZhpP1/G9cTGf9HsMQO2XUCiphaQmtuMqDGhELIXAlv11WdteBYvn7pWJEkxul0i1oDd6CsvEFBq0LNAIoIY8yKT9khpCPfAQ/pgtkcYDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiTxoG5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiTxoG5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D032D1F00893;
	Sat, 30 May 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159353;
	bh=/5PxbM1Yha7vn2MBazUMkjXvROdhAd2T5xjbiTb7FKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiTxoG5NXjaVqoHVvJxq3Bzc6kJx3CWAWSBwQTTTkEZbpojtZ4lsHxAWjtAa/TwRK
	 vHD3c98bDNLwif3nK2/YQv8VmSPSlDnTgVBz3TiXpruzvwwjdMR38K0kPafEYJ0URC
	 Qk+FrJWKIH6TwUFwaYG590LwqraQ7+po9fD1ulSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/969] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage to 0.81V
Date: Sat, 30 May 2026 17:54:02 +0200
Message-ID: <20260530160303.568904566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 94b91e3ca6688fafd6a5dd70bd89fe9d3aee88da ]

0.8V is outside of the operating voltage specified for imx8mq, see
chapter 3.1.4 "Operating ranges" of the IMX8MDQLQCEC document.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 511f76bf1dce ("arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -821,7 +821,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <880000>;
 				rohm,dvs-idle-voltage = <820000>;
-				rohm,dvs-suspend-voltage = <800000>;
+				rohm,dvs-suspend-voltage = <810000>;
 				regulator-always-on;
 			};
 


