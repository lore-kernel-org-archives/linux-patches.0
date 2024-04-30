Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C101292C8;
	Tue, 30 Apr 2024 10:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474051; cv=none; b=ML7MrgMUCzLPmQ/hIcEMaTu6YQXNPl/1Xt5WBBD68Jrp0YrTwtOUf8MgDD/VfIrY/mlhqyh8dUVtnGOuUO6yT+4nRtJ6oEisjqvYLaCwzYyExRJfKeJGGZEpT0v9XN2dNwrpKAuF/WtjrjHWfWwyP+b/y6DAlKrdXnK7kEl6/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474051; c=relaxed/simple;
	bh=S9NkVb6XVWbUcK4rWvnE4A4b8J1a5wo3sY5zKOgzjxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkusuM6OeQvPfXcJuCm54LbB16A7w4fXJ281VwL9thBwIu4g3c4Fyl9pzWzAyXNTLFpd05y/QBTdFEp0UdaZAuqdd4uckAjHq6M1H9yaPdc2RW0BUYdrvB7GvsuikljXT65H63UUsLsl7U/RqkXbHhOlKKEMILJSdlrVLEd3Po0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vR1QuNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vR1QuNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E81C2BBFC;
	Tue, 30 Apr 2024 10:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474050;
	bh=S9NkVb6XVWbUcK4rWvnE4A4b8J1a5wo3sY5zKOgzjxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vR1QuNEYiXpeZgZ+/WdPMn1lJdRk5LgZgh6xJ81RUOYYL2ofE/scsHV3I54R6DuD
	 EfHCVs0Fw1ASw1ryEZ94Lz2vBXDn9BN8Bd7VqcdAbUw9peGcCJA4Pvd/QikG6+Sbfk
	 zmrxnoHj9RNAhICXi9VIlSJD6iuXaIUOHYTy2eXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 017/228] arm64: dts: mediatek: cherry: Describe CPU supplies
Date: Tue, 30 Apr 2024 12:36:35 +0200
Message-ID: <20240430103104.312110978@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 17b33dd9e4a38fbaca87c68e532b52f9d0492ba7 ]

Describe in each CPU node the regulator supplying it.

Fixes: 260c04d425eb ("arm64: dts: mediatek: cherry: Enable MT6315 regulators on SPMI bus")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240110142305.755367-2-nfraprado@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/mediatek/mt8195-cherry.dtsi      | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 3c6079edda190..1f3a6755f1550 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -264,6 +264,38 @@
 	status = "okay";
 };
 
+&cpu0 {
+	cpu-supply = <&mt6359_vcore_buck_reg>;
+};
+
+&cpu1 {
+	cpu-supply = <&mt6359_vcore_buck_reg>;
+};
+
+&cpu2 {
+	cpu-supply = <&mt6359_vcore_buck_reg>;
+};
+
+&cpu3 {
+	cpu-supply = <&mt6359_vcore_buck_reg>;
+};
+
+&cpu4 {
+	cpu-supply = <&mt6315_6_vbuck1>;
+};
+
+&cpu5 {
+	cpu-supply = <&mt6315_6_vbuck1>;
+};
+
+&cpu6 {
+	cpu-supply = <&mt6315_6_vbuck1>;
+};
+
+&cpu7 {
+	cpu-supply = <&mt6315_6_vbuck1>;
+};
+
 &dp_intf0 {
 	status = "okay";
 
-- 
2.43.0



