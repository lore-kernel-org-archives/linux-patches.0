Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466EA8F6E;
	Sun, 18 Aug 2024 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723998157; cv=none; b=Y0ksNST05bq4k/xjMUma3lTBsfs3LOSIm8S+M3nmcQ00Bmdhs72KikoT/RktCpAXOmLsmCXlzAL8kMkl9Qt46YrFtFhf/FlrVF8RShb/PSWQUYwPDxFj4XM4Y6XmfoGWjV0PVGvQ94N4LXXSjP6O3VSTeoKA7UjST4KYomBCkRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723998157; c=relaxed/simple;
	bh=yfDXeKpfoTsz6WNEkk/c74H40IhurnjP1aVuZLT9Gpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PotXazWw59f4/IR01hoqgC7ruWGW6VWc9DhKpcU9SmTVs8snq7oJfyNyjvYztV7zGiGkEmcQshA2IghS5UWX9hCPsUJZzHxW5SjIFggOi3lC9wB/9Z8J2xlG1MwO7Jp7pR9WbmD8Th1XOHZDyfGPVkJcrwJyHHAByNvQIx9EJyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlmgyFg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlmgyFg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89473C32786;
	Sun, 18 Aug 2024 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723998156;
	bh=yfDXeKpfoTsz6WNEkk/c74H40IhurnjP1aVuZLT9Gpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xlmgyFg+UpCHeg1hdSMSy3FQEE49k6w1fjPq5MHi4b9UY/8/gkxEcyfldrCJ7lBSk
	 gGyrbUgxQuBamUO7PACWJzD6BPY2q6X15dJ3ie1lFy8iiDvv/6l03dh9jvzWqWt68m
	 +cxHgZQxAa7O98mHps1grEPn3qYN9OaQjHTNh7vE=
Date: Sun, 18 Aug 2024 12:22:35 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH 1/2] docs: rust: link to https://rust.docs.kernel.org
Message-ID: <20240818-shaggy-pastoral-shark-cb3c3a@lemur>
References: <20240818141200.386899-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240818141200.386899-1-ojeda@kernel.org>

On Sun, Aug 18, 2024 at 04:11:59PM GMT, Miguel Ojeda wrote:
> The generation uses a particular kernel configuration, based on x86_64,
> which may get tweaked over time. Older tags, and how they are generated,
> may also change in the future. We may consider freezing them at some
> point, but for the moment, the content should not be considered immutable.
> 
> Thanks Konstantin for the support setting it up!

Happy to help!

Acked-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

-K
