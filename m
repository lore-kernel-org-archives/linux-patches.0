Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794155778;
	b=bkVggFMOCAObkZE8AGuHVtOvd6iEqUNuhU6gm4U0TXXOLXuwqnP6S+WOGN6fLnfsDPds
	 xiiBeUJ9nr2DMIHyvkXTXLRBCuuuN/B+5/mX8726s6tOrq9bppboyMLywC77PIA6+CLhh
	 0udR13GBF+TLlSxLFDH5FxbgsW3bg6K/HZkQf1NfTvx8FfkIHDdj8AAN6R5zngXhiHV+9
	 SdOs1srgSpT7PABCicZ5VzXyJqB4zVSNvvYDd67bUlJYsIHFwMNc8mi6epEMGFzj9lyPP
	 ubXrETbqf0aljitBTi+Ep/2Lyd28qDi/KlLLae008GyBRu8VeuSkIKKXJrpcD0GFqEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794155778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yB7UQp3PMsWCYdqrryq4xgyn2qyEFFfma2wfNMpg+LY=;
	b=e0lsUQmQEztaO1UOuo0Rn8yGk5zqjbj+X2W4h2J6yyNavRN+C1Egl6xMk9Q7jt89YErn
	 OucBFgAmA3IwH4WeogCz2YcQqm+ZEcwFdS70BnAXK5kyOsQAJYa2E3WYedzljjSDOTR6g
	 4aiwxq/2lwY4uZRoftxXIk6JJvLa/nj5W6eS4Nwb3H2Zco0cF542rldXGUQo4Ovkwtj9h
	 VYvrZKi5ei7SKlsSJ0dFUvLKXqwlvoanUFHRy58MErmh3mrYu6i8xWjrNSefOhsRnQIqJ
	 D/RlZg41e86WmmLdXfH+JsJfsNiJYEkW/1H78cAQqtQ0525M+3ykdKlw+FyJjmk2sMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQOJ+8aW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6EF606A31C;
	Sun,  8 Nov 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQOJ+8aW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9641F0089F;
	Sun,  8 Nov 2026 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794155777;
	bh=yB7UQp3PMsWCYdqrryq4xgyn2qyEFFfma2wfNMpg+LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQOJ+8aW5YX4tYfz3y9HYN2JIIQQF9NV/zVmmd4oW+hifMSX9d05cz8vRN3B8gcAD
	 aOIZVfyHNREOBjEkUiNRK0e48rKJUM96iyX5qBTtOrsOhscTHE75imGWx6VbW6ZWWE
	 XkFn58H2iN682xU+MF/vli9y1h58ucvsJgOqgH1wQBlVHRDtsmL1yD4FdTG8OTPUxG
	 FRG9Q9L8wMxYKVNCzbP10SOIE2To6IMfBYdLhtbDVT0PZmWinFsx7OYda0hBwE83Jb
	 ZtnHHfznStNuumSQCIll95MJZbwGIGNHs9BFA2XXyjKdO5fbQik3Bq/1PtGS6yW3Qz
	 bQZjUeBAjm51A==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: a.hindborg@kernel.org,
	axboe@kernel.dk,
	patches@lists.linux.dev,
	pgovind2@uci.edu,
	stable@vger.kernel.org,
	ytan089@ucr.edu,
	Boqun Feng <boqun@kernel.org>,
	linux-block@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 6.12 0630/1536] rust: block: fix `Send` bound for `GenDisk`
Date: Sun,  8 Nov 2026 17:36:08 +0100
Message-ID: <20261108163608.122524-1-ojeda@kernel.org>
In-Reply-To: <20261107135015.226523646@linuxfoundation.org>
References: <20261107135015.226523646@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 07 Nov 2026 08:44:06 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Andreas Hindborg <a.hindborg@kernel.org>
>
> commit e502b667ee70a7fa2a578e7722672ecd4fe0eb81 upstream.
>
> The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
> This constrains the wrong type. `T` is the `Operations` implementation,
> which is typically a zero-sized marker type that carries no data, so `T:
> Send` says nothing about whether the data a `GenDisk` actually owns can be
> moved to another thread.
>
> A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
> `gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
> `Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is sent
> across a thread boundary, so the `Send` bound must constrain exactly them.
> Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.
>
> Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
> Cc: stable@vger.kernel.org
> Reported-by: Priya Bala Govindasamy <pgovind2@uci.edu>, Dylan Zueck <dzueck@uci.edu>, Yuan Tan <ytan089@ucr.edu>
> Closes: https://lore.kernel.org/all/cover.1780633578.git.ytan089@ucr.edu
> Signed-off-by: Yuan Tan <ytan089@ucr.edu>
> Link: https://msgid.link/20260709100100.604252-1-yuantan098@gmail.com
> [ Andreas: Fix tags to make checkpatch happy. Change summary line. ]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Link: https://patch.msgid.link/20260929-rust-block-for-v7-4-rc1-b4-v1-4-642a4c1aebd7@kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This one breaks most Rust builds:

    error[E0220]: associated type `QueueData` not found for `T`
       --> rust/kernel/block/mq/gen_disk.rs:198:8
        |
    198 |     T::QueueData: Send,
        |        ^^^^^^^^^ associated type `QueueData` not found

because there is no `QueueData` in 6.12.y. We would also need commit
06dad60393f2 ("rust: block: implement `Send` and `Sync` for `TagSet`")
for the other bound anyway.

I would suggest dropping the patch for the moment.

Andreas: could you please take a look and see how you would like to
resolve it, if at all?

Thanks!

Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun@kernel.org>
Cc: linux-block@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org

Cheers,
Miguel
