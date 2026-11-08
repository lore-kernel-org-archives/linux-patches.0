Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794156304;
	b=31g34b40x1VKPS/Bn9s7Eq+iuqi5ZXcA4kPTSIeJ4WmNsiFGEGO9tsitIRyU5xGbCgvu
	 KjjKaWPNGTJKgLIdfa/LbbsBCdsKyFxmzQm23drvKDcHz6RLnJPSLrwzO7c5QI/yfm8pB
	 GqvK4MoW74tE6Xfh3MapYbNoEGNjbEZTxF5WGZAVFm14xxb34lqcO3fh3pUj+3pq1eIDd
	 7BY6YmtHF1GPbNG1GlOzjTTNJoxb7+3vgkei2xf3SKxFlNzmrxkmO+vzpEhFzaK4KJ6Aq
	 4RCL3majtI8dZh2dx8PeGRm+OontJVRDmdk0PO7LR4NWifj9FS1BZtgpewYf6aaReSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794156304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CnM8dw9ystYfBj2V9oFeteddgcyAu/aArGQNcUeU12g=;
	b=Eo/NaA3DIWx52cfBRtF5393T5y4DVUquGjMvAcFiL6NXLO3nnm5iE/3R7A/rRyZROCWg
	 lLcaFQqaKVEHf0wdj8imfCdfR5efuWnA4IJGT1w2b+PDMJIIOuRDSV9e2edr0rDDni02Y
	 g7jtIFgOaf9Z84QAVOS7tqXoi/5DEvy4wNx1PaB/v+5V5aFQI/+3aZWFl6qPIHQOJKDBI
	 0zHUSRB3vFoFi1k/yIJYA/z23fBYlXxTNNnVYtNWaJp+5XfBOv33nurrOey3QKVpGuaKF
	 99DYg/4GxgkEzfXFW+536JOBCsFPOhKPA7p2QG5R+QlwD9V3FFc5JoLiDKhxDYnMfaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WfATwoiF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8B606A320;
	Sun,  8 Nov 2026 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WfATwoiF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B51F00904;
	Sun,  8 Nov 2026 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794156303;
	bh=CnM8dw9ystYfBj2V9oFeteddgcyAu/aArGQNcUeU12g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfATwoiFc6pgAy9MZCZhY7V7lijd46MOvTxcWohy/1/LWvyg1f+5UGN9e4028QKpT
	 j5o0zPE/zzmXk9qPrS0mEX8MrVVkCflx+tuRFAYLGad1j7FpeR4kyplcQ/3/ttD/Yq
	 Ma0EUcQXQtEEgILyhw6O6an4LrbQPHmF3oSf8lubbWFgSHKb1DvqW9G4AIMp3z46eA
	 wIquyp/wb9puidaI+fxX8YpXsI9zChg/Om9+BteG1reaCzEE7v9IExrXjxtRaBemC4
	 UV/avfa29SKme+wXLdVQhQJdMfj1rw1af81nf0+IPonhAel1p3hrKBJpDhc8mulN9T
	 w3RgSAXn2HBEw==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH 7.3 0655/1257] mm/damon/core-kunit: test invalid damos filter commits
Date: Sun,  8 Nov 2026 11:44:50 -0500
Message-ID: <20261108-rc-reply-04-damon-kunit-7.3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107183202.177477-1-sj@kernel.org>
References: <20261107134957.352235224@linuxfoundation.org> <20261107183202.177477-1-sj@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> TL;DR: Please drop this.  It has wrong Cc: stable@ tag.

Thanks. Dropped "mm/damon/core-kunit: test invalid damos filter commits" from
the 7.3 queue, along with its two preparation patches:

  - mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
  - mm/damon/core: return an error from damos_commit_filter_arg()

I also dropped "mm/damon/tests/core-kunit: test the size charged for a
filter-trimmed region" from the 6.18 and 6.12 queues. It stays in 7.3, where it
builds and its fix is queued. The 7.3 pair 29c6084658af + df7d9a0f8d91 also
stays queued together.

-- 
Thanks,
Sasha
