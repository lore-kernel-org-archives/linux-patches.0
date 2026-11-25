Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620270;
	b=rPXbPGBc7gkRymk3t0u5slZrTDKwRaT3Zv7VIVkBEMtNkJjMr25WWNMzBR9tjrCqti0Z
	 V2fJ+xmQc8NOqypkh9RyX0XxkhkwnTMj2WDoCPjS15H9m0JK7/YomLjiMhbGlgi6qP27x
	 fWtZTrrU73O+UT9t4O6URs/b5fdAJebDwpZFX4XqtqmnF2bdlZpPa3IAhlxkSR6vXzkCc
	 GznlX4xu1XC6jeUHnhw0Tk4oP2Wo1IFtV9vuyJVeaPi4x5pqbL6PSqa5eO62NhMQa1H5b
	 SfGUINxq775m9I/vs3KuCzSSXlBifMiRcqeCTewFEdmrDfXSXcAsz33OAx3P8+RskCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RHmrntirRAqiNf892bJa5pQ4/FA5zTK2VvLN9+kB+gg=;
	b=Q6NUnlGtj/Evcuzy0J6RLVzP5ljO0yOARKZH635OnjmcPBP+T4wBD6wBCkHS1Ou366BG
	 pwBKrqMPzY+nxGJA0PB7wEIJCQ+b1O56PHYKGI6ul0NsOev/8gG5tm0hKO4YFvPnOIo4F
	 2h0RKEabOYXhnJnEDKYH+HeK9k2TBW59gr5eg7J787P5wdflD1hiaj0NEdKVL7xe/4Lbi
	 S9OZV88qxBi4hDH4kk8p5I45esom5nU9NosaTXKljVKVLeeOE+4pff75O6zRq2QshTNDI
	 4udUPzH3xXV5CaF6uXgaqVk5CV7oU1wRVSPdOwGEVnhhrBvGeZfXn9EmZjmCewGzfyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGwbZKZk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38DA606A323;
	Wed, 25 Nov 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGwbZKZk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FEA1F00A01;
	Wed, 25 Nov 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620269;
	bh=RHmrntirRAqiNf892bJa5pQ4/FA5zTK2VvLN9+kB+gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGwbZKZkrNgmgzbEx5AIhJm7kvgpafngO7B1f4TmIaFZs21qnaY/nHuIi7QvTFoVP
	 aJaGm73ITZUZt4JVx5R8RjpGiwtxd82sZPRkgybqhhNE3blnmgoENRN/ucpsQsYBiJ
	 C3hP+0I0A1NsoJJCFZgENS8DlTnXp430aTMz8MyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0863/1005] dm thin: avoid wrapping no_space_timeout
Date: Wed, 25 Nov 2026 15:36:41 +0100
Message-ID: <20261125143841.924474864@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

commit bcb78d49620f666b4a9d62997691e8d031fd4ebc upstream.

set_pool_mode() converts the no_space_timeout module parameter with
READ_ONCE(no_space_timeout_secs) * HZ. The usual arithmetic conversions
evaluate the product as unsigned int, so it can wrap before being stored
in the unsigned long delay. With HZ=1000, 4294968 seconds becomes 704
jiffies: a pool that runs out of data space switches to
error_if_no_space and fails queued writes with -ENOSPC after about 0.7
seconds.

Widen the value before the multiplication and cap it at
MAX_JIFFY_OFFSET / HZ, so large timeouts no longer wrap into short
delays. On 32-bit kernels, values beyond the supported jiffies range
saturate at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET. The timer wheel's existing handling of very long
delays is unchanged.

Fixes: 80c578930ce7 ("dm thin: add 'no_space_timeout' dm-thin-pool module param")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2542,7 +2542,9 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
-	unsigned long no_space_timeout = READ_ONCE(no_space_timeout_secs) * HZ;
+	unsigned long no_space_timeout =
+		min_t(unsigned long, READ_ONCE(no_space_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user


