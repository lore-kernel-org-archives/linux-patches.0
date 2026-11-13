Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591295;
	b=zhEpSTfHmN4LjOLDk+2H9f230OAKOCe3vpMuPfFXbqpiir8qmjQksE93Lnxs1i0eZ2yn
	 iH/0OHSBdxsWe8wvegZ8ZlhgAN04IPK4B43ZEXHCsTXoVm8v3u+4NAcc8J65EwGQr1CwB
	 McZexkukSBsy6UumUrXCRLLVhpnXDl6bWaKlkjRClCpfqgBVQFPFnHez7rXfovJ3eJES1
	 pO2EhNZm/3UUXQgq8dbQ244KyOmFt5dH5IrqcSsUCeuRk+NR5OtV8XlQoenoyDcQDnMff
	 GEkS7p9UlxUlVTGQi1qAPR+dvi0zT40nUQwWVkbnB3hYJPlFsvPmgxZzgZn6F7boPSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8SzArz7HZ3EBOW0Rp4rtKx5WlsDhWRetQIm2sq7e63w=;
	b=S9mvO0GbNB+gzHOcvF8dyPfI2XgKHAYA5mNrOXXCFxeTw7CUKQ4SOBcSIenC2dfoi7mR
	 mKUx+mgOOnV9GeWQYlpyXBrjhrMSxxaDN6UbmRvySSrwEy1Oll8vlXDloSYVYwnk5DGH5
	 bO3uOXbO5l8UheVkfWtRa1sv0R7/UXGgPvGx+oRlobzVypoLpf95/3KTRe97Y1JB0Omag
	 tnfY2mAJXjpMNV/FYE8K+Xu6+fvL4ZHbGMzwzIKtBKP70q0nyNtwAPJgg4fQxsshna6C8
	 dPxmcq0eyrrn8kZGaprWpb6vDTbV8Ry0GJ7tP3tUOZ+xpJh1ij96e7zryqXyVf9DHbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbQI8Ujb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB060A5BFD;
	Fri, 13 Nov 2026 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbQI8Ujb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA9B1F000C4;
	Fri, 13 Nov 2026 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591294;
	bh=8SzArz7HZ3EBOW0Rp4rtKx5WlsDhWRetQIm2sq7e63w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbQI8UjbiLQU1OZ5HxyniMT5jdg7l43WQr15oH/J5JwuGxIDLDposZdx/YiVnveI3
	 vyuWq1tGo0hJ+gge5Hz8zT+Tun2cy11jpWEeEnyxr2B2k0qU43+17uyfZJp+fsS89b
	 Gaa4Ly8pv+qhgj7okv6ktNruizH7DeUi7bndt2Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/670] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Fri, 13 Nov 2026 10:49:35 -0500
Message-ID: <20261113153825.677100698@linuxfoundation.org>
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
index 50b83e0438a07..e28c4923f52f2 100644
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



