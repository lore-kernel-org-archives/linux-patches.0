Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773869;
	b=Cm2yQgwgX1kPnvZRcXTTkmoq7I+SQioopqE0ip6BRGjlz9KzzOrJKOmY8hIgt3m8nizY
	 yzJ1y/cu32x6xrZCaN0x04t4U07L9pss78gWpAcUHYGmnsWsVa0/kP9QlQ8B2P1T8O1Pf
	 nh7YCAVdX/8EII271TAVZmn5CnlcIN8e/42tnGAf5ZEk7rPhteZc8k23EnidoNY3Nq8lT
	 TudgxsFHBYKKoYIIYR+XheAw/f4vidrtXBALy7pDhLOJLoJTTgB0wbKl2+MnclVptfYyC
	 6j8IHmGgnlNMYTjOAoMocVznfGDWB2rNzy+g1eped56Aaok6sptFqeGsmT5GeV1RKkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyGRjGa0amYSn1mFnn6SVJOTAZEFQf/+ZcYJmKGyDgo=;
	b=Z0+5RheYeURyMCkTNHP9iUAW/nxhZXcup/M9nEk1TmU7wIPvPjb6gUVBsrGSy3TSuX+h
	 Qcp5UpJ5QS5rdIEjpIasLdTtKJHYYHsBziAUgRJtgpuyJXtY3PFOIO+KRZL8J0r4rXJOb
	 5RswIWc8poHB96IInrl90d5UpRdFyYoO21p9Ex3QummpHE6GnHRZFRw9OGh9S0ItuAX0S
	 Pt5fSg2eZlycH45AXeBlEn8rNRQ2LBFcEq/D6QFWiYGY4r3W72yaZf2U77sP6bsQR8dhP
	 YIyieohWefwW6S0RcOjuFZnHVCtE2U4P+lENvl6gKndRNBE3Sn51A5P+Ai2EERsC2Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rl3qpQpv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0CC606A31B;
	Fri, 23 Oct 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rl3qpQpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA91B1F01825;
	Fri, 23 Oct 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773869;
	bh=jyGRjGa0amYSn1mFnn6SVJOTAZEFQf/+ZcYJmKGyDgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rl3qpQpvFNcsbkl+BK3XmOjflAeMdzDzoWAZsuqiR/UDNrkM1FejaB+h+Ink/0zgG
	 bdhTemBVzz5OXVKOJQeKQsL/sZXwX+ldYj8bxCaHEASL2pBRmxQJUoy794U3/cKazK
	 7Pnprjvg7xR0xl5Ahh592m65U0ppaNeazFONTYpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/193] accel/rocket: clear rdev on device init failure
Date: Fri, 23 Oct 2026 18:35:19 +0200
Message-ID: <20261023163715.200763263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4ac852419f0d317c7bd8db5b8acb3cc78be7fe33 ]

rocket_probe() stores the return value from rocket_device_init() in the
file-scoped rdev pointer before checking whether it is an error pointer.
If rocket_device_init() fails, rdev is left as an ERR_PTR.

The rdev pointer is also used as the marker for whether the shared rocket
device has already been initialized. A later core probe can therefore see
a non-NULL rdev, skip rocket_device_init(), and dereference the error
pointer when reading rdev->num_cores.

Save the error code and clear rdev before returning from the
rocket_device_init() failure path.

Fixes: ed98261b4168 ("accel/rocket: Add a new driver for Rockchip's NPU")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Igor Paunovic <royalnet026@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260708062845.716487-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/rocket/rocket_drv.c b/drivers/accel/rocket/rocket_drv.c
index f6ef4c7aeef11..3c4330f2f3ae8 100644
--- a/drivers/accel/rocket/rocket_drv.c
+++ b/drivers/accel/rocket/rocket_drv.c
@@ -165,8 +165,11 @@ static int rocket_probe(struct platform_device *pdev)
 		/* First core probing, initialize DRM device. */
 		rdev = rocket_device_init(drm_dev, &rocket_drm_driver);
 		if (IS_ERR(rdev)) {
+			int err = PTR_ERR(rdev);
+
 			dev_err(&pdev->dev, "failed to initialize rocket device\n");
-			return PTR_ERR(rdev);
+			rdev = NULL;
+			return err;
 		}
 	}
 
-- 
2.53.0



