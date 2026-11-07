Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065037;
	b=vgXIlNmR5csuKCZwiXRmOdrstr1KV63+zjxUOogp1XD0+PGNH5b1z6ldj1KgRr/VJsBL
	 1prch5U9wemxRpuaZ1Fgvz7ILnHHKUvWMK3gf6E06KD+E/vd2pSs+oQp9AOBEVFJ1dwPs
	 wnHyeSGR8J9Qs7MfTcDp4C1epWMDH5Wo4XoJdGVwo4P5SEf2azF0dvHIPgOgBcDxOlHky
	 xkLGfUvi5L0nGzjVfANziiUWRUemcIL0pDUNDQgrA0dL21P2s2Ledby8TdPpO+L1Jobng
	 B5lRlrMX4laimZhfgXMjISEV832V8sAb9WKWRuljs2ss7J/7U7mF7l4I3039/jwm7lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihx5vagYj7hwy8HZ+1t1d+kgjGaFiFtJ2qOQptvEuOQ=;
	b=pcyOffhjlIAFQmkvMVgjGGNtAgBzRuvaaMi24FVA4PphZqKBX90LQpSZJE/6eXy80ugk
	 lufH80DcBb4z8py0e4RFISf7SEFQlAck5+Z1TkQDPOvpYgnjyJHUp7Ul1rcPXMFQqCfuD
	 DFnY4C3yysNE19pPY6mmn2LZI2l5p6eH0+d9n9b0vKgUUhdZjbJ6j01ek63ioUuM3W7xu
	 wTmp2loSQdvXhMi9SabkgJdiKzXDumMwNSDUh/1PQC0BFquoa5wturFfTtaqjfi1YDMJH
	 +uiekWP4xQrGBu4yZnaLV0naKo2t3yX5g0WF/xyNn3SO4VEfwE5SHXWPAgCtdhdzTpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpZYbbB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E70606A9C0;
	Sat,  7 Nov 2026 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpZYbbB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8335F1F0089F;
	Sat,  7 Nov 2026 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065036;
	bh=ihx5vagYj7hwy8HZ+1t1d+kgjGaFiFtJ2qOQptvEuOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpZYbbB3E2MzY5rc+WgPlBkGtw/j0dLClWRU5sno5npH1FtWtPsbxNoM6NTs+XAKk
	 VHZSkzbuAYQ5qrewktOIYcZ5zY1ZxIQ6Q4FRg7Bv4Wd8IGtz5gWl6VIfM3Vdg0bdKh
	 5mxMs9mYsMlDDv5qUOvgKgJVF4g8z6W/J0/xp62w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Karlos Abel <kabel@voidship.net>
Subject: [PATCH 7.3 0893/1257] Input: always accept EV_SYN in input_event()
Date: Sat,  7 Nov 2026 08:53:09 -0500
Message-ID: <20261107135003.986560817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit c1d13bfdb9c75c2885d10332174a887349eb0b51 ]

Commit 0cd587735205 ("Input: preallocate memory to hold event values")
moved allocation of dev->vals into input_allocate_device(), which caused
input core to accumulate events reported while seeding initial device
state before input_register_device().

However, because EV_SYN is only set in dev->evbit during
input_register_device() (and some drivers also overwrite dev->evbit
directly before registration), any EV_SYN/SYN_REPORT events sent before
registration were dropped by is_event_supported(), leaving those seeded
events stuck in dev->vals until the next SYN_REPORT after registration.

Always accept EV_SYN in input_event() and input_inject_event() without
checking dev->evbit so input_sync() flushes dev->vals as intended.

Reported-by: Karlos Abel <kabel@voidship.net>,
Fixes: 0cd587735205 ("Input: preallocate memory to hold event values")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Acked-by: Jiri Kosina <jkosina@suse.com>
Link: https://patch.msgid.link/asx50uz6iafsyAd5@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 01c91fec9b7eb..6c45a158047f2 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -391,7 +391,7 @@ void input_handle_event(struct input_dev *dev,
 void input_event(struct input_dev *dev,
 		 unsigned int type, unsigned int code, int value)
 {
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if (type == EV_SYN || is_event_supported(type, dev->evbit, EV_MAX)) {
 		guard(spinlock_irqsave)(&dev->event_lock);
 		input_handle_event(dev, type, code, value);
 	}
@@ -415,7 +415,7 @@ void input_inject_event(struct input_handle *handle,
 	struct input_dev *dev = handle->dev;
 	struct input_handle *grab;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if (type == EV_SYN || is_event_supported(type, dev->evbit, EV_MAX)) {
 		guard(spinlock_irqsave)(&dev->event_lock);
 		guard(rcu)();
 
-- 
2.53.0



