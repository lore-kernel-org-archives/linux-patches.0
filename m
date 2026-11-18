Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019210;
	b=DN+1wRbEQpKOmVVKs2XM1KLe2pjXPAZTrBRjDNfbJLgyudWhPF6jQwsvUs/1lZGe5W8w
	 Q8C9uGPblQgdxv44FGX9FEqd5Ln7bS7xCF/Pqj6LCCJpX94yQPjk5Xkv4BZQmTz5grzFW
	 tsvJqbCeKId6KwS6XtDgA979EHsgE1yApu67wMVmRlV8cQHiXWFtoV+Xv1LF7mBjfEh1Y
	 nts2NN2LmLHxP1GtvarxDdZocURgMjTa4wDoTVAlWTlLU6iHhyvh4KeljYyFQCCFKBky9
	 nSeWSJjXKrB7baNz9mUqbIpf/JgGKvoRaOKOEpC46w9/9+NYFeqWJ258PcAKUm+iavQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DzMuW3bkw/jbgFx/91tDXP95HsfXQNyuPWFKN9uKwbA=;
	b=1RSbYI97gg9fr6T664nX2//ugZok0SjAgbgRE09fbL1Jkq8eRsvHKl0ymQ4J6wpHkX6+
	 6ljeKhEzxQl0EFrphsIerGgpKKKByUrnF7vuqVeM/NuWZ+siwAL22ZW4cVsdKWWdKslQ5
	 8pjqteDiAnE2KEK7qbiiUfDQy2ilL+YCLcNOf2AeAZOzHzxTtt7CBI9VciDWSrDCyEoE+
	 IskxXEt/XT1rv3w8l6o5lKSEksyDP5oHeKu8Af9LxZuo8+wXwqwLfWM4upeVXfn463jdY
	 FAQ01HhsdDgAsyoFsZADB2e4dzqybsVcR1Pgj1i14gzBS18Xn6FF9K0+OBwA9b9ykOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQ98l5rs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEC606A33B;
	Wed, 18 Nov 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQ98l5rs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F80E1F000C4;
	Wed, 18 Nov 2026 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019210;
	bh=DzMuW3bkw/jbgFx/91tDXP95HsfXQNyuPWFKN9uKwbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQ98l5rsfoJAMr2ZhBDMzRSiGp/p3htO7M2V9r0UbcXX9qgqqOQ3AxW05sqUzvoZ7
	 b+6ondi6azPzIOTJdZa4F/6t5jx+0j+88Fbads99uVqPxfwAQUa4HyGjzkeXrctBly
	 /YTVK+n+QMPLH91dvgUk9RJe/N4H37ziLVm2mYuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Hiago De Franco <hfranco@baylibre.com>,
	Chen-Yu Yeh <chenyou910331@gmail.com>,
	Chen Wang <chen.wang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1514/2651] riscv: dts: sophgo: cv180x: Fix internal ephy node name
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118150342.505583432@linuxfoundation.org>
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
index ec3bf305274ae..d2ec70fd515e4 100644
--- a/arch/riscv/boot/dts/sophgo/cv180x.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
@@ -71,7 +71,7 @@ internal_mdio: mdio@0 {
 				#size-cells = <0>;
 				reg = <0>;
 
-				internal_ephy: phy@0 {
+				internal_ephy: ethernet-phy@1 {
 					compatible = "ethernet-phy-ieee802.3-c22";
 					reg = <1>;
 				};
-- 
2.53.0



