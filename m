Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029855;
	b=DJxTstFLofHNqKqZIeB9Ky8+uDi+GOpGvyhrKUNGjZh2GY1X81gTH6DhvPc3E76A9tqn
	 KEEAK3cZXjYfWBaYV9lZUnzy/MowDuqrdwAe9uTL8eIjNHsdQcCmH3tL5uywScqXySe/A
	 P2oCKMD+BWsejctcIvPlQXO0vxxt9bm8loOjK4nhYZtHpIeQ72qTOhiGtXKWUvFDOvMrB
	 ubKoFjJhPzQjB5JsTXM4mghfZfVicYwcpSsSbrt3F4yVSgbllDnwNl1ibuHR+qTubc5wn
	 8vZVH86lflar5CyJ67TEtK27JZpDWcK+lhsSxoyppk2LF571slf48fMdg+TkRk01eOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/a0JGAFeTBFE+vDeuzDpjC2BEXJvLLBmjLZ5aIUbmg=;
	b=tXqdepL2diRt5C7bdlIYkz262ypwREfSIeyzQzCZeSFOLXt+NI/RMLC49NqGxmY5HaMF
	 rgKj3HuJq5bdbLiL/rptqzLaF7zjw/V8dAKjPWKl0FTSsyfv9Z/RbXi6o58ieHqT3wYOF
	 TuwtA2odjTqISGcL+Od/47t/fqVzQjCE7Ay9j1uuZLCfufJ7r+yQ7GipeccMHw10SeHou
	 EYYk4IlLfHArk0+YNhEV3CTj6DkweJeNJfRWjIqmxtupKMaVnsIYiUhcxt0LLWYMwNj1K
	 8BIigJLMFA0KqRkbRATgVsMreYOXDQa7JzMgNibOZAN6ZFxjclqnyX7eANs1RNs/6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fv8Vx5CC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72D606A31C;
	Wed, 18 Nov 2026 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fv8Vx5CC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF6C1F000C4;
	Wed, 18 Nov 2026 19:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029855;
	bh=8/a0JGAFeTBFE+vDeuzDpjC2BEXJvLLBmjLZ5aIUbmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fv8Vx5CCJ0mFgfYUqUP7xMd4uds68JLx8Lj/Nn9mg7EE069aLAC6C0b9GN4ja7Pj4
	 4p3S8U/H/y/Tp0pxnfUR3FDm8CkrTFPIcNODQxHrIUs4jiimxTaqj6FvyOBWClyXj2
	 ji60HHrCpqgPbvMy6woCcZ7oT3t6vI9K1dWVXBP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0497/1756] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118150028.868585527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d229695f2162a41bfa614f175798fa56a5f1c969 ]

In flash_fault_show(), address of uninitialized 'fault' variable is
passed to device-specific .fault_get callbacks. This is not a problem
if such a callback directly assigns the value like rt4505_fault_get(),
but results in an undefined behavior if callback just performs bitwise
ORs like as3645a_get_fault(). So just initialize 'fault' with zero.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260904054437.461706-1-dmantipov@yandex.ru?part=1
Fixes: 7aea8389a77ab ("leds: Add LED Flash class extension to the LED subsystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20260916161607.90106-1-dmantipov@yandex.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 6fe9d700dfef6..e10a9c796c04c 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -188,7 +188,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



