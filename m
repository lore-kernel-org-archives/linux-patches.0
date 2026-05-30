Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A9A25B0B3;
	Sat, 30 May 2026 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165570; cv=none; b=QVCXz0gPatZNvY0HprkykuJNwlvozc5Fl1hCGOuCEOBq3PZWI53dhqSYjDFnxkJ1b9mIMWWnP3EjY8AHbSlpXCaheRts2AF6VwkX0eW8zwZjtncj1uhWE+jUDf1wWXWbcCYs3DUZUPPYLbtIVWPG1lmUxEf1HgFDjy2Wg4CuFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165570; c=relaxed/simple;
	bh=jHmyA9umktKBz1+TkUHgJtjbR1X58UcFJf/3j/4jz/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYahFUpAla4pnRLbOE5dwfzeaY5ZD70jwRL72ULRK7f0PpRooRkkE7r6y4qkbCDPyNlPU1ElZ+n6qFL9rbjH10xedeXV3qcJKJSBvzxoeBdZycfA50p+hexuj1mskEo2YtITocc43N1m6kKWRenFKLZWZDZHs+raMgoEAfj4qmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdM+tSEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdM+tSEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14311F00893;
	Sat, 30 May 2026 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165569;
	bh=AnS81dn99H8vgAbIgJYfdChpK3+T4uCxU6v6AthcQFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdM+tSEtHRKBhkJcuH/K05eOcZesoyvRjSZJ8e8B+82Kbn+CnjW6a0jQwvYobRiQ8
	 eydboaEEbLF+68rk5PoZLD1f5MWcg8eVfMaDmv8j6oEetgGqEfr+aqVv0gTEgSGENS
	 eBHfeyADvF1053sTqOx3d8Z6XWum4bBcFrfPonB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/589] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage to 0.81V
Date: Sat, 30 May 2026 17:59:58 +0200
Message-ID: <20260530160227.835984244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -653,7 +653,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <880000>;
 				rohm,dvs-idle-voltage = <820000>;
-				rohm,dvs-suspend-voltage = <800000>;
+				rohm,dvs-suspend-voltage = <810000>;
 				regulator-always-on;
 			};
 


