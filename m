Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868681C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BA0C433D2;
	Mon, 20 Mar 2023 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325800;
	bh=lTz+5AFy/jELT6czLvUxdm6WsyIvvXg3gLGmy6nRE7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMshjJyr8g6+2SCXAGIZgOe+aBF3YUy2DVveYeiSVKhMlPIdfnKbKzyksB217+YxW
	 Ec4fys1vS5taxPvP6Zh4dRyJ5fok7M7bJMi4YQnJxV9aJcPGg3eKXeMle2jWBohwaz
	 XpiqvdeBaLBP6ubgmQiBUKeBBHt3FaeR8bIQvn+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 103/211] hwmon: tmp512: drop of_match_ptr for ID table
Date: Mon, 20 Mar 2023 15:53:58 +0100
Message-Id: <20230320145517.604964542@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 00d85e81796b17a29a0e096c5a4735daa47adef8 ]

The driver will match mostly by DT table (even thought there is regular
ID table) so there is little benefit in of_match_ptr (this also allows
ACPI matching via PRP0001, even though it might not be relevant here).
This also fixes !CONFIG_OF error:

  drivers/hwmon/tmp513.c:610:34: error: ‘tmp51x_of_match’ defined but not used [-Werror=unused-const-variable=]

Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230312193723.478032-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 47bbe47e062fd..7d5f7441aceb1 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -758,7 +758,7 @@ static int tmp51x_probe(struct i2c_client *client)
 static struct i2c_driver tmp51x_driver = {
 	.driver = {
 		.name	= "tmp51x",
-		.of_match_table = of_match_ptr(tmp51x_of_match),
+		.of_match_table = tmp51x_of_match,
 	},
 	.probe_new	= tmp51x_probe,
 	.id_table	= tmp51x_id,
-- 
2.39.2



