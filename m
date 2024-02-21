Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F539762C1;
	Wed, 21 Feb 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523800; cv=none; b=DTU+/lg9i3GAWb/itctYJE1IzvJcpjRRkOEV59UBZb0ouaaEb0rVaNtJrfISZfW8BMUvsE/C2kqCwqkfRvuYhfptHkYEg/pJxCd+1LcrUnmNkC2mgB1fIAR+3v5RE1QocdGzFpCboZwj81NjCKHn4o31GCSg0TnLFE4SSm3LhbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523800; c=relaxed/simple;
	bh=33RTbqNVq+FR8JtQ4mVQ0/pHlhB1hehtBm8ym8WvBp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fN2k9mGC2WddjTkiaLAF7LQE+kIXk7bPnXtc/UE9Jut0CTzyyYx4fdYJ4y/6JXuB9f6kabYbqTlrXkfwKaeDV3k11ZRODrYyS8Qmg2s4LG+EAOhkz5HxzTKqXl+P3JMQgHS2assVHOGWl02KvrDCGL9KxphJqzMvMImxk9IyU5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNf4MZQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNf4MZQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC9BC433C7;
	Wed, 21 Feb 2024 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523800;
	bh=33RTbqNVq+FR8JtQ4mVQ0/pHlhB1hehtBm8ym8WvBp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNf4MZQeuHi8V8pjsP3F+/esSCTmUseEWm6GjsY5LcpTgfWup+E1w+qKhMs2fRe+8
	 ZBjmaVqtN49WyIMi9ypGwFLipWcWAVMNrehp9tRmgd/YHq3EaB5rn3+w1zd9rA9Rnr
	 uobKmJrfAJCS0kHJVs7IkcoS4dWNSUybVD4J5WDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 033/379] rtc: Adjust failure return code for cmos_set_alarm()
Date: Wed, 21 Feb 2024 14:03:32 +0100
Message-ID: <20240221125955.896586320@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


