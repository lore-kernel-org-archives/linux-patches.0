Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B843A2904;
	Tue,  5 Aug 2025 07:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754380630; cv=none; b=pCyxAFjjJPbuXOywNKzGD3lpn72VoTew6oTPfXWeeZrhrwZwjG1X7PCMA7rFbh7yGFVo4V2oqtkJfr+LTz1+bBa9m4wfdUIVOWsEq7ot1em5BGMONcXfYM1ijA14Z+2va1IaNiYQloQWyk+/OzYqN+7HZn9/9EMFRs40B1nHbVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754380630; c=relaxed/simple;
	bh=BR4gtnnPIqtSp82BOsm8BQSskRdyXi1z2aDbF6OZGAs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RKhp5lWDBhFBseIaU5etX5d/Vd7N5iuUycfxrZqlKyYt5muFnXeUaiAFXP1mXinhjgcMyMvqX1YSE6zkGOeOgV1wrow72kObQ8WwjhViR/IkkgVjDA2OOrpUSu7iBbs9Uo8JHpZ4kAknaW/nMa3RSBeRHlXI+fNvovSDZpnMbOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/xDRWaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/xDRWaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C867FC4CEF4;
	Tue,  5 Aug 2025 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754380630;
	bh=BR4gtnnPIqtSp82BOsm8BQSskRdyXi1z2aDbF6OZGAs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=c/xDRWaXq7gOlA9fOcBwM4Z5fKFfYgfYSl7LpCzfGWpbZEaoU8GOuE59z+LUyJaMH
	 h06U58d1Xg5HlKXFwqX6UEDo6TT9LTlP6XObh7G3dqZ2eDFjao37VZEOn8dL87L0F7
	 sVnZiyfs+mVmrRl9w0cQl9ylPX9a4K0UP16S8ak0+KB8SfZj6CePu36YvuSm3iBcUx
	 5TcOsnhz+wAs18nrTnUjFdwRksdHsSVfAkLmA/J/SbnxXX9Pppz5rHRWftql24P8FR
	 OMO+oGW4+lplm5joLeJ9FJh3qgugr+ky7cIVaZLSVgaaSmidRUH3NEbwtQU7zF4MDQ
	 ZlTAane0nq7HA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Alex
 Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH] rust: prelude: re-export
 `core::mem::{align,size}_of{,_val}`
In-Reply-To: <20250801161752.443431-1-ojeda@kernel.org>
References: <dVcviDiszZYohRRvhNw_T69gnpyGEpsQrNQF_bJO3r_YMAc4r01Sa8aOAYaXDcb-Ci6DpazHmWGSpI9fFm6p_Q==@protonmail.internalid>
 <20250801161752.443431-1-ojeda@kernel.org>
Date: Tue, 05 Aug 2025 09:55:59 +0200
Message-ID: <87qzxq9p80.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Miguel Ojeda" <ojeda@kernel.org> writes:

> Rust 1.80.0 added:
>
>     align_of
>     align_of_val
>     size_of
>     size_of_val
>
> from `core::mem` to the prelude [1].
>
> For similar reasons, and to minimize potential confusion when code may
> work in later versions but not in our current minimum, add it to our
> prelude too.
>
> Link: https://github.com/rust-lang/rust/pull/123168 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOKh9e9_60zZKmgF=vZmsW6DRg@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg


