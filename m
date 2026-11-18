Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033926;
	b=hvAP7t8KvLrvYkybngHLsor5WqcFhb9O7gjfLDETKxR+WLoIMfYVuDxl3SJbzQPv1aoR
	 5xfb9ZeHynjY5rjEd7tZK3fNrd/ShrykYrXs84HyHeJwHsjC3rQLNfmUiCDtPq1+9h22S
	 Ek86Vv6J7bL2YCQ4SArIF67U1E3H61ExVHZ8WnV1SXHa+vyvCY4WrG6fuoczNT+5Aq6cN
	 KTYFJCR2sxEiAlGzj87VFtxkBAGd1RXuC7GG6LZfr3wxnPY9zdlJl1SYMs1OMv1gVJMex
	 s1C2GRi/fER9SAF9LoFQpmmtWjTFejskLzXEixFjebj8SByvZGDv6BpW8UZBe27Kygg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3hygDRSjEnQWrvMTsVAHuMuQSSACVnii7lJOwz1xQ18=;
	b=L0XXu7yswtd2FRa4RQ+CxDOxwpWmuLjZzoyRPXe9z1vtNiSWi6FhiuzmGWebZr+02l7p
	 toG0ijgkS+2IzE7MRnNMs10++7QeEHIbAs3oRyJB867pkvK23UjTTRDfMZdT0XK88K3LC
	 4sG1utSK+HkTEdgulng8fdEMIbTSTUJho36PPSEsq5apLOlnRzHCB53kmO+SdepuZE5Eg
	 zCJxbapVkpV2ttvQ61NPWJf/ggmNkVNbjmqXjhrSvHMkiajERWYCy0ascvN4BOl1j2Iz7
	 dp0IDaVNqhExv1dBjtiFeM/MH5AV4UjQxcLlWmUyISkx6f2UxbKMJMIQ0zbQUngt+UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pblQYSPT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B132606A31C;
	Wed, 18 Nov 2026 20:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pblQYSPT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6ED1F000C4;
	Wed, 18 Nov 2026 20:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033926;
	bh=3hygDRSjEnQWrvMTsVAHuMuQSSACVnii7lJOwz1xQ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pblQYSPTSnXFe/8X9m/LMgFZB/QzpLGVoDKWQIMV8R38kZHd2BB/ncVdzqzsH+eMx
	 +hINYCkOPFwJ93xuqYnMrmVZcmUkWsCJOmHK8ko5si16piHeAfPN7sJYIiEnF8xauK
	 RxKWlPI7olmbOsePAyszE6r0q5KIYd3ksLiCZP1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0161/3318] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Wed, 18 Nov 2026 15:13:03 +0100
Message-ID: <20261118150319.408793872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 213604d46bbd3..6a565c12f9b01 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4388,6 +4388,9 @@ static const struct of_device_id platform_of_match[] = {
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



