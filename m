Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905A312C462;
	Tue, 30 Apr 2024 11:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475174; cv=none; b=HKi/uygQvZzAQd6clUc+pAUb2dpy9HByvaTyTPYdO/jk/xcuxiaTkbnu7UnLDCMp3P8DMpea061SWHnxtiSRwUjWbIj129jAeJ75LTqoRFbXAD9RTiDBa/u12XJKdTGJlD/8aS5rZDoCK7ZZqBusbB8+SBEEey9LjRAl2fN64kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475174; c=relaxed/simple;
	bh=chwNbc1pAUAK3gfydl9hM5CFdvPt0X4HXZyGSYzVUFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cyPACTcRWE8NCLruNlH6ic7WvtwKrWifgpchmw2yWqayGgOGnvIrk0RuQOOyePlDuAwu3WGr73Mc//1OTN959b9LYvRqgFvNxfzX6aapkFDhZae3vTnHwI3ix+M/yxJBq9Nc8YLJmyXCsTxt9XqPaJQAvokXj81Cq49xjwQ3E84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JB1MLnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JB1MLnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF42C2BBFC;
	Tue, 30 Apr 2024 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475174;
	bh=chwNbc1pAUAK3gfydl9hM5CFdvPt0X4HXZyGSYzVUFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JB1MLnQ3b41s078puxWbq5EUvGRcXYyiWxGy2PwOE7mjwo0jtu5jD1SuVoVgRuGh
	 zTbpXi+jmNWveaEjkKtY7Z571ZpDHcmWeXUzlC9jKORWZQyv17gU2nI+2r6kr2Tox7
	 pbOSB7heUlSGzGdCBejMg6edJ369eekd1Cne5tyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/186] arm64: dts: mediatek: cherry: Describe CPU supplies
Date: Tue, 30 Apr 2024 12:37:49 +0200
Message-ID: <20240430103058.521014360@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d721ddb230747..663c9f414b611 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -251,6 +251,38 @@
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



