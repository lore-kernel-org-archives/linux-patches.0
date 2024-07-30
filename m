Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259D18C931;
	Tue, 30 Jul 2024 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356084; cv=none; b=XHJxSip+uBeiQU4RFM0Xf6jjd/2EDz2RnjRRlwCQ5yFgLZ7j4SfWaVsSWtzo3VAVrw7JUQ6BR8qDPjMRHRTHAABmGlSJl5DyeryGYOmAafYdjs20JfrpODHCQgSENePGpjXCdqCjOhpxY/1QxSK/wJRt+sSODL8XUVpNOVVUIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356084; c=relaxed/simple;
	bh=21r5Ns4TmXC67ZXSH8mNWuXRKkYtR4Tk8qrepMET1/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7Xm0mzxpxKA6GrnoDbRdxTZme1Xk117mXFQkKzDf3t0A3x0Z9XBC1ZuUTpSBlLjag8H/dnJo7SMZbms1TRI/2oNSnDlYzuPs08fRBPTu0hAogabo8TT/1nwbVf2dG2WiMY0kuCfdqmdS/qgUHKMMiyJP9xAEFDriloKa24WqAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQXZuKOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQXZuKOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9906C32782;
	Tue, 30 Jul 2024 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356084;
	bh=21r5Ns4TmXC67ZXSH8mNWuXRKkYtR4Tk8qrepMET1/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQXZuKOqTzX1Tj2W13ER81882AGE59TbXlnipWIdOhDkxk1Nm6nBapX8t5cJ2Jrip
	 ecqsRDvWbVPANBRWU5W4T5bmtB6wPj4/UEaK7DXR7EotxHyrZCp6tNnjOe20OCF+4r
	 FogcxW2PPe+ldDmPt3YOLffmLzgBJfQAwPAx41fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 115/809] arm64: dts: rockchip: Fix mic-in-differential usage on rk3568-evb1-v10
Date: Tue, 30 Jul 2024 17:39:51 +0200
Message-ID: <20240730151729.163785961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ec03073888ad23223ebb986e62583c20a9ed3c07 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb

  rk3568-evb1-v10.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

Make use of the correct property name.

Fixes: 3e4c629ca680 ("arm64: dts: rockchip: enable rk809 audio codec on the rk3568 evb1-v10")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-5-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
index 19f8fc369b130..8c3ab07d38079 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
@@ -475,7 +475,7 @@ regulator-state-mem {
 		};
 
 		codec {
-			mic-in-differential;
+			rockchip,mic-in-differential;
 		};
 	};
 };
-- 
2.43.0



