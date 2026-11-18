Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047915;
	b=4YA9aAy0i4Jq2KeJamZKLtCcDGqAHCXCg5X+uvXUoGD6jV0Vu+2oUevSaiCm8xXtSfps
	 hI8hAQprIcl4oQYb83L9PegD+i32bZuEBnFTpnky7bNATGUwDJireMIx419pBrcNgISFz
	 IWx0YZ0vN06DSWhKn+mMgGW2RDq5bk+eFAEhuTJgBL+cI9PFDm4n0k5WgUwiTeMtXpcOB
	 HsypwevxholYkw7y8cR1zfSU6LWiuBuk9fxiE+8VCmN4F+u7pe5LRLCio7J+YFu2rDW3/
	 hdo16/YVUMSDC8KVjM4jNNgIdt8+sRWYOZ/G/hlpmFNWxllQZpeAmULGxHiuSS5E8eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3NWn49xHBOKNdIwpBtZnX3KPQC9A6ZIUeO785t3+Q8=;
	b=O+hxZ5qkKBXa1+imRUrmtEl1ZpWyb+9EkkX8Rsm9gJ/4MSx6u0T38KMI+R04SFvBqz+P
	 i1mWe3wg8G8nyY8nrRwJP1dXaKIpvCiPrsGQE1YrcKhOpO+ZnhLTqZghz/W5IW4SQZZv8
	 bDAnmu/xeDwNXMVHPROmnU5of9c6BH533cmwVmOvmRFJZD8ggaaPscXpVmARSbRsgBS9D
	 zQdge1I7NUVWALKNx4J/kmwH2RWlsDGV/CWNXzWR3Xy7I+7maXn2N5+Rf6SNs0STCIpu3
	 /ZD8N8WSOrnDTvZXxC2SY7W9/pPiZVRJquK1CJTlXMHUrHvA1WjkeFABLOVxfguOqAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EQ9jF5v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F1606A31C;
	Thu, 19 Nov 2026 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EQ9jF5v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D2E1F000C4;
	Thu, 19 Nov 2026 00:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047915;
	bh=X3NWn49xHBOKNdIwpBtZnX3KPQC9A6ZIUeO785t3+Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2EQ9jF5vN235kulSb/v9m9BEpjl5lOwIc9yvfQvpZ/BAhrG1CZi0zW7Kz7X/tCq5r
	 vE6YN4nVm9c27dB8j8sOOALx6ENhhpFd5b4XX2Nc3cNuvbsNscm33PLA+XRd9ridPB
	 rdsWW6QmZZy6yNJb43O/jFsA2Ltzozr0Ris28dA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1808/2857] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150306.351039978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 32c7f7f80e5f7f2764682fd456054478fc11c8d9 ]

The crystalcove GPIO driver lacks a MODULE_ALIAS() to allow it to be
auto-loaded.

Fix this by adding the missing platform alias.

Fixes: 104fb1d5153c ("gpio: Add support for Intel Crystal Cove PMIC")
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 25db014494a4d..636e4d3f990b1 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -395,3 +395,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



