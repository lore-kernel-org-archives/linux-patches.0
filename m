Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CF01D6DB5;
	Mon,  1 Jun 2026 02:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279901; cv=none; b=kbvDsPqfKkKCRSD8sXALsHHckMvHSCLABpbfS/JvGH+g9DPtdqB4pgtmLdCoO/Hr5BqIzYuWPLRP/tdqNq4UnauFNjk/h9Pm4mPIOK6tIS/Dd05x6wHSHpRj4ykchhRLbSTG+rBbQSedITTXK05xf4MH7F+j89jrzWxlo5WZlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279901; c=relaxed/simple;
	bh=Pkeq+eAf7l39aLJncIqIFwo6NRQTKSn3Pgv0vOnjODs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTx7Y2ihXA+0rP89tUMB5sGGeqFW6ECnrVD6OyqsdaRv03ZBcDh3afjF9oJMQGXJPHpdf0XgXj5fZHn2Amkg6C7wXgAl4C1PSo4gNy/lpzNWWu0MNAwYJsGgUoXp0K2plxc4AnTXHr86SlYE0UW02+A1v8Yo96b7p9fOcvcv1Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMMMKBVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMMMKBVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6993E1F00899;
	Mon,  1 Jun 2026 02:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279900;
	bh=kkVniWLmgy6s0Pca+csbtIe3VFxiEtEXrLpJ0HvbJi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMMMKBVQBv832YTDX4StUhZtNzME/911vG60BVVEL6ghQtfOgQholtyvtUFiN/G3T
	 RiD2sVyPgVTjuBmM1V/34VaspUvY9oHvMg6nya6F5J0j3optXgCOc3odedtNwmbOIn
	 urEM1T6xtQg0hzjFxdzTyTk2x3LQh/1yc9dSZsNEPQUjFJzVGAT2z93FJSE0Qz5FNp
	 refOERhmVoAVCNop5Fs6WZCQr+eUNdxJLVAe7PbJEyhKHOijkK4/H7WOns0QsLqLVJ
	 7VQuNmwv9q3mX2Le+hgb6ByWMoY85r7yT5iY2JCk/PWCwcQyF6LIb9wYNrHnf/1Swu
	 dQLmd6qaW/8xQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 176/589] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Sun, 31 May 2026 22:11:24 -0400
Message-ID: <20260601015021.rc-kvm-vmcb02-dirty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <203134947f42d331eeb0f19c0849802c044103c7.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160229.512180199@linuxfoundation.org> <203134947f42d331eeb0f19c0849802c044103c7.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 21:59 +0200, Ben Hutchings wrote:
> Given thow much svm_set_nested_state() has changed since 5.10, I'm
> having a hard time seeing how this fix can work here, particularly
> without commit 4995a3685f1b "KVM: SVM: Use a separate vmcb for the
> nested L2 guest".  Has this been tested on 5.10?

I've dropped it from the 5.10 queue. 5.15 and 6.1 have the prerequisite and
apply the fix correctly, so they're kept. Thanks for the review.

--
Thanks,
Sasha
