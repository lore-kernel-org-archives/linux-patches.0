Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F9526A09B;
	Tue,  8 Apr 2025 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114378; cv=none; b=ghVpBMlKdupVwilHmec0plOwkTQ2retA63fmoSVJbgYJJL1tVFcnng8nequ1zBQxBEjOW7jaZRs8jcqE2bfMlGEEvn960+FdmDe3fj23LUmk4bwr61w7DrhwYjB+fz9u5TdKrOv2/im+JVtR9kScid3vKRlsganASJ/vJtiG4ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114378; c=relaxed/simple;
	bh=zc93IYsTHKEdVgeg7q+sj0kIPFbXpSZzuNJ6HtAPSkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqquMXlogY4y3m+uqBU+uX18Gvn+RTlcYY4VrsX4PbiEexGMDUt8tAuGQK8aaKNv6BPplY7Vrmp4be9EDkqRotdaiCAn1siZGafNx2n7iBv0HT3pFM14g/dYB/hcmE2k9qNiH2R4CiZQNvxGfa1n2kpnN2zhjlCrkbhDDG5AQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ+bLC9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ+bLC9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D362BC4CEE5;
	Tue,  8 Apr 2025 12:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114378;
	bh=zc93IYsTHKEdVgeg7q+sj0kIPFbXpSZzuNJ6HtAPSkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ+bLC9CrIZXQhwq+/sCEc1uR8HOdSPs15QmJp5r/Ytes9zi1yh1mQqKroSBhPeKB
	 /O53cBYmPyq2GNhc6d4Tcu9v8G8khHPDbmfudJFqFoxAJESmYN7s+3XHsxcJqvN60p
	 vkKMfXgE04zArt8hngc+WpSSLKTM4gc89b8pD+5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 044/499] auxdisplay: MAX6959 should select BITREVERSE
Date: Tue,  8 Apr 2025 12:44:16 +0200
Message-ID: <20250408104852.343123347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



