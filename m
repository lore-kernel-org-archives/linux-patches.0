Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793C521E097;
	Mon, 19 Oct 2026 00:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792368865; cv=none; b=OKQZaJBoQHFrjA1N2i9AzsdjRB44RrUtvm/omCm7jDLestAlyxbI3rIdUigSuNhgXJHh5soXWGJMNW6dhwqjzEhJVPVK/sbE1WYnJ1DSgvyXGDD4M8ReFpM8Cy5UUdLiNy3481KeX3o3+J4VW0waevtg3aXZ2hAYrHK+FVamfiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792368865; c=relaxed/simple;
	bh=5ONj85UNZ5/AYyBrXlv+6JpoIXIrA5Kj0wOIRByhvVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRyjHFrGeWFq/jZzWljvElSNpp8q7pTjZeLB4wYMNVb10YCpYuqoO1EvDspruTTWRQDU28Xr+pm9mct48nOxFNSdZlL0kQxtC7w/DD0IgnFRdGFJW7wDlFazUg1S6qdye4CTdWTIeXrSG2TfM6lsOyFZ8Y3zjiw9E+QsVAt3rhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxBHnB5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxBHnB5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0211F000C7;
	Mon, 19 Oct 2026 00:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792368864;
	bh=J61A+djtFkc5urj4x84SBOja1nB+TLUFUWdt6fOUggE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxBHnB5LCWWmaWYvkUQfsgiteAFUzIyx1ESxbCYfJ2BFbX6b9dUb45PICklb1FDXE
	 kDmjeCWET8qQ2otQkF/qU1P6UhoyTCU4VoXFu9IhipzhH4+Qodap1OlvlMDxKsMS3U
	 AI9GP9zhgB1sI0qL3Q1hSSDPrfDpCBdG49vvWgnhEKTHqrnJllZ/ROvOTstF2wFz0F
	 w25lHen+18pfcG/8FXUmqeaPfeNkgDoeY/0U2jSlj49BNn810OUTnK6ZykxF6yJc/m
	 qpa8dliSjlk0CQKMG2rhfnHN1oek/VHLkSAohbmSH7woIXGaRyM7UndXeUnXx4MZJP
	 i3ePOeNPoy3Lg==
From: Sasha Levin <sashal@kernel.org>
To: =?UTF-8?B?6ZmI5Y2O5omN?= <chenhuacai@loongson.cn>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH 6.12 590/869] LoongArch: BPF: Refactor jump offset calculation in tail call
Date: Sun, 18 Oct 2026 20:14:15 -0400
Message-ID: <2026-10-18-1-daily-reply-0004-loongarch-bpf-jump-offset@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <704712fd.8bf3.1a14cb7e0ba.Coremail.chenhuacai@loongson.cn>
References: <20261017160036.979869304@linuxfoundation.org> <20261017160052.180362519@linuxfoundation.org> <704712fd.8bf3.1a14cb7e0ba.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 18 Oct 2026 09:54:41 +0800, Huacai Chen <chenhuacai@loongson.cn> wrote:
> 6.6/6.12 doesn't need this patch, I have already point out.

Thanks. I am keeping 37d545d12f21 in the 6.12 and 6.6 queues, because the
commit it fixes, cd39d9e6b7e4 ("LoongArch: BPF: Fix jump offset calculation in
tailcall"), is in both trees: f83d469e16bb in v6.12.43 and 17c010fe45de in
v6.6.103. The emit_bpf_tail_call() in the stable trees still has the
tc_ninsn/cur_offset/jmp_offset macros that the patch removes, and the
CVE-2026-89906 announcement lists those releases as where the issue was
introduced, with no fix yet.

-- 
Thanks,
Sasha
