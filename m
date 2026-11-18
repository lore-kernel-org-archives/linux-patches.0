Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043242;
	b=QUMvn7Chb7HIkDbAygmoFM8nmzEjDT1FjJgzarwJoQ3Y2gUcRj1mH0Fka6p9AMzxc4Xv
	 odgz/GeGZUziQW0X/E4ICfg0sU/6A626ZTpcyba9y0NOkYyMLtHTJ0abY0gquC3uryHXv
	 TIQ+QgGqG5rdTfpYTghkdHlGQYCte/a1ogbJj/Rgtw9VIxocPBlZUPXUzfqmgTRLJ58nm
	 rcXkWX0P0EiZp+mLyjD2hlMJPyemaVEq6zeiWI0EAqOr5qjGMUwS+J/YKwkU9XlAHDV+y
	 /2kFyLX1+jYj6g800bVquw37VYTXCN2bRmoL2KW7vjYZHmROywAaX+1YFkBAYDhmgqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eOlk3RP4ScEB0lpMg7k185XKVarXFaI3jI5+Ej5zHN4=;
	b=a8ZmE2Kzxg9JmUOSrQn4qhY0PsdSH0JedulnccbsyXVrX6ujoU2e8gYjnFUxV1BAC7K/
	 CavlUVFeO+JDI1G2GmL9qFCgV826FZJpc+Jta7UA5U8GdzROxZmQ+sJHadVCYmo4L2p04
	 185xxdAQ0/1WNqw70D8aWe6D88YMa2afmVNVdS72mFaUxpk8Pd44JeO4MvPPmKgbt6YnI
	 wvQla5WajGlKpRX4YatQKUxW5fGdEjR15qqYbOPPj+krHaptkme37ClHCScRAaYCg2fnT
	 3IRLcFe2NloH8NYiGwBJgwOIUoQC1tcvjjfry+lpbDUoegDXaKcAgKEENex5Dy9N3vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AL2n+hfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78699606A32A;
	Wed, 18 Nov 2026 23:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AL2n+hfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD711F000C4;
	Wed, 18 Nov 2026 23:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043242;
	bh=eOlk3RP4ScEB0lpMg7k185XKVarXFaI3jI5+Ej5zHN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AL2n+hfSB2pzglGPw8rL0OqSzJPaAzJWTwhJd40Zbzea8Ea8jNsr9Vg4OCnyWwYY4
	 nyYq2tlGz6GMu8nde56oFT7Gpa2DpKOsBnnxKwe22/YNoMFUb9hvH2y9FjVsDSKKpr
	 USiOFyyPqwCa3GzyPXnD/c+YnybEako8jztvkKMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0140/2857] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Wed, 18 Nov 2026 15:19:34 +0100
Message-ID: <20261118150206.394314739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Schocher <hs@nabladev.com>

[ Upstream commit 900517da69afca6f72dacf14278aee3b65275507 ]

Commit 922fb2db0287 ("dt-bindings: display: simple: Add Kyocera
tcg070wvlq panel") added the compatible string for the Kyocera
tcg070wvlq panel to the devicetree bindings documentation
(panel-simple.yaml), but the corresponding entry was not added
to the panel-simple driver.

Add the missing compatible entry to the driver.

Signed-off-by: Heiko Schocher <hs@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260721041935.757240-1-hs@nabladev.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index f7787d6c97fe3..ccc3ac8000114 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4194,6 +4194,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "koe,tx31d200vm0baa",
 		.data = &koe_tx31d200vm0baa,
+	}, {
+		.compatible = "kyo,tcg070wvlq",
+		.data = &lg_lb070wv8,
 	}, {
 		.compatible = "kyo,tcg121xglp",
 		.data = &kyo_tcg121xglp,
-- 
2.53.0



