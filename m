Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD31171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAD9C433C8;
	Mon, 21 Aug 2023 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648494;
	bh=6pqmm8jqOqfxen75NH+tVBsm7a1n6zaAlPEIKgYbxKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EY6V819zXR7R9tNYZZa6VStBE1SFerLkZvjklHUAq9qLeJtEdQNMnI14mQlFjR3e
	 ikeok9OHIxWjJQq76SyxW9v76SJeifbOWDwkPsCuwcHwkqCMNpw1ob8OwagXSBb4c4
	 FeXSjDsk3bcOoh7g+KaJUe3YHK2vi7DVC8UnK/nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Joel Stanley <joel@jms.id.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 196/234] soc: aspeed: socinfo: Add kfree for kstrdup
Date: Mon, 21 Aug 2023 21:42:39 +0200
Message-ID: <20230821194137.496457305@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6e6d847a8ce18ab2fbec4f579f682486a82d2c6b ]

Add kfree() in the later error handling in order to avoid memory leak.

Fixes: e0218dca5787 ("soc: aspeed: Add soc info driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230707021625.7727-1-jiasheng@iscas.ac.cn
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230810123104.231167-1-joel@jms.id.au
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 1ca140356a084..3f759121dc00a 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -137,6 +137,7 @@ static int __init aspeed_socinfo_init(void)
 
 	soc_dev = soc_device_register(attrs);
 	if (IS_ERR(soc_dev)) {
+		kfree(attrs->machine);
 		kfree(attrs->soc_id);
 		kfree(attrs->serial_number);
 		kfree(attrs);
-- 
2.40.1



