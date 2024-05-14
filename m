Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CE0F9D4;
	Tue, 14 May 2024 11:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687741; cv=none; b=bQmXuKkO5C44HBzljp/wAyKZjp6EftCEOcS5BzzhXmo4lUkE8MhI2I/T8VRCzuUkgccIph8j5ucfXydzFVxDgIDRThLZPfvvT34x7xslV9Z7dR/kIdfi43gb1bY2MthBFOVkEJwPjToa8ycIPs2Un5zK5oYY05aQfrPIw26138M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687741; c=relaxed/simple;
	bh=OG7usIaceb2ndvasGwd5gLveFIldwxHMx8NUOBJkHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuITTNftu1hd+YNLQpy/9QRcWFisrzqKnhUITOLzpeqn44zL9b/6Liyqt3Xuy4jRfhhrMdouAXiRcP0rmP/vt6+ckD4kzBPYGDtgCe9GEXs5+XBEDFRt9cueh2MxL+lzeAY/8HXbF7fZB9RJUw8aW3iyGrqSC3Rdvy0AW5XCKQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yk+19tnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yk+19tnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CB1C2BD10;
	Tue, 14 May 2024 11:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687741;
	bh=OG7usIaceb2ndvasGwd5gLveFIldwxHMx8NUOBJkHQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yk+19tnZxziJ1bBJlSn3dsOiQpIJfc5k0mRywGQiXzy0EsqVMLMoQxXkXl18OcTu6
	 fb2FBG7Afg0tKBOToMIgl127H9nfDWNe/3he+XI8mxyVdx/EyphLp/jgSl/84zROHd
	 1bttniZKyNd2Ll8z2WUSOQBqeqFMyseKejkXqze0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/168] gpio: wcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:19:47 +0200
Message-ID: <20240514101010.052960733@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 16a0fae1e32eb..2df948e16eb71 100644
--- a/drivers/gpio/gpio-wcove.c
+++ b/drivers/gpio/gpio-wcove.c
@@ -104,7 +104,7 @@ static inline int to_reg(int gpio, enum ctrl_register type)
 	unsigned int reg = type == CTRL_IN ? GPIO_IN_CTRL_BASE : GPIO_OUT_CTRL_BASE;
 
 	if (gpio >= WCOVE_GPIO_NUM)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	return reg + gpio;
 }
-- 
2.43.0



