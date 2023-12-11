Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602DFBE1;
	Mon, 11 Dec 2023 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYJQoyF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292FCC433C7;
	Mon, 11 Dec 2023 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319654;
	bh=6DeiBfL0m1iYpjFXqr5hseMYsnGkBu5sI48oS4ZI950=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYJQoyF6BZgk86J95lQ+FW/ofJkWc5YEsQnglkevmQMib5Hvz50vdSw5bNCHV59cH
	 CzxYdpbW+YmXAjR2v0ckae05x94mpmfRAEZrcXwldZy641h/oxvIyEWMNgX/kaEkIM
	 7j5BDJt8YuuzKUTwKPsfTFfyOfW9YXzjL0f3lb7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 186/244] arm64: dts: mediatek: mt8183-evb: Fix unit_address_vs_reg warning on ntc
Date: Mon, 11 Dec 2023 19:21:19 +0100
Message-ID: <20231211182054.280482361@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 9dea1c724fc36643e83216c1f5a26613412150db upstream.

The NTC is defined as ntc@0 but it doesn't need any address at all.
Fix the unit_address_vs_reg warning by dropping the unit address: since
the node name has to be generic also fully rename it from ntc@0 to
thermal-sensor.

Cc: stable@vger.kernel.org
Fixes: ff9ea5c62279 ("arm64: dts: mediatek: mt8183-evb: Add node for thermistor")
Link: https://lore.kernel.org/r/20231025093816.44327-7-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-evb.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
@@ -38,7 +38,7 @@
 		};
 	};
 
-	ntc@0 {
+	thermal-sensor {
 		compatible = "murata,ncp03wf104";
 		pullup-uv = <1800000>;
 		pullup-ohm = <390000>;


