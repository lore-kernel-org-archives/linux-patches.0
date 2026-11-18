Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052820;
	b=3leBmg7xaW2a2fURCa6KQCsqINxxsncOBTQE+7c/OfbKqjc5P2FGr4v40JbIHt6OtVX4
	 OBFCJpIZqPjPk/DYg2KbVJNn+MFr1ydKYyRo7dmWlN4s6DDA5BqeE3IMqjEq8II1pZCbH
	 bAye1cVJyY+8fHUMda70Im3iBrlg29USCTtpIqgLec7c88prndU7gIK1awnfp6Uj6G2zM
	 oo7H7oMz+QW2avJMNQYAWMI1yqDe/Rhsd69aV0cfDXySdE6fjo6MrjRu6QwiZtNvZ5vUU
	 NTp+DzoOk5nTn3WEaW5hNsl7908WkwXBmU4SxH8LbDospZV6fZSRXNCECZtkEuyI0xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Nb8sie1j3IVRghqXXha/Z6SI6bDEF7M/iA5rfhlg0ww=;
	b=HfE/Ginehmg1m1fyT7yuNImCW1AFeYTcKqXe7bXwxTgOkhrDhC6ZFJAIcOBlcxw16BLc
	 uAKEdYq2pjWlpb4sTwBguPeDehavaBmG0PDyOZsyHEMThJjSMftG81yfUwu5sTMD7PW8o
	 L6PlZpgLI05TXUoQHxdLwX7vgeScWU3qYllyi4W5IdIw8R+xZQNvxMwRhGwgkoFxhg7SX
	 KDS0SsSJOEhvipYQQYDYoIISc7/6R6N4hiu1BCe3RJfLNNgLD+1nwb+1BHQexPVz5ct41
	 H+IB+I1bqXX1ROO6bF/fWLZz7R3iFM1PsFSYOs/u8e2iEsh8uPZOa7iXgeiss7W0c2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyxIB447;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22536606A325;
	Thu, 19 Nov 2026 01:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyxIB447
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739751F000C4;
	Thu, 19 Nov 2026 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052820;
	bh=Nb8sie1j3IVRghqXXha/Z6SI6bDEF7M/iA5rfhlg0ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyxIB447OS853J4ecFQxl/xZVTi7MEFDBCxNujlrLC1wTB6DeETlGko/tGzY0EfSi
	 NBMHZ3OgwpMkSKyLfsfYoxyg+JqGTdylTTn5m4iyDmlEpcn3EM6FxsZMP8K5miCOa1
	 hoPmMLphTdsa3hH2R72qE0yX6TYtbySVmCmFazaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0700/2214] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150039.806273313@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

[ Upstream commit 6541fbc942f3b63bb8bd44e34eee6223e0abe719 ]

The sequence counter of the cwsseq target is modified during the
sequence counter loop. If the loop retries, cwsseq will now match
but the offsets contain the values from the previous loop iteration.
These are not guaranteed to be consistent in themselves or with the
current loops "now.

Save the target's original sequence counter value so that the update
also happens on loop retries.

Fixes: 868a3e915f7f ("hrtimer: Make offset update smarter")
Signed-off-by: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023-timekeeping-clock_was_set_seq-v1-1-61c4c53d031c@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 20d506209a047..84bb2549c44ea 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2298,6 +2298,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2309,7 +2310,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



