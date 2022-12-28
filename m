Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EA11863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE673C433EF;
	Wed, 28 Dec 2022 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239640;
	bh=5+NbVSRPuQBuAknbwIoK0y8/8BUfbHuJf89N4DK1f2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWPNALtTTQWp5f1jEcvVlHeRlbhyuV77QaKJspP7EE1yaAe79jg8bjiZNG3oFB+SZ
	 LVQlwDq7P8A50uGYAOaoLNa3BU23gbe/gLz26KW9/OM2v7nOYFqtM8Ww3+PwENSsZ+
	 qD7sbn54KsrzSr2kshuDTORes3AeSPfjdkcXNhE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0022/1146] riscv: dts: microchip: fix memory node unit address for icicle
Date: Wed, 28 Dec 2022 15:26:01 +0100
Message-Id: <20221228144330.775849321@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit d6105a8b7c160a73ae04054c8921eba80a294146 ]

Evidently I forgot to update the unit address for the 38-bit cached
memory node when I changed the address in the reg property..
Update it to match.

Fixes: 6c1193301791 ("riscv: dts: microchip: update memory configuration for v2022.10")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
index ec7b7c2a3ce2..8ced67c3b00b 100644
--- a/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/mpfs-icicle-kit.dts
@@ -37,7 +37,7 @@ ddrc_cache_lo: memory@80000000 {
 		status = "okay";
 	};
 
-	ddrc_cache_hi: memory@1000000000 {
+	ddrc_cache_hi: memory@1040000000 {
 		device_type = "memory";
 		reg = <0x10 0x40000000 0x0 0x40000000>;
 		status = "okay";
-- 
2.35.1



