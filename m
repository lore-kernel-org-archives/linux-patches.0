Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAFD3FB078;
	Thu, 12 Mar 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334161; cv=none; b=bITon8NomABz0sHLfRqNqRMLcmDT5DT/wCT+84XpPd5SFjz8FNoIXL9QtXaLgSkbtxlaWDzQq7VaoktsgKBbCnu5nRMV5Jw8VqddaUv5jFTt0OfyNB42KfqPwwtaaT9gwR4y8y0NTe5E84RG26cBUjLY3xPoxXal9i2UoDlnTTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334161; c=relaxed/simple;
	bh=CKjsMtBY0Bir9Asltf6sE4JGRZVkGB1mbJpvZHhLBik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRs23IxrQ1V7Fozpsq/TGze5OetgDND4aAjObq6YYZa+M1MewRC3FGiaY6G0lr41rqq8m4SD8/vEgtgoM7UT1FTdvrU0KAyPD/qqEpPpDz8G0fCsRALpfCfeMEcvN9j0XMBzfX4JN2WPVubx75pp1FaSv6RbPUQsB0oFp9K1f5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GE2xnE2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GE2xnE2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C1CC4CEF7;
	Thu, 12 Mar 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773334161;
	bh=CKjsMtBY0Bir9Asltf6sE4JGRZVkGB1mbJpvZHhLBik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GE2xnE2vDgMFa+mX0SH5Y5jcTy9ctXVil1fgizeAU12FPbmSuI+pbd/5//d7RXzb8
	 a19hcU9yCBn9gj37FQCQkdBfYDUWTYrfHeIHO66+PDRdH/ox6f0p8Aag8pqwE6Qt9p
	 1yGF1Vr7kK7xY1VaJVnVke2u/RM/tcGPKmvkdlUSiI9+FHXxNveGxKIdOgwrzetopM
	 5t9znwqV49D6+TxeY7zqVe51CUOTN8vB+AwF+42KQj7ZGx5tJG6AUBtRfdCMdATKzO
	 btZXdDfF7PlS5hlw/ExbwKdJ6d6J55HjoL/FmupS8F7ZmzK88pn+1gWo09vXN5zFcO
	 Hky/jioUHi+nA==
Date: Thu, 12 Mar 2026 12:49:19 -0400
From: Sasha Levin <sashal@kernel.org>
To: Eric Hagberg <ehagberg@janestreet.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, peterz@infradead.org,
	kprateek.nayak@amd.com, shubhang@os.amperecomputing.com
Subject: Re: [PATCH 6.18 022/314] sched/fair: Fix zero_vruntime tracking
Message-ID: <abLuj_pax8huB_BR@laps>
References: <05467440d95c78161254bab895be5692e4f0a3f3.1773141555.git.sashal@kernel.org>
 <20260311161400.1003322-1-ehagberg@janestreet.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260311161400.1003322-1-ehagberg@janestreet.com>

On Wed, Mar 11, 2026 at 12:14:00PM -0400, Eric Hagberg wrote:
>Shouldn't this also be applied to the 6.12 stable kernel as well, since it has the patch
>mentioned in the Fixes: line?
>
>The broken tracking mentioned in the test case is seen in 6.12 kernels as well.

Could you send a tested backport please?

-- 
Thanks,
Sasha
