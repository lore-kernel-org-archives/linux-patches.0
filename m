Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208395;
	b=q1TBxaF5I06ditOg/opf5QJDXJPIRiFT+zXkI+o501qvxTlXd0oNCN10x7jc6mjIrZPw
	 oE3j4fwsZs4lrJ+SJFISIp1O1QcFW4aaUORR6PXXL25CdKZznsuX2zpk1npmKT78Xi1JZ
	 fuSExXhkY3UkR08uUYsloWNqeNgTQIfXfefwMiZPm9BT1Lgl5uJah3p4fM4oTf1bTvTOe
	 EJ20bRy/uMF1NTydkyIvwXOewB5fKrfZ3pKQkgm+ztIVmZPV6cX2x/C9oD0IMzLm4tZY/
	 CtbD4I7J17eYcIuQSUh8hg1aRJehttVGe6ZVCi+CqXW3RTPK/jUBy4sw95cJ+xHHFTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6fFjNKrt61JEOwss3UGnIZ7PAewkwNqEPH4V2DZL2Q0=;
	b=B2tX6JQhOYpyI9AnPzk6gMG1KyO7w9F0LBkDXjV5PH1Bbrfs/B77FHl1YC+NtY6m2xqa
	 E8xeLmUIkbIqbgg9FxW7KQbWZbW+btt9JRrElexZdS5yZXPwhz/UbJDFUsDbbcVnDlbjb
	 51QNmAamr86ttwGogngfhzJD94pzWUTE51AWubX5AaQUQ0fHCA1krLfK5mP+wW/kQ/Yuu
	 I67LBzg4E0FgO9oAxKewdEls3ljy60Yx7soYOFDXkJEnThVc9WQ6h+6ka0DRcjmDSV8FA
	 ADSPt03p+Q6E30HFwI8xuieuRUsZGtNAvQW4SOVq7uMIeKiLXUKWs4xlSs8CJ8+WZ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbGBpd0V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E6D606A31C;
	Wed, 28 Oct 2026 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbGBpd0V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105F41F031E1;
	Wed, 28 Oct 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208394;
	bh=6fFjNKrt61JEOwss3UGnIZ7PAewkwNqEPH4V2DZL2Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbGBpd0VDIb5t8BdwVY8+BxwIf/NpO9HsOVl0hza8zgsBFGQ4mCgH27n/eN4w9wx1
	 ziOIh3JOqq2v3d86Qiz5LcZVI+qKVc1G6AxAnqqjDN3A+hj1uNr4AkIlpthL0Zvc3N
	 fb6snANqn8MUEpJAq0qc4uDapum887VhcimcXGd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/516] watchdog: rtd119x: Avoid division by zero
Date: Wed, 28 Oct 2026 17:54:17 +0100
Message-ID: <20261028170006.004927692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 5af7d2cbd20f893def03c8310a460ade66a5d822 ]

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: 2bdf6acbfead ("watchdog: Add Realtek RTD1295")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rtd119x_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index 95c8d7abce42e..e963be4df8c4e 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -98,6 +98,7 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
+	unsigned long rate;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -111,10 +112,14 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
+	rate = clk_get_rate(data->clk);
+	if (!rate)
+		return -EINVAL;
+
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-	data->wdt_dev.max_timeout = 0xffffffff / clk_get_rate(data->clk);
+	data->wdt_dev.max_timeout = 0xffffffff / rate;
 	data->wdt_dev.min_timeout = 1;
 	data->wdt_dev.parent = dev;
 
-- 
2.53.0



