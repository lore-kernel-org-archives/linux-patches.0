Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F48B408023;
	Wed, 16 Sep 2026 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586953; cv=none; b=l+DRdnKKvVFYzyQ6AtjfDgFuEUXgWIPSvRwfIS49/3O++uREFfhR+SbYmbMIszfU5VBt/gneduDRpkBpOdcerAxd3VJDJrstdLbRgYUzd2YINO7pQiYkAS+meskV3qszJEC5sOFCiIUcYlapAHYtSFH9osPRQ4img9vnAZOHDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586953; c=relaxed/simple;
	bh=F69HD0gL6X3qTaHfiUiB2ND10TYSqfBKJ35/XNHeeO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQUQHz48l+rHuw4riIyk27DyqFi/YEoBVCkphsmRTRwe+gB75jguWAwC+7L4AStMe8qjcP1/KgvvSaBcduvcUGU4AqQNbTcnycBH+WzuIPg1pWPq/ywtr0IbI+fpawvPc9XuMLwYMt6QNFGTkMpyjdgxaAEyMfLQA1XBgvMvPOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MogLI7nk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MogLI7nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572FA1F00899;
	Wed, 16 Sep 2026 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586927;
	bh=zAmqPz4EIGZ3CzbE6+ISTpJlKdp2H+z8OgLsnR6fIwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MogLI7nkZfTZeObT4YA0zQTNgb2WCUsxSQEeO0lVqgWK4YZi52dJgTIjUpYFJ10vL
	 HkZ7tM9HfCaupEcrc/8NRnx1p+1flKbWytkjbbzvXOskMQa2e6+tn291jMo2XptD/P
	 ZR5CJb+wgJ5CPMJLHkm5zDJjcIWNNUHOrfWwcZSLS2OresKHDZPYRlsxKVLUkEjl9E
	 u8rK2nfjOVbEaGFIgQBYhSmCGqWYH41mN8qtGDshaKRgRBrJI3dR7M+bLMrWU+MdfF
	 YZVg7CsKhEQrpMGBzt6ueBc30u8J+1jr0rWAqWuj90B/V4jl6QNIDR2ujfG3qzrzxe
	 E6cnlOhOzJ14Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1031/1376] xdrgen: Do not declare union XDR functions in the definitions header
Date: Wed, 16 Sep 2026 15:28:07 -0400
Message-ID: <daily-reply-20260916-0017-re-xdrgen-union-decls@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <28b2ad9d-520b-48b0-a4df-d940bb21bbb5@oracle.com>
References: <28b2ad9d-520b-48b0-a4df-d940bb21bbb5@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses f7cb94fad4e6cec354a3ea779f91fe5560fb72b6, "xdrgen:
> Fix union declarations". Thoughts?

Queued for 6.18 and 6.12, thanks. 6.18 had the same gap.

-- 
Thanks,
Sasha
