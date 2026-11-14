Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794678333;
	b=W8RD92sc2+16r94nt5Hw6O78B47c0gbuGeeg3Ad8RXTjZVm2p8+65hurhaQrxybJGJqW
	 3PEc3ENErJgHrwHA9qPXD8ajSkJeT+VAwDdd/3PdxQomP4XSyc8nfuMBl8MN/ET01RuG7
	 j8wxjEIiUDmxq64FSq9h8tBn0nl3wK38LqsK9Novk+4CnggVy/FMk8Xnxs9ll1zeBuDnd
	 fWyzREyKzg4bSFXiGFEYrURtQUgs5GfWnSiR871p2363bzm2lY/tSSzb6iX4kVxu1l3u8
	 H+ujbiFk3NnO6kyXNjcyf3MOZl5giR+AM4T8O7138AumjSF0xgzf984qVvKC/970//w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794678333;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xB2Ll/hE6fCRL1qkpv+uhy1y1+Wgnd2n6ZmeDTOra9U=;
	b=NH0DO3y9zh+NWfn5wph8nFMwhk/2vFKdOCEUPSIKqXEWBMKXtKtl+1CeeYiijjDLOoF/
	 6G9uTJY+OfzZ/djJYFYKxQ0DEvpeTdoJgwLhb5DKaWoRHxSo3XwU3sAMFYdNaCEE2KjoZ
	 RHe0HfdmeYgfyvfm6ifQBf9bzLUHqJiikItw+kpFNQELAxmdCyAyTh7Kl7FV4aNWBWeJU
	 mHY0c1GRyPgf912/FCA+sClpI55BtOiakV6pYT48ukwQPWGwD0URFXZCVuN+P0tw3oqXY
	 eov8icnWVk7hTZZRaU/i5hUCsMv/TdWE192roZ2NEeo0yQh9g6v2OONPiC6kPQNKXFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QyO2K7lf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1362606A327;
	Sat, 14 Nov 2026 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QyO2K7lf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A281F000C4;
	Sat, 14 Nov 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678333;
	bh=xB2Ll/hE6fCRL1qkpv+uhy1y1+Wgnd2n6ZmeDTOra9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QyO2K7lf1ccEKQG1VMjR3+Rwahnau24XY+kx4XPVNNGQEeMmOOut7N90cZW4mLteO
	 qjjCohp3Qs5gB9pctDHPTSXmSCdiISZagmNAN6RoKNrpZ6GXgX7UYPq+VI2/OG/wYI
	 FGqML+O0QatMY9194eGPdqOzRz4KFNY2xC+OGDidmocLeYAiBqZDjpOSBonm9HnXRr
	 TUaCkhO95FRm6FsEUwjE23wZ9CkrQjAuqu5ZYJDzmR4DfRitGiiBnJCeX1cBhJawQq
	 dnN4e6j97peIUuVQ4Oq0YyCX9qrqPa2yINYLRIG98eFspiKDABiKdSg5CGW6ueBiQo
	 Qsz6Eh5rehgsQ==
Date: Sat, 14 Nov 2026 17:45:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	gregkh@linuxfoundation.org, 4ncienth@gmail.com, akpm@linux-foundation.org, azpijr@gmail.com, 
	corbet@lwn.net, david@kernel.org, jannh@google.com, liam@infradead.org, 
	mhocko@suse.com, patches@lists.linux.dev, pfalcato@suse.de, rdunlap@infradead.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, stable@vger.kernel.org, 
	surenb@google.com, vbabka@kernel.org, linux-mm@kvack.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <avieGNg0Z0WsD17N@gremlin>
References: <20261113153812.408825269@linuxfoundation.org>
 <20261114003912.82206-1-ojeda@kernel.org>
 <20261114031943.192867-1-sj@kernel.org>
 <20261114154112.3718615-1-sashal@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114154112.3718615-1-sashal@kernel.org>

On Sat, Nov 14, 2026 at 10:41:11AM -0500, Sasha Levin wrote:
> On Fri, Nov 13, 2026 at 07:19:42PM -0800, SJ Park wrote:
> > On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
> >> ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
> >
> > I found same thing while running kunit.  I also confirmed both applying commit
> > 47e725702b0b from Dave and reverting this patch fix the problem on my setup.
>
> Dropped from the 7.3 queue, together with the prerequisite it pulled in.
>
> Thanks to both of you for the report and the confirmation.

I'll send a fixup.

--
Cheers, Lorenzo
