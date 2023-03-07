Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5749FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8730C433D2;
	Tue,  7 Mar 2023 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208895;
	bh=86Pikb5QcrLgoUu9bYwn8ZItJT+ml1APxLETUjmsuWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjaR1AkZZPUST0djhIHP4LkpVhmka07T25HpeGd/4Lh2H4Q97j+R0lFyhVTprPe6X
	 ORW1+NTDMYstKYzD0jBLXNmAVWtinMo4GvMpdOs3jSM8Vz8/tBQ+uyz6Wj+XxFcVvf
	 bqcGXSgnNapIVAfBwyOPM7TymG4EzaU6ySfI+uuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Bocharov <adeep@lexina.in>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0044/1001] arm64: dts: meson-gxl: jethub-j80: Fix Bluetooth MAC node name
Date: Tue,  7 Mar 2023 17:46:56 +0100
Message-Id: <20230307170024.031109806@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit cb199de1d3aecb02556d8a6e26393015effa0a9f ]

Node names should use hyphens instead of underscores to not cause
warnings.

Fixes: abfaae24ecf3 ("arm64: dts: meson-gxl: add support for JetHub H1")
Suggested-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-3-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
index 270483e007bc8..bb7412070cb26 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
@@ -86,7 +86,7 @@ sdio_pwrseq: sdio-pwrseq {
 };
 
 &efuse {
-	bt_mac: bt_mac@6 {
+	bt_mac: bt-mac@6 {
 		reg = <0x6 0x6>;
 	};
 
-- 
2.39.2



