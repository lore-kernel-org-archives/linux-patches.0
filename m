Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA50547A57;
	Tue, 14 May 2024 11:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686842; cv=none; b=Kz2EqICYR+KzIrfAky+7tP1sMt0l746MsQZom+PMaxxDYSk/rs7afShP0aXi2dcZ+YB60/oYKDr3YGhQ1zCBo9agVIAjp372WMTNp39q5bq97DbWnUdN/lwSbGwZxcHm5bvsHibiduM39l8luuRGToLkKNXvdAqODQa1lqj+eDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686842; c=relaxed/simple;
	bh=RuAsk+dn38z6d4wz6zcVgdtS96ITm0oW1QMRwTRmqvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeVMEVlnN0USlXSxSjaTRQCp/nTtDukmuwXV6XmoY09GslsJKg0rt+SDt00jUI1fErkZaaUlGwY0T3uEFYqUN7wyUxfh0lHUKXialgy5z5xpbkIWh41+4fF6MbIZgaxQ9qRNsRqaxVMSgVC2IfZspSCG112Cbda/LumUysdkeyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5ozlTBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5ozlTBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5242DC2BD10;
	Tue, 14 May 2024 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686842;
	bh=RuAsk+dn38z6d4wz6zcVgdtS96ITm0oW1QMRwTRmqvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5ozlTBXk8pY2BV9iPDR8iIwbG4Vdh2HoZJVoCdM7YDZZRKpgfx/ENUJFbaQH7nTo
	 HKkauo3QqlLL6mB6+4PNtFQp+xrQUPC4D8SVtbn3lJz1pPC0WjLY84AA6odQJm4tIj
	 zh3VCYVDly32jChAvfwHp4pho+eNj9+BWNjn8Z4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/63] gpio: wcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:20:01 +0200
Message-ID: <20240514100949.528499369@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0c3b532ad3fbf82884a2e7e83e37c7dcdd4d1d99 ]

The GPIO library expects the drivers to return -ENOTSUPP in some
cases and not using analogue POSIX code. Make the driver to follow
this.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcove.c b/drivers/gpio/gpio-wcove.c
index dde7c6aecbb5e..b8d79f70cb965 100644
--- a/drivers/gpio/gpio-wcove.c
+++ b/drivers/gpio/gpio-wcove.c
@@ -110,7 +110,7 @@ static inline unsigned int to_reg(int gpio, enum ctrl_register reg_type)
 	unsigned int reg;
 
 	if (gpio >= WCOVE_GPIO_NUM)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	if (reg_type == CTRL_IN)
 		reg = GPIO_IN_CTRL_BASE + gpio;
-- 
2.43.0



