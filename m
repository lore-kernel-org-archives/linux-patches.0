Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033083;
	b=t2BW3cT4VXqQmTBN8zRh9EqCysoAhA4+tizStekz9JrCVi3t2QJB7ziRHJYRPdcAoyaj
	 bPWCjOMZuUI2Kzv28+ctloBb5UAsRpM6NSt04wKbjR+iac7Olrvju16GMhPwjGGGJlqlh
	 4JrxpaMA+UlCM4sFwHNVBNNX2Tn7OlHqnj2o0XA33TCh5KNkB8In7JHqrsJFdPORHb+Hx
	 HKHL0wzI7VHJog0bFsoPI136vDlqNDENRN/HUpJcwjsTo4fGUfZJOjBvmgvWWTRZmw57N
	 KFMzmIwlbiwtIGVLFtoJS3VqcvbCCCMzaae6LNHOh/zX5twrHm8gx3+zRldP4S+Fv/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+YsIhkIadpWHO2xE8E32AGY8QeZ01Yd6UWVpFYDCcE4=;
	b=c55W2MhXKuXmtwqseoyVbIzUtGvaIsCMAw2nREH5VYXdns8ZzOFlimx2ntvHxs/xyEFc
	 1T3s7V4/nQi46JlQ9N8fLouH4yqHe3FkSrNxAp73fkRk6RCv1Dz34UtD13C7m224UgYIu
	 Zy1SU12zesw+V/JSV3t9T3BnaOkizoTpGAg5EuJnpOqeOSAoVUuH6SkLv7vDr07U2xKQa
	 1RZbNsQ5N4Lc2hAajiHn+BNQwLTo/lZU9uyAa5zhb7yIJuAZWPHFwHs8CblvnxV8xcipf
	 /QRXaBdwzZcJwYBC4pD8rqWtPWzml33KW4EblwxOVBGAy7yzkgrfxIgTTIk83S02hEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJBQ1AVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEF2606A31C;
	Wed, 18 Nov 2026 20:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJBQ1AVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B61F000C4;
	Wed, 18 Nov 2026 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033083;
	bh=+YsIhkIadpWHO2xE8E32AGY8QeZ01Yd6UWVpFYDCcE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJBQ1AVipJSa54ulypATF/8Ku1VFLE3iUuW/aIKJjAgncyo2xxbuRhTUcdiWluOw2
	 flTiMWQ7ohep8azbehQ+b4oL0Gpeo/V0mx5PdddxJrEvd9Nz5ZXh+f6FyrwvIh9Qhj
	 ux6rR8OLiVq1R+G4dqdeWAiy5ILPLwH54ynch7II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1639/1756] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150115.016691165@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7d96874ba80ba7a2ab578ea9139c2af79c353b88 ]

tg_set_conf() parses the limit into a u64 and stores the iops ones
through an unsigned int, so anything above UINT_MAX is truncated and a
multiple of 2^32 becomes a limit of 0. The next IO of the group then
divides by it in tg_within_iops_limit().

Clamp to UINT_MAX, which means no limit, like tg_set_limit() does on the
default hierarchy.

Fixes: af133ceb2610 ("blkcg: move blkio_group_conf->iops and ->bps to blk-throttle")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7a29eeb7b6957..c15dfb3100ee9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1282,7 +1282,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) =
+			min_t(u64, v, UINT_MAX);
 
 	tg_conf_updated(tg, false);
 	ret = 0;
-- 
2.53.0



