Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41031BD9D0;
	Wed, 20 May 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295606; cv=none; b=MQ496XAooIRUwD9G9wBLUhrOpdDDLP555hH1+TaAExAE6vDFIyPamr+V6/odIMxyMzMAADuX5MjQDsDtc7gY1ygHE4OFh8Y2ksVq1ucm/rY8E7JQ372LJB+xF7qpYSVQMshJM2GrB+Uas41Sr+n9MTqxyCbzKVjhcS6a7pupTfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295606; c=relaxed/simple;
	bh=5aPgWBdx+41TFTrHl1LkTLCgqwsaigUleeIVrbnoGZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTEB4pvhGfFgYWF45qw3fHzDCsZudS6QHUtor+ydWaBtI/t9aXh5zgI93c5GveKZgURkSPY8fpK7hKQ/B3k29yNanpQNeS9TPxO8rJv85dEU62UHwQKZ4PqUQu57YuqRi52eRwf/J0PeUcE7b3qiPFZeDBBUz3Fufa9dy0eymbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwONSuKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwONSuKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245481F000E9;
	Wed, 20 May 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295605;
	bh=i9X2Ph0fq31vIWGt9rALEq0oCoJzOzB+H3q2Bs/CXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwONSuKDE/FrPXqNnloFg+BViyj5dZOOPBhC2RzxFxqwP+RUNHmmA2EQ0IhrLKSvS
	 WLQFLd0hFkLdI/fLnmo8EnHvABjnPrJqPbznJDc5YnKhPqBmEf0jio096+88hRcTS+
	 XsYF7VbFU9E681qEp8PhqniQPl56NBoWPu9MrX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0484/1146] arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:12:14 +0200
Message-ID: <20260520162159.144838028@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit c4c4823c8a5baa10b8100b01f49d7c3f4a871689 ]

The gpio-ranges in the MT6795 pinctrl node were incorrectly defined,
therefore, GPIO196 cannot be used.
Correct the range count to match the driver.

Fixes: b888886a4536 ("arm64: dts: mediatek: mt6795: Add pinctrl controller node")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6795.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6795.dtsi b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
index ae2aaa51c9ad2..134cfa77e3b1f 100644
--- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
@@ -371,7 +371,7 @@ pio: pinctrl@10005000 {
 				     <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&pio 0 0 196>;
+			gpio-ranges = <&pio 0 0 197>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
 		};
-- 
2.53.0



