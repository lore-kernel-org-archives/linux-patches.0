Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029655;
	b=ejd27dhbFP3pSj4QQf3qAVpswKkkttlhpbM0/g7j4QeBJt70Jfo+ckyKhoiFgTbUorI0
	 LPeVupQ8XRLihmXr8JyVy1tqQPn97XQk2BC/Khww04n0uwGUlpYFjpnDImPAyzhExtFk2
	 EstPeG+u0nUeg8LKNr5En33ZcAZYr2zY54ez/Tv2dPQzNBR6myLjQz+U5G44+r1YCI0Xn
	 7SuVm+FYle+Qmaj4R1ZOWScqsyuCGeKuoRIBpVGr6k5TruEX5aF8+As43qOjkhQCTSnjM
	 vOZkyjVc+5/okJRub9HqDvEehzOwkbPEpTamn4Aek1V3ltf/m9LzsKu9jCqWTcuAd2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yY14Bzwr9rYFi5hzCM0WoJwDYTUYSkLdEphAS5jpVBM=;
	b=VBmCn3nZ4h31CAGhJQeagL+BRFCpHujQawl6lbzQzMTRgjh2n5fDvIDlGbcb0HQcVZ30
	 F3WuprkZd3TktO3HnysCLiEzUJcwha4ak8LlsAzZQ3YGzwsMLNI4rEAg2449OYFAN8u8P
	 QLjvMoOufl5xWFfd4nllBx6kHeXHAGryyN1itC9PGC88yD/3o33mxUq0CuIF0fdh+qDsC
	 yfjPd8ASCc5+KWW6mFtyg+WZRdnXYUZH9TTc7wRMPty8edNfErkjDP+lpr0aEsXwhXU9B
	 g210AACetuSpdEB7VqaR4xNBNGkNglcez5/QIhCWTa05ZebrHHlNeErIvRGeaBWVkeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SH4NS53/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436EF606A339;
	Wed, 18 Nov 2026 19:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SH4NS53/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925FF1F000C5;
	Wed, 18 Nov 2026 19:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029655;
	bh=yY14Bzwr9rYFi5hzCM0WoJwDYTUYSkLdEphAS5jpVBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH4NS53/Mukt4+oMvzHiiO595P9vKieQZH0rmrTaP5xDy39iUMIDo4lsO1/mHfhYo
	 HwnliaeGYrenRM9rGNzWFXYqAKH8AjCKzfCWUIZ7UheaH8Z+3DEr25yjanpzxYxiYb
	 GMvae7jZOUOm8K/YUEzlbv0j4QTjgljLBxdPUVFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0382/1756] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150023.816842655@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 700a0a6892f7c0c541d5d23837cfab98cc744d17 ]

gfs2_get_link() returns the link target or an error pointer, but its
kernel-doc still describes an integer status. The mismatch dates back to
when gfs2_readlink() was replaced by generic_readlink() and persisted
across the removal of nd_set_link().

Describe the returned pointer and error value.

Fixes: c177c2ac8c5a ("Switch gfs2 to nd_set_link()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e6fe1a95d9304..c27587db85b6d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1907,7 +1907,7 @@ static int gfs2_rename2(struct mnt_idmap *idmap, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



