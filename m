Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7C7429CC8;
	Wed, 16 Sep 2026 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586945; cv=none; b=kq82HeN7q4AgZ44NyPdR9yYQrPQh3/GrzYeX9iyrxzfAPPIlb7Tuv/eWKpx9v62kIUqFRov4cBhNAb/v5o+COKMlUdpProOsYnZfZ3mMxGTaBlUMLxYgXaajhC1DvBH17EIPC/44BGPvt41SaZkm/0O+AzjvbsrZJslnwnuYmdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586945; c=relaxed/simple;
	bh=GtJHQXR/X7Gs6LT4k9czGWlY/A1jviQK4+QSH5/ZM/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ3IFpmt43EbUlwcr/g2uSE/TGPV7VSrxT37EDGkl8l0BQXybka012Z7TPDxvM+YdIg/wSxA5Dokt2TqzMAZOSPUQ55L/dQf4qY6G+9R/N9SP7djxnvz2ScTYW+qbPTQ1NDWqn5E9ksPYlCpnaKO8FpAubmy1iSg0Y7m55h46lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFYswTK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFYswTK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209921F00893;
	Wed, 16 Sep 2026 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586919;
	bh=KcyWRU7KE0zNk0j9XanQGIxj44q9l2buKAroOsIXLDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFYswTK50yuQ6t09MJxFot27mtUhWsESaRfm44ywsyNNENfNAVkCYOSD8wWXoQyw3
	 5JfkEQjdK5WboNm5hUoPQvw0A4ByzLP8URDYY1IvEohYpwvznQIfPmiaGvbkyVI1D0
	 d8pClZRb2COInVGrlMnCRmeT7oo0qJFV1zPec+7W7oVRqQzA2f0A+2Bnse5tLcz2f+
	 X6esiVBjA+KD4WDpEU9HtkT+zBX+V4KslFMGXeeqdjuGsh8RQ3ZdtIu3qSsOIR6jiI
	 +eIGi4oyC/Jjjnfz5oKAap/enWD2MG85qZ3j7EvRSb/G8Me8tdPn1qrtt1JvVrTC0E
	 dSLFpQytqlP4Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1291/1376] selftests/mm: report unique test names for each cow test
Date: Wed, 16 Sep 2026 15:28:01 -0400
Message-ID: <daily-reply-20260916-0011-re-selftests-mm-cow@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <08d94b53-e012-4757-9f5b-7b5732391d26@oracle.com>
References: <08d94b53-e012-4757-9f5b-7b5732391d26@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses 3f192afbede24c60e59db1272ad155a3a44f5fe7,
> "selftests/mm: add helper for logging test start and results". I suggest
> applying it before this patch and rebuilding the MM selftests. Thoughts?

I compiled that route first, and it moves the break rather than closing it.
With 3f192afbede2 ("selftests/mm: add helper for logging test start and
results") added, hugepage-vmemmap.c and khugepaged.c start failing on 6.12,
and 19 translation units fail on 6.6.

So the cow conversion is reverted on both trees instead, which restores the
build.

-- 
Thanks,
Sasha
