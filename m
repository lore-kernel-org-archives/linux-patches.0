Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93941E5201;
	Mon,  1 Jun 2026 02:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279895; cv=none; b=chLo46hE2+vOF4njr8F0y87Yl6yz0q5YEZU9jkhrQWVgsaLESCcmUbffPeWcd/ttwl4qDMrQLR8PlOj86DZUFYKkhk3AXZxN5OAbfMqGt6N6JZ58UE7lfUiqySVTODYTDXfP2LpAKypSpiYNsDdv6dBvKbf05ZxqJqmfXHvzFUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279895; c=relaxed/simple;
	bh=FVy6UnIyXvnttxqiIkbX0iYQjVbQqivBmy3sYV+PTlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdym4/oRLkfvPTVANeBHZuXVaVCQKFhTCztzFH/Z1GFqGRogYIoICap1EUhksjDyY5QlNIVy020mI/BzilQLu5iYTd3CUBIGVsM68EIoKNmPyD+gwN9uUYwmr+17klKn9swPu415DYylJNpPkJrrs4czZ2k5PU19WYkRePKLLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBHlbkJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBHlbkJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF201F00898;
	Mon,  1 Jun 2026 02:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279894;
	bh=32GcC6d78qY3EWfUzzJx6rdgdcgMdJ9WWmSvcskMndM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBHlbkJqHaJfi5gwVywiTuCS+T+T4Uf9M0LqTk1oZdRnPgAbRhajKu/TNi9ZQJ82S
	 gOyPgxprzpJoKTb36UFrqKmYnIGYpGD3o9PmrbyXNQs34atA0Cr2WdRQfZ3dcNYBhP
	 xrfApXHhApg68R+PuvRaPS/SwZcP/nlhTQXAkl3WLovntojW1zTnP0nQbj2FkJ2kU1
	 nU9RTXhDMTkke6yY83vtkxu1CVRobGm4AeeAQ01RnAUhTxoxmap5EWP6KGU5vq5PA9
	 1ZChe6pVZiZXt7kBkyvsi7cwMSQRWc/zoiWJ80ria5vBx8W3sIZ8KYzS918QkijlTg
	 JQepUmj7iyKrw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 002/589] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Sun, 31 May 2026 22:11:19 -0400
Message-ID: <20260601015021.rc-asoc-sof-array-size@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
References: <20260530160224.570625122@linuxfoundation.org> <20260530160224.642881938@linuxfoundation.org> <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 2026-05-30 at 20:51 +0200, Ben Hutchings wrote:
> asize is signed and this comparison coerces it to be unsigned.  So non-
> negative values of asize that are too small will be correctly rejected
> here, but negative values will now be accepted.
>
> I think this creates a worse security problem than it solves.

I've dropped this from the 5.10, 5.15 and 6.1 queues and will pick up the
corrected upstream fix once it lands. Thanks both.

--
Thanks,
Sasha
