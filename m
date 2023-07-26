Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9BF7C
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 01:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E165DC433C7;
	Wed, 26 Jul 2023 01:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690334748;
	bh=fhZU954FRILZk/Wn2rw4ZPj74Nk992wmCH0WCQkFkD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ug7LWcil+Aww0VuSgxZX13Er3iIA42eQ89bP86S8XtAVJRwa2sOzy/kxuYcYmpSP/
	 3sbK+sN9AGCW9ipLN71uQNn1EqnEVa9G3148NLHPzYo9bZavGPdKo0FT9jqTuYRDqo
	 r1fp0Ef7A8qFcs0NgkwRlp+Ag8Ohypu8C2KJZ4SW8dgujoCZi26DHN/hk6VATZd6zv
	 4D4by8FDB5vMtoCQDOp5bpKFDeTOQOjCJ3FKPElqg75DjdpMctZLZTLS21Ai8xG+Gx
	 m8VwFNW4CA3KDBFkLLuj6PFPhzNw5x9ek4Z1YDf3TPPeApU7SS5H0v9obRnbTbYoTx
	 gQuK3Ob++TT5w==
Date: Tue, 25 Jul 2023 21:25:46 -0400
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5.4 113/313] crypto: skcipher - unify the
 crypto_has_skcipher*() functions
Message-ID: <ZMB2GjK+PDkf3HIO@sashalap>
References: <20230725104521.167250627@linuxfoundation.org>
 <20230725104525.907419883@linuxfoundation.org>
 <20230725161343.GA2295@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230725161343.GA2295@sol.localdomain>

On Tue, Jul 25, 2023 at 09:13:43AM -0700, Eric Biggers wrote:
>On Tue, Jul 25, 2023 at 12:44:26PM +0200, Greg Kroah-Hartman wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> [ Upstream commit d3ca75a8b3d77f2788e6c119ea7c3e3a1ab1e1ca ]
>>
>> crypto_has_skcipher() and crypto_has_skcipher2() do the same thing: they
>> check for the availability of an algorithm of type skcipher, blkcipher,
>> or ablkcipher, which also meets any non-type constraints the caller
>> specified.  And they have exactly the same prototype.
>>
>> Therefore, eliminate the redundancy by removing crypto_has_skcipher()
>> and renaming crypto_has_skcipher2() to crypto_has_skcipher().
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> Stable-dep-of: efbc7764c444 ("crypto: marvell/cesa - Fix type mismatch warning")
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  crypto/skcipher.c         |  4 ++--
>>  include/crypto/skcipher.h | 19 +------------------
>>  2 files changed, 3 insertions(+), 20 deletions(-)
>
>How is this a Stable-dep-of "crypto: marvell/cesa - Fix type mismatch warning"?
>
>I don't understand why this is being backported.

You're right - it's not a dep on 5.15 but rather on 5.4, and my failed
optimization attempt did the wrong thing here. Sorry.

-- 
Thanks,
Sasha
