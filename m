Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043422;
	b=bfml1yux2XQwqjQEE/tEM8U1OnFNLHWyE8vzhJR3UKZtiAG+Es9goN8lndBsyQWihhVi
	 MwjFyqdRBhzlcFmDAfeY+yDMRkLsG7/IKjJTwK7E3gwE6EfWLZ/MFnKFMN97GRY027/ht
	 LQrDG8HJ5g3OlRSkR7/9DC71BlG9JQyFVc7JL7sldNWlMk9F8bRln7N95e4GF+tK9uO8e
	 eNqGVDc65/zcRedY8nXsq3RpCWVjjGM+WIcBr6F7sYYeZae1V39xph4VMiRvY1S6LCkgb
	 CYKvcIBOVsfbWqzQ1sxvP/TND2ocUrxg6pMaEwustirjKBzZXKjMV/5sGTqkrz59DYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d9lQlIAPnapt2LGvA0xAJALQSE3jotOtxmFgKl1VqJ0=;
	b=HKcyNv61mN9l6MNxYH2vTVeeG31z5gIOV5lutMouVsXqZkifKwtZ7s0urG4ISUQGT8G/
	 1BymAQ7VM/eM+rstIaRf30Gn98lgU/CQL7s23irPj/NSO5PFz2ZudsVueAQkoS3uHF1aO
	 5n0IbNxsBZZQVnizhxOworFfCmPu+D9yp9q2ee+IE0Fl6Otcmzjw/vGyhMV3D5HqT3YhO
	 OQLKLaQaN57PIlGt7cNhBe4C75J2FRmDfg7o4atAqJOpx10QmL708vV16/2dkqCkqqcdK
	 Rq5UQqIdJ/Q0rR5tGCDILzexpO3+ukCITDXCnT417u9lyD6nTvR5f27LKAbEXVxyE0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cUYDL/k4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A805A606A94C;
	Wed, 18 Nov 2026 23:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUYDL/k4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F359A1F00937;
	Wed, 18 Nov 2026 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043422;
	bh=d9lQlIAPnapt2LGvA0xAJALQSE3jotOtxmFgKl1VqJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUYDL/k4lvXmqI0yO+OH7ZTyPlflBDzlv/pdLgQNkI0T3q7KGBFRmIrRTETqsPuFh
	 rBQHSUoYDZQE0EdQI/AM4RXBVYQ1zyaeoYgGqn0p3VhtQbuuM5eKJhnuWRhvuFwR4/
	 W3G9hKPQhik/hE4Mun+3TV4BFtZG4rLvrYB7WhFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0206/2857] md: add cond_resched() to md_do_sync()s skip path
Date: Wed, 18 Nov 2026 15:20:40 +0100
Message-ID: <20261118150208.772804521@linuxfoundation.org>
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

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

[ Upstream commit 162eb5ba791f6260fdaabae75fa2df20134f67d8 ]

When sync_request() reports a skipped region (*skipped == 1),
md_do_sync()'s main loop advances the cursor and takes an early
continue:

	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

If the personality returns a small span per call (raid10 recovery
returns only 128 sectors), syncing a large, mostly clean array iterates
this branch an enormous number of times without ever yielding the CPU.
On a non-preemptive kernel the resync thread then trips the soft-lockup
watchdog:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add a cond_resched().  This does not reduce the wasted iterations; the
excessive iteration count is a raid10 problem addressed separately.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Link: https://patch.msgid.link/20260723135535.101995-3-yunye.zhao@linux.alibaba.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e268eb0be6da9..712789d386dd4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9100,8 +9100,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.53.0



