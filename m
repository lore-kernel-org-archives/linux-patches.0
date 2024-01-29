Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DFC15A485;
	Mon, 29 Jan 2024 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548255; cv=none; b=ACt3x83rPjqMikfEvZslLUYQvSS4XOIXN8y3vTnSZxDNyiBwDeOk1MIfqCyK+TDewzDRExLEs0+oSlXzZLvsbh6vYWDHRj2YdnE0z8u5BxQTslBlziq5/lS4RjU0pjJ6Eu//qUzrePfS+TZD88xMhL3Y7npd+nHdVT7OGts/96E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548255; c=relaxed/simple;
	bh=zh8fHU1q45rSnG/1FNUYj4jtfqvEPZjilJvacyUXVgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7JvUeWlSbRUUO1l3r3gLvD1yyCQc6ktqni7R6ivrzm5SjN9uE6+Yi4Iy2dOMvyzfu0cw4MWJxf5VY5jEtfIxsVnXiQ14MP/Zw4ksjAmVLBlkaODvUyRA/GxxWK14ciuQ1O7F1MYpINvLBdpmetqvn48NTJqn1uJvZRvRTDm6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHpnSqgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHpnSqgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30D5C433F1;
	Mon, 29 Jan 2024 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548255;
	bh=zh8fHU1q45rSnG/1FNUYj4jtfqvEPZjilJvacyUXVgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHpnSqgO+sKgkeRKYCKrSB2Br1Oua3bTU0ZbW+SkfEjPfJAroOY90QiCdTgg1Te4O
	 d8lYQT/vsN1jaJzNspHIy4GBIIUgJ61RxznoVW+COQyVeI3wwX2/i0pJghGhhrGcEC
	 XRnSoY0mgbmPOvxc5GvGVYs6X5tXzKeS0zI/Ccyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 049/185] rtc: Adjust failure return code for cmos_set_alarm()
Date: Mon, 29 Jan 2024 09:04:09 -0800
Message-ID: <20240129170000.170184074@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1311a8f0d4b23f58bbababa13623aa40b8ad4e0c upstream.

When mc146818_avoid_UIP() fails to return a valid value, this is because
UIP didn't clear in the timeout period. Adjust the return code in this
case to -ETIMEDOUT.

Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc:  <stable@vger.kernel.org>
Fixes: cdedc45c579f ("rtc: cmos: avoid UIP when reading alarm time")
Fixes: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231128053653.101798-3-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -292,7 +292,7 @@ static int cmos_read_alarm(struct device
 
 	/* This not only a rtc_op, but also called directly */
 	if (!is_valid_irq(cmos->irq))
-		return -EIO;
+		return -ETIMEDOUT;
 
 	/* Basic alarms only support hour, minute, and seconds fields.
 	 * Some also support day and month, for alarms up to a year in
@@ -557,7 +557,7 @@ static int cmos_set_alarm(struct device
 	 * Use mc146818_avoid_UIP() to avoid this.
 	 */
 	if (!mc146818_avoid_UIP(cmos_set_alarm_callback, &p))
-		return -EIO;
+		return -ETIMEDOUT;
 
 	cmos->alarm_expires = rtc_tm_to_time64(&t->time);
 


