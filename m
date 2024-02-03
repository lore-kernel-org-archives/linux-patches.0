Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD01CD02;
	Sat,  3 Feb 2024 04:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933530; cv=none; b=OZHKexk2I/r/fdtgbp9xwabCceXkiNFW1i0Jsj078Jl0CrOHN8RsK6ysDFyB88H/EyVCbQwmFNOym1CopTkSKQrBqAvwXeLHuPr1YRKZu9JtmURc1o4kS1cnho+Ip16CAL5k+ykUmfaoBWLuv0ZP1WihQP1IYeQ8TmowlYj9GlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933530; c=relaxed/simple;
	bh=MUbqWZS7muOS56gwd7/asman6apKqUz8TqaiToBKPG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES4iOXfIgoJm64VAGBXl7FBRMFW/BWnkvLq4izU3d9rDRlZpr8J6Ftf/u6WwdZPRbJBLmbHl2xWxyQ9noKepCtUa5tJg8M+QhgKRStAO2D8X1H9MXl8W1TRIQQYxOnjrul2zWRnVZDx0vZyngMXy46bdv+lVNCShkfwei6wI6vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av3XdACO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av3XdACO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F044EC43390;
	Sat,  3 Feb 2024 04:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933530;
	bh=MUbqWZS7muOS56gwd7/asman6apKqUz8TqaiToBKPG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=av3XdACOBHwVIO7JRIZ7fUPk+gcdKQ4GpjJcHkG6rOiY6zzrotCU15hfEzoxLXS40
	 sbk9ERAIRLnFhs+N7gJ8ATz4/Q3h6/J+l9cuJWYjghcLk/X9vlwoo6zYKK+siCkMg9
	 Ryfmnn2kpNUhyWASzYMcnd76GvaYPTByOTjSg/cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/322] crypto: stm32/crc32 - fix parsing list of devices
Date: Fri,  2 Feb 2024 20:02:15 -0800
Message-ID: <20240203035400.306417403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

[ Upstream commit 0eaef675b94c746900dcea7f6c41b9a103ed5d53 ]

smatch warnings:
drivers/crypto/stm32/stm32-crc32.c:108 stm32_crc_get_next_crc() warn:
can 'crc' even be NULL?

Use list_first_entry_or_null instead of list_first_entry to retrieve
the first device registered.
The function list_first_entry always return a non NULL pointer even if
the list is empty. Hence checking if the pointer returned is NULL does
not tell if the list is empty or not.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202311281111.ou2oUL2i-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311281111.ou2oUL2i-lkp@intel.com/
Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-crc32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 90a920e7f664..c439be1650c8 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -104,7 +104,7 @@ static struct stm32_crc *stm32_crc_get_next_crc(void)
 	struct stm32_crc *crc;
 
 	spin_lock_bh(&crc_list.lock);
-	crc = list_first_entry(&crc_list.dev_list, struct stm32_crc, list);
+	crc = list_first_entry_or_null(&crc_list.dev_list, struct stm32_crc, list);
 	if (crc)
 		list_move_tail(&crc->list, &crc_list.dev_list);
 	spin_unlock_bh(&crc_list.lock);
-- 
2.43.0



