Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3743F2673B7;
	Tue,  8 Apr 2025 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110421; cv=none; b=n4LAQ+sbvUOXLt3j925GaIaamEXLwjnl9r/yRsf4aGKqFyay/N+R1Z6i1yO/UMdYnvXknRVyb/6+oq2NXCtz68vTu8x0fDG1KJ+Sqfr3J30ZHgTwu4LlKBOGxil0wPJFGcDA8l6VbQcxvykwX8J4veR6NHsm4AcMEwdF1Wy/JE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110421; c=relaxed/simple;
	bh=hdePo94eVsixFTkkVRAGWBh7P6CGRKBhHciqSdXL4b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3oJ0mxyupfV8cfPFlwtDMW9hb1Yp7TAuPT3+elvXLxTgmVwHmSOGBXnfREy37WwkuvUFwhqqrgXhtMOaswjhT2CfHM6g/Bnu2NTh6sW3v8lXu6rO6jKVAplinqJUtc6ysLqzIDJQhsDxzvIkJ5nqoo6ixLmWikFhO95DrTaWTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUHYndi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUHYndi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D3FC4CEE5;
	Tue,  8 Apr 2025 11:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110420;
	bh=hdePo94eVsixFTkkVRAGWBh7P6CGRKBhHciqSdXL4b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUHYndi6ty/GVLzz9PNZsnlMDYegCpDe+FESG8VwCBfhcirEOywuC6AZV9hszUatp
	 J4pc6ZougyGUKM7HgRD2+RKSjldtN/FHoz5VaPV03urfwQc6Ingq2r+qVUh7ssix3F
	 6aYDGnbHLjPRutzoK8TRo0XXgcYAJ+BiPzgkRMUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 058/731] auxdisplay: MAX6959 should select BITREVERSE
Date: Tue,  8 Apr 2025 12:39:15 +0200
Message-ID: <20250408104915.622488829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit fce85f3da08b76c1b052f53a9f6f9c40a8a10660 ]

If CONFIG_BITREVERSE is not enabled:

    max6959.c:(.text+0x92): undefined reference to `byte_rev_table'

Fixes: a9bcd02fa42217c7 ("auxdisplay: Add driver for MAX695x 7-segment LED controllers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202502161703.3Vr4M7qg-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
index 8934e6ad5772b..bedc6133f970a 100644
--- a/drivers/auxdisplay/Kconfig
+++ b/drivers/auxdisplay/Kconfig
@@ -503,6 +503,7 @@ config HT16K33
 config MAX6959
 	tristate "Maxim MAX6958/6959 7-segment LED controller"
 	depends on I2C
+	select BITREVERSE
 	select REGMAP_I2C
 	select LINEDISP
 	help
-- 
2.39.5



