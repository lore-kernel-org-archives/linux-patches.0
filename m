Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022827;
	b=qMLhEvRUIpl0Q4wUiO9QEaeS1hc2TL3M0Mf6dD981VANcECnxsrYNoDTdv/sy4TF96bg
	 VyxsjIutXsKH6kFgQTya3146nSTy65yvSUIbkJ8tyuE4TkVMavbwgKmuKRAfZj6swiOPN
	 m5z8MUZThG37eTyvq9eDeU2laEqWIs/AVWZibyWQ85Ivz95+GTArHkPAWcwdMaZrxZyFe
	 FD3jlXLTS0zBU9CvF0ST6yK/7gUzRxkXkTQBmbiUINJuizRC5Lh+8cNLMWG73Orjd7rf2
	 58dLVDcnesLXRg4yudzT7Fb/kVSgcJf49VF2DusX8ypI4Z0ob+OJA//g02ScDw9k2FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BKMOVaRhWa4DPFqwUH8YRPGd2YK+xuLDCugmkQxwHq8=;
	b=0/IYURtUXqW6cSPmHVoojOueB0zBR1KV2yYHaShnnwyP5CMTr3tOVD+GjJHhORCM+TQ1
	 eAbuEHNy7hltaSc6B2Av24nrFHCvYfMs/idaKJK6WzMsLHLYxYqpGsTz0e+UgiyvRpKF/
	 ExQdEGyAiBLBQLWPrPzUBGpLpTVfFjlXxZ0yzQOW4G0wWOLopN+rYbJ5WArEkWsoL81x7
	 IOTpGiGQMTAULf8czI+ayji3vx81QujSNXjpmeK0to8OFnmTi735c+lCJy1/ZZmXnrpsU
	 hXovnmuMVyK1R0xfpoG9m5f+1dq8kgPy+LTnLk57DTrpQixiLiE8r9k6mn8Arjrt3fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBvPXTiN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B176606A775;
	Wed, 18 Nov 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vBvPXTiN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6301F000CC;
	Wed, 18 Nov 2026 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022827;
	bh=BKMOVaRhWa4DPFqwUH8YRPGd2YK+xuLDCugmkQxwHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vBvPXTiNKROwi/GKtE/e4utXMAMhydGeOb+Ayq2JEBrcP2AABXlS/FL+ZK5QIRoWt
	 nHD/ncqZpQlNbKj9c2M+s/GItAUkpCufEK3SS9i7TiJzF1GNYiqqLmtaer4NMbtCiY
	 JDP37e+qiYOwB8UviXKA6tSExzZDNDISZPipGWBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0153/2151] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:31:28 +0100
Message-ID: <20261118150127.333126744@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
index 7aa71a9aa1bbc..16e9a258876ce 100644
--- a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
@@ -235,7 +235,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



