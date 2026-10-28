Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214932;
	b=mDdhm8S5msrpamKc0XimigB9UXCmzBaIThkhd53NtcNr54GTuX8DU0vHNSX1SgXeEWHT
	 IXUADD5Bd9TV3arjEyyKPaQnWNBALDbiO03K7wB0oi4kxJKHruNlVGM2YTSH9SmGJdPGW
	 qqn4KjpBQgzVdlM3Toj23BdCFzK8oUBNzAQ5hQwzoasPAm8g6/eJr6jCYk7M9X4kDS4Zs
	 qavWH1JqJYMaqdAJXflOnqzGR5H2QTHqxHsOs+mKXP6Pxlfpbyyy8TIhBnPD6+nyMEYY+
	 2cw2HaJ8zURZVEeKrVfGLjjBibhNXgvyTY4bn/3FWL1san4wPw8Ta18OLpKCOT+BqKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1nDhBT+EJHQk+z3vOEvRZ7pDmjg3cakou2e8tNuzks=;
	b=SaTTmv1k4skn0YWFxSsmMTZ4OcHRQkyMNL0qwW03iP75eeBL2Uekl3Zn2K1oOVJLApzZ
	 jrsid73vv4fEu+jDp5LMQ9+YyiLgs76LhgBeAC9UK3qP5ilM9fF9t7wHOcljEAZteOyVj
	 Mdlnqcb9bqVD4NSSfjME4342wxuAcOjaMmGGVtwQCmJ3yU9OApksNhsxIcneLzSAQNoz8
	 1HsUHQZ4rxMDwkAQIhNppJcFcOb3yfmu8WgraCjb7TPSg8hatxzlV49HRgzvBRbTKIQ37
	 7ZlIQONOi7srjtISQuxL1lJZ61HiH+Gose+6quWaraJ/fwYTe7/L9Zm+tE9TIkoSaSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YesNGymi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D93606A31F;
	Wed, 28 Oct 2026 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YesNGymi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AF61F031E1;
	Wed, 28 Oct 2026 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214932;
	bh=t1nDhBT+EJHQk+z3vOEvRZ7pDmjg3cakou2e8tNuzks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YesNGymik5GTfwPVHNpNB3LH39czS1HGpuAwa5DDeBO83oN10/rZ19tBGI4Zh8Vdt
	 lNcIXOg0sHH//x9ls8pjgTryQD/FEbGopP2lB2YdufT7bIp9w0+1BNhqRslg3k7ZT1
	 hznsFoGjzOY89kQPX0STWk5jyC7AXIuR1jlwGgjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1032/1887] ext4: remove unnecessary e4b->bd_buddy_page check in ext4_mb_load_buddy_gfp
Date: Wed, 28 Oct 2026 17:52:08 +0100
Message-ID: <20261028170522.897467422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 285164b80175157c18a06425cf25591c9f942b1a ]

e4b->bd_buddy_page is only set if we initialize ext4_buddy successfully. So
e4b->bd_buddy_page is always NULL in error handle branch. Just remove the
dead check.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230303172120.3800725-11-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index df6fa0a568559..4f35376134056 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1614,8 +1614,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		put_page(page);
 	if (e4b->bd_bitmap_page)
 		put_page(e4b->bd_bitmap_page);
-	if (e4b->bd_buddy_page)
-		put_page(e4b->bd_buddy_page);
+
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
 	return ret;
-- 
2.53.0



