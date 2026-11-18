Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021004;
	b=RjfbUYQY/Js/M/J6QAwBTYqmh27jNWUkksyjnPAGbtnnkSpsbf5hkctGNG/u4qlEj8Dq
	 e119bi43RbHiA95ZTzrKL739Uqvold/NHY1m6PbJ3O9X9Qrm1/8+JDZDWXktvQauX2AGy
	 L0yLtfOHgsX9tuK23Q7PcBCNi6Wen8OZKKn5m6AHbkyiUT6SiQXbi6KFb+2eN8hCFYNjT
	 LDD++XhK23eXzgFkJ0QyW85zk58LCYJmvTFxMNlyVea0tMSt37FbAyvGix9XYNjU78Y0C
	 tsHAJWv4rQ8PVX/p8+tREpqn2v+/9DD3AqL7bjDoEADin9JzeWidmsquEiMjwtnADDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hh83X+Z0iR+CpYHwGZZ11glfn1E6SM6e6fznsHtjC1Y=;
	b=yfJuPdSczFcWbD+VTdhxmUlxRhrGlM+7KPmAhDoQuiMIR4NLZGWBh+ZnNNsLrMd8CJ9n
	 4avNKP0XhncRYs0cW7HDXg9QYUaaAuzBa5+XrY9m1X9VcY8qtZSu3v4QPQi4TKcYWR78d
	 6Rp75KX0Lb3ZR4Lfzv5Whj7W4FHJ0fJRG5sbeqtF/b8TFGLtkCMib1xlTOd6vFmMeueW2
	 8sBkhoF17iAMHOLFtuHqVSWw6y+x+Hl6tql6CeyKIS4CmEy/pzb6ad5j2MN/9UhJFlrU4
	 wbdavky/amVGcUHCjhozJWXmfMFhSdMDhAU8JOcwqK+y7DcvzILqh3W1gbjpv8nmstw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzVHixMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F2E606A31C;
	Wed, 18 Nov 2026 16:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzVHixMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FAE1F000C4;
	Wed, 18 Nov 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021004;
	bh=hh83X+Z0iR+CpYHwGZZ11glfn1E6SM6e6fznsHtjC1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzVHixMieb+cfudaSkmG7c+R36vafuKhGE5GvyYxtg2abVo1WFvt6T3Yk55+wadEu
	 BsgYrjwAcd/eD1sRu1u1OICnM36dQgie/wfFWBUYyOFYoc9lco61eKMYnPXesFHUJ+
	 WEA3otBC+LpYsaskiX/f3BqmPdtv05Ojahf5bNWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2154/2651] gpiolib: clear the event clock flags when a line is released
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150403.370292831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit d35f61581ee67f8d4d58c325bac813cea528b6b9 ]

gpiod_free_commit() clears the flags that a request sets on a line, but
not GPIOD_FLAG_EVENT_CLOCK_REALTIME and GPIOD_FLAG_EVENT_CLOCK_HTE,
which gpio_v2_line_config_flags_to_desc_flags() sets from the uAPI v2
line config. Once a line requested with
GPIO_V2_LINE_FLAG_EVENT_CLOCK_REALTIME or
GPIO_V2_LINE_FLAG_EVENT_CLOCK_HTE is released, GPIO_V2_GET_LINEINFO_IOCTL
and the line info changed events, the "released" one included, keep
reporting that event clock for the free line:

  GPIO_V2_GET_LINE_IOCTL, line 1, input, event clock realtime:  ok
  close()
  GPIO_V2_GET_LINEINFO_IOCTL, line 1:  input, event clock realtime

The flags are set before edge detection is set up, so a request that
fails in hte_ts_get(), for instance because no HTE provider handles the
line, leaves GPIOD_FLAG_EVENT_CLOCK_HTE behind as well. The next uAPI v2
request rewrites both flags, but requests through uAPI v1, sysfs exports
and in-kernel consumers do not, and the line info then shows the event
clock of an earlier user for them too.

Clear both flags together with the other flags of the request.

Reproduced under QEMU with a test GPIO chip: after a released request
with the realtime event clock, and on a kernel with CONFIG_HTE=y but no
HTE provider after a failed request with the HTE event clock, the line
info of the free line still reports that event clock. With this change
it reports none.

Fixes: 26d060e47e25 ("gpiolib: cdev: allow edge event timestamps to be configured as REALTIME")
Fixes: 2068339a6c35 ("gpiolib: cdev: Add hardware timestamp clock type")
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Link: https://patch.msgid.link/20261012-gpiolib-event-clock-v1-1-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7c865640d4232..9c05d36ccd74f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2682,6 +2682,8 @@ void gpiod_free_commit(struct gpio_desc *desc)
 		clear_bit(GPIOD_FLAG_BIAS_DISABLE, &flags);
 		clear_bit(GPIOD_FLAG_EDGE_RISING, &flags);
 		clear_bit(GPIOD_FLAG_EDGE_FALLING, &flags);
+		clear_bit(GPIOD_FLAG_EVENT_CLOCK_REALTIME, &flags);
+		clear_bit(GPIOD_FLAG_EVENT_CLOCK_HTE, &flags);
 		clear_bit(GPIOD_FLAG_IS_HOGGED, &flags);
 #ifdef CONFIG_OF_DYNAMIC
 		WRITE_ONCE(desc->hog, NULL);
-- 
2.53.0



