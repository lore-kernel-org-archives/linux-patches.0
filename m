Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055026;
	b=HJ5OnqvpeLXEquvQL3TFb/WGazx9FNP0SWIoMA2kpQfJBa1eNAyXMHfHlf1BKH0P35nj
	 NFn1AdCPJ7jIyXTJn4HbBwHuN9ALvHpYjTWLoDunKzRKCDYFQmRiqv/90YyRZ//zfeumP
	 4cWbAUy6Ft0JOMLZYReoz1GZzTbylCS8Y3fsbL9NDjHicNc74/vab1hwIbXlhi4wzdZDm
	 Jx56iyZLDHAxei3H81TqulAYEkuBSmflQrQibiBXyiNJyFBthiZaNZjUYiDTOllgJmnsn
	 6Cbl+AJtFOI02XkcxBZQd20GFJGMfYD90cqiCeY18k3O/DfMh26PawWSy7w6xb6VWoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2y1N83lk5j75byz0FpFFjCWICgWSfvJK2XbI7o42No8=;
	b=05jglP5H5xX+21u3DykQPbQA8cZjyHFG3+BwuNhpQJtJ4R4RyH8YLV7UCnIDTtuo7mAu
	 IRZT6l6sYeuwAXxIhC+ArgkDZTQzYX9vlKP1r3YgMgZZRayO3o6OHNPjpvXilL3O4S67N
	 +Zk3XmxFbgiihNnqJuhvtSuKncZxhK9YUGaSSvS6BWU2cmK+D+QkTI3Y/GtSc8EzJlwZZ
	 ymuZdWBfNfW22UfYmPecW6QpIN7VPZmEz5o6i9fWEwzm42OzMj9PA4wSG2YwV9/rp6c3r
	 V0yxtqfK32QqYI0SnKmFPNID6CgAQw5/9e7YgS0ZHaJ/y8msvPO6PIjyoBY7Ekhfcaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHAy31Xh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480EF606A31C;
	Thu, 19 Nov 2026 02:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHAy31Xh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF71F000C4;
	Thu, 19 Nov 2026 02:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055026;
	bh=2y1N83lk5j75byz0FpFFjCWICgWSfvJK2XbI7o42No8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHAy31XhvNv82xS8MsAmyaamFVOt9mxtnZ7n5Mf1hNfdVEA1Ui/c+jg8eUkb7a0pZ
	 pzrznvH2hNRkJ31g8jo8E75HrZkjFgYu18DRyBTsAV+jRAe8sBkNxuQHWYi1jc8gWa
	 ExevWeqIUOXLxHc9tf/P7dhCgocUgeEjsc3u9Jrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1484/2214] ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150110.514278290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit fc3c0ffefc169719316eddb8c36e2427e11ce713 ]

The default baud rate when none is specified is up to the DT consumer.

In the case of the Linux STM32 serial driver, it defaults to 9600 baud,
which differs from the 115200 baud that this board's barebox bootloader
configured.

This went unnoticed, because barebox automatically fixes up a console=
command-line option that looks like this on the LXA boards:

  console=ttySTM0,115200n8

This had precedence over the 9600 fallback baud rate.

But when EFI booting a kernel via GRUB, we run into this issue, because
the barebox-provided command-line is disregarded by GRUB.

Fix this by explicitly setting the baud rate to the correct 115200.

Fixes: 666b5ca85cd3 ("ARM: dts: stm32: add STM32MP1-based Linux Automation MC-1 board")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-1-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
index 1e9bf7eea0f1f..2a53bc455f455 100644
--- a/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
+++ b/arch/arm/boot/dts/stm32mp157c-lxa-mc1.dts
@@ -33,7 +33,7 @@ backlight: backlight {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



