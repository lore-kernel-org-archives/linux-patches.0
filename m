Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056933;
	b=XUM+RixQN40m/rmMOWQwkTw5HRcAzb6BrMJHUuS9VcZx4e78ner4vAmX12RePELD/1wU
	 F0kW8+B5GqIm7ncJzbdgchyv7KuPRwPNAJ5ZxFz+KYtKdfHDeSnJYVW+MjAP3BYdr2bDq
	 l9ulSU2GytkDLFjhgZ18x6bVnmCph+S9DXuLug5FmLEFDpihg4maNzRUPl/WuRrncWYOl
	 CAX0QRK/lUSqx1qEZdUqwazxNUD+OSJoA3Qj2JNiCEi3txGUgLW7lYN7siu0tzj555drD
	 OotvJnDLv9pmw1E8FKXmXyNkyrE+97ef07FdHXkETLfIpCaPbTVDj03Rw2sDFlYIvJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNkU53rUMz7zsO50p/TfgQzaxqMcsb3z4Dkc4zuWkqs=;
	b=yBMaWWAWBEUUVfkXGsUnpj6y6982rXQo8T3AOdwzH4vtm8nRGSVTDMJSju4WOOnJry0Y
	 Rw3qbpwLdkZ5FCr/nfcbqWFSxlefjVx/48hOURNJD9K153E4DkbU2xTRa7bn6+oIxsgya
	 0vZ0jzL3Xks9IHI5by2Vo4+47a1w33wpf7oGlgrnZNYYuZBCelBjbtx97zRDLKCp6y9re
	 aDkY5cEE5M/dXRA0RqYtDy2+j5XYmnr/nmUUPKIaS0VUo1fIfxrsH0y0BsoZOKbFJEejs
	 +TsuUI13UK44bbTMB+u6mVBkTGTlnKogBhOUmfk3ljtgPe5jvcRwjyiU6AlASpiWbXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNjUfwYC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA7606A31C;
	Thu, 19 Nov 2026 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNjUfwYC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A791F000C4;
	Thu, 19 Nov 2026 02:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056933;
	bh=QNkU53rUMz7zsO50p/TfgQzaxqMcsb3z4Dkc4zuWkqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNjUfwYC9vFt+yx56tX6EZx0HdwAhjbglcxxRSe3TglRjdjr3w8XtLbto2fxWyAVe
	 kyE0I8tV6tvbrEuK9zdSC9+IX/p5PZ2mdcJeaCyiHwdqx/eqZxVuV+yfLOfDv+L+zu
	 7+W46dOX78Nh9HYTZC8Xc2tHQVy61YJlCYDg8id0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2162/2214] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150136.929216133@linuxfoundation.org>
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
index d502a4bdbd9df..ac28d3f7d7ae8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1486,7 +1486,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
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



