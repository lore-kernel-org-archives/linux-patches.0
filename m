Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A841D5ABA;
	Wed, 25 Feb 2026 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982963; cv=none; b=XWUyQIKIlyM7EMqDvo2saESYu0J4LF3mC8NLyvhCFDO4McY8ivZYfCtM/ngadNY9xlyp0Y7mk7gIpYYLPPnxxfKrsf4YZzofp8HrF62sv+QySMHbdoDUSquF1Hr1eo638hBn53AXpl+vKE5+vPiGchbaNieZFafOY1ajcrPBvpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982963; c=relaxed/simple;
	bh=Q2/DX0dNyQ0O1KhPpWQfdt4m1ZICbQLP6lX3p2QyUbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7w+0H7/9gMUFGa4TAr1pSKV3fCQGo5D1qI8u947fcjlgQrBInQgUpTddpdlpIdcfDp/FFK9IoPYwaEBGOxXSIKaXsWZOo1JHqjkCGON+QDB10sqkJ53OK0g3yTkmWS3gX085IZxW7uCZrvNuWaQu8ETJIVI+L0r6Gjbxy6rhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlSnDRhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlSnDRhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21578C116D0;
	Wed, 25 Feb 2026 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982963;
	bh=Q2/DX0dNyQ0O1KhPpWQfdt4m1ZICbQLP6lX3p2QyUbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlSnDRhE+uNprJo7TgCim09AEcVO3PdgP84Od5j5KQ4g63K8qYOHShEzYXxU5IjVp
	 GEoKTZXiWTYa10ByAeoD9SON6sClgHMyoWG8lP0KpRe0/ndFNyFeWJSy4kGzgJMdnS
	 SwfcJPcckhuo+vFf9CvstTIwD5hwf72h+42T4HF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 139/781] arm64: dts: ti: k3-am69-aquila-dev: Fix USB-C Sink PDO
Date: Tue, 24 Feb 2026 17:14:08 -0800
Message-ID: <20260225012403.077794761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 36ee9f8b1ae07fe82885a7a3553a5be347d3f978 ]

Change USB-C Sink PDO and the amount of power that the device can sink
to zero to maximize compatibility with other USB peers (the Aquila
Development Board is not sinking any current, it is self powered).

Fixes: 39ac6623b1d8 ("arm64: dts: ti: Add Aquila AM69 Support")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20251204134220.129304-2-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts b/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
index c7ce804eac703..f48601ae38b7c 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
@@ -399,8 +399,8 @@ connector {
 			try-power-role = "sink";
 			self-powered;
 			source-pdos = <PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
-			sink-pdos = <PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
-			op-sink-microwatt = <1000000>;
+			sink-pdos = <PDO_FIXED(5000, 0, PDO_FIXED_USB_COMM)>;
+			op-sink-microwatt = <0>;
 
 			ports {
 				#address-cells = <1>;
-- 
2.51.0



