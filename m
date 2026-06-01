Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767F11E5207;
	Mon,  1 Jun 2026 02:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279902; cv=none; b=chrbpE8LH3kbkSYbFhE+HdDM1RdbrDQsUxwrIP6PSpGELz7Pocd74MPXAS4BCsDCtMlyLzp7JApi9wsAhKJSLlWJqi6ksKgYhhTMc1MqS8toyVUxpA9UvdVIwQILFDaq/zgakvLHPy2tmkYiTfXbzRHJ8wjDWKK1PPE0aBa5mk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279902; c=relaxed/simple;
	bh=qxJZR0Mr/73LEpka7tfQOszENcakreDhMX9afxV1q+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7QWw2eWEF9sYJlEzk7e1c75/uVJHqrSniT2xjXNNSKTbB3OiXZrkYM0cfEaJ48DJIZ9lDg3edIDq81MF3D4SP7Omb+wElQMdyjsgMhqGX3fthzqV/leSFuIUeSHVimSAW2CSmH+rHV5nnLqsdyZzPmCrC+rWVTH+XyzShCu7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1CUDDOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1CUDDOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7201F00893;
	Mon,  1 Jun 2026 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279901;
	bh=pB2bdseOGP+BXF3GchshTNmWccJc427b6yW67aOrYWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1CUDDOTfejdNHsfA3+Rcntd/0+Wk79GHEXCXqPmdtz6dkzHozYbNnK3UVgrnCkE9
	 bjQjzw/0lwcrOxy2O0xs76Yiml3QkAUimrlrUyKGBZ5omr5A4t/kzOTJ2mqfe5PtLN
	 3sXQN+xHa8kY0JZumzhQKvrxR/11YLmkfwnYAeaXWKFzmptUxjOfUfDr0mr+qmBphs
	 AV3so9Gum4b54QCwYfnDf98A57trfCWLKDgs4zEVNfpN3gNwNA7BQv3ZWuVt1n0SdN
	 HnAjKCH2exqhN+d2yYI/dq1JK+9eQ1f+2NrjdjC+frzaMf1xpZHHtBI5WQlEW/IkeK
	 CCmqBbSu/uk1w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 177/589] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Sun, 31 May 2026 22:11:25 -0400
Message-ID: <20260601015021.rc-kvm-sync-nextrip@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5903b777c7688dd17f8e4eb173361c80ea0fff46.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160229.538712833@linuxfoundation.org> <5903b777c7688dd17f8e4eb173361c80ea0fff46.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 22:14 +0200, Ben Hutchings wrote:
> > +	if (is_guest_mode(vcpu))
> > +		svm->nested.ctl.next_rip = svm->vmcb->control.next_rip;

I've dropped it from the 5.10 and 5.15 queues. The 6.1 backport places the
assignment after svm_complete_interrupts() with no preceding guest-mode
early return, so it's reachable and correct there.

--
Thanks,
Sasha
