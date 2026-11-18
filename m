Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023935;
	b=0Nrfim/R+7xYwzCEf2uuZwt03AJA4zjmymC8rZZ+6EVzc9gjR0NBetdf2Tei/XurMg9Y
	 E7GSKXlQjw0af4juEDtcL74HqobnpQMkUm8onUUW1ueFsGdAXpOCqiFAzgpBXbrqYsEgT
	 zFIwlXrSVJHS62H9yb2dAOXTJi4qt/xkpxZ4CqgXQ7I84olC6txU3Tb3oMz+gJ2ba23ns
	 2nZAeHFrZNWzcnX5EX90XX/Dnl+sD8wTbjng8OAEhQmYfLhSSL4RHsiQI5Z3N/pS3GNAv
	 Z/KvPfwJRGhahcN7tEUg/qp0R7hDnzTcL0mgebQ/WAcIU6gcd8CXuBpDAkaJQ6w9lOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkyA2BljqeiLkbqoSSSGPCuRqxq6HTku7TJdjRZU+lo=;
	b=d7ZsPHT+NxljvvghlATJeuuyVGquUkqkFn8dwqLadKYnWgVkKqGeldfiyTUjUQdJTmZJ
	 2sbcvfUdptUyHXv5zMUoEd4TuDNpWyJa/FOYur06bPO0++8LZmBmlyxSRtW2DG1JxF+Pc
	 xVEdbDaEKmo24T8AaaKkXXerJYVnHQyknpTLuRtI6cu+PwTqArTTPrplF2i5meFa5Ckea
	 IbTdscatfF4Hf4R9x3UVNk1hIG16PSX0THpe3Ba2vw0qZ6jRg4sF2SG37ZDP98HUhCQEP
	 Rw8b3DF3qA2e9hUH92RAF0J/bY+mjMEDw/otZOdcstSypuy15Arfak9l0bCctoNhNdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znDQzczu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D3606A32C;
	Wed, 18 Nov 2026 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znDQzczu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66BB1F000C4;
	Wed, 18 Nov 2026 17:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023935;
	bh=wkyA2BljqeiLkbqoSSSGPCuRqxq6HTku7TJdjRZU+lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znDQzczurfhxfTBforX7Po9JUPIu22AOBEHrugqaJlV+tnZ2x6XZ7KBhGwD8WLXyO
	 co/cSxAyFgiVlNSTb2jr+E5J1h3PZU88MY/J/eEN0O7xkww49jdPxzYBWcve7PFcsv
	 Kntk4jwM4WsB5oPkLuS8aJIvkIW9yZRQgNSkQV6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0545/2151] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:38:00 +0100
Message-ID: <20261118150141.826534545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Triet Hoang <triet.hoang.dev@gmail.com>

[ Upstream commit e98e3d712023859af7cd78bb7fdb87ea3a9ffb83 ]

Check the return value of platform_device_register_data() when
registering the raspberrypi-cpufreq device and propagate the error
if registration fails.

This prevents the clock driver from reporting a successful probe
when the cpufreq device could not be registered.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: e2bb18347c8e5 ("clk: raspberrypi: register platform device for raspberrypi-cpufreq")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 1a9162f0ae31e..eb08dcf7f827f 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -516,6 +516,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



