Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478A01A28D
	for <patches@lists.linux.dev>; Sun,  9 Mar 2025 03:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741491769; cv=none; b=eh7ZoZ3O+Iy/DsL0Ep115XoWI85jVNhigysknw0mJ12v3V58DIccW/sqxt0WfsF5VQOPkE77o00OtPSO3CAypUdRdPKagOQ1TMfwwRDrO21/7d4SaegRUFdLr8K840XMXb3Ak6rzFB8RsCKdCao06xDFo4WqniThMmLI6TrYCec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741491769; c=relaxed/simple;
	bh=lx6NB+qDtz9P3ipI8WEAT2l+BpRs5XenWiRE/I9mXHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpFicCTqgKCJ8UjqyGQkaecboKZGuKNRqNrDGZUrd2XN+zpk96wA26cXi9KRPabE5+FpDqnAsfbnZzXzpSn2qzfFMu+myacn1YBXHG1AagaqDX0E8ThZHv1hJmq4lCkt8MQeP4Xz4z/gVt01TsHCCjd5ZZUC+iQybzahnRx4yno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kYLpAegK; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYLpAegK"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4767e969b94so3963081cf.2
        for <patches@lists.linux.dev>; Sat, 08 Mar 2025 19:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741491767; x=1742096567; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yp0HF8hebKGm850Xmgb0c7EhESLBd+xQ9hWzxDmF5w=;
        b=kYLpAegK4fb4M7h2hb07MDCudAjQWgFZKBbIBpXan51oVkZtpicfyLysZnlNSyhbV5
         /58c7sr6CL37pzoaDPlwMChKHwmEp4EH07J9jv748NTQZKPCQUqRAZzxdPPWaDaIvoQa
         gy3sIT/TQnWyphy0XG8XR9pRcWXdI9qzUNhDQUwaXGV/Vc1AM80VbzrTvdgabhfpbsUv
         2XuTAV50vG4JdFkjKBhv5Uoe5AkT/sh2J++AleFv4jRju9u//DfkSh9VTTXge2gTcIby
         pTzv/Xjn9X056VYHgH3dSe6NY1FWAfsP/texY6n+OJ20NE9lTlImBe4VSwTAxBXkNjKj
         lXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741491767; x=1742096567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yp0HF8hebKGm850Xmgb0c7EhESLBd+xQ9hWzxDmF5w=;
        b=wZt5cAukANzl4Lxj9FjiRt4LG79jY3d9+iBfgEvoB7o2Sc67XFezl1Q+ng1KWZ9js7
         ioDTuoimTyvyutfb0TX2K1DmYbYIIqeBgWWBB7LWEaboIJqqVxhVDeA3cUq/x9aMqoXF
         nB3T5As/tWHr3FSRwkFEhPvZQHFXJaDBLVEEwnvjRv0JucEgCfMUxAcvzHQdM57IHHX7
         eyNhtlDwmV+0CIOFaHwsnTwpmZWqvHN+S4olBOvfcgmRwiXJmn3zeKx6nl9kFbmBNnRU
         f2dUHtIVGsUKjI4tHZR+A/ZymsB+HVTPlz2jaoP5Pa9+MVMimEFu/tFuWYin31xLsGQL
         Opxw==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ukm5LYhY3Cgem439Pe7J5AhU92eR2aFEZ8r4RJG6umMxh57ZO3ZoWvJlgheGQwcEPN8AACEL@lists.linux.dev
X-Gm-Message-State: AOJu0YzuWiCof8I/CS+FTpEAWAvb1ugyDAVkkkpwWhM8sn6fS/YGid8d
	JHMoto3DhjtDqDdZLeScshd/s0l0Lez48G1rJbcTuD92m3VaYoQR
X-Gm-Gg: ASbGncsRAcb401GZVJRkFa2F/y659596h3zAzOgG/BXnX2GucZSTF4+Lyg+5r3rXBiz
	55pMPOy7ycNG7Q06Wu0DmN2vcl+E1TGL+9yEvejoGxoHorazGndzNKXILN93mOVGRfQf2gabfpI
	cCAjyRFLdabqaPjVSUxXLFVwDAfQCSyE0vlywdyWnOt0yE1lQh8C9CC3eT5B0V2WlqOqJDY9T99
	UNI6TlI49cmmZW83x+mH6vhsWKRbfQJJFkyL6IuaOzkvA0frWvub+C0R0kT1AajpRnUMPzF4AFf
	eiRQeVtVaNmxQGBRieFfjCsFBe2RjnXE9N7NpTVzJOav/4oluC1AJE/OIO+I5VVQas6BWwWWRuN
	5XG12+M2zmH/chCCq/USoorB8UpO8S3scktA=
