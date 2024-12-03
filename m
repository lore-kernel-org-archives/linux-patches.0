Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2843A1EF0BC;
	Tue,  3 Dec 2024 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238149; cv=none; b=ctRiAMIR48PoC8eF4ZAmNrPrvF5tuKyAaYBI2E7dpBzGbf29gGFyyc7eX3Es7dm6V37vTpP2FXlhqSC5/HKMIo1iCzfJZKRhg+OWQtTLa32EEAl65FS7o0bQwBNuaasBFQZF9mI2SEJR7ku0HsbWSkl8AtcqS6Y68TTUTQVXdPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238149; c=relaxed/simple;
	bh=PITzQXXdfMf/BFuG6qYRay6vcpV6t9/W/TENzHESnGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7PLlq8BQFhlp8dAtbS5kN9viu+9u0P8uCMXDGqXrSO6Ol1W6ZvkuGNijikgmunhrKdQR+fo0zpeGqJNFqQr7IcAGX0bG1iLqKFf09aBHIaGUkrsM3FZ1knwMyAnDUN6XjMaQnMo5hF/dIkRCVfYv9mKdDUUQELwXDzJizJDmuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gdwwsh/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gdwwsh/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2539C4CECF;
	Tue,  3 Dec 2024 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238149;
	bh=PITzQXXdfMf/BFuG6qYRay6vcpV6t9/W/TENzHESnGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdwwsh/Up9Liil41R7C7OUG6Dhw0igMg9AkwTxk1iqiz7Xueon8ke/7tPxqFRZEa2
	 +P+hyRwYZX9xC/F1rQhM3eFES8rkURrdRmtBOM4R07UGMG3Lw22eobYnSWEURdHR0j
	 H+d23N77cYSQ3KciP8WnV7GO9GVTaDusuFNhKLgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 179/817] arm64: dts: mt8183: cozmo: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:35:51 +0100
Message-ID: <20241203144002.716624585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit bd0eb3b1f7aee698b86513edf10a50e2d0c7cb14 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 52e84f233459 ("arm64: dts: mt8183: Add kukui-jacuzzi-cozmo board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-3-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
index f34964afe39b5..83bbcfe620835 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
@@ -18,6 +18,8 @@ &i2c_tunnel {
 };
 
 &i2c2 {
+	i2c-scl-internal-delay-ns = <25000>;
+
 	trackpad@2c {
 		compatible = "hid-over-i2c";
 		reg = <0x2c>;
-- 
2.43.0



