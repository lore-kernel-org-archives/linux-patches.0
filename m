Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212382;
	b=SvoRvrj+JhT/N4b8xwDckd24bFdNYL27HX54VnnudJ4K57bNvWb9QLkq5SJQL6H6kBeo
	 Rm2OQ/VHIj/TkNeMeenJc26pLfHTU3T5u+J10UnouvYF9yDOFWd9dfOel67pbB/pSs6hE
	 3mmolRzfdDOluRrCQXYc6deGXK0T3CetpdwpZyt7jrWEOAj94aawKUbWJ7R48OHqNieFZ
	 3yAoSTFlbWbccd3eSkC9FP8ENhV3+9nTERal5EZYt9nNaPYOps1LHdMOC6UV5KhRsfNFf
	 COjhXojW2Uj9FnLmqhe6ZHQAw+X0dJgwPK1U0TZuANYMY2dz6drULuHOBJxZ6QzD4Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0l8Y9rVPpfiZy3rAuobqE0OoBiI/EoFhhvTQGlrbOo=;
	b=cb90to1y4ojxfIJPxAd9WyXyOGXHg6EC/7+FIxzgXabTrRXC0L6jeOv4WA2hIAGeye78
	 TBk9/YQHmfpZJk0PmjNJ7iQZCt8sCNQtrjsCf4ozT+csesEflESRo9EFBAO8Oj+kcBNYr
	 rkF3Y/iy2PCZVrThV4lc5hjH0l/JRw71b6l88LM+uufr5taZSrTHy5YVB4apTufw9oMsY
	 SFuC0vK9RFdlAhPlj1jL1+JjWoAkOxeyXwBwdfz+TllaNiDBh7Ef2ykxmVsOldpcqdIru
	 IgIbMdZWy0MrACY9I4c6RmGpx3GkbmDHumgHYGaSGw6TO/CwdKl4QXp7tMjW7A+eEdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTxtqYI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B3606A31D;
	Wed, 28 Oct 2026 18:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTxtqYI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6236C1F01825;
	Wed, 28 Oct 2026 18:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212381;
	bh=O0l8Y9rVPpfiZy3rAuobqE0OoBiI/EoFhhvTQGlrbOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTxtqYI6b45O+NC6g31jG7qE0LnlbHHKQfUcioelW3UwM2KZHOZjYKe/chOaY5ZlK
	 f7C/pdmSmKPT0Q+wY/rPpUlhhLzgppFG0pHmySwCiNq9tk5CZkM/GNLMYvgXZ4QFmH
	 xDENm7fqzTis+tUQLoVHx0ZjuSEwDB+hm59KjJJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0134/1887] hwmon: (pwm-fan) Stop RPM timer before freeing tach data
Date: Wed, 28 Oct 2026 17:37:10 +0100
Message-ID: <20261028170502.286370691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 26d5ff79768548efb1e604bb6e8697c101e06269 ]

sample_timer() rearms the RPM timer and accesses the devm-managed
ctx->tachs and ctx->pulses_per_revolution arrays. The cleanup action
which stops the timer is registered before those arrays are allocated.

Since devres releases entries in reverse order, driver detach can free
the arrays before pwm_fan_cleanup() shuts down the timer. A timer expiry
in that window accesses the freed tach data.

With a KASAN kernel, a test-only kprobe delayed entry to
pwm_fan_cleanup() while normal sysfs unbind ran. Each of three runs
reported three four-byte reads and two four-byte writes in sample_timer()
after its backing devm allocations had been freed. The helper did not
invoke the timer callback, cleanup actions or free functions.

With the fix, three matching unbind runs completed without KASAN, BUG,
WARNING, Oops or panic. Instrumentation confirmed that timer retirement
completed before the first timer backing allocation was released.

Split timer retirement from the power cleanup and register its devres
action after the timer backing data and IRQ actions are installed. This
preserves the early power rollback action while ensuring the timer is
retired before its backing data is released. Use timer_shutdown_sync()
because the callback can rearm itself.

Fixes: 01695410d452 ("hwmon: (pwm-fan) Store tach data separately")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Link: https://patch.msgid.link/20260911071809.130151-1-lhfff@tju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ Adapted cleanup changes to the older pwm_fan_cleanup() using del_timer_sync() without pwm_shutdown handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pwm-fan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 83a347ca35da5..a6449586d4d7b 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -466,12 +466,18 @@ static void pwm_fan_cleanup(void *__ctx)
 {
 	struct pwm_fan_ctx *ctx = __ctx;
 
-	del_timer_sync(&ctx->rpm_timer);
 	/* Switch off everything */
 	ctx->enable_mode = pwm_disable_reg_disable;
 	pwm_fan_power_off(ctx);
 }
 
+static void pwm_fan_timer_cleanup(void *__ctx)
+{
+	struct pwm_fan_ctx *ctx = __ctx;
+
+	timer_shutdown_sync(&ctx->rpm_timer);
+}
+
 static int pwm_fan_probe(struct platform_device *pdev)
 {
 	struct thermal_cooling_device *cdev;
@@ -598,6 +604,10 @@ static int pwm_fan_probe(struct platform_device *pdev)
 	}
 
 	if (ctx->tach_count > 0) {
+		ret = devm_add_action_or_reset(dev, pwm_fan_timer_cleanup, ctx);
+		if (ret)
+			return ret;
+
 		ctx->sample_start = ktime_get();
 		mod_timer(&ctx->rpm_timer, jiffies + HZ);
 
@@ -639,6 +649,7 @@ static void pwm_fan_shutdown(struct platform_device *pdev)
 {
 	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
 
+	pwm_fan_timer_cleanup(ctx);
 	pwm_fan_cleanup(ctx);
 }
 
-- 
2.53.0



