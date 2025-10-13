Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055AF3101B7;
	Mon, 13 Oct 2025 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368979; cv=none; b=dnDJ8URTq3o/e8qFBzv66L1FpW/Mkb6d0/HaMWJZtgpZzGupJ+JOEux27Eq9rXsTngmd0YLNXAzH+g1XwWF4W0y7pHLCO7xZKMQE2LvSA9SO1fZ3fABMcOQNo6OpxhtU7/VO+sCY4Max+gyE6NY11tUP5d9jF64zdVNGHCu2hds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368979; c=relaxed/simple;
	bh=sbE5CZnwLA7iYWxyY2w0Vbg27mIiiFgm+iWMwH1/64Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpyw2fL4uKShLOC8FGoRhbsP7Ma3jkQ1ZNPVVC7TS2uSFycIjpHvPWas64MZk4cYuDkS4pBb1dXy1lxoRyHDROomWgtxu3FUOiI21VS7ifaK6P5+Jlxy/RIRGB8Id6QZoHAm/f3ekrRvlDDM0chlQfNWo0GwUK7O0n9cavYmfLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKi953Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKi953Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90EC4CEE7;
	Mon, 13 Oct 2025 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368978;
	bh=sbE5CZnwLA7iYWxyY2w0Vbg27mIiiFgm+iWMwH1/64Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKi953JxA6hVdjL99NsvLv+yf2gDYdyXINKRrmnCaA1tJxrf9oxayJHYuCnQoB4WZ
	 H/rV5dQOJTlZSH3vAzxMqiSWbTC3ovVeyJjdfCyd5vRfTgQZCR2RISAOqqsaYLkggz
	 QOMVcuVYh1DTOEVUVKNVSTZhMYpxzVmqXo/7Otj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/563] ARM: dts: stm32: stm32mp151c-plyaqm: Use correct dai-format property
Date: Mon, 13 Oct 2025 16:39:05 +0200
Message-ID: <20251013144414.340657368@linuxfoundation.org>
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

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 0b367e60c73c05721cf2156fe8fe077320115ffd ]

The stm32-i2s binding inherits from the standard audio-graph-port
schema for its 'port' subnode, audio-graph-port requires the use
of the 'dai-format' property. The stm32mp151c-plyaqm dts file was
using the non-standard name 'format'.

Correct the property name to 'dai-format' to fix the dtbs_check
validation error.

Fixes: 9365fa46be358 ("ARM: dts: stm32: Add Plymovent AQM devicetree")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250830225115.303663-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts b/arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts
index 39a3211c61337..55fe916740d7c 100644
--- a/arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts
+++ b/arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts
@@ -239,7 +239,7 @@ &i2s1 {
 
 	i2s1_port: port {
 		i2s1_endpoint: endpoint {
-			format = "i2s";
+			dai-format = "i2s";
 			mclk-fs = <256>;
 			remote-endpoint = <&codec_endpoint>;
 		};
-- 
2.51.0



