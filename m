Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C96210C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B51DC433D2;
	Mon,  8 May 2023 09:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539511;
	bh=Ug9NZHoDCYVYO8qjH3CgqBdFoPrTxpFJbQaHzYqaRXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8hSTFsnCR3CPl/i+McgRUOSfE4bUZSHLPF+4LFCP4Sm5owsIuM7Sylarb4eImGNb
	 FqBRZ3jrwZfBT13vOuwoojB0FUpcgI8CeH3URWaVNxDdZ6NyhodoQco+1CUU6R4nXP
	 4EOcwikazbSdl/w1dIBmOUkTZqiPr6o9Doj0CHDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mariusz=20Bia=C5=82o=C5=84czyk?= <manio@skyboo.net>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 036/611] hwmon: (adt7475) Use device_property APIs when configuring polarity
Date: Mon,  8 May 2023 11:37:58 +0200
Message-Id: <20230508094422.970249029@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit 2a8e41ad337508fc5d598c0f9288890214f8e318 upstream.

On DT unaware platforms of_property_read_u32_array() returns -ENOSYS
which wasn't handled by the code treating adi,pwm-active-state as
optional. Update the code to use device_property_read_u32_array() which
deals gracefully with DT unaware platforms.

Fixes: 86da28eed4fb ("hwmon: (adt7475) Add support for inverting pwm output")
Reported-by: Mariusz Białończyk <manio@skyboo.net>
Link: https://lore.kernel.org/linux-hwmon/52e26a67-9131-2dc0-40cb-db5c07370027@alliedtelesis.co.nz/T/#mdd0505801e0a4e72340de009a47c0fca4f771ed3
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230418233656.869055-2-chris.packham@alliedtelesis.co.nz
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/adt7475.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1604,9 +1604,9 @@ static int adt7475_set_pwm_polarity(stru
 	int ret, i;
 	u8 val;
 
-	ret = of_property_read_u32_array(client->dev.of_node,
-					 "adi,pwm-active-state", states,
-					 ARRAY_SIZE(states));
+	ret = device_property_read_u32_array(&client->dev,
+					     "adi,pwm-active-state", states,
+					     ARRAY_SIZE(states));
 	if (ret)
 		return ret;
 


