Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050783;
	b=quHz3cktcSQIeVwl3Wu7cihLJ5FFyBk2yrSE5+qfyFCDtGbzwbM/4p0VlaQl9ncZHQrd
	 ZW9dHhAfPEuDqJ7poU+dhwYZ3sa8avcyTx/h1GbTLNEpXDp0iPEZi+wH0aCKv8IgYySG8
	 Fv8kO7x0eyH2kMaOsFvKm+FgbejPP6ZhxsK83uYXg49+zOgRULHKZtOkNMwbeNy8xoUQV
	 J8pe/oETwHbOJb1ZZuW/ekfN41eCeF1kTCtmzr0AvkW6oHZD3rW6vWt7OuTudrXAAqD3k
	 1KM4YS5NuUmD0oEkrlMXYqFb9BVeP9PxsgYl0uhP5r3InZwFkK9uKT8pSZ0qj3drszg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cSaolskqREEvOMX6jUxH9yS3x/smet13xFJ1uKCUgac=;
	b=v1UoY73FrjaFYAacVepYdLVfJ6YDbVCzcKME30iuLlyj72MCAcHZlZZW0kVX0gJlCLyV
	 usDomXMmYpbhFpuzP1ptEKVoDH5ACxb5X0AuUW05mQ42NeqKV5CvIQTt+4t7vaKU+5gHe
	 Vakuwn/aQBCF5taNdaArsK6w/iVY9nHYpfAxDOkVYHm/BMOKhMwUNVHGlpBpfaDfm7esO
	 5+pmst49UJfmUw+n8iAD1MHmjvM+Nf8h5leeYvQYOeX9hkfB35d+UyU3mBmkKbbOZWA/9
	 /nP8d6cDfAJwZzzTGou9A4Mk2bdFZHQEfJC3hF6NrKCJymX6wJEZ08xlsfUxfYxJSvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQew592i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE02606A32A;
	Thu, 19 Nov 2026 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQew592i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21F51F000C4;
	Thu, 19 Nov 2026 01:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050783;
	bh=cSaolskqREEvOMX6jUxH9yS3x/smet13xFJ1uKCUgac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQew592iaM0vDVW83lajd0RE0qgdcIRwmxsiggj2/caPSajcRfBpGfEsjz6JCeeAY
	 skYev3MXTmxdVwetTGTY2wmIOL4TjMsUJ/jABvGy0NonV8QwXjWgToRT441Ix8Xt7f
	 O44awknfVCjGvn6L5USPMdJ4/0Zum6vzhSqElhVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Omar Sandoval <osandov@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2830/2857] block: remove redundant explicit memory barrier from rq_qos waiter and waker
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150343.477514371@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 904ebd2527c507752f5ddb358f887d2e0dab96a0 ]

The memory barriers in list_del_init_careful() and list_empty_careful()
in pairs already handle the proper ordering between data.got_token
and data.wq.entry. So remove the redundant explicit barriers. And also
change a "break" statement to "return" to avoid redundant calling of
finish_wait().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/r/20241021085251.73353-1-songmuchun@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f3a6dae67c9c ("fs_pin: do not trust the pin after a spurious wakeup in pin_kill()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index aa45f073d51b0..f68edf5550943 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -218,7 +218,6 @@ static int rq_qos_wake_function(struct wait_queue_entry *curr,
 		return -1;
 
 	data->got_token = true;
-	smp_wmb();
 	wake_up_process(data->task);
 	list_del_init_careful(&curr->entry);
 	return 1;
@@ -274,10 +273,9 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			 * which means we now have two. Put our local token
 			 * and wake anyone else potentially waiting for one.
 			 */
-			smp_rmb();
 			if (data.got_token)
 				cleanup_cb(rqw, private_data);
-			break;
+			return;
 		}
 		io_schedule();
 		has_sleeper = true;
-- 
2.53.0



