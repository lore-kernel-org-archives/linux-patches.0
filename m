Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F0F2F12DB;
	Fri, 17 Oct 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713221; cv=none; b=Suq7lfIgykev/GpesYtgnUlEQ8bIkfoYbnh9vJqR6mtu44wmxWQzkygDTq8/CHW6Ro+Il0FQT9yfFKe5HwPlZR+Q6JvF9gq9bOglPZbiADYlpiKQUVseZJbb59iNDHh23eR7t2m9rmpwlcJ7AhV14YMrcObcUSSs0KiKpW4NkDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713221; c=relaxed/simple;
	bh=AISeejv4wpXVz4V2T8EcC3q1Zi4FIalDx+CehiTRYh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5lPlsYiaNeIm8X0lzVoqSvDIQ7wRRMTO1AnOJGLmA/n8oug7bJfOrlaggCeuubaLpTuKo7SQHUJe7LONbB7kdctCcsSmqPGGztpUSatc1uJfYLam/QIvVRo1rb5n/9PD55chVDeDJLt8ooXtcyeGQvC+dkdKueUBm/OHz+CNY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Vxuwvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Vxuwvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F61BC113D0;
	Fri, 17 Oct 2025 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713220;
	bh=AISeejv4wpXVz4V2T8EcC3q1Zi4FIalDx+CehiTRYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6VxuwvhpRClpa7HtEjp6dqSWwhQKKbtofT3QFPW3fg615pa9xMH7QkS9zaIaGxWm
	 GjOZXSQjQm6a5HUbK6Mn8sxMBDqIUcXE11+DSFtfHAmZug8lcqtnY7v08JHANq9q7S
	 3pNNRVr/CgvlVbuTROKPxhmIoNPoLTg5rr0dQc+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vibhore Vardhan <vibhore@ti.com>,
	Paresh Bhagat <p-bhagat@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.1 056/168] arm64: dts: ti: k3-am62a-main: Fix main padcfg length
Date: Fri, 17 Oct 2025 16:52:15 +0200
Message-ID: <20251017145131.085808997@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Vibhore Vardhan <vibhore@ti.com>

commit 4c4e48afb6d85c1a8f9fdbae1fdf17ceef4a6f5b upstream.

The main pad configuration register region starts with the register
MAIN_PADCFG_CTRL_MMR_CFG0_PADCONFIG0 with address 0x000f4000 and ends
with the MAIN_PADCFG_CTRL_MMR_CFG0_PADCONFIG150 register with address
0x000f4258, as a result of which, total size of the region is 0x25c
instead of 0x2ac.

Reference Docs
TRM (AM62A) - https://www.ti.com/lit/ug/spruj16b/spruj16b.pdf
TRM (AM62D) - https://www.ti.com/lit/ug/sprujd4/sprujd4.pdf

Fixes: 5fc6b1b62639c ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Vibhore Vardhan <vibhore@ti.com>
Signed-off-by: Paresh Bhagat <p-bhagat@ti.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20250903062513.813925-2-p-bhagat@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -97,7 +97,7 @@
 
 	main_pmx0: pinctrl@f4000 {
 		compatible = "pinctrl-single";
-		reg = <0x00 0xf4000 0x00 0x2ac>;
+		reg = <0x00 0xf4000 0x00 0x25c>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;


