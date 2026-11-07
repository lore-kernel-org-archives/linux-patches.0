Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063597;
	b=awyTSa3Cc1YAwWbNkD0onTmhhtm2e0F3AYMJ/i19DN395dZ5HsOfZXqcsgIQlh16b2n1
	 UykC0aoaSlQhpERckq2j4dlawPmuu7XU+1txcQnw4raXOA9BQhoUueuNqKhHMUDnyg3Gx
	 QXpORrJNpggUJWaA65xfTRG/Tu0xqNA+BY1P2JHAJJMs5H0gp3zjAq/5fRtypub29lbd/
	 ax71Y26w9YHKwUqq4P8vcJTLudpLc9ZjWl0hOCeJzXV3uZDqU111bdDnZtGzl1ANzZ2ZE
	 9Neca6dOk7wrqMxQv3OYVopuK8tPYH46PC+izgvARS3zd20Q8w9K69ZSVEM7eSec8cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+kB5TRo1WxySr71or0MuYl+26XFTU3Br5ACmr6xTBg=;
	b=KkGIII2sEyeIcB4GCieMT4uoowlJHhf4exrM1NAPlVbS4itd6VXF3OMu73GHj2igUmSe
	 pbOXXxzVm1iNronYlr3Q5iQYwigIm+2lqG00CzNWr9eOUFDN9tmn16S3IvoLwrmfZfAWW
	 YKISh8oJE+7MV6KiqwyEYe6AqMuJWmdVAp+r6eZs8YAxplWIODxedVl60y2iEQqPVV6cw
	 8AZ1YwYRbzzUF8y/99B7wZkbPbypKvZ0xfOaW1YQFK5LMFM2K0UDtQHgytX/Fumm5KcKs
	 rTsE6MlqF7tpH1oXEBQteVBRLSWK5xtZhXTQOE96rtDhpOPTl/0GFTb9Qr0OmDfxYDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCovPj+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B1606D826;
	Sat,  7 Nov 2026 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCovPj+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C591F008BC;
	Sat,  7 Nov 2026 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063596;
	bh=3+kB5TRo1WxySr71or0MuYl+26XFTU3Br5ACmr6xTBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCovPj+iXYpYk1WIPn7+0htY5Ca2DgxIxDzjlRBsfMNHgSKCV1mwqrmPhuhmj12Iv
	 /wKR7dz8ORDTqv2fxf8tfd6VTLvAZNOldb+wG64nG+euBh0SlVnU11xLFIJJKoJyWq
	 6XI9psTAn2D4X2/BL55xdTMq2C0N+lrRPpN7M5cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 720/869] gpiolib: dont report -ENOMEM for a requested line without a label
Date: Sat,  7 Nov 2026 08:56:42 -0500
Message-ID: <20261107134917.248077094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Adrian Ambrozewicz <aambrozewicz@nvidia.com>

[ Upstream commit dae739137441667d67fbfcc4d303a0ecc6618662 ]

gpiod_request_commit() sets GPIOD_FLAG_REQUESTED, calls ->request() and
only then sets the label. A line in between has no label, so
gpiochip_dup_line_label() passes NULL to kstrdup() and returns
ERR_PTR(-ENOMEM), which for_each_hwgpio() then passes to kfree():

  BUG: unable to handle page fault for address: ffcc73074355ffc8
  Call Trace:
   gpio_sim_dbg_show
   gpiolib_seq_show
   seq_read_iter

Return NULL for such a line, as for an unrequested one.

Reproduced with gpio-sim: reading /sys/kernel/debug/gpio in a loop while
lines are requested and released oopses within seconds; with this
change, 100000 cycles pass.

Fixes: 35b545332b80 ("gpio: remove gpio_lock")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261020-gpiolib-chip-removal-v3-0-aambrozewicz@nvidia.com?part=2
Assisted-by: LLM
Signed-off-by: Adrian Ambrozewicz <aambrozewicz@nvidia.com>
Link: https://patch.msgid.link/20261022083343.3905973-3-aambrozewicz@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 635b77c0eab53..c23ba5e94cd6f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2556,6 +2556,7 @@ void gpiod_free(struct gpio_desc *desc)
 char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 {
 	struct gpio_desc *desc;
+	const char *name;
 	char *label;
 
 	desc = gpiochip_get_desc(gc, offset);
@@ -2567,7 +2568,11 @@ char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 
 	guard(srcu)(&desc->gdev->desc_srcu);
 
-	label = kstrdup(gpiod_get_label(desc), GFP_KERNEL);
+	name = gpiod_get_label(desc);
+	if (!name)
+		return NULL;
+
+	label = kstrdup(name, GFP_KERNEL);
 	if (!label)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



