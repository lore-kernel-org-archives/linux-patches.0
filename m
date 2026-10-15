Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5841922FD;
	Thu, 15 Oct 2026 00:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022935; cv=none; b=d9y1dlhns1QZXK/BpNDQ5h3it1vYgt1uRVHa2X9U/3o4zueo7Y12B8KbCxfSx2WrUmSbmnvTDWv9ZWtGT3LHXzDdom1OPUIvZuYKLQkw6fnhQHliAijh+1SsL6JO1VO90XEcuuLGVLF+1jzZ1h7UlQakawKLRamtq4ryj7ouSkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022935; c=relaxed/simple;
	bh=+9MUVZ9S3eI5dsxpsEG4Dzq7WndpRtOGxAxbdYyeBvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNvPkoX8Jr3mKAmNzc8jDeYLMId+1v/ADTflwRRmnfH0090zOWBmhUaDavPyVZWZG28gPLDXH0APyS/0sUzen6eJUSdwtqF+d9yDiu5Eg3YiSKeyGpqY1TNpx1nEifPrBqlRtPZsjoygq9McgfIHfgKz7XroJYX4WeWr6Pj3Ys4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+FfP5UA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+FfP5UA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDDD1F000C7;
	Thu, 15 Oct 2026 00:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022934;
	bh=FgX2lnWzC5s16fGffkjkOnhge/ZnrkJVD4uzOO0Ibds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+FfP5UAbDAlqJUSUOEuElgdvQtCtEwcifIFC4bkxdZx68MJg6zB+UJIPeOq/NDFi
	 sNdZJqKDYpyJsWi9nqcnMIR4iMb9ipHbfLL+VfkrosQ/icZx1mWfAs5gL9DJ4K55lx
	 lJAJFwv9/sguJ4WqcziGZfNQ3b46TVgXhfAoZOiU9VP6bKshCuNDM/57+VWOQCDfpB
	 HK39+stlrfIWMOGhEXoKAQwdJIik2TjBEVvKcBIDHppI+JdYE8qRVwrrhxIqkriNSM
	 UmMJuHNA2Hzl/7rc39FR0VRB1x7Hv61F867E77O4oLmdY2g2sZuwJhuaJ87Let/lxj
	 kV/sC5Keii38Q==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 6.12 465/497] wifi: mt76: mt7925: restore the legacy BSS after MLO teardown
Date: Wed, 14 Oct 2026 20:08:42 -0400
Message-ID: <d1e65d05170d4e5c9cf43070@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cb60573d-858e-4a86-ab7e-05bbce6227d2@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112918.916875676@linuxfoundation.org> <cb60573d-858e-4a86-ab7e-05bbce6227d2@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think we need to queue this prereq first before this patch. Thoughts ?

Keeping this one in the queue. I will queue 04222f980301 ("wifi: mt76: connac:
tolerate inactive BSS deactivation") for 6.18 and 6.12.

-- 
Thanks,
Sasha
