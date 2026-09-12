Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259823939B3;
	Sat, 12 Sep 2026 19:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239921; cv=none; b=nbrdOVxlw/REhxx/3ojIcY3Ryg3g56Mux32+NzqibWRk1rGhtD21sDBS1a0Gli2Hx7pOKWz8715VGovxnVTAmj+A2h4baLbsFJ7CXHqIjvrhcfjAC2inioYZ5nqrKfKEaZn1UrJc+2tv7nCCw/W4NQIvc5s2opCxOoJyaEL8Id4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239921; c=relaxed/simple;
	bh=YvWgx0jMxKXZgB2hvGy56fC2bsB3ZAf0TOygMIRxGEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCxWsiP7mTpkPRL+wUlvyoYr5TEpXgpk+98UyHn2J6NNLCeSm2l7uRvWClKvqoN7OkmjtrPkZmTWJ1+yQEdUebaEO84LS2qbcwms/KYFr6Kekjt7xdPp0OatzE3UHNHjD7lUEE9wNbzBUm6Mq2KgT9dI95mTjPXv+EDapA8LYf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE9R3Weg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE9R3Weg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D01F000FF;
	Sat, 12 Sep 2026 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239918;
	bh=3BpjVvfkLanA3X8EeZNgAktYC8NZMsr2Tm2ACcFi7Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wE9R3WegmeV6gUpfqQ6QP9fOW/QXXGJbLe/BR9jEIyV3efT7DPyQkDyAEDnPsEPgh
	 Wzg/Sw5A8Iy7612mMNz5Z5sqCwE6yKKhLOfbd9o19FD7dnzBl2R2nJ4ZS+G9ic6Xjq
	 I6J4oawt4x5gznHVSe36sJQsHiGH72+/nlQKsXkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 760/935] ARM: dts: helios4: add vcc-supply to GPIO expander
Date: Sat, 12 Sep 2026 09:03:10 +0200
Message-ID: <20260912065544.264032381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



