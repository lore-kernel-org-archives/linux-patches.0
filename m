Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC186CDC9;
	Tue, 14 May 2024 11:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685498; cv=none; b=bMnWmTUBukJcAHmTygDW67Pa+7QyagFbIymRO0Kv7hHq4Jn+48oU7aShnm5VWw4vrPcE7IOJVBtlSr+2tIxHNWi1Ra6K0jdThCJmpzeCvi1yTNEB5wFBgFW3Zitc2kQkwecN3nRWb+yYzJO9+t1dddFXHhfNXocfOysqAUE1aHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685498; c=relaxed/simple;
	bh=8I4AOGxVHqbcbPHUbBPV414UME6DIk7NbO1cp5NLUWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY3jzvwKCj2FhcCF1mHxOFVkZrRnfTLAFe2Nxt5S99hHrsPA7/XZ4wOh03osUsnOIaig5NzZ2Kkn5MPoy+hkeoAvlUnVx3BxC4yU5w3PdS7/WwvhiUzHOxenJiLEwpClfKkxJY3Wz9TFPUrIycjRb++6EIRY9DjoNiHm3xw2FzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En6Li6Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En6Li6Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3371C2BD10;
	Tue, 14 May 2024 11:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685498;
	bh=8I4AOGxVHqbcbPHUbBPV414UME6DIk7NbO1cp5NLUWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=En6Li6Fm8dXD5AhLcHJq3DFayXPwpN8b/BiQ0ideLHU4wy9nS4UfWYPmsloxOu/ZW
	 uTiAFiVcoEG2insgD3AmffPJ37oJR8jLxrClx046YfjRTLHiZSm29ckQizZcOGNNXT
	 DgDnDnj5fXEkAqxi/XQdWHfIXka7M4BsRkcOHbpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/301] gpio: lpc32xx: fix module autoloading
Date: Tue, 14 May 2024 12:17:18 +0200
Message-ID: <20240514101038.561703836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 11baa36d317321f5d54059f07d243c5a1dbbfbb2 ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-lpc32xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 5ef8af8249806..c097e310c9e84 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -529,6 +529,7 @@ static const struct of_device_id lpc32xx_gpio_of_match[] = {
 	{ .compatible = "nxp,lpc3220-gpio", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, lpc32xx_gpio_of_match);
 
 static struct platform_driver lpc32xx_gpio_driver = {
 	.driver		= {
-- 
2.43.0



