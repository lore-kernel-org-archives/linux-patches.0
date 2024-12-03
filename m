Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8471F707A;
	Tue,  3 Dec 2024 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238615; cv=none; b=B2ttuYGFkqTZpvUGiIySwz9FI8K/vga65Cu35q3SRf6oquQu9Ibbbefa1527cvf9eI4sIxUpKJr1zRbR0T1by6Ka7TD6/WyCrU5JfYJRPfT76WXmQhEIZM/4kNYzUEalDkzb52AzCyUPs6gTQVNb3ns3PA28YUc599lzeee04/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238615; c=relaxed/simple;
	bh=I43C62SGKVTphy1S+Iv/grESxuoAlMqK4JSQKuuNIk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCxiHiWreiN++qP0LKdgsexAflI8ZzBaOcF9ZCW6E++HT6MS6CUY3jAhxZ6NazsLJ/b6WtmNDXamoAHIEPlvc85M/5BwejEt/1Nuvwinxsmxj/wTDOFnpJQVVESTsMx8y9D2c5Qh/1QuOaTwnitKT3AoXdnF4nMSdT259TkBZbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhUsda+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhUsda+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89026C4CED8;
	Tue,  3 Dec 2024 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238614;
	bh=I43C62SGKVTphy1S+Iv/grESxuoAlMqK4JSQKuuNIk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhUsda+0a/eJTd2v3RD2E1QEo6DTLSjRQkRmYrqDCZqslYo0I2eIXNlaWXPvRqJZB
	 MCo3fGo/pgoW0LoNOrketzQmsWLLXzIlUHmTRWw4lNnuyZEPH9DKRrT8OmAdSV6WbC
	 itg78zbH/1f2gPZV3TqQcuCpbDq+Vk8Bzi7NIA2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 307/817] wifi: cw1200: Fix potential NULL dereference
Date: Tue,  3 Dec 2024 15:37:59 +0100
Message-ID: <20241203144007.799915226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 2b94751626a6d49bbe42a19cc1503bd391016bd5 ]

A recent refactoring was identified by static analysis to
cause a potential NULL dereference, fix this!

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202410121505.nyghqEkK-lkp@intel.com/
Fixes: 2719a9e7156c ("wifi: cw1200: Convert to GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241028-cw1200-fix-v1-1-e092b6558d1e@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/cw1200_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index 4f346fb977a98..862964a8cc876 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -450,7 +450,7 @@ static int __maybe_unused cw1200_spi_suspend(struct device *dev)
 {
 	struct hwbus_priv *self = spi_get_drvdata(to_spi_device(dev));
 
-	if (!cw1200_can_suspend(self->core))
+	if (self && !cw1200_can_suspend(self->core))
 		return -EAGAIN;
 
 	/* XXX notify host that we have to keep CW1200 powered on? */
-- 
2.43.0



