Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029204;
	b=C8tY5W2gmckvRYXvgJk2q8mlutKZvlYFawVdzwjf0bjvQdgXwLHzuRMv3NnaYkiH5keK
	 UOBVALDEZ8sCHc9RmvMv7ywjG5DOg4MjeGMbeJqxXFJK5AF3gEr4LizzxgL1SCxRKRw/P
	 3rjhcm5UopVSObMlsmEZ9Tznq1/nWp12QhHRkTKZl7X2HLa5U5yvy9rydioh8W2nQDRKN
	 pEnEGNQPQeWoVu1oNkA5XeXfBZlNkFSRcnfU6ANjRnR/UjTQwBPLROcB7gZvq652epvgn
	 wpt9xSqYYfNsRU6eD70P9lqabeGkaX2wNQpF2RGWkPpXL0G8WSpzR8MVz7HoGHjEm3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nYDHdH0KSRUnGk4bqGOm/eScUdfeai5FQbPXO/FO6Jw=;
	b=JNxAXBSkzvtSAPjcnCo88N941m9attpb/yN5WtwX21rqsG+778Ui3+4mp5DMUNLpLpK+
	 I8+GFygFpmZSeIPifzHTG0oTvOs5a3sL6x3j5I10acUT+LWAezgLQM7bLswwlBxEnPemZ
	 0rU7j6UVyDa2RDB3dMZV5u8946sk18L2+8Gwj3SLolCYT1TsKPJqyBbkkaV/rpU2hvObU
	 hXPB+rm3BQLK5egz0AjKFh2rdaBVHLrn/RGZE49BqzD/5mLpzr6loenvg/dIjHgtSRtAF
	 mkibXdfvyaDsZ5XVCgjJGckhUPp3fUUFJHymfvygFv0ywR8/Rh4HKr6/p7v5EhZ6N2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAc6DFNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AA8606A31C;
	Wed, 18 Nov 2026 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAc6DFNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E41F000C4;
	Wed, 18 Nov 2026 19:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029204;
	bh=nYDHdH0KSRUnGk4bqGOm/eScUdfeai5FQbPXO/FO6Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAc6DFNG8NC+dFC7iQ7f0muhL/Ovf/PNRpF/lSrjVvPa9jZc+vf/hQuxWMKWjF48A
	 jSgJomdm7yTYuRy4C+KEkzRje8OSBIoGBzgrrlN3LeSiAjKdgGO8Pchf2TKcswcM5I
	 cz5CaCzYr1KOb9PbLyQf3RIlaNt6GHBH6Yv8GeI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Manush Prajwal <manushprajwal555@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0264/1756] pwm: lp3943: fix NULL pointer dereference for an unconfigured channel
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150018.864925273@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit 17dbb6938d3ab444cd6be1c95506450595a8800d ]

lp3943_pwm_probe() unconditionally registers a pwmchip with
LP3943_NUM_PWMS(2) hwpwm channels, but lp3943_pwm_parse_dt() only
populates pdata->pwms[i] for the channels whose ti,pwm0/ti,pwm1
property is actually present in the devicetree (the binding
explicitly allows each PWM generator to drive zero or more outputs,
and lp3943_pwm_parse_dt() only fails outright with -ENODATA if
*neither* property is present). A devicetree that configures only one
of the two channels leaves pdata->pwms[] NULL for the other.

lp3943_pwm_request_map() dereferences pdata->pwms[hwpwm] with no NULL
check:

	pwm_map->output = pdata->pwms[hwpwm]->output;
	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;

so requesting the unconfigured channel (e.g. exporting it from
sysfs) crashes with a NULL pointer dereference instead of failing
cleanly.

Return -ENODEV from lp3943_pwm_request_map() when the channel was
never configured, before the pointer is dereferenced. The caller,
lp3943_pwm_request(), already propagates an ERR_PTR return correctly
(it does so today for the existing -EBUSY case).

Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/6a9d4c6b.79b5ea6e.147aa1.5883@mx.google.com?part=1
Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Link: https://patch.msgid.link/6a9d5187.d63de05c.175391.a17c@mx.google.com
Fixes: af66b3c0934e ("pwm: Add LP3943 PWM driver")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lp3943.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index 90b0733c00c1b..ad761daab4f44 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -38,6 +38,9 @@ lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
 	struct lp3943_pwm_map *pwm_map = &lp3943_pwm->pwm_map[hwpwm];
 	int i, offset;
 
+	if (!pdata->pwms[hwpwm])
+		return ERR_PTR(-ENODEV);
+
 	pwm_map->output = pdata->pwms[hwpwm]->output;
 	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;
 
-- 
2.53.0



