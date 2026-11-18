Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057372;
	b=Iwbnvs7EMt4xYWD2YxqTaA+62E0jqrqaLg7KXLYhptwV1HQQAWGCdSyRSjbEocX0NHLD
	 Yy1WQHPBOOQlMfKGWjzaHtUBUInfG+cLUawhVgGZyuo5J4XWn7IaZ5hOrTvslNrfZ5kco
	 x+HHB0kJNa/I6Sl1msYAN/MGAZM4S0LGOUL3Z1poi9pK7gtR/G+7UvSN4y82FRPcYhEjm
	 wBU0T22B+k0WBSuSeE5V1sBosKajYKJPUcMuB5sjykTkKp0FAHtpDoB0GqEJ+5s9+JMkX
	 +RLdok0OzX1oRzyUPuCcXJhKc7WzG01eG+h2mGNzSWfTlvu56TmN5Q81PmdMiGnC+DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9JqmJ9ZBe7wuwAr766dnAqIjs4ZBf67zkRpp1E7nFs=;
	b=nqDH/3nu85zyLTkHy7gzj/5IHjM6CgS3Y+FAcFDPPVaXltMIuzOqRywIRwpTk6yH1zSK
	 P+13iFtvF5SlV3PlJMe3htTlFIiFhVrsYwTOJkn9Tq52zoLmtIiSzrmBDISu5sA06TR68
	 5J7kmx71gmJO1qwK8EYp/PR/Mt0Vm5fYsz+NiDwr8EPTjUFwpYtHbaCvkdsnI2FhdUqDp
	 bj/LQQsa2XHVROxX8WBCaYpY9WXbXp57QgCw/pPW9lkded1fSd9nUYVf2MHrFKzgCqYgL
	 CRsGedjTkBDC0Dnj5U/i87aZuuLLQdDCjzpnU1lfByrhlzx2U+T6SCuqNOsgsYsxwAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXCpP1ey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416A60A2603;
	Thu, 19 Nov 2026 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXCpP1ey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CC11F000C4;
	Thu, 19 Nov 2026 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057371;
	bh=L9JqmJ9ZBe7wuwAr766dnAqIjs4ZBf67zkRpp1E7nFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXCpP1eyf+annCkPc2nvv2/qRIqz6lmkE/4i0brhl2foepcEjSg59nZImpSAboOLa
	 ptMdqNGP55gxFMQuakUATiMMYt1fiixzJac9T3FXUOhwupvnGK4v/XBfCOqMMYZetd
	 6xq51Jry6BlH8geg+R4T8f+3Nh6TnDfvT3+SNzdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0108/1848] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118145915.560574226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0c18c0cc701c4..43c74d9ed54c0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4162,6 +4162,9 @@ static const struct of_device_id platform_of_match[] = {
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



