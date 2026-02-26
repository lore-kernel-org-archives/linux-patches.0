Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2D36C5B5;
	Thu, 26 Feb 2026 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772113518; cv=none; b=S+nR+i9oI+1daUxjvLBwzLsAY1X4egcPfEO4abvldbXAkFY64JJibMYafsOwQoMpxmG9w5X6rySK9X7LljmJfIxJ9dzJRZmWq/vHNY6lWVE/QczHa9WyaYwj+n1hQNCL1IXcINTWsD/4WoNlYHVhkUIfGST/AAbz/nMNAfcrBEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772113518; c=relaxed/simple;
	bh=dV7ALMoq2XgdOFKV5Emv3PkDFWkIqZYBpcOx1vNi51I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6ucqieTqewxp3owuLsrt5vmjsraiknPqAbqgl8nhA8zAtArAbmBrR5cVQOhatC0prkH7hqhC/JquSNInIWn9MobKfAWjpYZJXV3JN8QxZ8VYxYYm5dXbr9Q9z9Qea81/wYQkIlP6e5U1qpmRpiJ++e1YkAh95jgLX8xSAKenWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyKbk1Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyKbk1Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97383C19423;
	Thu, 26 Feb 2026 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772113518;
	bh=dV7ALMoq2XgdOFKV5Emv3PkDFWkIqZYBpcOx1vNi51I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyKbk1PesDbWCAqwgmZDKDMdqKB07CIYQPoIQNjGwzqvuQZKnaXvAw8bsftoI/rQB
	 JvBYNx50Gc1dM6f8zo9DY77eBiw1Ch/gjnBLUwN04xl7sWVhYD46bhIvMnoKtgTQ0n
	 MBk1Bng+Zgdcd0VfivW0pK7HwK+O/WnEgTVD2Ay8C9eWKnGcdFiIgIC30xjw1z+I5K
	 HoXgmOZxyCfafkFRvnHl+Nk/+QRgjh47eoBLONrBBSPpCeUAvO9aEZRLhyegYLzceh
	 FzJwJYBuCOKvLRGSRJk5UC5uOZx+OIQi67KDypdU51ATkyehb13JDgRInz+dvxdQi6
	 Jo73bKxJIA9OQ==
Date: Thu, 26 Feb 2026 08:45:17 -0500
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Alice Ryhl <aliceryhl@google.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Benno Lossin <lossin@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	ojeda@kernel.org, shankari.ak0208@gmail.com,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.19-6.18] rust: sync: Implement Unpin for ARef
Message-ID: <aaBObfxypvzGmCVl@laps>
References: <20260212010955.3480391-1-sashal@kernel.org>
 <20260212010955.3480391-23-sashal@kernel.org>
 <CANiq72mi6_UrGoFs2=ch6AyKP0hhCon3epSkXCzwiGUGmfswOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mi6_UrGoFs2=ch6AyKP0hhCon3epSkXCzwiGUGmfswOQ@mail.gmail.com>

On Thu, Feb 12, 2026 at 01:11:50PM +0100, Miguel Ojeda wrote:
>On Thu, Feb 12, 2026 at 2:10 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a **build fix / type system correctness fix**. While no in-tree
>> code currently triggers the build failure in 6.19.y,
>
>Hmm... If nothing is failing to build in a tree, then I don't think it
>is supposed to be considered a "build fix". It may be still good to
>have, e.g. for other backports and for downstream developers/vendors,
>but it sounds more critical than it really is when worded like that
>(same for "type system correctness fix" -- one could think it may be
>referring to unsoundness).
>
>> - The commit is still in linux-next, pending mainline merge
>
>Wait, shouldn't all stable commits land in mainline first? (modulo exceptions)
>
>...ah, it is actually in mainline, but the AI checked linux-next only
>I guess (?).
>
>Would it help to hint at it in the AI review instructions? Or, if you
>already only ever make it review things that are picked from mainline
>anyway, then telling the AI to avoid checking that?

Right - the LLM went a bit off the rails here. I'll improve the prompt a bit
and see if it helps :)

-- 
Thanks,
Sasha
