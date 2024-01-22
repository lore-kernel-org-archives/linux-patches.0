Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE5E15445E;
	Tue, 23 Jan 2024 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969390; cv=none; b=ojGx7Hsy1LPOy3A0OkTvs1bGJ36ZnCxAwGiDKI/h6Hvni/JK2wBiDNUBgiHdJ2NkIvD6aHvtTwLA0Nk2wCSsIj988rrkY9NzpPc/ugwSUjhGsXh8cvWw53w/Rlf9OdYgdYGpbMN8oF6CPOgJWWUAcnCQV11a01gL4qvZy11G6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969390; c=relaxed/simple;
	bh=MgtB7bihR3OiTkIbUgwRHPvuHw5WEyfquR9zLkoyGHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btZyddTu1/ustUHTOue2Nmpkx7FnXeokMLCQbNQ7CHviuU8+MhwMAsVqfIIjdztvB7Vdgz/xmgtGtHWxLGzZm+IcODMljD+HvKWksDEyIbTTKp1/MdqwAzD5TGb77UlEYstoEwktP+PioACwl3G8z4mnyNf2YiJtxapoy8zKAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEzCH+Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEzCH+Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357F7C433F1;
	Tue, 23 Jan 2024 00:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969390;
	bh=MgtB7bihR3OiTkIbUgwRHPvuHw5WEyfquR9zLkoyGHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEzCH+CsIpMcF7E4swszI055/LsU1o57mo9cNE5EZnfpVP3pvQZt3rOTSJNAFsI0J
	 HuC3tTl4Et23IQP8AlP2FXci14ZbzujHjuS03K0yAVpOsOadtpV15NoeWY6s8DXmQ4
	 3iPYqH9csrfl63jr393vLk04wkbL0sKXZ644DGmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 191/641] arm64: dts: qcom: acer-aspire1: Correct audio codec definition
Date: Mon, 22 Jan 2024 15:51:35 -0800
Message-ID: <20240122235823.950725409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit feec9f0add432a867f23e29afcd2f7088889b8e2 ]

When initially added, a mistake was made in the definition of the codec.

Despite the fact that the DMIC line is connected on the side of the
codec chip, and relevant passive components, including 0-ohm resistors
connecting the dmics, are present, the dmic line is still cut in
another place on the board, which was overlooked.

Correct this by replacing the dmic configuration with a comment
describing this hardware detail.

While at it, also add missing regulators definitions. This is not a
functional change as all the relevant regulators were already added via
the other rail supplies.

Fixes: 4a9f8f8f2ada ("arm64: dts: qcom: Add Acer Aspire 1")
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Link: https://lore.kernel.org/r/20231205-aspire1-sound-v2-2-443b7ac0a06f@trvn.ru
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sc7180-acer-aspire1.dts | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts b/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
index dbb48934d499..3342cb048038 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
@@ -209,9 +209,22 @@ alc5682: codec@1a {
 		AVDD-supply = <&vreg_l15a_1p8>;
 		MICVDD-supply = <&reg_codec_3p3>;
 		VBAT-supply = <&reg_codec_3p3>;
+		DBVDD-supply = <&vreg_l15a_1p8>;
+		LDO1-IN-supply = <&vreg_l15a_1p8>;
+
+		/*
+		 * NOTE: The board has a path from this codec to the
+		 * DMIC microphones in the lid, however some of the option
+		 * resistors are absent and the microphones are connected
+		 * to the SoC instead.
+		 *
+		 * If the resistors were to be changed by the user to
+		 * connect the codec, the following could be used:
+		 *
+		 * realtek,dmic1-data-pin = <1>;
+		 * realtek,dmic1-clk-pin = <1>;
+		 */
 
-		realtek,dmic1-data-pin = <1>;
-		realtek,dmic1-clk-pin = <1>;
 		realtek,jd-src = <1>;
 	};
 };
-- 
2.43.0



