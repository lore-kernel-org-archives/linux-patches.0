Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052455;
	b=Yi0PU2gmamuH2R9FwiS5voGA7W8BMOdOxSHDU9LiddXEbm6rW5KKuKMZASrhPWACrYPt
	 9Z35p8QD6ykpiin48FbaNC0HnStUX5De+odLhoZWFjaEWCdcTbmlzMUIOBkuJYZPcqZed
	 BRUiFESVoruRLhFSCIz9bnmmRK5A0V4HHaLshBgNL0n3RW1gKnzVaL+iOa1PRcLtgOay0
	 2YyUhAokx996BF/1wku58Stw1mRTFPgvyh6v/yjx1lYYIpIWAjSEvKwWj2QOpEEsms2Jo
	 9adjWtfVAOATgd1VnWGvkVHhBSrhg5O+nGwO4McEK8740DDjT7npPjFlkAVVJuQV+wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oo2uaQW3Bx30Y2xnQBphDU1lbBMsSG2v3ycCgDZAtL8=;
	b=forz1xIJqFt4qROprl3fcoIsqOGlp3VFBUHmMkXCj1v1xJzLLmaiAUAffRtojEk9VIfZ
	 EkoxVRtPYnV1kMTM+fdj6pert873y0aUj1qti0U23lBOz/yYgLFgcxEobdD3rBAAswvsy
	 KvkvfbSvwBfBuzh3FKuRIwU7TA0pj7PbuqsCU4v3u4qrnY1X+pbG7tAvN2G+0/MvAh5Yz
	 CTaTCj695hO24PD6ykdGwkJ6UHwdRdHVbWq5ZGsnS2fzOg/l+2ycJJJgXmVhK9FrTtyL8
	 sjnBXaPj5MktmBkb+xmOuoVYF/XnIg9031Gyc0/Ied8RYWvObhjHaj2gndal+dkXGXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgBN4aP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC11606A320;
	Thu, 19 Nov 2026 01:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgBN4aP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEAA1F000C4;
	Thu, 19 Nov 2026 01:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052455;
	bh=Oo2uaQW3Bx30Y2xnQBphDU1lbBMsSG2v3ycCgDZAtL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgBN4aP2t7LDogod9P/pg5WymCSF9hqjICbMl8trajRHHhkBruF0+iCES2mRgf55m
	 pN3hoboDZX4pU4ZOq8xSYHiw3PALyVUzgbYtaolHvAGvs5NJszBYbv1NxvyXSWnnvg
	 qimUVgxqQx1cPkjlukOvHD6SNptE+yIsxBh9Vk5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0568/2214] hwrng: core - reject unknown RNG names
Date: Wed, 18 Nov 2026 15:37:24 +0100
Message-ID: <20261118150033.696693498@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index c3a2df67e0e99..2a92a651b290a 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -343,6 +343,7 @@ static ssize_t rng_current_store(struct device *dev,
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				cur_rng_set_by_user = 1;
-- 
2.53.0



