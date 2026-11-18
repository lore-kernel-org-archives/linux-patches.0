Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015403;
	b=VK0h+1xCbQCVuKgdiQNgusqktkc6J2BhbJgCUBYCWF1zmIOGY8a9yLzHalUOP+aRLWdv
	 TEK+6euijsxulzYhUYKWkGJUU26poNaLK5m5RxZGQ6GozD2284HyYaDaT3zygzxS/7Vj8
	 2Thgqv2UmcRyWtyCr77QyrFpuEF9sV2q94m9mTvNUIrWXX2W7LULEhQARE75ch3ShCGYW
	 EcguPqRuqsGrO8F4ddETWPPBac6aGzjbTStaLga22gWJl2enAD6xr98MglFt04hBSaN0J
	 ogLqrNzhFvsTZSKGTfwMB8iksTmztdtv4IZ2C6tnM1QeuQ3Ez/RUCWoWOJTfs1xOfOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3lNYQFUe0K4r6jWjB/gAYxnxsfQxtinGT8KkHNRN+Y=;
	b=AY3HC9DQer5ISU266gqGQ3sx0+LhQmA7vTUUJjF/hXtu3TkAkK/3sLlawOIcuUZmlne8
	 K3BrZlM0hQS6wA4Zym/Zy8Y/klMAnGn+HjtlF8stP2ANSH5uUhy6Nj6YtWFhcLxr9AWOj
	 9fMExHH4y8ws78i5O/tDoCxrQRwED0yi8vm6RhkH0mA4QDvaUK1T7fclRw1YeKWa/V05M
	 q0R/zzpPVBMwufc687uhLN6a1vX8gFvkqLmJyHLdQ083hgb/CWtGC/UmHVgGIp0QXMWZ7
	 PUeoKQdGQ6Ffh4GfNRRRe3MGZR3Y0/PvpK5uBsxmyy54c7MFsBqEANbsHQM0xChW2dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njwgJSqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DFC606A320;
	Wed, 18 Nov 2026 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njwgJSqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1632D1F000C4;
	Wed, 18 Nov 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015403;
	bh=V3lNYQFUe0K4r6jWjB/gAYxnxsfQxtinGT8KkHNRN+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njwgJSqTukqIJoaXCTUYLxXjohuWp1FKRzb9vw7cy/3kmGVe3x3E4JhhHEvc/1BsE
	 cDcGEyAHVzAojlj+1MOrG25hQcOXPVTH8Hi936IplIH7Pwq0eYfFxH8WGC9KTAyc/K
	 Yb7BDrnxAkkFAePuHAKZCcvPkwh3GOy6adKaS5lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0120/2651] arm64: dts: apple: t6032: Fix cpus node indentation
Date: Wed, 18 Nov 2026 15:22:40 +0100
Message-ID: <20261118150252.191322987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit db6fccb5a4222ceb9c102a68f0e98a1e40b299af ]

Drop the extra space indentation of the closing brace of the cpus node.

Fixes: 67d9574cf8ed ("arm64: dts: apple: Initial T603[124] (M3 Max and Ultra) device trees")
Reviewed-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20260830-b4-apple-dts-fixes-v1-3-cc20f8445754@kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t6032.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/apple/t6032.dtsi b/arch/arm64/boot/dts/apple/t6032.dtsi
index bbf19ecdaaec4..61d044f3a7346 100644
--- a/arch/arm64/boot/dts/apple/t6032.dtsi
+++ b/arch/arm64/boot/dts/apple/t6032.dtsi
@@ -283,7 +283,7 @@ l2_cache_5: l2-cache-5 {
 			cache-unified;
 			cache-size = <0x1000000>;
 		};
-	 };
+	};
 
 	die0: soc@200000000 {
 		compatible = "simple-bus";
-- 
2.53.0



