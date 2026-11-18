Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049027;
	b=fXxKHOWU4eXGadIWXmp287Jfj/uenmWnzxkcu3DHQxbqTtJ7MRKz5IUEkVHtMmadizaW
	 NJul/gFFjqPaZLyczymQnylFNV+8B0V2ssGKBb3IOI2n9o2PHtTUvRYFoiRDemlMGA4IC
	 zLuNCSZ0T8Ptl22Huan+hJnHBU+KlxHwyRw6Ux+r6C0JZSmykwNQ5XTEeZNS01nKI0MGp
	 hdhJaLcYf0UwoIXPVjF598rn8LpmPbcgqaiLGC85RUoceiv9KBdM+yr7wniTPNr3L4lv7
	 8WNfuQgRYacwLq0vy/rV0W9mtUXIQPHC/oS4jNSonaF4Cb4f7dTHCYMprAFkNycU6ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U+6qCyppFYGIBeCVAUWA5m6CeYplBtcWHXljAOP7EsU=;
	b=H5sah2Zliar0jzCqd5Fq/OatbwK362dn5GNWGEBamf1lRs6L5/Ky6LNawyCTZrJo2scv
	 B7vck4mIPsXLZ3F9aNbX+kLy7qSrFQ5n0N7rvZ+aGWtbobvwVK8qQ5tj0NcX/Wa4hLUIj
	 r45upQY/t2SnmeiGpAk6V4Jr95kyMbo9IwFdONqYrwjtSpfl4tEUnTqWEBe4O9fDg8urR
	 2WU4mSXU51jW5NHH3zOBhwvQw1k/F/P4WeLJzRD8ngmWFfGJYJEp0HCH89BrIcN5twyCI
	 KuZ/YqNG1Zn0wGGGzi+tay4JH4Qw1j5XdKpet2iyq3lDmbLvpGoMJ+BEFIFPDM7Ovtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9CMLuVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8422606A333;
	Thu, 19 Nov 2026 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9CMLuVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0907C1F000C4;
	Thu, 19 Nov 2026 00:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049027;
	bh=U+6qCyppFYGIBeCVAUWA5m6CeYplBtcWHXljAOP7EsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9CMLuVo/6w+7h2k6JoHYKPNCnD06MZbQ/4Oa0pN2fK6xYOqrbXjS86ipqkCHrZMP
	 3PkedXEKkRJJnyWDoQUlLnYANZDCUkN6VRDteV5DgMLF5FJJikGAw8nWEM+Rob6Cct
	 sDU+yVAHcLpp4saNFPpoJWha6wvSH2BCq8td32FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2205/2857] selftests/alsa: Do not take another controls event as our own
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150320.816784465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a3fb3f708f9e7..fac8131296640 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -280,6 +280,8 @@ static int wait_for_event(struct ctl_data *ctl, int timeout)
 		if (ev_id != snd_ctl_elem_info_get_numid(ctl->info)) {
 			ksft_print_msg("Event for unexpected ctl %s\n",
 				       snd_ctl_event_elem_get_name(event));
+			/* The loop condition must not see the other control's mask */
+			mask = 0;
 			continue;
 		}
 
-- 
2.53.0



