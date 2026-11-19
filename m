Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073803;
	b=WPnEaLdvuUHrCxHFWITmH1hNwh5VKrmZoczDCBeOGu5Ihx5EPIFRlypICLS1VsNrulax
	 kRRnFQtPldNRgcyLwEhXRpMNPnObCfP6WvXaWNsSTZIX81urNAVtRfZuz8ZwHEH6tXjEt
	 nE2aPHxgXatOgVNFyQxthtNunfMo7Jb3JN/2cVhhZ/zV1GFm2yZZOEf5VodUbmq293Hp0
	 Qjt6nheGc75FAztDQ/NtNavGub7QyBXl97Wd72HGYJUjaPuaHE7Uh/ndxK7A2Dyw2qLFP
	 0fVVDN5BdZTRlv8Q+ZSFC3yGN8/lfEfmJu5jXMPJT2maY8UfXtz4XAdExunfSraE0og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073803;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=bdQ/tUWKSbxbUywOJKWVBD/5Q2mj2vvJKi7y7kCM6wQ=;
	b=WqDnOMHHZgBZp0GSnvLlSKxCrPr4U8BeTkwPCMXCI5O4Kba7/xupPx4dbL5ldHlsGQUA
	 y87k8LciR5XACFBlTc0Qi8/hqMNUkYkZNSPfVpcDkiW0Lt3yoMISCPAZjdflQ5IJx1tTh
	 wDevhOe5z5fTuQLVT3xVS5L0oQsDy5oxWPfZ4Ap5s0B5Jo+mPx2/3gnU/KgHu6cSHQIAh
	 AFxjvl+/mxoswm/0sBw9WYniNoCnOAKf5SHjxi20dvNcxT91cv7SlO11izizsAgexvBlr
	 xq5Q7IA2Q74tqYOmkW3hTt7iyWVtii6m5C1J1uy01szvY1PUUKmj1LsrysW0IuJ0yWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OsEESh5L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027E606A320;
	Thu, 19 Nov 2026 07:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OsEESh5L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14CB1F000C4;
	Thu, 19 Nov 2026 07:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795073803;
	bh=bdQ/tUWKSbxbUywOJKWVBD/5Q2mj2vvJKi7y7kCM6wQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OsEESh5Lf75GHVMF1u+VghTbsweUc+8SSAu16sDewRKg1avPKax/v8J0I2oMHEODs
	 1+sEJAEHQd+fKbw9qRm41WCKmHBBPMEP5wHqpqxz8bimhSHOiwY2LagD4E/XMBYNK2
	 XmlCC+FU79jgFViDmd48DyOCwTErI55dUP0Xj/TsSfUA1Ric5W/6Ag5T1NAZcJPbKn
	 KfN3SwU5gyckFtiaLDA5Ns9VriVQziCBvXVp+Rim+b+IZ/wvQnf7wJ6UJ1xvTGT+px
	 4iZ5BN9IkalEqpFD630IPWC3O4x/wZhx7kJs0IHupLtCh0dZHNwxVLXQpl+u+ViaGs
	 fPEO7HRNo1Fvg==
Message-ID: <9c8d1253-ca72-4adb-a324-8dc86c8b6e9f@kernel.org>
Date: Thu, 19 Nov 2026 08:36:39 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0949/2651] rust: configfs: require thread-safe
 callback data
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yilin Chen <1479826151@qq.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150322.070825488@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150322.070825488@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18. 11. 26, 15:36, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yilin Chen <1479826151@qq.com>
> 
> [ Upstream commit ec27f3b700010d2ebae1cde2df0246197689d159 ]
> 
> The Rust configfs abstractions do not fully constrain callback data for
> cross-thread use. Add the missing `Send` and `Sync` requirements.
> 
> Specifically, make the following changes:
> 
> 1. Require `Data: Send` when implementing `Send` for `Subsystem<Data>`,
>     since the subsystem stores its data by value.
> 2. Make `GroupOperations` a `Sync` supertrait because `make_group` and
>     `drop_item` receive `&self` from foreign threads. Require `Child: Send`
>     because configfs may release child groups on an arbitrary thread.
> 3. Require `AttributeOperations::Data: Sync` because its callbacks receive
>     `&Data` from foreign threads.
> 4. Update the safety comments in FFI callbacks that call `get_group_data`
>     to cite these bounds as justification for sharing the returned
>     references with the callback thread.
> 5. Remove redundant `Child: 'static` bounds from `GroupOperationsVTable`
>     and `new_with_child_ctor`.

This errors out too:
[  494s] error[E0277]: `UnsafeCell<MaybeUninit<blk_mq_tag_set>>` cannot 
be shared between threads safely
[  494s]    --> ../drivers/block/rnull/configfs.rs:45:18
[  494s]     |
[  494s]  45 |     type Child = DeviceConfig;
[  494s]     |                  ^^^^^^^^^^^^ 
`UnsafeCell<MaybeUninit<blk_mq_tag_set>>` cannot be shared between 
threads safely
[  494s]     |
[  494s]     = help: within `TagSet<NullBlkDevice>`, the trait `Sync` is 
not implemented for `UnsafeCell<MaybeUninit<blk_mq_tag_set>>`
[  494s] note: required because it appears within the type 
`Opaque<blk_mq_tag_set>`
[  494s]    --> ../rust/kernel/types.rs:332:12


> Fixes: 446cafc295bf ("rust: configfs: introduce rust support for configfs")
> Link: https://rust-for-linux.zulipchat.com/#narrow/channel/288089-General/topic/Should.20add.20Data.3A.20Send.2FSync.20bounds.20in.20configfs.3A.3ASubsystem.3F/with/623719979
> Assisted-by: Gpt-5.6 Sol
> Signed-off-by: Yilin Chen <1479826151@qq.com>
> Link: https://msgid.link/tencent_5449081195EDDF5726C709CF648DD4044A08@qq.com
> [ Andreas: Add Send/Sync bounds for `Group<Data>`, add `Send` bounds to
> `GroupOperationsVTable`, `ItemOperationsVTable` and `ItemType` macro
> implementation. ]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
-- 
js
suse labs

