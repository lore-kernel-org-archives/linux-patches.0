Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031497;
	b=GJ5NEiOtKdIhp40SVXd2JZfeeiwZW4SiqcobXJPlrPTyFY67pqEyHlDvifuHfEklaJW7
	 LBLJGlo5ZveC3w80mCU2bgegLXo9FhJrBMK1ZzqfP64XLgtr7HHdE4AcUtECbAU7JMk2a
	 GoATvxoINTqaJ9DxKMPJ00nuuiSbSBgb0UHqNyzB1JnnLpnrUxB/1NijBPHVUbZ0L0nmm
	 8tgUz8O6MCu3+y5V/Cci74ehGHQQk/l10T3+heUSEaCEGPqnZB2XaycFDSy85ji6oQqjA
	 unoiK/Hcms80SjYazuO8EPZ/n7w0Im3qfhEutFfEJwuLJRT5eikR9GX6TpOHC4kqRTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1G1cP6dRgJJhmQGoymgIzVhopW8YcIaBFKlXYgwwaKo=;
	b=yQai+ln3GOedC10FZqe8YtQ37Ud9eso7MhPAEZMzPb+yHbFsYzNGfWBDM8dx23pW69d6
	 +aO7dFVa/Dmc2uZD2FR0SZNrol6i+lNXx+kFhKwJfutgDBYCiOKk4K4bYgkI6Wp5VZqvq
	 KIjzbjWtF9MTRV7oZw53+kPHJ+DQeMhkXYNaS6/vf5Y0s6eHmj6Fbmq6FJQ5+CJGhxvt9
	 eBV14SqiqZvTgSOg/oVLLmhAiZR78eyjZS9R41RwEhOHqBoM/TkwC1ziRv+uUFXpis+wP
	 CLK4z8djDkaiX2blFp8ZuVr9O8f/ABBoPZQk5og0wjGFPR9oZOG6CPks5taWliHZ0zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EMoHnuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D10606A32F;
	Wed, 18 Nov 2026 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EMoHnuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E541F000CB;
	Wed, 18 Nov 2026 19:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031497;
	bh=1G1cP6dRgJJhmQGoymgIzVhopW8YcIaBFKlXYgwwaKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EMoHnuCgN0v+qKU9S4FFki8/p6JToW9dQ2N+EBK1bwSBikY3GpBjdt8lnf1jQbpn
	 XnjrKFt4dHPE2he6p04m2Z7BX5SyIpl6RdJesNVD1bGk9PLh4H6NTLh49/9Mx5FWg7
	 4DARisRj8rpnu8FITG0R384Ghmc+6zhIvRU+e9Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1080/1756] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150053.212534814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 36b0abe904ac9cbdce6161d9c7c0bcac963bb3fe ]

devm_gpiod_get_optional() may return an error pointer such as
-EPROBE_DEFER, but gab_probe() only checks for NULL. The error
pointer is then passed to gpiod_to_irq() and the original error,
including -EPROBE_DEFER, is lost.

Check the return value and propagate errors from the charged GPIO lookup.

Fixes: b0327ffb133f ("power: supply: generic-adc-battery: Use GPIO descriptors")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261009112429.33318-1-phucduc.bui@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 43b735d4d49c3..c7e5786dce59e 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -243,6 +243,9 @@ static int gab_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register delayed work\n");
 
 	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev, "charged", GPIOD_IN);
+	if (IS_ERR(adc_bat->charge_finished))
+		return dev_err_probe(&pdev->dev, PTR_ERR(adc_bat->charge_finished),
+				     "failed to get charged GPIO\n");
 	if (adc_bat->charge_finished) {
 		int irq;
 
-- 
2.53.0



