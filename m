Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062529;
	b=wfXdmLvTrfN5b9ELT5HXsyRFLfckgMyXIaRWvlCoyf8PAPBd/j+v8RY+4ewj3Pi4vGbr
	 F+5OKWVJh6Q5uO/vgMCskPrOho92ti87Sgu0n5cgm3XzdxHXk4hZcqUyIuoLrMFMcwjfE
	 Kxc1l3VRG+MxS+YDWh0LMxVl5ZHqrWEpnODZhSIl7zQnNBaN3J6frCMOWDqyUbyvrtLgG
	 0PMDSw9PiGl+C96hUu57vCrCX3E3Lygh9yynyYgleykQRx95FQ53u0HfZ6v2mTFAdyHzq
	 /RjhPtoZLwD/lkrpKdjfpYpH4brVJ5WSRVzjq183+bL4Uq+AAWLoUWY98aIMbnnRzDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbMm5EdPw+CajNdr6LqUZdQTpUk9+a7vK3ms7ozgYlw=;
	b=kydv/TXQyvnBoY8YfJXan+uARSwaA6nAQ/xQduiMcIasWyhJIQQC8qp0hGP9NnfwIAGm
	 zCqpGaowDtm88WLZxxsFFONPnEoMSApgNyNmcsbuO5mEASD1Sd4qw1Hslm668aul/FQP2
	 UsP51UNQsz0W9Z3BGz6tcpz5qbgCVqzGMqc0DEdvo4RQH74dLSjAjnyCXhElhQ49Ldl2K
	 xPSuBpUczauhFiHqXfpvbAdYqi9/zZX2UBoj5iapcKE+XJMtdgML328UtARzj/3k4QCip
	 eoHobgcFJ5lo46/MCkK8MsaVqEE2YlsFVwXBonOLniT/8IemkP5f2qpPnzeSKctEiHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kK8sYVDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C1606D80F;
	Sat,  7 Nov 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kK8sYVDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4031F0089F;
	Sat,  7 Nov 2026 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062529;
	bh=tbMm5EdPw+CajNdr6LqUZdQTpUk9+a7vK3ms7ozgYlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK8sYVDKp0Bdvri/Y2XFbycDxL80gdrKRr5zDRrSY6DAw83R8CN1BdWcB9+hHcs0G
	 CkiUyBYbbUDd2IXcTuLROdJgEmnWq3zEkgbB1EpJpbwjqY3fk+bGKToOizbCUpKQnd
	 S+zRkuzLDmzom2XnYsuJJL+KWzc7nMhQaJGPbTPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Adrian Ambrozewicz <aambrozewicz@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1421/1536] gpiolib: dont report -ENOMEM for a requested line without a label
Date: Sat,  7 Nov 2026 08:57:17 -0500
Message-ID: <20261107135037.738527832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 115bf569dbdd0..02a322f8330c2 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2471,6 +2471,7 @@ void gpiod_free(struct gpio_desc *desc)
 char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 {
 	struct gpio_desc *desc;
+	const char *name;
 	char *label;
 
 	desc = gpiochip_get_desc(gc, offset);
@@ -2482,7 +2483,11 @@ char *gpiochip_dup_line_label(struct gpio_chip *gc, unsigned int offset)
 
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



