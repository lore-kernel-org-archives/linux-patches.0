Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100813A265;
	Mon, 23 Jun 2025 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684542; cv=none; b=hImG9EoURNGpuObDATOVDKJKjziynLlzAM8UX/ZHe6aMiIdNG71ozyxd2ZQCMcM5i/538/qsAWhMuClJ3iQRHMSvDX1O+TVlugUujxUgecMkhcVPZRwLPadP57uOaU8bVgt7X2CviRE6xHbBeTOVwNE4PWi0k+BsJTR8YyIs2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684542; c=relaxed/simple;
	bh=1/9V9Nmnb2jqb9b94BWZgXGgeJ3OhTAnJ54iWlY2eUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STGtJjZw3oPTMUqO6CmQ3T1xH/fFSOZeQq2pMH0E1nV9PoH6Oc8COyxAA/ukcWjGYivppcvlx6wOc/EC9WsKw6pFdAGqaTXGIeO++gDkRStbGAtGbfUWagmWnWDk1BCu4aAhsOPS1BBDuGE4I8OjgxpnPjZCa9JePXs5yz4tncg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbUr5P2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbUr5P2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A7C4CEEA;
	Mon, 23 Jun 2025 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684542;
	bh=1/9V9Nmnb2jqb9b94BWZgXGgeJ3OhTAnJ54iWlY2eUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbUr5P2CJhF2Qr1HHBOcJKXRtIZxZQqGix5l3G/MS61Xdlxt91bSjWP6sVvD/FQG1
	 57531YS7mvt0sYakucjnvmSbUxCCaIiyV0b/OprhiwHQF6TzGwnw5oMIXHVCpJYx0M
	 aahQnggzK200HMITY3FnbquvaUJL3+k0azh/ZKQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.15 106/592] bus: firewall: Fix missing static inline annotations for stubs
Date: Mon, 23 Jun 2025 15:01:04 +0200
Message-ID: <20250623130702.798758601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


