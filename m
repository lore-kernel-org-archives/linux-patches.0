Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120E1F3B96;
	Mon, 23 Jun 2025 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713840; cv=none; b=SybuvYk1ggygPYHneAgRV2xhmmMW4HCtRtGhjWQDmGY6I4FhBOzbVcmot7nD9ofHMcUt26b+YfwHFYCyEX5OCy7OVNTrsGgw7k1UDzWAfiRGbErAZinyVCmuzgYkzD5tgD2mam664lMc8PrX3AR74fks4Xq9Vmxl0tAzlwclWGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713840; c=relaxed/simple;
	bh=VqP8LMVEMUYQkJCvGXXv0N7gJpByhJ9XGy8YPAEvXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNDLlaTsO9oKzq3ylsoXsvdR8gVAyCTTSxuRIXGAo+DDIa3FEs/KuhqWlNMgHNHqC7q3Dg5za1MiuaRXCfIYuq4jPCzt/zveCJ0KhjqRvS4sPRh/b5I0BgnUtqQV57AXexxgxc1HeprxvoMRwguIKKNXgGC2G5GHJITVQVK0lJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gt3fAZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gt3fAZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE207C4CEEA;
	Mon, 23 Jun 2025 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713840;
	bh=VqP8LMVEMUYQkJCvGXXv0N7gJpByhJ9XGy8YPAEvXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gt3fAZ3nAclQgj08i0tPNiuYeVu0YNYHcX95EiwJuDf3I0i2onZ59V2LIXzN7wYW
	 4ukPbWXcgaEGyx3YuWscIJOWF3B07y56/E143athxr/Ygi09IT9QrxzdVtPuKfJy7t
	 0bvXb5hQDgk9cTAgwJQ2GZw4IB7oPvPLCIkMMO9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 086/414] bus: firewall: Fix missing static inline annotations for stubs
Date: Mon, 23 Jun 2025 15:03:43 +0200
Message-ID: <20250623130644.235029942@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 66db876162155c1cec87359cd78c62aaafde9257 upstream.

Stubs in the header file for !CONFIG_STM32_FIREWALL case should be both
static and inline, because they do not come with earlier declaration and
should be inlined in every unit including the header.

Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: stable@vger.kernel.org
Fixes: 5c9668cfc6d7 ("firewall: introduce stm32_firewall framework")
Link: https://lore.kernel.org/r/20250507092121.95121-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bus/stm32_firewall_device.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/bus/stm32_firewall_device.h
+++ b/include/linux/bus/stm32_firewall_device.h
@@ -114,27 +114,30 @@ void stm32_firewall_release_access_by_id
 
 #else /* CONFIG_STM32_FIREWALL */
 
-int stm32_firewall_get_firewall(struct device_node *np, struct stm32_firewall *firewall,
-				unsigned int nb_firewall)
+static inline int stm32_firewall_get_firewall(struct device_node *np,
+					      struct stm32_firewall *firewall,
+					      unsigned int nb_firewall)
 {
 	return -ENODEV;
 }
 
-int stm32_firewall_grant_access(struct stm32_firewall *firewall)
+static inline int stm32_firewall_grant_access(struct stm32_firewall *firewall)
 {
 	return -ENODEV;
 }
 
-void stm32_firewall_release_access(struct stm32_firewall *firewall)
+static inline void stm32_firewall_release_access(struct stm32_firewall *firewall)
 {
 }
 
-int stm32_firewall_grant_access_by_id(struct stm32_firewall *firewall, u32 subsystem_id)
+static inline int stm32_firewall_grant_access_by_id(struct stm32_firewall *firewall,
+						    u32 subsystem_id)
 {
 	return -ENODEV;
 }
 
-void stm32_firewall_release_access_by_id(struct stm32_firewall *firewall, u32 subsystem_id)
+static inline void stm32_firewall_release_access_by_id(struct stm32_firewall *firewall,
+						       u32 subsystem_id)
 {
 }
 


