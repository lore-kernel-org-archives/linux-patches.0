Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390B684A3E;
	Mon,  3 Mar 2025 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741026782; cv=none; b=jXwT7NWcuP8vaqdn8hEFwvA/lcxaOMKyDvQ+IfZSAe1imdg9HsGJjyxTSZnTkhL+BgXxi25tdbk140L5E/aJq/Kflvlea1wjATSJwFJ+QaYLb1IfFvqxqtjCX3faW2HiT4XZjLOgkAJdY2YiunskD9W20I9+YYNwkrfp6umJezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741026782; c=relaxed/simple;
	bh=p+x8Be3tf6PtbwUT0uHQMPM5tK3lELCvuVQXFNOznLA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XwlQ62hHvCvTmqUcbVAbIV0GQq93AyvuKWk5zyBc1WjyZoIEMBeySDk3GdVXy8D6hF6SHdLUd2zKy6BVk4QPDFvjvqo2u4JtwbpjRDGVROiOJYd2pvjt2iSCfEr3ipVUW1qrHEeUv1OBkx2vf9zqaTYjXYq44tUDGBJXB6dNFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8PGFLsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8PGFLsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1D1C4CED6;
	Mon,  3 Mar 2025 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741026781;
	bh=p+x8Be3tf6PtbwUT0uHQMPM5tK3lELCvuVQXFNOznLA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a8PGFLsx3QKVpj55nYkPhKc4dqlgPVSbMoma/FVi9ndYb3G9qG2xadyrzlkZ3VL6E
	 eRArliVk1RLWaKOk3vo9WmaqDIzB5o4Am6nVJvoPtgijOvYcc9t+kDrzTCmgWWADtY
	 P4DDcvCsEnvACwlMHFakvdrX1GJnHT+V3hwUQ4VWshC+SfH97s3LUEL5SVUd23efjH
	 CrdFhhbFCUQBe6LFAdCcXyBTuy0lL2lHv76iywodGju1SqvKiw/2lyxeUMIJLZ5hHy
	 eyYghcis1KCrcWQzcl9uQdnnN8uKhvlr9SSf+G2dvq6+a0+1ftfbTWfoausodO5sjp
	 1P6s7HT5Rkqdg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>,  "Boqun Feng"
 <boqun.feng@gmail.com>,  "Gary Guo" <gary@garyguo.net>,  =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  "Benno Lossin" <benno.lossin@proton.me>,
  "Alice Ryhl" <aliceryhl@google.com>,  "Trevor Gross" <tmgross@umich.edu>,
  "Danilo Krummrich" <dakr@kernel.org>,  <rust-for-linux@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <patches@lists.linux.dev>,
  <stable@vger.kernel.org>
Subject: Re: [PATCH] rust: remove leftover mentions of the `alloc` crate
In-Reply-To: <20250303171030.1081134-1-ojeda@kernel.org> (Miguel Ojeda's
	message of "Mon, 03 Mar 2025 18:10:30 +0100")
References: <38Ry6xPAarfPYWB_FZBM_3Jy2Eo-skh5yWoGi-yT33tflksARlQmwDudaXGjQIgMiUgeSK8IPTV16DN5xdiGoQ==@protonmail.internalid>
	<20250303171030.1081134-1-ojeda@kernel.org>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Mon, 03 Mar 2025 19:32:51 +0100
Message-ID: <87cyeyj770.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Miguel Ojeda" <ojeda@kernel.org> writes:

> In commit 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and
> `GlobalAlloc`") we stopped using the upstream `alloc` crate.
>
> Thus remove a few leftover mentions treewide.
>
> Cc: stable@vger.kernel.org # Also to 6.12.y after the `alloc` backport lands
> Fixes: 392e34b6bc22 ("kbuild: rust: remove the `alloc` crate and `GlobalAlloc`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>


Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg


