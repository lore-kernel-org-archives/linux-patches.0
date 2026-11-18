Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025930;
	b=I7xOAVYoyZQCF/RUsFfwKVhq0xT5ZvEnzON/XIwpT9xZtdNNO1JhyYXFw0hpc5hlYiv5
	 knYKmmP20emwb8Iwgwc/kTuSBffENOOnjQQy5psyF5QP62PaYgBQW3M6PCH6NHb8z3wYG
	 ehvbPd8OzrI7TG99BOIWzV9ot+/pde/39REcFFrICXN5TcYWkHBeTHLs1lzlhczPNvnA8
	 hLA28jh5uT771E/OYUxOamWXmEJe+JYjodJ06txhYlU7PMmCXTBDIT1DOSCh3VcXx/fEf
	 KdMgXeyJrJfkEXeT2Xl6Zgk8+JUhHhfQs5qTF/U7qfGeo6L1kNeDjGj+861zjuNuISQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jszh4mYtcj+qUFozZJ2rs6SmP8JXHH95fUv0dPN1rY0=;
	b=u8gonZs/x/yBg0TJLkfnRn32Tue1Vrj+cHWaYi/pLUiZnq2Qe5U1Ns85c8zuFJUqkxXG
	 V+GTUUcGdwV1GX/jewv+hYJYQinyxlUcCHwnUxgIz48YX1OlYrd6dajgmr5oFBfeQbdbi
	 pJcoJ1ABqaKxgUJb5BCkr0cgMelqNcNwwl7pZHndS5HbWkGCS+Qi7XpZ4OIhZ68fhxdMX
	 pkZRu/88FYG6d78ULGGdnfuBw55VjMH0Ka8TBIclatAXB2IfcQP1SMRYA+dGQ2cZXeCMU
	 FAA6JTb7l1lCuiaj75dtrpEL8RWVXlekuFt7LR9XJUwwFcGEtbcqWqrqoAmgV8utpbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jaOEdwkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC356606A336;
	Wed, 18 Nov 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jaOEdwkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92D71F000C4;
	Wed, 18 Nov 2026 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025930;
	bh=Jszh4mYtcj+qUFozZJ2rs6SmP8JXHH95fUv0dPN1rY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaOEdwkgxlNl4XMZ7HsjCsP+U5m22B/xdPWTeuKF4WQXl1HM+plTl8JvrPPHRs83l
	 ZhTi6oQ5ic53eg7L/4Zl8F4N6LRSgeJhgT50PZQm0K+0cu1wBOM/I37nQwQI+xhZ7w
	 RJPtClFcYwMK//2WI4Sfp78FLpGzYeK1KZVH5O/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Hiago De Franco <hfranco@baylibre.com>,
	Chen-Yu Yeh <chenyou910331@gmail.com>,
	Chen Wang <chen.wang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1255/2151] riscv: dts: sophgo: cv180x: Fix internal ephy node name
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150207.877392592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Yeh <chenyou910331@gmail.com>

[ Upstream commit 673f8e66d5edf424eaf599c8051e0f6962605861 ]

The internal EPHY node is named "phy@0" while its reg property is <1>.
The unit-address should match the first entry of the reg property, but
this is not checked by dtc for MDIO buses. The kernel confirms the PHY
is indeed at address 1:

  eth0: PHY [mdio_mux-0.0:01] driver [Generic PHY]

Rename the node to ethernet-phy@1, which also follows the common naming
convention for ethernet PHY nodes.

Fixes: ba1abacc57cb ("riscv: dts: sophgo: Add mdio multiplexer device for cv18xx")
Reviewed-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Hiago De Franco <hfranco@baylibre.com>
Signed-off-by: Chen-Yu Yeh <chenyou910331@gmail.com>
Link: https://patch.msgid.link/20261005093749.645014-3-chenyou910331@gmail.com
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Chen Wang <chen.wang@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sophgo/cv180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sophgo/cv180x.dtsi b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
index b2453ae452164..e05631a472574 100644
--- a/arch/riscv/boot/dts/sophgo/cv180x.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
@@ -45,7 +45,7 @@ internal_mdio: mdio@0 {
 				#size-cells = <0>;
 				reg = <0>;
 
-				internal_ephy: phy@0 {
+				internal_ephy: ethernet-phy@1 {
 					compatible = "ethernet-phy-ieee802.3-c22";
 					reg = <1>;
 				};
-- 
2.53.0



