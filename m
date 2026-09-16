Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE753AA1BD;
	Wed, 16 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523573; cv=none; b=itl0EHWLHsjUE0fG9EchjkjDv37PxaiYe+P6nHyjVJqZqpzt8OMmPw32BmI160yw5m21zwDvf8BUo/O7dCu7l+rbVGNBiQ+TnLazeBl1yhlmVwYbzMBJeoYA46DT5G8Io+COY/HHuHbnCpFX15PqVN0Hu8s8TBPSiJj4q78qe84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523573; c=relaxed/simple;
	bh=mTUdh7xTuC/WWeP0LrdMzxlIzrc7axeDPP8j3IZJ2NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnaSNvQe+cIMw5y4KyWLSGG7CRkK1BUF9pNPHN9pZYhl/jxo83rLkcZVRwLnkun30WwKLk2wIrqZ89bK67MbWo+GrJn9jRBIm7DjOQrGmguCSdZHQycw6NsaZON4J3UFhN1jF0VRsiIVzWR2/oXzchH7RqOuMWj4NQsnhxsrP6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2q5YDsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2q5YDsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67431F0089D;
	Wed, 16 Sep 2026 01:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523554;
	bh=NlJuFRS2Hd5Q9+kDuRUqYVabD2v/L6sawEeE1aCEpmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2q5YDsSi7Le2VAW9xsp1k+tN2LEeXiQt2dXegBanI9xKgp3mHmHsKySsWyweAjSN
	 JuYAVSFOR2q4bw367YbJXGj63tCC6ziHgbKcWiL7ETeflOsw/L7tAuWSBc8OgoMRJu
	 l+P2/q8A54taPQphrIQfuu9QIHqwN91DmmxvGt3HsmiDDZKMe0pAqEW0lg9bkg4cRJ
	 b/nkAL1zQPn6OTGKpB2ypGDdUeqEjwLEDPNy3g1cE3n9XH8aWgvRuH9PCT+hlIkL6g
	 ivrTdSHS37U8ivB/H5kNCYPGidTKcZyb+cRwYxSd5HIGxGT6lXi//Ss229z0qNe1iL
	 RkwkL9kYvuLrA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: Re: [PATCH 6.18 0547/1518] cpufreq/amd-pstate: Add dynamic energy performance preference
Date: Tue, 15 Sep 2026 21:52:14 -0400
Message-ID: <daily-reply-20260915-0009-re-amd-pstate-dynamic-epp@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1789495960@msgid.manchmal.in-ulm.de>
References: <1789495960@msgid.manchmal.in-ulm.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This introduces X86_AMD_PSTATE_DYNAMIC_EPP for 6.18, while it was
> already removed again upstream, in v7.1-rc2-7-ge4e9b7b38d5d
> ("cpufreq/amd-pstate: Drop Kconfig option for dynamic EPP").
> 
> This is a bit confusing. Mind to shed some light on this? Perhaps the
> latter commit just didn't make it to 6.18 yet?

Your reading is right. e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic
energy performance preference") went into 6.18 as a dependency of another
fix, and the removal never followed it.

I am going to leave 6.18 as it is. e4e9b7b38d5d ("cpufreq/amd-pstate:
Drop Kconfig option for dynamic EPP") does not apply there without
da8afb1c666a ("cpufreq/amd-pstate: add kernel command line to override
dynamic epp") in front of it, and that one is a pure feature addition I
do not want to pull into a stable tree just to make a removal apply. The
Kconfig symbol is default n and is set in no defconfig, so on 6.18 it
changes nothing unless someone enables it deliberately.

-- 
Thanks,
Sasha
