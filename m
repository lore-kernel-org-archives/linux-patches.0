Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC4C1C15
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DB1C433F0;
	Wed, 28 Dec 2022 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246193;
	bh=KYjfqLRli8n1iZBmOBcBPxWQX0H/ZhAqW9Izjsis0xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKaLhPAkFV7TeuNOge0LYu1XO0lP2lzm8nYidXReRqzZo0vucDMv/Tlr1hwOWm31C
	 bvNbItj9Bv+nkJK4mW0WkHNWvfsDg88CHFucoYujHc9+owpwF/OWybL9UMir/8n1q9
	 LwEVcICu7SHW/IfCFCq5i5hUuZvsJ3m7zKBY333k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0996/1073] hwmon: (jc42) Fix missing unlock on error in jc42_write()
Date: Wed, 28 Dec 2022 15:43:04 +0100
Message-Id: <20221228144355.181168042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b744db17abf6a2efc2bfa80870cc88e9799a8ccc ]

Add the missing unlock before return from function jc42_write()
in the error handling case.

Fixes: 37dedaee8bc6 ("hwmon: (jc42) Convert register access and caching to regmap/regcache")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20221027062931.598247-1-yangyingliang@huawei.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/jc42.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 5004b17c5682..50aea882ac09 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -350,7 +350,7 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
 				  &regval);
 		if (ret)
-			return ret;
+			break;
 
 		/*
 		 * JC42.4 compliant chips only support four hysteresis values.
-- 
2.35.1



