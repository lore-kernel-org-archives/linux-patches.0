Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EF02236FC;
	Tue,  8 Apr 2025 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116151; cv=none; b=srPasUp9bFhiPMehE9iapZ1I8NjsyMAycf8kjgz9FrIElcpmggtSiFNR49RD6B/N9KklCgYJwN1EIjq/apspWiO475mhZWpn4m4tQl8Epzk5sdyNWZ78xC/ENq1pNk99FY1AbMJBBomyv9N6ptyobyHHyFB3+xp4MDNPE81kIvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116151; c=relaxed/simple;
	bh=v4eK6BH4o5RINZcRN+in9c25OTMllQe+CUcYJgBAzIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAOx51ETnsGN9yg1bCGSsjLBQvr0UzdsHpUJLsC9ZmGEvFOrl4ewteYLSzSBQ7JNQ1mJvxEdTfT9fq2VXYNh78C4dBNIDJBT0NJy9GnGoVf0uucGEXYAqYDoTCS0/4qtz+8VIRVaTHGw9WTa+sOFfr3bHwOwZMOVoosc0QxlBuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Np7KOun/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Np7KOun/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A240CC4CEE5;
	Tue,  8 Apr 2025 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116151;
	bh=v4eK6BH4o5RINZcRN+in9c25OTMllQe+CUcYJgBAzIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Np7KOun/XHoqAFt/RKitBOS4CCyzwYEhDMqThNE2+myY4Cv/PfcYrc7u0dh4oSE75
	 WwrHVUxzhCYiWRqc8yQoRVVOMlC+O4mUYeErLoz19aKvU+VVpvWjj0BeuppTrxes/Y
	 XExAlpNNt/bskc6vxE1dQB+guhMDujqpvJ2RdPyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/423] auxdisplay: MAX6959 should select BITREVERSE
Date: Tue,  8 Apr 2025 12:45:59 +0200
Message-ID: <20250408104846.518344987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 21545ffba0658..2a9bb31633a71 100644
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



