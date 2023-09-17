Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D87461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E18C433C7;
	Sun, 17 Sep 2023 20:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981937;
	bh=EKVqVctqoxuq2R0G1HvDUXQ+z0zXOcC/DtOG35F6bz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFNvr5mLi1w1YsJYrCfWx2jGm+IXKyBZ0YxttgoRQoSvEq8Qx6hUjxZXOYz5UFykB
	 9Z2/3tfqYuY2S9YvYhZLIl2syMhxZq/N2WKBx3R7Ff1nrevf+OTcqjYZp1Fjx2xJon
	 xRCKMq7bHeIft31zSeXuwjKO1gHiRUJNIR/Uust4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/511] hwmon: (tmp513) Fix the channel number in tmp51x_is_visible()
Date: Sun, 17 Sep 2023 21:09:07 +0200
Message-ID: <20230917191116.771413188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit d103337e38e7e64c3d915029e947b1cb0b512737 ]

The supported channels for this driver are {0..3}. Fix the incorrect
channel in tmp51x_is_visible().

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/ea0eccc0-a29f-41e4-9049-a1a13f8b16f1@roeck-us.net/
Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230824204456.401580-2-biju.das.jz@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 7d5f7441aceb1..b9a93ee9c2364 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -434,7 +434,7 @@ static umode_t tmp51x_is_visible(const void *_data,
 
 	switch (type) {
 	case hwmon_temp:
-		if (data->id == tmp512 && channel == 4)
+		if (data->id == tmp512 && channel == 3)
 			return 0;
 		switch (attr) {
 		case hwmon_temp_input:
-- 
2.40.1



