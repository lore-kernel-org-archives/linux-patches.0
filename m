Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144D156260D;
	Wed, 14 Oct 2026 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996817; cv=none; b=Ir5ZxrWf3NdatbKWeqP3Rkcn99P7Fjn7pT8WoGrgsf+7SwoBpNctZU3NvUP2d+1oVpP1pSWq1rvY2Oq6IJYWVuQZrLaYX13FALMRXceuevdkkKl7LOi3zdg9MxDbxnWN71qe18y26jk+xu/HRb0wVPvAdH0KXDo3aQuQDoUOLh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996817; c=relaxed/simple;
	bh=e+5XkhbXRff3LYjCjbbmwuKhzswhzVE5vgyfGJ0CT/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiPC/T79mCUkxYApwlk53n/RSw1TvUzbk0b5b2tBsp+2yGSJgdysM54YCn8vyTP5VOsCJNrceX6ir/d/umrfhYFS6XVJYlJHYriKlfSZAhCsDHpUyDl5Fb7dbZCzwLuyRgQ4CPuSmJMvsXPu5iym4irzLmYx/+vykWzEQBgNnBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ng+mCMQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ng+mCMQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD1A1F000C4;
	Wed, 14 Oct 2026 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996815;
	bh=Aabr/GHIoZvoXT7bqh0br37LzhzeOfwcF/MXkN3nPd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng+mCMQOG1fcGSKaAiQw7LrfygLVWlYeQkSN4WHYdvZtfIVZI3uawSpINJb8V2oVd
	 rKmLu8f75KEw8IwibmgGlnZVCUY0FUCUSzgejlL37wpfs8B7jazd1z5g0v+M3iHsRF
	 QF9UsRnXTsn+5FbuoB9G5LUx2AxZdG9zfRtl1b1BHHwEXlwCN0GLjRIhH6LJZSFIZ7
	 FTdItepay7wPGB07CrKr44vgWBY0k1VaoLjLirZ4mUNPM6WuYNYAiEBnm5f0tYjgu9
	 nZWQkIJf5xxQEXQ9dU6DFRjaHtWOMel7ALAWfkwTNEyo7o2lcJ9kvhP9rygHpmqM3f
	 u0y+Srq4Q9sWw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Date: Wed, 14 Oct 2026 12:53:18 -0400
Message-ID: <2026-10-14-1-daily-reply-0015-ice-drop-page-splitting-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <fce25d6d-8fd7-4f83-8d8d-929871aff885@intel.com>
References: <fce25d6d-8fd7-4f83-8d8d-929871aff885@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is intermediate commit, if taken without
> 93f53db9f9dc ("ice: switch to Page Pool")
> there'll be huge performance regression on all ice cards.

Thanks, that makes sense. This patch is dropped from the 6.18 queue, together
with the other five ice patches queued with it:

9e314a3c525c ("ice: remove legacy Rx and construct SKB")
3a4f419f7509 ("ice: drop page splitting and recycling")
a9c354e65659 ("ice: fix crash in ethtool offline loopback test")
02852b47c706 ("ice: fix rxq info registering in mbuf packets")
e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz")
436fa8e7d1a1 ("ice: fix broken Rx on VFs")

That leaves 6.18 without the XDP frag_size fix (the fifth one above). Could
someone from Intel send an adapted [PATCH 6.18.y] of it for the 6.18 Rx code,
without Page Pool?

-- 
Thanks,
Sasha