X-Google-Smtp-Source: AGHT+IHyGX6at8VhNa8ZE2qK+ILoyuTNdjSx26AdZovpMYwfd74OOMttVlZ+pNy0Z6dl0JtuCEX7lA==
X-Received: by 2002:ac8:5a84:0:b0:474:fa6e:ff3a with SMTP id d75a77b69052e-47618af90c1mr125991401cf.49.1741491767057;
        Sat, 08 Mar 2025 19:42:47 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4766efce08asm9739451cf.15.2025.03.08.19.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 19:42:45 -0800 (PST)
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 516811200068;
	Sat,  8 Mar 2025 22:42:45 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sat, 08 Mar 2025 22:42:45 -0500
X-ME-Sender: <xms:NQ7NZ22bvaIdXGcxt9Xk2XrztDfpjDVIlyzywdWe0zxuTCgamVLt2Q>
    <xme:NQ7NZ5E30bo7JXsrsJgET7ze1QUuzSli5kVpA72stpIVhmWDCnC2q6rTJhrrLtyu1
    RlrXutiKrXbwKD2dg>
X-ME-Received: <xmr:NQ7NZ-5GDXJZUVGXzsb3416YPGDcArRyBhUsRXzWMsaA7CJG9EAIQUvT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduudehfeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrih
    hlrdgtohhmqeenucggtffrrghtthgvrhhnpefftdeihfeigedtvdeuueffieetvedtgeej
    uefhhffgudfgfeeggfeftdeigeehvdenucffohhmrghinhepghhithhhuhgsrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhu
    nhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqdduje
    ejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdr
    nhgrmhgvpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghpth
    htohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghlvgigrdhgrgih
    nhhorhesghhmrghilhdrtghomhdprhgtphhtthhopegurghkrheskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghj
    ohhrnhefpghghhesphhrohhtohhnmhgrihhlrdgtohhmpdhrtghpthhtohepsggvnhhnoh
    drlhhoshhsihhnsehprhhothhonhdrmhgvpdhrtghpthhtoheprgdrhhhinhgusghorhhg
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehtmhhgrhhoshhssehumhhitghhrdgvughu
X-ME-Proxy: <xmx:NQ7NZ31zrImLUXfw8YrxaYYuMcmQJbNYNVdaAekA2ExwcowVDfBcZg>
    <xmx:NQ7NZ5E-r6fToaCMfAEskr_uYe8tQeaMSywbER4yiHlazoZX1E5vEg>
    <xmx:NQ7NZw-GZsSRSW-8fBnsG43KGPv7qpoCGiL7ZxIyjsfP5KOw4seWhw>
    <xmx:NQ7NZ-kfisaGKRm8bx5az3elPKC0dU1ruXLCtdJRG8HNiX3VVd5esA>
    <xmx:NQ7NZxG59yIYZYJu9vEdphcH7CMFUgc3uOTNFM7CW2GFw-FF1loFR14h>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Mar 2025 22:42:44 -0500 (EST)
Date: Sat, 8 Mar 2025 19:42:43 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: rust: add tree field for RUST [ALLOC]
Message-ID: <Z80OM7vrg3ZrJGL1@Mac.home>
References: <20250308164258.811040-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308164258.811040-1-ojeda@kernel.org>

On Sat, Mar 08, 2025 at 05:42:58PM +0100, Miguel Ojeda wrote:
> In the Rust subsystem we are starting to add new subentries which will
> have their own trees. Those trees will be part of linux-next and will
> be sent as PRs to be merged into rust-next.
> 
> Thus do the same for the existing subentry we already have: RUST [ALLOC].
> 
> Cc: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

FWIW,

Acked-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e0736dc2ee0..1ddc313abbdd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20732,6 +20732,7 @@ RUST [ALLOC]
>  M:	Danilo Krummrich <dakr@kernel.org>
>  L:	rust-for-linux@vger.kernel.org
>  S:	Maintained
> +T:	git https://github.com/Rust-for-Linux/linux.git alloc-next
>  F:	rust/kernel/alloc.rs
>  F:	rust/kernel/alloc/
>  
> 
> base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
> -- 
> 2.48.1
> 
