Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136B137F725;
	Thu, 30 Jul 2026 02:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785379259; cv=none; b=PMS8joInXPN7TW+NMBsewbdPsWpbesnPu78TX5Klwl7nYrFTx1s4qXD/m9fqFGSIh9we3abDg3vzhnmI9jbzv8/RJ5Bw14EzgFxLmIku802btCUIKOlfyb9JhZpnAI/gXjAw9NLfyBKGD6GklINKIa8eZrk7ZoNBkQ1Xg+mTbHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785379259; c=relaxed/simple;
	bh=Pwvo04QYWaWQtxTM3ozRuTUDHanfWiYa6BADc5UQzSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOMOhhZopGTKD9DJmTMR4ImKCKDSj4Od5/uw8AmPCAKtz9H7tF0t+0oLuf2cfUCN+cQmFF+BaF/MbCrNLGnzKSb2EExn2rddx7hoYDRlN9mdfOZc+tgpFeXpVWA+lsAyiTI3P54lH2Rp13QIebw2CPEudFar9/Yi7XjrQKAZChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXK7rTuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXK7rTuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9111F000E9;
	Thu, 30 Jul 2026 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785379257;
	bh=3ngty/gw3+ILuhFoymP8B4SNLHoSzISvwWcyB0HQfRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXK7rTujz1xBiJ5fLKvs9VNfbei/aMqp6gcnskPGnAfVrv1vtEhx4wJXhMo/1/qLK
	 UOUpQjRswvLrXPYjkb+fvZz6hB9DbACVwzekEuPV1bAe4Pg3FUCygTuXXz0Q+6VMHh
	 m/8uM+xCtVzyKlxHrGYZfOMBdHuvq28xpt4jst996hcoVtMlZTwJZZvkF8jJF58KZE
	 0zF4m1oNtAokJugn59XjgLph7hZgXQWqE8ennDjIW1nscdMtXpwkZnzCnqiro3oJYW
	 Bmw6eYXIvxiyvCeY5bCsXLab0xj0o3nNZrCnModuptrzEFFdxWjAcc+6qnifUGwb4c
	 oHjxSq0ZDpbMQ==
From: Sasha Levin <sashal@kernel.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: Sasha Levin <sashal@kernel.org>,
	andrii@kernel.org,
	ast@kernel.org,
	gregkh@linuxfoundation.org,
	kpsingh@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	xukuohai@huawei.com
Subject: Re: [PATCH 6.6.y] bpf: drop bpf_lsm_getselfattr from hook list
Date: Wed, 29 Jul 2026 22:40:23 -0400
Message-ID: <20260729223316.stable-0030@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729145157.2065278-1-guanwentao@uniontech.com>
References: <20260729145157.2065278-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.6.y] bpf: drop bpf_lsm_getselfattr from hook list

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
