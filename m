Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060570;
	b=fb0O8Bqmfc3PG8DrcZRL4RYGI9PB3PMco6JR6qLs2JzhDrA6HutMN1L6ZRHtO1UM5Lbk
	 9kbQc/QonuQO4XLDq+OyzZqdNX8DxEEugM7LyX6Achq6ETcexi1qYwHPGHoBY8qlieUcv
	 19r5H3fQTYHpvuRnio/37qHiNSMgHCa0LC3qgw2EYQYVFpGFlr+AvUXX2k9uWAFRrY6tU
	 4gscNN0Ik7GnecYgwfcmsDdcaZjsAgOASvvt+cusDVsUkf0ACtns7qpQH2yQ0l9DTd8iS
	 LFMc8jaNMFN7hf+uzPkI+FiXy8JLm2aHcQ8YrFhtdm2F3FRhKf/rkhUm5lqrzuPeCpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7jbCb/yIhOj5cbNRWwN6e4WqRUy8C06KeRRZh/ZroV8=;
	b=kv/y/sXJDfNHsOFtRvlDzekF63kwWnUMSHTWYwrCBi4di0EA6ScHMTcGiPMd5G3ULUpH
	 wobl3vv/j8rvrolhN1dl9hHYyH1Gg7lH99DoKG5KW8Nh3mhWBGY7JgCMRDM/8SQCAndQG
	 SDccyXqs/hj+5oct7ZcifMCQNHIv9tJkfaTUSl3kxq6LVnELh6ePU9yUYglFV27554o0D
	 cjmmGrMnKQBkEGnLqGiMIL5Z8G2dU3gd3lwYZEISR18Hw3FO84IzUxW+uq+Bjxy8u3kEf
	 5IjIWjUxXjWa+sPdnIVLh+9R2jS8TCr+lI6IocWIPz5MlUupgNdDW1CqbzpR3sWdQQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHRGEYLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4204606A326;
	Sat,  7 Nov 2026 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XHRGEYLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457011F0089F;
	Sat,  7 Nov 2026 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060570;
	bh=7jbCb/yIhOj5cbNRWwN6e4WqRUy8C06KeRRZh/ZroV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHRGEYLSHhZ23G62dKa2b0Or7qiMS1lJfmEVMw5iOQRahf45+RZ/F0Cm/GlgW+EwS
	 d3WgvP52yPIftJKddD8DCIOBeQ3RwcbYtV5+Ga/+SypXtTzF7SFYulySfaWNgKm7Kt
	 FobJZfLi0VkYCyZdNKOMKdWOpHi+bLItt8G2LQ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0031/1536] gpio: pca9570: Use I2C match data
Date: Sat,  7 Nov 2026 08:34:07 -0500
Message-ID: <20261107134958.546107716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 415c63896b76fd98883e190bc7518383cb01779c ]

The driver stores chip metadata in both the OF match table and the I2C
id table, but probe currently reads it with device_get_match_data().
That helper only returns firmware-node match data, so an I2C-id/modalias
match can leave chip_data NULL before the driver dereferences it to read
ngpio.

Use i2c_get_match_data() so the I2C id table driver_data is consumed
when firmware match data is not present.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624053744.72612-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca9570.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca9570.c b/drivers/gpio/gpio-pca9570.c
index d37ba40493683..29fd67ca41268 100644
--- a/drivers/gpio/gpio-pca9570.c
+++ b/drivers/gpio/gpio-pca9570.c
@@ -127,7 +127,7 @@ static int pca9570_probe(struct i2c_client *client)
 	gpio->chip.get = pca9570_get;
 	gpio->chip.set = pca9570_set;
 	gpio->chip.base = -1;
-	gpio->chip_data = device_get_match_data(&client->dev);
+	gpio->chip_data = i2c_get_match_data(client);
 	gpio->chip.ngpio = gpio->chip_data->ngpio;
 	gpio->chip.can_sleep = true;
 
-- 
2.53.0



