Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8962D0C75;
	Sat, 12 Sep 2026 12:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215829; cv=none; b=DM4C7TepAMrnRK4b8HoUNcQ1a7161ztNhl4z3L83re6VA16ytoSAn/z2wYi2hZvfJUDg0mZjbfhK+BQn0muB8UFF13d9pecQBugTvQfUTKFWcep8BoLREpsO9jkpfaNNA0t0NYYCGeePcngZrUZMmd9BOANNGwJDiiM8lZ00La4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215829; c=relaxed/simple;
	bh=2+/FB73sn3j1RtMqvoRYZpisnY3QyxlWeTUx6P1Fbsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BITvYOmUU8Jn4CfiBW4+EcgLdXgh8XWqrnQ6aZh/WI+ApNIYRYhUxGrp+lBEOECTf+v9YD5/aSI0qoW27hud9r4Q4BEKdaq3A5yCIx/0yjLfAMfrir30G/jV5WMMgMQkUjoKKor22jVQaBPyBBHUKxAHTvRZN7ntsm4DivPn6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fnwurSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fnwurSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815161F000FF;
	Sat, 12 Sep 2026 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215828;
	bh=JpmK8YeGYf6goGShSx6ZQFabdr8wzHFEEai6ceMXQ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fnwurSp+LNDqnNBS5Sq5RiDOlYpANVUOM6ix5dI0qP2Fh3TVGwyg9ii9NzcVnSz4
	 EuiTvBEQoyHBFe6GLL0SlLhAH2ZcYbRRxTT9RjIrm0Oas9Jf+4g7X82QO5K+1VVs7m
	 MZGpwGLrXF2pk3Xjd1g5NF7jhVBzX2XuG0y30euI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0605/1376] arm64: dts: amlogic: meson-axg: Add missing nand_rb0 pin to nand_all_pins
Date: Sat, 12 Sep 2026 08:50:31 +0200
Message-ID: <20260912065621.019351229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 45eb76f9ab6854f79690d56d04df227429a536b8 ]

The nand_all_pins pinctrl node was missing the nand_rb0 (ready/busy)
pin description, which is required for NAND controller operation.

Add it to the pinmux list.

Fixes: be18d53c32b2 ("arm64: dts: amlogic: meson-axg: pinctrl node for NAND")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260624135650.727077-3-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 4717c9666f2a5..ff05b997f6fe8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -454,7 +454,8 @@ mux {
 							 "nand_ale",
 							 "nand_cle",
 							 "nand_wen_clk",
-							 "nand_ren_wr";
+							 "nand_ren_wr",
+							 "nand_rb0";
 						function = "nand";
 						input-enable;
 						bias-pull-up;
-- 
2.53.0



