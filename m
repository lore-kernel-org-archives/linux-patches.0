Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053558;
	b=z5wJbAIG37+HUMLYBHPRPpisSn67hrbMt78UjCA47AVwOPWiaOrx1Nk9y6bz3w+gKWFq
	 4agGo8TfF2WtamQzt3HZSVcc3B9iHIA3vRS+CevR6J3xcjnmF9n3NnnQev+QwgCw4L3Ix
	 7zg9R/KU7jLhdTAtxGSbY4YBdbOGlHqM+pXprgKoK6WzAibMB3psmFbaM3oJsEh6ycSSU
	 eBQplAFaesxsNmcR6Ov/KiX/+EAdQZ5EVDSEjCtu+dlcnwh3+rERfxXyRqO4/hhz8XyA7
	 64EXvNv01dLUYqEa3t55OMymhcPpYz7qSPVNv4vtvgUnFuZlOkW7q1R1M73B1XL+Gwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1A3JK+hf8eBwvkgd/ibI069A5XS3hSgSxkBJCsx1bc=;
	b=I8/nZo9aJDy28X/aDPgetF7rmVfSIUGcnBtnYr5i4ODiOTD0inKuaKT2sMFUZAQMyDvw
	 porU/1uRTHfn7vec9oYPUZq2W6mQ2oUFBzFC9vZwfNEL6Y2HCU5t+h0tdGd3yLey7Q5I0
	 cRb43UM2Asy9blS7TNjMPo7VtJAt66otpoxGgotTMcEwRcgE5/0jA5M9pPzo0DjL4rrLx
	 JVTU33rEAtma0wQkxImlatyI8fJBFs9ZyXYWVKhARHFTJhze9YEYV3a8jVfIDoEHgBpQK
	 G8+gLrUFsTl/wGuBPU5yJDWNlIFauQcej9yYNXoVrtBRX9Vj1O1zAhkWw/EVx//Kyuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hQ6cSF/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30B606A325;
	Thu, 19 Nov 2026 01:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQ6cSF/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2721F1F000C5;
	Thu, 19 Nov 2026 01:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053558;
	bh=u1A3JK+hf8eBwvkgd/ibI069A5XS3hSgSxkBJCsx1bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQ6cSF/Cn2vo0xPGj86wRfPfziV53nbij7m5Gsu5SXZvU5u3pm+qukfsHNG9AaX6F
	 xNJk1gcSpvvouMlUUCBP4eEx/QHEAYJzReNv0veFKIphwOqSg/7mWo7tZMZG0GXNj+
	 0fzJiijvBfAQFTkT5/CQqZnE8/wQdtwo+nyZSZbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0962/2214] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118150050.786820812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 1025b76d13288a311e8259a0eefde0854fa63c41 upstream.

When more than 4 GB are transferred by the throughput meter,
batadv_tp_batctl_notify() will cut of the upper 32 bit of the u64 counter
and thus under-report the actual transferred bytes.

The data type of the temporary storage variable must therefore still
continue to use u64.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-08bb3be4-6c6a-452d-b4e4-606940c6cfa5
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 5514fef54b0a9..1c19da01fa2d0 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -226,9 +226,9 @@ static void batadv_tp_batctl_notify(enum batadv_tp_meter_reason reason,
 				    unsigned long start_time, u64 total_sent,
 				    u32 cookie)
 {
+	u64 total_bytes;
 	u32 test_time;
 	u8 result;
-	u32 total_bytes;
 
 	if (!batadv_tp_is_error(reason)) {
 		result = BATADV_TP_REASON_COMPLETE;
-- 
2.53.0



