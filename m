Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDD530CDA6;
	Mon, 13 Oct 2025 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368855; cv=none; b=ti/dY7Oc66t0Cn1jBOZ7QKlXPHb+0M91tqhFW07ciXYVpx7kEdu/gDJARc/YiE4LV+Pbgsy6T2dNvKr1lsn/1vc/GiatuQ3JdlbAI82RmgvXspMC2Te1P8dLyUN20C32u2sf079NhCu5SpqO1QQUOuZJAY6rMbchWccU9T1bZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368855; c=relaxed/simple;
	bh=rybxzKl8BT4pyilMUqlznvGy47J0zG1sSWjs2/J3wVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O01pGc0GH+wV96W1g4sCDvfkI117EgZqwwweQegfTnCPvk358BWKcFdsldVSAhkzhnWhhw74eEjo09KkJohnEZa2BnRKZQqvMVDanYeCLTM2Kelz5enoaxLZzXuuSYHHD+SGTmrrw2k+dFIlWKrYl4emz2q2GUJYSrUaHUYS2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0DjP2at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0DjP2at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EB5C4CEE7;
	Mon, 13 Oct 2025 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368855;
	bh=rybxzKl8BT4pyilMUqlznvGy47J0zG1sSWjs2/J3wVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0DjP2at9Zi3GE/pZ/AbgcJAg6t+fG9RWRF26NCfodafEqeW3Kxc2ZYj8cQURUPnH
	 LyBpEGD4lrrw6SUfv+EyGyqiWcNczhopd0JKPv9OW0POIJhRE9I24i9TW0nF0VatH7
	 j+iPG58pOwssRldfSelJTqzlNCSsdyTfs0HFsG/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 042/563] arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0
Date: Mon, 13 Oct 2025 16:38:23 +0200
Message-ID: <20251013144412.815544982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ae014fbc99c7f986ee785233e7a5336834e39af4 ]

On RZ/G2LC SMARC EVK, CAN-FD channel0 is not populated, and currently we
are deleting a wrong and nonexistent node.  Fixing the wrong node would
invoke a dtb warning message, as channel0 is a required property.
Disable CAN-FD channel0 instead of deleting the node.

Fixes: 46da632734a5 ("arm64: dts: renesas: rzg2lc-smarc: Enable CANFD channel 1")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250801121959.267424-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
index 345b779e4f601..f3d7eff0d2f2a 100644
--- a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
@@ -48,7 +48,10 @@ sound_card {
 #if (SW_SCIF_CAN || SW_RSPI_CAN)
 &canfd {
 	pinctrl-0 = <&can1_pins>;
-	/delete-node/ channel@0;
+
+	channel0 {
+		status = "disabled";
+	};
 };
 #else
 &canfd {
-- 
2.51.0



