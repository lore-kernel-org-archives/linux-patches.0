Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829662;
	b=VOeyGgUcjPICl8dE8aIE04aDiVhj21qc7YDbDU3gR2s/Ya5xgbU70uBFqzvtCuqyb7g7
	 sKfqckCnvSUgxfUAQge1obLO0StOtLoig7R2O/K01357YWseqyWCrnJrbIxuPvnS72TaC
	 q8UsDXuTH6jjDrOmLAOOA1Ix+RJCuQ3Vm2lvudf1dVVvdjkTPebKjnq8i5GO9Ti29LtJ8
	 AJ0mV9Ul2pAH7OAHQYKIWUA8kKaHiaanbZnbXDiRW86AlKazogXhKY4aSypkU77jRJUFu
	 yhjETQWcmVPJOncn1Pp1Axas/DtoQOg9BErL1zn3VRcApKz/By4LBGcr737afPG4eAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLjX7PuNGAB7TlZv8qXzKbCNDOK0igHh3EyjZ1s6wCw=;
	b=5JMj6LXwTnkpM+vyanClLJxFvDbzE3jHa2UVFN2TBHZzkyWTVtNOFh7jg4ENVwl21t6a
	 LEQaVmOqv5b5Awguw72LpBwfIDbz58y61A9lWBgWWsW+GDst+X1UiDK6RQpSlXYB3HOpI
	 BRXaMUu6xUCdD6FV62Vnf1KyIJVWSDCPhDmyxEXGGz1xAuPy5pHdFzbiB1mfyYtZILMc8
	 IzlI56A6KhrAzbIhCAhXFAECAEX35WMqJghh+Uzsz/+mWKnNV5Kc8sUtMUi34YoOdTZ58
	 /WlE8N4WggwX0TdYOLNQFKysGv/z+LAiJLnF5iXJgTaYdzAAJWjsp2Kg2IVbUvIqkrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQLZnpU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C438C606BA1D;
	Wed,  4 Nov 2026 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQLZnpU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D77C1F000C1;
	Wed,  4 Nov 2026 22:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829661;
	bh=CLjX7PuNGAB7TlZv8qXzKbCNDOK0igHh3EyjZ1s6wCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQLZnpU2BHcCJ7H7lUtA8wWIgWJ/ob2wqgzTChyZIsqEwh7V9by879cM8lJ1BApjl
	 sEh5fVwF6HH3yP7yPt/Btd91BVdsfmHiahCknXYSBW6KMpQwihMLFM0JS1kAR9YGhG
	 KMmmhVwAqei8NCaCNw3H0F+feJzqU45FJJPR5x8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0225/1005] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Wed,  4 Nov 2026 15:59:18 -0500
Message-ID: <20261104211050.126798687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 878a5dc7748fb..c784f67f58fa4 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -5245,6 +5245,9 @@ static const struct of_device_id platform_of_match[] = {
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



