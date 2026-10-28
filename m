Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210831;
	b=lBZwpPoeV+yCv7ZdlbMpkvzo8FiS+Xa583RReS5+VE3CtdMZDXrVQ2UEhTKnFEQXG/e4
	 bK6edH+UM23YqJivfx9tmi+npUHtRuaqbhKyo8BGOCDE6o+s0UAR4Yc+uLxP6b+m7UFzU
	 wqdD4NIRZjkB5CQ1xhBFgW0PsnOFS/w0IFz02oBS6010eIHfz6TCK2hNmTZBti0Cz+WF+
	 LP3GINOXuN17zfH3WG3bFz9urjE9beefHI+aU57zWsvQFBn1QS/bNepZH0RD7H0sBFHe4
	 fbPZgZGV8ponQ4KIT1A2nA23v9dlmh7L0S2giv3udlLNUwPH8dgr+LLlgCvfKE4mSJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=263/UqzwLp/hUO8VXXMSHTcpmMhJYTAxeC7Kwhgp/zk=;
	b=kTH6GmhxCS0kThpm6gOLxoty9E6gd6xLecusaHfVvdLOGLXsQTJIiZr4yGKd40Pf61N/
	 92V4va4BR4eRtXCcBrq092r/SdNm9PL34CYmlh505o5eUPiU6kVNLWPef6pbzijZeuLB+
	 CdaVQSbX9bXJEWq46JZYqcEFJhoBhOSbGkbZgmNVP+KR9rNX85bkCa+H3s9uSOOtQA/o6
	 611/AL78mbD5HOO6YX4qI0qLuzhjgGY7EX+9Y1D7jkTwDPEDkI0BI8z+hB+C1rgSy7yOn
	 nIZ16BTYpT9q/CUEJzWtEIOAbsA9MRjCxVEZ4VVc/OA5EsdTV0Iym9y2OvgZNhR1Kbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRYfqDWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67259606A31D;
	Wed, 28 Oct 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRYfqDWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B867E1F01825;
	Wed, 28 Oct 2026 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210831;
	bh=263/UqzwLp/hUO8VXXMSHTcpmMhJYTAxeC7Kwhgp/zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRYfqDWVqSxrIZDw/zTIzQvVS6KehOmj3nCOubaSiq19jCnOBpS6k/ZuNKC2edk5j
	 KSFLlxF3wY1dNS02yXGKla1DnDH7o1sKq+tRLDzBJFrBnugtgEtrbhdoRrGY5EghjG
	 jiAxy4XvAYYDxfvQh3CJLs3n/Zi/lp8ZZRhtaMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/571] mtd: core: call _get_device() with the master MTD
Date: Wed, 28 Oct 2026 17:55:10 +0100
Message-ID: <20261028170011.884586594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 5333d24b8c972..f0fb91a5ca600 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1158,7 +1158,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



