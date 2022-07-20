Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAF53A4
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7300EC3411E;
	Wed, 20 Jul 2022 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658326252;
	bh=tXJEfF7L2p8K215WRJaWN7Xavdz+rCtyQxFvI4cqgr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mje3u/0bqv01SmeqckP65E1vYrEKA5jMKEFKBGWrtVrcO1kxB3IjgQC6kjceftvTr
	 FF3gWkSIhWL0Do2ifv6ro5vd0cqGb1jAqW+A5nX+lSKokPR50I6BjwZkYcdl7F244Z
	 cJwzIrcYGzGeRdzSuEVrClR//TutOgOKME/9C0UX1Zfd1loEk6IWTxxDH7iVv9OEFT
	 vNoLvoQYZqop3qzgBFq8YyiQhHs/0SzdbaD8O/WZIzNr1v1BJ2FHTNZU46QxyUIN5s
	 Kq7jhjbbRTPUql3ww6OveR2kV9zGwDBi7+D/iGIGI5Z7ntd6zyQCkHKBex15pQb8Wi
	 3Zl2UElrSkBJw==
Date: Wed, 20 Jul 2022 10:10:44 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linux Patches <patches@lists.linux.dev>
Subject: Re: [PATCH v1 2/2] MAINTAINERS: set Kahless as ultimate maintainer
Message-ID: <20220720141044.smp2gtv4eyfcy7uj@meerkat.local>
References: <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
 <20220720-claim-for-kahless-v1-2-f787d95bfb7a@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220720-claim-for-kahless-v1-2-f787d95bfb7a@linuxfoundation.org>

On Wed, Jul 20, 2022 at 10:06:59AM -0400, Konstantin Ryabitsev wrote:
>Kahless does not read mail. You have to bring your contributions to him
>in person and defeat him in hand-to-hand combat.
>
>Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 651616ed8ae2..9c503e9006db 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -22257,9 +22257,9 @@ S:	Maintained
> F:	mm/zswap.c
>
> THE REST
>-M:	Linus Torvalds <torvalds@linux-foundation.org>
>+M:	Kahless the Unforgettable <devnull@kernel.org>
> L:	linux-kernel@vger.kernel.org
>-S:	Buried alive in reporters
>+S:	Kahless does not read your mail
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> F:	*
> F:	*/

All hail Kahless!

Reviewed-by: General Martok <mricon@kernel.org>

-K
