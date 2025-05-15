Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575B145323;
	Thu, 15 May 2025 16:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747325917; cv=none; b=VPOsj3jYbsVEx98hSowy/8dT7XYC4QZJf7xoAm/qWbBQruxkCwwE7d2bdqbQ860/bxRnfwxRgzGHwGsFryEtR470gvuUp5NLi3EMwnuExRAwrmSl1LFQfmOiKkMB7X/1lBkq5/dWP6Z3B9o405wAOFhrI2lsBh+wntb9LC1aDXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747325917; c=relaxed/simple;
	bh=L0kIF48XCYT861Asg5Q6lEo9pZRH1uwyCTmWad2IdM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spqRkkGBF7GUPoQ5D0BRDdcDf45NQX/k963IfknXhAtrFFFpqPG3ixkAcLirY/g758u3tVRi18WegSrW+8WxpRd4VxE1r+xgW3wu9buGmJclM68tMoXZ3HGbC2tX/UgN2trKEUCtHiks2FiDdNG525V7lm59UBJjaGSer185dvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlEsi/03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlEsi/03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36C8C4CEE7;
	Thu, 15 May 2025 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747325917;
	bh=L0kIF48XCYT861Asg5Q6lEo9pZRH1uwyCTmWad2IdM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SlEsi/03MYcTceqX9DlGjgDznpzb/ll3S3PZJWkS/EYDimu/o3ELCxDbeNmfflnh0
	 aKFYZU8oat6WH6Ywh5X5WcsXFjg6VqRteO3SN3AG594EGzPMtfrH/dpo3NOpXlRmoo
	 B58QC0C/mxX/tBVSPWSdZnKZQiU57tzx9hOs99a6WRB3SIUuaBbSN4tPlirv1qwkpk
	 A9mMSoPSnHx5scFPjIufS8IcJBJY9QMvhV6Khj8+Q07XwBLmICQg4DCJZDx2SKPk6g
	 jSX5nJOIrDjSJGPnnaCmXYNjFcaB97vvbboY6DF9CIBdT7RlfS2kI6o4vtzyLAMUpq
	 3LvHHPQb/nOfQ==
Date: Thu, 15 May 2025 09:18:34 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Timur Tabi <ttabi@nvidia.com>
Cc: Joel Fernandes <joelagnelf@nvidia.com>, 
	"gary@garyguo.net" <gary@garyguo.net>, "a.hindborg@kernel.org" <a.hindborg@kernel.org>, 
	"ojeda@kernel.org" <ojeda@kernel.org>, "boqun.feng@gmail.com" <boqun.feng@gmail.com>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"tmgross@umich.edu" <tmgross@umich.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"alex.gaynor@gmail.com" <alex.gaynor@gmail.com>, "benno.lossin@proton.me" <benno.lossin@proton.me>, 
	John Hubbard <jhubbard@nvidia.com>, 
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>, "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "aliceryhl@google.com" <aliceryhl@google.com>, 
	Alexandre Courbot <acourbot@nvidia.com>, "dakr@kernel.org" <dakr@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
Message-ID: <devk5empq6e3fy4vp5mhxaznzrxfso6d4bqqzpzachlwy5w567@32tvtoddkn6p>
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-2-ojeda@kernel.org>
 <20250513180757.GA1295002@joelnvbox>
 <20250513215833.GA1353208@joelnvbox>
 <38a7d3f8-3e75-4a1f-bc93-9b301330d898@nvidia.com>
 <f4c946b2988d63a26aff2d03fe73fbfe1f52f31b.camel@nvidia.com>
 <723f7ae8-bb36-4a4c-a1d8-733d131ca222@nvidia.com>
 <grdfkevm4nnovdefhn7thydixjtdt2w2aybuvnrtot2jolyte3@pmvcv3vbmmll>
 <554965650ac2aaa210028d495b06e1ede6aab74d.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <554965650ac2aaa210028d495b06e1ede6aab74d.camel@nvidia.com>

On Wed, May 14, 2025 at 07:46:49PM +0000, Timur Tabi wrote:
> On Wed, 2025-05-14 at 12:14 -0700, Josh Poimboeuf wrote:
> > The above warning is in completely different code from the Rust one, so
> > they're likely unrelated.
> 
> True, but the fall-through is bogus in the C code as well.
> 
> > The fallthrough warnings are typically caused by either Clang undefined
> > behavior (usually potential divide by zero or negative shift), or a call
> > to an unannotated noreturn function.
> > 
> > Timur, can you share your .config and compiler version?
> 
> .config: https://pastebin.com/inDHfmbG
> 
> ttabi@ttabi:~$ llvm-config --version
> 18.1.3
> ttabi@ttabi:~$ gcc --version
> gcc (Ubuntu 14.2.0-4ubuntu2~24.04) 14.2.0
> 
> Since I build with LLVM=1, I'm assuming the answer is 18.1.3

I'm not able to recreate, can you run with OBJTOOL_VERBOSE=1 and paste
the output?

-- 
Josh
