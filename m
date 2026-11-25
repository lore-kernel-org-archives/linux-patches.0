Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623430;
	b=oAVnOc3JLIqDXyrZXWJW7lxI2wInx6StmYUjC2wvrVl3hbkOPKJBuaOWj7NAHq+Mf4Kb
	 rmtbkty6WNzaoeJR3VROl3GsPqW43c1AVndgbiIPsQfnx4hVyB6LQWN7yPUEIYtc9Ocgr
	 FwzS5xEHhkKeH5UeD3M9C68PnZswh1VwFZ8Ec/2OZLX0Qkyqr8MFq7Drt0SGS7elGC0AK
	 ljULEeXCUICMKPMdbWav4dpvC73UIKfPoNU+l1yQhsu3nS7dDuQvq24ZQyCpK9NWW4LuS
	 q37OHh8s9wcXrVeVOlGpZTPNvDwxQ7gVm1ltBg+1vI9BmFqelYxfW/bLqFNqF4tA/qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UZiH9KlwJr8W9fPXIiv27X0RLG27LGkKyq2YelQNvdQ=;
	b=i0s76IqPevICbHm8CaFySW5J9pqBtV1apjYcWanZX+kahHUhxc7McQjoRsMLhIuphwjW
	 ZZb9VKUTntph6SVbZJ1U6mLLnGKTfWfDmPCVlGu5ksSukLDH8UFpwwpRNZtBvwy5xf/xn
	 sf493P+u/KEONt6xhJiaKjnb6R64oOIN7bB2EuqyLuBHcXeUhObqoviW3eC2lxaWZjpbg
	 EqPmlOVZ7I3XBZdpEHQIubJatxlntgOz2OfmVdMSLzmoRwPXHbJrBXyJFx9qchJSybcto
	 umXXACXA3twlH1wT8CFvJgKC3YG7ihstz0kakTJ2cjWEoQEZqEIpiCrfgMnCFOXtDXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qpgo/uwM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35303606A31E;
	Wed, 25 Nov 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qpgo/uwM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E21F000C0;
	Wed, 25 Nov 2026 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623430;
	bh=UZiH9KlwJr8W9fPXIiv27X0RLG27LGkKyq2YelQNvdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qpgo/uwMBqmdvjaMACuO78JN5ikV8pXitBaGEgFirUdk68PAnBnWpP4WmltjRAq6o
	 FBL6uzUdOKngQgAwg98RsGADu/ebhZZB6Sy6Kphcx7qDRC+VQO3FgRMyim0nbDSDOw
	 PIfpSpIDUiTlaNDWqiSb0wOVTsRU9ONlTEvj0pcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 857/990] dm mpath: cap queue_if_no_path_timeout_secs
Date: Wed, 25 Nov 2026 15:37:04 +0100
Message-ID: <20261125143842.101782411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

commit ae5b40accbc06f93e6a513e0e9a07fd32b197e49 upstream.

enable_nopath_timeout() arms the no-path timer with
jiffies + queue_if_no_path_timeout_secs * HZ. The module parameter is an
unbounded unsigned long, so the delay can exceed what mod_timer()
handles: a delay above LONG_MAX is treated as already expired, and
values above ULONG_MAX / HZ also wrap in the multiplication. The timer
then clears queue_if_no_path right away, and I/O queued after the last
path fails gets -EIO instead of waiting for the configured time.

On x86-64 with HZ=1000, 9223372036854776 seconds failed a write after
124 ms while one second less remained queued throughout a 4.2-second
observation window. A value of 18446744073709552 seconds wrapped to 384
jiffies and failed the write after 455 ms. On 32-bit kernels with
HZ=1000 the delay passes LONG_MAX above 2147483 seconds, a little under
25 days.

Cap the seconds value at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET before multiplying by HZ. This prevents signed-delta
overflow and multiplication wrap. The timer wheel's existing handling
of very long delays is unchanged.

Fixes: be240ff5e402 ("dm mpath: Add timeout mechanism for queue_if_no_path")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -803,7 +803,8 @@ static void queue_if_no_path_timeout_wor
 static void enable_nopath_timeout(struct multipath *m)
 {
 	unsigned long queue_if_no_path_timeout =
-		READ_ONCE(queue_if_no_path_timeout_secs) * HZ;
+		min_t(unsigned long, READ_ONCE(queue_if_no_path_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	lockdep_assert_held(&m->lock);
 


