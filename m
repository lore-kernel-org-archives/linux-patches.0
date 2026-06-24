Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFF92848A1
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293844; cv=none; b=IPb0XJKDJ7AEQt7xXOeimoO+iyI4n9Io0iC8enO9UyWYcx5l6bBJ/lb4AMx2m+WA/D4xubkSG1QUu+h+Rww1qhY7M2xr0yqraIo1Mf0UByvNGoZv71Vv8InZsy3lnMpjwXjc6VaIDzcSGDH9zQEm3GCqfnQN2rOqKS/SfCbzriU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293844; c=relaxed/simple;
	bh=1cqTBdcnChw8QnoeTxO6pHgP5ZdYyoFcPJLg3SKwsWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jePLFrtLI+Y69zHFOQqQ7pgdZQfM0x7LP2ZMfO7RYHWKfL9+15LRzdbTn183OdME4YGJIkcUo04s9Kg3wTCqNzCb9JI6lXhKWS37QRsmG9creTFQ2vF7KSuakC6k6OrPKA4/rZz/11oK9DB+0d6AJDCh+2OSGqPzaRmMlW2krMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h8R8Z9jL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h8R8Z9jL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FE842944;
	Wed, 24 Jun 2026 02:37:12 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AAFEB3F632;
	Wed, 24 Jun 2026 02:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782293837; bh=1cqTBdcnChw8QnoeTxO6pHgP5ZdYyoFcPJLg3SKwsWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8R8Z9jLg6U+gI89CL20iOYcQ4YrIl1lVhKH5zVgl2OLlQvpZrEobcT1HptU+7/bm
	 okNAaryVuY3J+cbSDfMWLIiPlZRxqg3OI3ASdqJCK0Bxr75cKMmEIzriYn8YdSAPAu
	 BYkdSmALk16mjhEatgu5Dbg0oFiPnxza895bdxvY=
Date: Wed, 24 Jun 2026 10:37:12 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: iklatzco@gmail.com, gregkh@linuxfoundation.org, 00107082@163.com,
	patches@lists.linux.dev, peterz@infradead.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: perf: Fix dangling cgroup pointer in cpuctx
Message-ID: <ajulSBVbBakh6NWu@e129823.arm.com>
References: <20260616145120.525872058@linuxfoundation.org>
 <20260624080310.2502480-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624080310.2502480-1-guanwentao@uniontech.com>

Hi, 

> Hello, 
> 
> I noticed your backport missed - 'event->pending_disable = 1;',
> which different than upstream version, is that true?
> 

Yes. I think it was missed otherwise for the DEAD event, it would have
the middle OFF state.

-- 
Sincerely,
Yeoreum Yun
