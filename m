Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134352FFDF2;
	Tue, 12 Aug 2025 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024913; cv=none; b=gYD0/EWVuflrpJby1iq09UwW11+rBnsidboUwDXgxHfHPbhcdIJhkOJRSQVswvCGi8iVj7cBD98xX7F9doaETdKhiHfCkauxNPQ+W2Xk0Kj7IRoUqF+dhJi+wFR3XQUZpDBV2j54TYaAipOSztHa7rJl+ALZrrEuvX3ujsav8sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024913; c=relaxed/simple;
	bh=VrPz6nXzrBDv6dc32caCFHOEaUiX48gvyMfsaRpeTwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZZyQXLewi4JiXiYCQXJ9xj9B2+5lSazR82hJqXl6AaNyrnZ6ec9reVi34sGSohndz4f1sSUIY7oaZ8IFZMWUxKGH5Ibmq6GDekmhedh12heAsociSXoDxDv/cQXvTNbAO+SA2rREOxZlat/LmSQ6UcDVooSPMQidHBJn1LW5hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3o47xP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3o47xP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768A0C4CEF0;
	Tue, 12 Aug 2025 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024912;
	bh=VrPz6nXzrBDv6dc32caCFHOEaUiX48gvyMfsaRpeTwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3o47xP4TJO2NAxV+keU7pgDoDMkti0Ey28SSaRA2oTYnlhpXVis61l0W5MT9GX4R
	 y2Cmr31+N728cGZ4B5dmR/ZrYOfXPls21DIs7558bjLAC7Vd+/3ZgOB2evlk9bH5fq
	 hxxmGq4yn6hEm4JHWYLlKm6vnNAz4U3DT2yWhupc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 513/627] ARM: s3c/gpio: complete the conversion to new GPIO value setters
Date: Tue, 12 Aug 2025 19:33:28 +0200
Message-ID: <20250812173449.630846773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 3dca3d51b933beb3f35a60472ed2110d1bd7046a ]

Commit fb52f3226cab ("ARM: s3c/gpio: use new line value setter
callbacks") correctly changed the assignment of the callback but missed
the check one liner higher. Change it now too to using the recommended
callback as the legacy one is going away soon.

Fixes: fb52f3226cab ("ARM: s3c/gpio: use new line value setter callbacks")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-s3c/gpio-samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c/gpio-samsung.c b/arch/arm/mach-s3c/gpio-samsung.c
index 206a492fbaf5..3ee4ad969cc2 100644
--- a/arch/arm/mach-s3c/gpio-samsung.c
+++ b/arch/arm/mach-s3c/gpio-samsung.c
@@ -516,7 +516,7 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
 		gc->direction_input = samsung_gpiolib_2bit_input;
 	if (!gc->direction_output)
 		gc->direction_output = samsung_gpiolib_2bit_output;
-	if (!gc->set)
+	if (!gc->set_rv)
 		gc->set_rv = samsung_gpiolib_set;
 	if (!gc->get)
 		gc->get = samsung_gpiolib_get;
-- 
2.39.5



