Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60DF2E92BA;
	Sat, 12 Sep 2026 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789246824; cv=none; b=aGU90cObrPROJ1KImPraomMVrkAsPBqodncNowSn1jQOyd3zwGlEThzRXOP9YYWyBE7Bh3FFD4vdNH5oEu1Q9RnSCyL/83PeTR/F7i9zGPytEH6rlZuukQYpPkJrBRRuIq8xMF/NKhsEZ1t1hRys8QaFgLgPtkUMa4a2SH8kxWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789246824; c=relaxed/simple;
	bh=3MnUZlmf4QpsJe4wb53VL7PgFVVElxtFaCNEt147H1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPXtG+ZyZ2ByPcU15P8QJURwYXID26VKmTTicbRthvibv1v3l+RgdNh80D8Ggt/mqFUDesgkWoEYhxUlq1nbt8zQju9s2hYNTO/wCAOO5AKDL266ZN/aWJJLVqtu9rm4p+Dzpt8HaAjkwEpdlXsVUGC1A075FMTDnGcmB8GY6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3gxilRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3gxilRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB001F000FF;
	Sat, 12 Sep 2026 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789246823;
	bh=hHHsVY2BTWhpkWeoHHc39qcKvdgdZPNvcXyQAxgOMz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3gxilRUJj3bGQeyV4Mv3fHqSeeuKjTsenit2xhTClNnuolbsgXqppSgxsfaeD+bn
	 NgnEKgISXywlhgLOTR8gMIPbekXn4zO2bRgJyqGRUnQqkArXZQBs4nv4bcPnt77GjV
	 7J22CzG3ftjQWFq7+Audjpd9sXY1vXqkstg+AoOkvxF/s5Sb1BrIrCBX+oTiZOfO6G
	 4fHrLnxPK8Ytf9D2w5wd1wUQO+qTG4jJV3uUQARaUZrc0SFHxJGFgQRn5auzobyRRW
	 goypy4vW0oZv9ghKfFcgOTyOS7OWCdho5tHfnQRo4k+U+fbVmEOvAMVQ6EeYNhTs2L
	 seezaZdvI8+cA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 7.2 1226/1815] btrfs: fix a lockdep caused by path resolution during device scan
Date: Sat, 12 Sep 2026 17:00:18 -0400
Message-ID: <dcc66186d3b44474@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d460ffbb-5db6-4029-b177-9273a8261453@suse.com>
References: <20260912065648.999753832@linuxfoundation.org> <20260912065717.791396667@linuxfoundation.org> <d460ffbb-5db6-4029-b177-9273a8261453@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please drop this one.

Dropped from the 7.2 queue.

-- 
Thanks,
Sasha
