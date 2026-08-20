Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADCA481245;
	Thu, 20 Aug 2026 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248191; cv=none; b=YE6fVEXla+K3AiULMNaoGTbwx+vfpnEeJRndKEevIXLn14OncGz4muSMNW7WGn9SKuYKxzS7NvcWGjfQmj84SWWxDcNesdjNybNPdWwlIqv9E8Nady+wkkOjS/ZJqvl0JrARV1N9Ckbqr/GQOwzqydtGo661pYc0zmM5+kZI6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248191; c=relaxed/simple;
	bh=CZYv86HYaa29BONtyGFq/fRgx37GEunKrR/JSwez2oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEomZFo/37QCPLJuBryM3huzJK9lWKy1p2457ZEy7bF7yf1vgK8SkM29U+OiYYBUhST6wjSdGq/2/rlLp30HfIO2l275LTzM+i/Z98oXorSQElOG2e20cAaNv9+FE/y/LRGZQq++x7+Rzsth8pIbhDEfO/3ApmttMjN1nk7eZyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk+zkXpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk+zkXpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475BB1F00A3A;
	Thu, 20 Aug 2026 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248189;
	bh=zQMtN5sgbesXgBMWQ+rMmvQhrfhdW61FoTFix+S2vqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tk+zkXpmY/JKRWZBq1ed7jJ/xWM6EipR6m2eA0F8B5ZbKChwDNhgKocL7qiBTxfl9
	 q/I2IfTfcvbbkaZmbbI8rzzYvqkHtCjhGHM9lr2pBDxAA4E/HVyMfv3Qiw5HWH9fYo
	 /LJ3sAnifQL3oYXvQCy99CNNGUT7VbeZleYCEXCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/303] dm-integrity: dont increment hash_offset twice
Date: Thu, 20 Aug 2026 16:54:36 +0200
Message-ID: <20260820145257.490245816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit edf025f083854f80032b73a1aad69a3c90db236f ]

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1499,9 +1499,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


