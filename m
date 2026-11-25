Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618609;
	b=c31zolEVQdCAwK4QhZohcOohNC8ekpYcYSsPP2eo/UTuqy2FEtzhc3Hq1GNmSurCStn6
	 D8MZQ4rw5Gc80GwQxKydxPHc0mv/zRIe+C/k3687HzTJ6oEGX2G85L/D8/BP7OJfulwc4
	 Bc8i/iBojtEcRpOr25wnkbg2g2M8PgckbIdnJeS0PYnss4vGDz0PZoUX8cfe3XxlhJqqT
	 2m9fAmi7VazTQPyVHCScQokzfB9qpa9DMxrfCntcpMZw29X4KsqbPpU+Xe890lRj78vDj
	 joIRax52q0UBuGQeG+iaRNYlgsY9BC9SSOFEkB5yNUrnh6FDwDOvmzAHK30++0zk45A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RysUVl38xUTHVW3CGAQkpEhoBfKMnecxMFTJiEvTqyo=;
	b=roU4g/aqLrVv1WoF6jq3cMBFh7vFfrzBE0bCdn5gExBe7NOAPYMajISdyZmci5/gftRH
	 AAyzp2v4w5fBBBhZYUuz2bEm8KVtl+fTatXehckvHAX2BM3+BBWvNzB+t0iKO+opeIcRi
	 JltejISyWNc10V21LdtqiNFPGr3GCkwW2Cl2jbz+Rah+60TtzYmmR1RbIBJCkjZvin/Lw
	 HCWvqBdicUsnpijMu7HTr2OFH/TR3hi8oUzdEdB+BnbwiZdVLaEMxCk9nf8uxsyHUoGW9
	 HdUNkYk4aJ0zd8w6DcuAw8x13JXx7S5i1R4pUHhtRw1VURBDRC4goH5lp29cJe4mCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5Vq3uWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3888606A32A;
	Wed, 25 Nov 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5Vq3uWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEF71F000D2;
	Wed, 25 Nov 2026 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618608;
	bh=RysUVl38xUTHVW3CGAQkpEhoBfKMnecxMFTJiEvTqyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5Vq3uWl0vWfUtH1bKqVOEe4ySEul6rmJYEQf9yjg8Qzh4FOzDOI6cy37u7EvNy3f
	 HsO2sTc8IyFa52jL+zQnl5WzxK6iJ+88u1PF8JCvSCrZJMCcGKIT62NJVgI2aiQJx5
	 mv74Z4ITJqyEx10PDJz2nVmd7yXQF/RzyS8jYgc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0333/1005] vfs: preserve subsecond timestamps at filesystem time limits
Date: Wed, 25 Nov 2026 15:27:51 +0100
Message-ID: <20261125143829.534702792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 55a0c91000646b008261e3b1e15d1e774f3026e4 ]

timestamp_truncate() clears tv_nsec whenever the clamped seconds equal
either filesystem time limit. This also drops the fractional part of
timestamps whose seconds were already within the supported range.

For example, setting a JFS mtime to 0.123456789 produces 0.000000000,
although the filesystem can store the requested value. Utilities such
as touch and cp -p consequently lose valid subsecond timestamps when
preserving these endpoint values. Timestamps strictly between the
filesystem limits are unaffected.

Only clear tv_nsec when clamping actually changes tv_sec. Continue to
truncate in-range nanoseconds to the filesystem's timestamp granularity,
including when the seconds equal either endpoint.

Ben Hutchings suggested comparing clamped and original seconds in the
2019 utimes review. That caller was switched to timestamp_truncate(),
but the helper retained its endpoint equality check.

Link: https://lore.kernel.org/lkml/12c095e595836a7ff7f2c7b2a32cb5544dd29b55.camel@codethink.co.uk/
Fixes: 50e17c000c46 ("vfs: Add timestamp_truncate() api")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261101113815.52911-1-dennylin0707@gmail.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index bc93c1757a380..5ffe9b74acbc2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2858,9 +2858,10 @@ struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned int gran = sb->s_time_gran;
+	time64_t seconds = t.tv_sec;
 
 	t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
-	if (unlikely(t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min))
+	if (unlikely(t.tv_sec != seconds))
 		t.tv_nsec = 0;
 
 	/* Avoid division in the common cases 1 ns and 1 s. */
-- 
2.53.0



