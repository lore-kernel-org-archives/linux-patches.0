Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8AD2ED168;
	Tue, 17 Jun 2025 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176761; cv=none; b=KAvdsaCKc8jwt/21S0cqhaG/x9Mh3e+QKAhiVC3a5hGnkMIHjKfStnhAh22Q08tDzGxnLUgMpS1wkwd5lz6E2vQuM6KDeQZDnOs0mVsqjJIk7u3n6RqtmGAsJJZiL3RJ/+kwgEnJ2wyLvXTVWqT0StXy+uGffIMGTRWMMIkETHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176761; c=relaxed/simple;
	bh=JugRCIzUUks3BiLCtA0T5nuII2ea97IK8RFpCbEtVCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjdJaPAnqb3C5OwC40bs34jHOoQEnBJVKZor5y/tZnlVUro+kNg1qu2/DE6LntWBnXTs4Ek+iVn4bM82ShYsOEiB+BM8vd6a4IUOOtURzK2eP8kFp08BNGUa+ZItq9lpdk6mM13/ABZiO0/nD+My1BLdIANVEb6HyjPRfOSv55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpTg4FLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpTg4FLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DCFC4CEE3;
	Tue, 17 Jun 2025 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176761;
	bh=JugRCIzUUks3BiLCtA0T5nuII2ea97IK8RFpCbEtVCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpTg4FLJOWO+K35aPKnPtQ7eW4OcqN74G436DD+ckOc55zKHrruksCPOP4g1IV7KK
	 vEaiFzJEUwYRUNp7u79QbfQ7RfkbXrCYKnshFlrcTv5mHoeFB7A+uc5AaIUdBdHaUu
	 YlU98Afq6dMIu23EcqXCUr01Kmn3O0gFcxiJxNqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/512] arm64: dts: mt6359: Rename RTC node to match binding expectations
Date: Tue, 17 Jun 2025 17:23:50 +0200
Message-ID: <20250617152430.289723871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Julien Massot <julien.massot@collabora.com>

[ Upstream commit cfe035d8662cfbd6edff9bd89c4b516bbb34c350 ]

Rename the node 'mt6359rtc' to 'rtc', as required by the binding.

Fix the following dtb-check error:

mediatek/mt8395-radxa-nio-12l.dtb: pmic: 'mt6359rtc' do not match
any of the regexes: 'pinctrl-[0-9]+'

Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
Signed-off-by: Julien Massot <julien.massot@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250514-mt8395-dtb-errors-v2-3-d67b9077c59a@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index 57af3e7899841..779d6dfb55c00 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -298,7 +298,7 @@
 			};
 		};
 
-		mt6359rtc: mt6359rtc {
+		mt6359rtc: rtc {
 			compatible = "mediatek,mt6358-rtc";
 		};
 	};
-- 
2.39.5



