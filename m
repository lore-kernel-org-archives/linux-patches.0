Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051205;
	b=xc6r4rNTFASbudgnsWNAhecSN1325l+y1mu9vHang17RhPdi4JoQ9dP/2vnz4TR20wJq
	 SVSnRXwAG02b0Zf7PyxAkRbKXjzzNrzRMJ7amenFX7Vxs4JOG6EpeOzETFJ7UU2Ok7iZT
	 TEjbk7VKFOUv8JhCYa0ll6zQt7p87Z88ICJGndTeQJNo70QNhmkasTBXEOzCq/223beXk
	 3l/p8wR1khnrnTnZvQ1NtEJD523puTFsOVxEdezjLePujU3kDgHnVEIiYlgLkmAxblGrw
	 qDEuq056NJlP4zvlehOC93p42Y8XihQD8bE1mO2b4M+joRlThd0yaYioD4m6EaWzZhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFUBfsYoPEg5Di/b9uOgxPLVo/ps2+3EOAQhwYL35zM=;
	b=Ee+TUafCZcD/t71mTvzt938X+lEjLadejFdXffmzlRXHDGbc2aLgwcABVIcOghnXii+E
	 9Kl+kSK7cgKkXdpK5cCvG0Y5jm0jGK6zIkZoDAiV5q4azAq0SP6J/cSBokxqGw3+d7cwU
	 5XWvLF4CodLaFICXr0N2Si7L92sKfbqE6KW0wrLD7JKlX32WPeIq8QpfZYdxLoT8VLXcY
	 EkFjqU9Nd0OT/J0/3XHF1FiJ61+/WxTtCX17JAIFWCzPa/Ipu2IxvfpC6v77U5d1IEDtp
	 z8bbxJry7e04gePRZYExXMbfZftFftYVGXaPKVuHUjhGTxLJjDoaj37G5faqaJats+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0kbuz8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E806E606A320;
	Thu, 19 Nov 2026 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0kbuz8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CFA1F000C4;
	Thu, 19 Nov 2026 01:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051204;
	bh=uFUBfsYoPEg5Di/b9uOgxPLVo/ps2+3EOAQhwYL35zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0kbuz8UOlrrntfOdYJCSUM4vK6NPny4vQT8k0wdIiB8g39qyNk/MqjxyqjYsTI3u
	 SAIEeamwFxL33VxL21KIogLNd4p3AKPgd7MatGyHj6XbCjL7mGCrsvnpDG9mgXNPp5
	 UEgKa+dqpyYZaDOXkHxW0O30j4dkvJQ7KL4xw25o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0124/2214] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Wed, 18 Nov 2026 15:30:00 +0100
Message-ID: <20261118150015.127907344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 754549f11a2ac..bd86d15bfeaea 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4775,6 +4775,9 @@ static const struct of_device_id platform_of_match[] = {
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



