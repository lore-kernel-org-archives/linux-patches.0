Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76D62D0C9F;
	Tue, 12 Aug 2025 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026784; cv=none; b=e6FOmKDLUFMMYUGUmYbsbpkVxmmQ8aaVkdAu5FzLmjBBKgxZT42xBku6H4yTSe4aSsiCtwli9RaiwCQDWq+UgELxJaqpFRCLQsbpqSeN0rvGtSYtDqpPGgJcTLKO38SbdKTcmoUJZc6Y8OAovLWrpn8ofJZVGlu3P0su02zboME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026784; c=relaxed/simple;
	bh=ArzXnBRBa7xaRhvahCApjbfNf8pO5+aExIwZLRHjQn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cd6NRVkBGKQ0ABRmKF/gvaE3oW3T3ATDxxq8KlaDpreITFlG/p/bEEwgWKufZYIumtVa5W/EOftDczgkG0OuKFJeUIQ7RpJnIOaCufKm9g4tGO5S+ekauZQVznZp+B2TVuXew5RQ3Oe8HPZmhNo+O0lXV8g2dOEpZMn4+zltRqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flo1xkDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flo1xkDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D416C4CEF0;
	Tue, 12 Aug 2025 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026783;
	bh=ArzXnBRBa7xaRhvahCApjbfNf8pO5+aExIwZLRHjQn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flo1xkDeZeDiAYFvHOUrLzqmHz8MkFyuwppxRYWU1k3ZDulHApKid+Tz6PIn2G3Gi
	 0RmN3K5OtP5DzaG2AeRL60ah7trL76EgitDJ1P7vNMyII6NJa90QItREU07pOPngmb
	 jGwouFaS/y6xIVQEJj6OlyuyaD/nlQjHkFLjnyL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 407/480] net: airoha: npu: Add missing MODULE_FIRMWARE macros
Date: Tue, 12 Aug 2025 19:50:15 +0200
Message-ID: <20250812174414.221664911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 760367c2c033..cfd540c93dc8 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -518,6 +518,8 @@ static struct platform_driver airoha_npu_driver = {
 };
 module_platform_driver(airoha_npu_driver);
 
+MODULE_FIRMWARE(NPU_EN7581_FIRMWARE_DATA);
+MODULE_FIRMWARE(NPU_EN7581_FIRMWARE_RV32);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
 MODULE_DESCRIPTION("Airoha Network Processor Unit driver");
-- 
2.39.5



