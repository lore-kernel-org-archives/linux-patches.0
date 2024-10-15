Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438681E6339;
	Tue, 15 Oct 2024 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998522; cv=none; b=IL/i6u4SYccnyDjHSaTBAUETdkJOWdrUCNcBDp08jhK7JjGjVf+KRDNjUVQcOurlrLFqsxzE/cb1XWNBqd+4Uj+0fw3evPG6jcDP4JWn9n4RBdykO8vwR6lPUUFgZL3i1oIGgb/4+1Zk1jdlRT48ide4Ys5IummGFNhnajcgX/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998522; c=relaxed/simple;
	bh=6M7B0Ud9xwsXQQuhgjv/hLjDPvSYBXd170EbTihLknI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6EGCUi5cuzq0vdJ5igmxfIHV+hkECrUJe13mSnu4GP7/oMyaRw5I2ywTBJiHF5OYBj/zHUwkfKhmC2QYgTTkbHUyltNnzqSOjLoBsKLzlh68MV3/OAxCMIyUoxRxybwArDZIdyCGNV6y9IBKomkKdjig9FM7+6xnfcE7BuSeWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oCeknV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oCeknV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70887C4CEC6;
	Tue, 15 Oct 2024 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998521;
	bh=6M7B0Ud9xwsXQQuhgjv/hLjDPvSYBXd170EbTihLknI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oCeknV5R8XLPHWePQxot2UEfYBTU4qBE0aywQ3yPwxW+o5Zg5X4ahxRkcrYiery2
	 DfHMfO5seWIiQxEXsEkr1YtOzs6txoVKrKu6AcyCk4DiatQZCU2KPrWubAQnwwSaEH
	 OA0OeR9ZzeS9iwHN3RdFRIJ/yiBpUHNKQQ3jDBw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Tremblay <etremblay@distech-controls.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/518] hwmon: (tmp513) Add missing dependency on REGMAP_I2C
Date: Tue, 15 Oct 2024 14:46:44 +0200
Message-ID: <20241015123936.292086195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 193bc02c664999581a1f38c152f379fce91afc0c ]

0-day reports:

drivers/hwmon/tmp513.c:162:21: error:
	variable 'tmp51x_regmap_config' has initializer but incomplete type
162 | static const struct regmap_config tmp51x_regmap_config = {
    |                     ^

struct regmap_config is only available if REGMAP is enabled.
Add the missing Kconfig dependency to fix the problem.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410020246.2cTDDx0X-lkp@intel.com/
Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Cc: Eric Tremblay <etremblay@distech-controls.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8a427467a8427..a762334084cf5 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1866,6 +1866,7 @@ config SENSORS_TMP421
 config SENSORS_TMP513
 	tristate "Texas Instruments TMP513 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP512,
 	  and TMP513 temperature and power supply sensor chips.
-- 
2.43.0



