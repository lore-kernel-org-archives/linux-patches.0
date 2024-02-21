Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E206A762C1;
	Wed, 21 Feb 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525274; cv=none; b=eZMOVWIp+As6Jpi1P7roPxS4EV4+VCy3KWmU66DOANCRMx+toEsvoItqhvK++HvuFA+1lo8v7OKd/9Soc7khEn7HIpXllfyaR41Kd9vpxdoKQSqolhCsYlX7kO0flq4UFDBbC3VEZ8x7h0gzRC9eWERd3uYs8qAEmtJr2bcgq9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525274; c=relaxed/simple;
	bh=Jd8o9YDeoLxmL5v8KEmy6SroT9rEhXTrL58epA1AGQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glsLBCwsfW5mz3UZU7kx1Gi8iCODZpn22l5ROE/8DUPzjHhgkkOjNNN244yAAXQ+1emUPUxmZXaT4qdWNyq0s2qAD41jXJXAE2WtVTwTGZSFRYsdrQo0EuXcEc/B9MQ+Wvn8qFAUH9gtDKhQ2/aQc/4qi/OIShfRKKDd897WWBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5ktIJ0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5ktIJ0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C2C433F1;
	Wed, 21 Feb 2024 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525273;
	bh=Jd8o9YDeoLxmL5v8KEmy6SroT9rEhXTrL58epA1AGQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5ktIJ0HqwD2Kv2Fyvk/wFUdppK9d2TBx1UulvT9DkwVrDT8CYlozLW420m677UZU
	 PlpneJM9f/Z5kbMBaA2yVW3d6EUnXJlBejW6PgmmB3ULR0ZRiKoQ0MlYZMRoQGpY2f
	 jiaslqapmHqH40XADCr41oWXaN5h8btimXz1bAaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/267] crypto: stm32/crc32 - fix parsing list of devices
Date: Wed, 21 Feb 2024 14:07:00 +0100
Message-ID: <20240221125942.456295302@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2ecc970f5cae..b66e06818afc 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -98,7 +98,7 @@ static struct stm32_crc *stm32_crc_get_next_crc(void)
 	struct stm32_crc *crc;
 
 	spin_lock_bh(&crc_list.lock);
-	crc = list_first_entry(&crc_list.dev_list, struct stm32_crc, list);
+	crc = list_first_entry_or_null(&crc_list.dev_list, struct stm32_crc, list);
 	if (crc)
 		list_move_tail(&crc->list, &crc_list.dev_list);
 	spin_unlock_bh(&crc_list.lock);
-- 
2.43.0



