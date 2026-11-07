Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063511;
	b=11A4A9x6Xlvx+MqKoWd7EqNJggwB8yYKQVv0tjVBRdGz/V/55Q+aNC8zR30TAl35jJLp
	 VIs8AxnC8e5S98htzDuJprjoqSF1y18Rin7KyGEz5GED7MAp7AhG1FbbSG29gfLUA5aY3
	 IjnIoDUXGdmmemTQqcbQdLnLY/s1NN9fqsm2C8Qg+f0iVPvjDhORLYWtahm0HVIi83mfi
	 /i7t2lpwag0fuC81Q1trCJFFuq3lM1GsVzJcQxEjuvDCAVYIArWKcWnRGGvxuMJdGWYwB
	 GEdzGW7vXiiJpwLJbwOPLBxXXyd4FETuL74z3FSmZtFRy66J8hSvgPoLCTWKInFb+pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2xd10RXLVas9OiYDw2O5vTRgh7N3bhdI0I+ULIupbcQ=;
	b=pW2DdmuWY5uLMVuaZT8YXZNjfnJFTYI/3eHOlSPL31+Mg8k6GOAjUtP7Bj5iYifZ6zha
	 +QDOSmVwyQQxFaZesQvtBjp80h4cFy0HkL1keX1g8ZwtVAS0OsQqdCuWYk/TeoCZdDVTh
	 Y8o9eZXzdT332faZfJPJfFQR9UbxXHE5O6YYLi1f3orGAwQbK0unb/GYwuiTAdQG5ehSH
	 Bm5pnyk+OVNyvY6bS5mUWYXWsJYSvPFBbBTFMAubZtxPdqdCaB69d0d5w/UdETqWy5GvD
	 ifkBQuhfFFtbrTDKMS3UgP2k+jSd8P6+MmkOnG/LrDD75K/MzHUoELWkApMI0iZX6CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hB54mPZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57E606B8AF;
	Sat,  7 Nov 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hB54mPZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387731F008A1;
	Sat,  7 Nov 2026 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063510;
	bh=2xd10RXLVas9OiYDw2O5vTRgh7N3bhdI0I+ULIupbcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hB54mPZTEs6vH2e2RmMlHbvkOXmZ0P62FWabWDoAnM6ekxyjG8WcrZ86huIhExmmm
	 5ayiUk6RKxbT6L0T2TxZQtkvOWUkfj5DjOEMYSz51ZyK9ZmJqtlqfIRaJgNB7ommGl
	 opXQngx/U8PQERwJlgmk+NNuJp4AVeCrt5AcJEH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Karlos Abel <kabel@voidship.net>
Subject: [PATCH 6.18 654/869] Input: always accept EV_SYN in input_event()
Date: Sat,  7 Nov 2026 08:55:36 -0500
Message-ID: <20261107134915.241434047@linuxfoundation.org>
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
index a500e1e276c21..9907dd9ec880a 100644
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



