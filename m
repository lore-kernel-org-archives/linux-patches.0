Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591602;
	b=L2wSZ7G0pckXptuEMpjfcqxuF8couLYwckT2zIsgmybcujTPTT5IfeOWOsyYC2GTc5T+
	 Yq3UyLAEqu0y16bB8gZNOZFQ2McpgPKa+WN3cWIYADuRauSEs+o8OHqVTXB2lP/dQ47gt
	 F+rRavic3JW9zAabedX41jLg/cg2rfGE+xx45A3psK6/Xs1z+hagPSi4m0tGb3rkwMMBb
	 ThOwfA6HL9OWf9GmL8uiQPJx1NY7U9iOYHihdOTfRlRxCwjzhP4oS84M4BnQHDdKgPBsg
	 ZGxdkNWfjWGwn3CEM2vcvP9OVUvff8RXFCev3pEv4opE3zTna03fWIq4HAO7tZ0UpDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t68Z+rfkhWfHaxu5gvN0/d19jugQBoYNRCmVNAfJLsQ=;
	b=CSYwWsmBJFWLFiyrIxWcXo1e7L6yLQX3qwBeim3v9flTzVXjYArfxpKOcdsp/r3ewFNo
	 H50XxS95/f1DF8ZCX4iUh8WzYT/Gvy5pF59DjBUcTEI6pLYoEaLYYOOELdhyXUD+/yAe6
	 pGeuLDg7n7Mc+3ejv/n7i0iO0CLQYphjnZ1HeBXC0K/XwUa4aqVmLltfkLHcZB6oN1PjV
	 uc2lnrJm3Ms1xJGO/9nKmo1RJ3RzsNyo8sHj6HF7q+jkVhI4wJBdL9aohvvM58nqx9SfS
	 ba/FDAfJ++02tkhAfq+8Ov+iAsPOMjGYyMsgUdon9AuIw9eO+g+4s+KlWey6MlS+2NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQqrF2FV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BF606A89C;
	Fri, 13 Nov 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQqrF2FV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47D31F000C4;
	Fri, 13 Nov 2026 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591601;
	bh=t68Z+rfkhWfHaxu5gvN0/d19jugQBoYNRCmVNAfJLsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQqrF2FVKUC4ewPRdkdJ3Ss1EOoO5A6Lxt+sCGjMFGIZd7uhUHAIOaEA4mJDwaPZe
	 d1THV0rTOdCOEM644kMilg2yllSgXrfFVC2d2o9ArcyIDiomENLe9Lwrtt8zDFno7d
	 Uc4YJ1hSfiM7GBSm/JH8ddRmP8IAMi62eSgY+Ezw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Karlos Abel <kabel@voidship.net>
Subject: [PATCH 6.12 644/670] Input: always accept EV_SYN in input_event()
Date: Fri, 13 Nov 2026 10:53:28 -0500
Message-ID: <20261113153833.614953250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Adjusted context to preserve explicit spinlock and RCU calls instead of upstream scoped locking guards. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c51858f1cdc55..05366b82f722e 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -392,7 +392,7 @@ void input_event(struct input_dev *dev,
 {
 	unsigned long flags;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if (type == EV_SYN || is_event_supported(type, dev->evbit, EV_MAX)) {
 
 		spin_lock_irqsave(&dev->event_lock, flags);
 		input_handle_event(dev, type, code, value);
@@ -419,7 +419,7 @@ void input_inject_event(struct input_handle *handle,
 	struct input_handle *grab;
 	unsigned long flags;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if (type == EV_SYN || is_event_supported(type, dev->evbit, EV_MAX)) {
 		spin_lock_irqsave(&dev->event_lock, flags);
 
 		rcu_read_lock();
-- 
2.53.0



