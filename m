Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F41ABEAC;
	Thu, 30 Jan 2025 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738227046; cv=none; b=MsNwxQZ5+9mO8URXUPh6273oa9Aveqe5b8T/HGMC4mZk3wI+cDo/QBj4oMGH6plvnv1X+D+KN7n9uChB+RMIw/KIH2wCkQvZyAag5X/Axkus3ZO/0Q5iFGmCryNETSjk7qYRvbwjcDKVA/f/+QUn5DV3s8vw7zydXbXp925agJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738227046; c=relaxed/simple;
	bh=LfOlhQW9YhJoKf2Wbk/0xaa5MIVHPeBRmxlTvd11MZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+ji9f8pO92Zk5Lb9dz6svKJav4kvhwsFQe94DN0e3ciOX7QO7TG0UPZ69Mi8zf+70IE++RO5MfAzYpH88zcfa5nJVIXDzh+c8EXs3AknVDhYU2F2yBPwncZ/kUClIl8tSU+ot83r44//Nsw/3H1WK2WdqwAYkjn2UWuzOvw+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2syV9yR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2syV9yR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E43FC4CED2;
	Thu, 30 Jan 2025 08:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738227046;
	bh=LfOlhQW9YhJoKf2Wbk/0xaa5MIVHPeBRmxlTvd11MZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2syV9yRgmXGFExYlRQAPTLcjJ0B8Dk+XQf8dETlKTuJXKMUblcx5qK4HPWY50RRf
	 eok4ZPqU8gKIP0BtIVKA2EiFCkt2HBoB1l9dvWbIGOKgOH6iHMEhLNHVPLvpZ+DLU+
	 I3C1rcpFcua6x/omq2Bu0Z8U3xC+/AYTv3AZhFneBv+/WXVPWm3iL89RWzA9UJoTOc
	 b+ttbxr5uRxpJ1VKciTwFnTovBED/qq94R7y9Q2tumpCw3TGPlKJRpHtVFKlVKpdM+
	 a+ua2U6zYgYxKL71VFxdEBr2X/AjGiFU0Td0ri2YHby8GmgcKEvpv5WoNv1UHjh1JT
	 6d4I+HmBCAYjg==
Date: Thu, 30 Jan 2025 09:50:40 +0100
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: add Danilo Krummrich as Rust reviewer
Message-ID: <Z5s9YGzNeVeVmvkR@pollux>
References: <20250129215948.135486-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129215948.135486-1-ojeda@kernel.org>

On Wed, Jan 29, 2025 at 10:59:48PM +0100, Miguel Ojeda wrote:
> Danilo has been involved with the Rust for Linux project for a year now.
> He is primarily working on the Nova GPU driver [1][2].
> 
> In addition, he has been active in the mailing list and most recently
> submitted the Device / Driver PCI / Platform series.
> 
> He is also already a maintainer of `RUST [ALLOC]` as well as several
> other DRM-related entries.
> 
> His expertise developing Rust abstractions and APIs for one of the major
> users of Rust in the kernel will be very useful to have around in the
> future. Thus add him to the `RUST` entry as reviewer.
> 
> Cc: Danilo Krummrich <dakr@kernel.org>
> Link: https://rust-for-linux.com/nova-gpu-driver [1]
> Link: https://lore.kernel.org/dri-devel/Zfsj0_tb-0-tNrJy@cassiopeiae/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Danilo Krummrich <dakr@kernel.org>
