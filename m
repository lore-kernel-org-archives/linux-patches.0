Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030792;
	b=NtHEuSsyDn2LTDTapNUUtBvSj1tcM7ieuBhgHgILdYg3gPyZj3Z/aiau4GK7RuAU2XLW
	 FYcV4eEA+DSUVjIDWVuHquWRLlh/aTyCpPepANXX7M1VN3KAxNOVYdSrN5/+o7vJXmqwt
	 QUUdURdguPf53XUhxBpjBwCBGRMRGncNqdmveeFzgM8LLteVHLRiuR7tO4Op78dn/t8Ua
	 TI8V+q0z0pBQ2Pv4jURg7j87HZR00K6tusgv09f6ycgbFdzbi+y4y4LokBjSNu645mZIM
	 Gvrh/jxOijRBTebRwTXWMjE6xzrmyAXbmSe+yQsQar21aa3Wf+m+hp418+VTxwOi/vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzGrCw9ZB1vNfBTEe5Uq2lkMzi5ohp91180WDsyJGJg=;
	b=hHEJ0AiYPA/jnKFyZ+s+tO3yIkm5V+nwvvKTtCV9O6H6c9b2/S1RxBEbKB6CqB1/9D4i
	 Aa4J4+RBiTo6x0Pt4KWHwTuiF07eKCd5fYQZlq+JYVneHvkp06Upow66Nmo8IveaXv6/Q
	 +cJVH3sBss/e5wQ2Kap8NEfDrDxIjzO9euy1cksSD83jWbhOnOaQzgk91Fa1+LlLLtFPj
	 pwDGgqsBmQ6ZUDEGXVnG495inkkTCS/xTX0fiU5jYp3f1VUzBU6sQJx9EbNPvJ3jJNEZE
	 rl2oPH8YrnUvJv/HOdBlKHaznONHtOIKF1DyDGM8Vrh719z/RfCnO1bU7HwVnfoNv0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=my6IRAv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB49606A92E;
	Wed, 18 Nov 2026 19:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=my6IRAv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EA81F000C5;
	Wed, 18 Nov 2026 19:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030791;
	bh=gzGrCw9ZB1vNfBTEe5Uq2lkMzi5ohp91180WDsyJGJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=my6IRAv+DJhYDHalWtowqkAc/G4FOCjSh1a8jzQwhEf3uq8dM8/gV6JJyX25rZ2by
	 xpjRYiqHHqpO+LUd3j400LMfZXJFvx+dj7YrhELwgDCg34515zzK/uO37yX1VAe/y7
	 G/TFnVPIrCgMZH13YSTvcgQJf6fej0JYy83lKQ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0828/1756] selftests/alsa: Do not take another controls event as our own
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118150042.476616027@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c9b0768669976a1beb0a1537b4257bd6b76dfbac ]

The wait_for_event() skips an event for a different control with a
continue inside its do-while loop. But continue goes straight to the
loop condition, and that tests the mask of the event just skipped. So
a value event for another control ends the wait as if it were ours.

A driver that notifies a second control from its put() queues that
event first. The core only sends ours once put() returns. So the wait
returns early and leaves ours in the queue. The next test then
reports it as spurious. And event_missing passes for a control whose
put() said nothing changed, as long as it notified a neighbour.

To fix this, clear the mask before skipping the event.

Fixes: b1446bda5645 ("kselftest: alsa: Check for event generation when we write to controls")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930111534.3782264-2-sammiee5311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index a3793ef939321..423494c2f92e2 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -261,6 +261,8 @@ static int wait_for_event(struct ctl_data *ctl, int timeout)
 		if (ev_id != snd_ctl_elem_info_get_numid(ctl->info)) {
 			ksft_print_msg("Event for unexpected ctl %s\n",
 				       snd_ctl_event_elem_get_name(event));
+			/* The loop condition must not see the other control's mask */
+			mask = 0;
 			continue;
 		}
 
-- 
2.53.0



