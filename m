Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3792FAC06;
	Tue, 12 Aug 2025 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025008; cv=none; b=k83/m8IBwg3H1g3IkuFWqk+lJJBp++LCk0jZZ9k/+j9VirSXJcR9xwN/S0HMrpjtyv1fu0F3PBsg93uOMps7q37GZDRZ9VclcDhG7EV1TAQPFU5fvv33Hbqu6HwWTOSL53yqx4bdkeHIExSw32EBINyIFHtIqGyNY4RubclKaEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025008; c=relaxed/simple;
	bh=2dK3qES79IwF6Lz7N2kJMTwsuCaD4GEJBj9/VWYi4Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VorE3Mj6Z1j2S+oiHgCCRlRjUAj0csGrQWNfgqluoLiIvm8ieJM1DlasMChBY1a656AODD/t5Y2zrV3lB+6gfbRFhjBi1cAa+g6TvC2PeOHwO9VHFvs4kna1h5IYwGlVdpVJq+swdImtlbXfFW5IisjuoQMFqXJcwjZgtaB3pZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xfaf5cCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xfaf5cCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBC6C4CEF6;
	Tue, 12 Aug 2025 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025007;
	bh=2dK3qES79IwF6Lz7N2kJMTwsuCaD4GEJBj9/VWYi4Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xfaf5cCMsbaWmF8NEuqWbGVeebe64PDOKJD3aewV+k55ycgE1oMfOhl9qu4JvBU/r
	 npJ5y81DmYvZF31tCEcs1J4Ml8zhF0jmMOHw3gHkeFJ7xXnN/vXMjYoIumR90nVppt
	 oRnc5r95c3KJASZHKPWGmlPRltkQp/+c1DMgDhzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 543/627] net: airoha: npu: Add missing MODULE_FIRMWARE macros
Date: Tue, 12 Aug 2025 19:33:58 +0200
Message-ID: <20250812173452.561266745@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4e7e471e2e3f9085fe1dbe821c4dd904a917c66a ]

Introduce missing MODULE_FIRMWARE definitions for firmware autoload.

Fixes: 23290c7bc190d ("net: airoha: Introduce Airoha NPU support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250801-airoha-npu-missing-module-firmware-v2-1-e860c824d515@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_npu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_npu.c b/drivers/net/ethernet/airoha/airoha_npu.c
index 1e58a4aeb9a0..12fc3c68b9d0 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -586,6 +586,8 @@ static struct platform_driver airoha_npu_driver = {
 };
 module_platform_driver(airoha_npu_driver);
 
+MODULE_FIRMWARE(NPU_EN7581_FIRMWARE_DATA);
+MODULE_FIRMWARE(NPU_EN7581_FIRMWARE_RV32);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
 MODULE_DESCRIPTION("Airoha Network Processor Unit driver");
-- 
2.39.5



