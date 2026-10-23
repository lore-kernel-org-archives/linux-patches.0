Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785798;
	b=t7EAiiLL6xMnOX8XRGuL2WsdJ4OtuCyI3+MgpNZETp62ju1uEOMGkJk+Zsefkpve7jWi
	 CcWajuQnvUwlVroKBxtSa5mrul6V/YrmbNMrSCu4r5K0BhXAvPRuxRWJGqVbd3ZSMI9Ld
	 M6//ADrO4VTUp4YoQYC1o/cVKCDtqAiMiRh3GgqkBdodZi3suA2unL2SrK5KYmfVZrrtQ
	 hqpzmwmRZ92U2kBdOw+NTwiw4IU3Q5qUabMuKIh/bVGP1ZWjHYsVXCkPHmznHFaFN287z
	 Y66hsBoAxOdvyPZ8ZnivRFM8O5+IssxRBEFgJHnE2ezFCAkBkTRnMvkuwUCffBlKvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=I7KwAjJ5WPe5PJDiUy+9Fs5HvZU2t0Lk7/SKMphLOIo=;
	b=SopyKAnWzRQsLRjevEwfIjfh8uEyqCZB6k5J0p45+ZRgitw7qh1mJIHaKnl27fkLTBvp
	 Hun9gBb38jchr6RetPO1ZjGZdOnQmnavsPJESmt+movaLZXJJe/R7UWyHeBNh73Y13x50
	 5XYBL1bxloOMFju4pn8Eg8b2XB3wuq/k1u+J9IUY6TgyKPbja56rKgadH/r3ISY0nZXkG
	 1TmNufvEJISAEKPS5qkDAZiazFusR90A/aB77rDYeQCFy3b2joAWVZQoAqPEwj/UGbInC
	 iNF/DxXrL90aBz7CTQTGbyWqRXV42c0Jj0VAw8/OGAGVDGmJT/sxe6mzd+UtQWNwcMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jQhw/tfY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DBD606A331;
	Fri, 23 Oct 2026 20:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQhw/tfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A5B1F01825;
	Fri, 23 Oct 2026 20:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785797;
	bh=I7KwAjJ5WPe5PJDiUy+9Fs5HvZU2t0Lk7/SKMphLOIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQhw/tfYhTdLvA/woFK2vV5zcntAuBlzbWIezqYZCdN8rxd/Uz5meXILqi/58RVEQ
	 mP6a6GgkwYtV4wrTueZn8jDlwonyk/vVJZhy7M/VWCbZs046M8iY50Oc9a5ecYN9bC
	 u5Uo8gL46M+ALPxOdcLOAeT0WYDPYCZuy4rw+xaOwvi3IgahD7a2zHXK/tKOdv1ER6
	 2ZnkFr8fBJvrgTor8jpmgpQMZT6uXCN2s5wFttwmlQ14DwDtAcSf1+5c2FBDmqLFMe
	 UQmvdebriPNCkB4uxQ1Z3ImycuE2SDXYuf7DPYZ+Ow6eovE86BRdPss+HarxEM1U23
	 v4wwcfk8KU4rA==
From: Sasha Levin <sashal@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Date: Fri, 23 Oct 2026 16:02:54 -0400
Message-ID: <2026-10-23-1-daily-reply-0018-ice-page-pool-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
References: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
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

> After deploying it to a machine using the ice
> driver, I noticed a huge memory leak. It's easily reproducible:
> running a flood ping eats about 1 GB of kernel memory per second,
> effectively killing the machine within minutes.

The partial series that leaked is out. Greg has now queued the full ice Page
Pool conversion for 6.18 (remove legacy Rx, drop page splitting, switch to
Page Pool, plus the two follow-up fixes), so please test the next 6.18 rc.

-- 
Thanks,
Sasha
