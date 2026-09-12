Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A33B3290D1;
	Sat, 12 Sep 2026 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231149; cv=none; b=Q2PP10K68CB4sU9BK1uK1bvipRVZYzLU6lFEEl4Oyvanf+0WrWCB03BMBL6OQjVNmOymLgFpJVbBnF5a1jzs4UDoINwmYXab8gozsZ4g2pJdYXoIBXYP15RP7BCk4ZfW4Bw9++5FoB3XOM+od8gIDBicDqcjxrJufGRXi7gjB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231149; c=relaxed/simple;
	bh=n2XQlcYnA+2602TXkWjZfNExh8fqnSrnbx1ja/6nmaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft5vbUMqM7Oblr//lbVJnS3NF1wVDQ5AQursAmyb+TEagHQSzbqmGGnXjKVXngTuGdHKzgt1eXTPep43XybANTGDiVO2Ly8VWWazFwu554QogVxhh2zHUJBpuufYplwyIWg+qbzo7ueq2zf26QhYLgCSjtbb75J4zKDqn8nfaOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idU5H0za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idU5H0za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382E11F000FF;
	Sat, 12 Sep 2026 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231146;
	bh=GXLWVIhOcIUqjIB5m7/YXIDXEmN6r7LMfdx+l7FFIxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idU5H0zaODA+qP0KOC19Qq6wAOBQEdI8in+MaGiRU4JaDl7OScZpvQ3UQWWVIrldf
	 mqyMS3Fpm9hNyNChTGMI4CTaRI1dntiwDZoApKInNPdUBsvmxptER8zKXpo0g7svGB
	 jT3bzCf/Y1I9LQM7D4eMzKqhTr1Gfg4sAGPxe8VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0939/1191] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 09:01:07 +0200
Message-ID: <20260912065609.316761988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c23988f84496e937dd255564cb30bec67608dcc6 ]

The pca953x driver requests a 'vcc' supply, producing:
  pca953x 0-0020: supply vcc not found, using dummy regulator

The PCA9655 (PCA9555-compatible) expander is powered by the same
always-on 3.3V rail as the other I2C devices on the bus.  Add
vcc-supply = <&reg_3p3v> to silence the warning.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 61fc3adab54bb..21df1b9e3900f 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -169,6 +169,7 @@ expander0: gpio-expander@20 {
 					gpio-controller;
 					#gpio-cells = <2>;
 					reg = <0x20>;
+					vcc-supply = <&reg_3p3v>;
 					pinctrl-names = "default";
 					pinctrl-0 = <&pca0_pins>;
 					interrupt-parent = <&gpio0>;
-- 
2.53.0



