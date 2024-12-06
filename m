Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8545D14A4D1;
	Fri,  6 Dec 2024 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496094; cv=none; b=m4rqgoqnWqt+On8YLRvfdB5az79Rh1uTkDsZTlWuupXCgWwsSHvcnpu9dpenOFHIS9Eol6DZ9QHsPXC6RIuDOw38V5PNpbwLwwz6RBySfRpBr/Pcg8EyOhZ/kZrFdlBrbqZOwDdqO2jY1RbHH6yNeKrUtH7QftAjz3C31PUA8cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496094; c=relaxed/simple;
	bh=2pSm0EhsT7xAkDxwl8/ETIgul7gKxTkg1DXS/gCsw7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxwgBpp0n2VW8KVJApW1XxdhlN04yqbQAxb8dXvAcGAB+YnF4Fy9dWyzeaMR/U/FVR7ZDpZyhQqJ4xPiNbplIwWvsznEcA3+NGqSqK2FaZi6jkEDZJEDvkQz+a5Vj5FdBFLVvkxC68qneHB5ecraoe3yr/wgHmmbk/yFMiyoYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=af5r6nG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="af5r6nG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F46C4CED1;
	Fri,  6 Dec 2024 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496094;
	bh=2pSm0EhsT7xAkDxwl8/ETIgul7gKxTkg1DXS/gCsw7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=af5r6nG0a5qSiLy+Qkg4EWUroreJvmFF9KoJCOJlwmzF0zeKPBxdcRH78mQPw+TX8
	 5eEDK9SwWr34aIu8nV02rscoyliST6Ezv7Yx5V9cJLKCOa/Fj0+jXVbUMf6wzU1WqH
	 nCrvx46+KTfNOiByniGF6TQJL377cwKMkVLJZNx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.12 018/146] arm64: dts: mediatek: mt8186-corsola: Fix IT6505 reset line polarity
Date: Fri,  6 Dec 2024 15:35:49 +0100
Message-ID: <20241206143528.369239003@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit fbcc95fceb6d179dd150df2dc613dfd9b013052c upstream.

The reset line of the IT6505 bridge chip is active low, not active high.
It was incorrectly inverted in the device tree as the implementation at
the time incorrectly inverted the polarity in its driver, due to a prior
device having an inline inverting level shifter.

Fix the polarity now while the external display pipeline is incomplete,
thereby avoiding any impact to running systems.

A matching fix for the driver should be included if this change is
backported.

Fixes: 8855d01fb81f ("arm64: dts: mediatek: Add MT8186 Krabby platform based Tentacruel / Tentacool")
Cc: stable@vger.kernel.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241029100226.660263-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
@@ -423,7 +423,7 @@
 		#sound-dai-cells = <0>;
 		ovdd-supply = <&mt6366_vsim2_reg>;
 		pwr18-supply = <&pp1800_dpbrdg_dx>;
-		reset-gpios = <&pio 177 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&pio 177 GPIO_ACTIVE_LOW>;
 
 		ports {
 			#address-cells = <1>;


