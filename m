Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F201B3948;
	Sun, 12 Jan 2025 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736693674; cv=none; b=TGt8D6A5HP1EQkm7Qrn9ttXCITduvpZtrK1BhhBYQQG0EUTTARnBFmBjDQqSXAi6z6m3/LD2USIcIKORTsoC2+6zMTrAKWYr/2/IHxGO6B3xmbvx2nrHxm+z3XSNu5cYyrDrq3djeN2ANPqnzSXSbNv58OZImGepmp/Po0NO7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736693674; c=relaxed/simple;
	bh=9dqA17U4v5bNA6UGoWgoPLebWf69ya2Zv5ng/piZlXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7oP2BuTa6/u4LCKNUMqRb+lOTgTLMZM9hn9nWRoZGPzzu7aSXZ67cZQ/vmGPDqH27mU3T2YxLL9dcR1mVQVTaqdV3s7m3UU/dul4qr8c43pg+OgDRSILtvK/E0RqkHi1LLfutEsaU+dB42s3dwpZOhrRQ6RMC3Nr6j+UZFQkio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBJg03aM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBJg03aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA8AC4CEDF;
	Sun, 12 Jan 2025 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736693673;
	bh=9dqA17U4v5bNA6UGoWgoPLebWf69ya2Zv5ng/piZlXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBJg03aMgTB3SBIHF0jV+pBLERVO9yLb6QpQbZh23FT/GVrNZY1W04zM6qkxYj5O6
	 3XypUfgJtbQE2OZB9M/byE0QY2rHn7uYnzNrdx/BlQbeyqDHco5FMxeVhFqi+tF7Tu
	 ljSy+jmHK+l5bXwpUbqtTPCaVnBRh6nFPlvaTc+o=
Date: Sun, 12 Jan 2025 15:54:30 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
Message-ID: <2025011206-poker-last-774f@gregkh>
References: <20250112143951.751139-1-ojeda@kernel.org>
 <CANiq72m=O6LHrj03nTLEtn6wqxe-4ra3UNxV6eUXOQOAW58Rsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72m=O6LHrj03nTLEtn6wqxe-4ra3UNxV6eUXOQOAW58Rsg@mail.gmail.com>

On Sun, Jan 12, 2025 at 03:47:03PM +0100, Miguel Ojeda wrote:
> On Sun, Jan 12, 2025 at 3:40 PM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> > for more details.
> >
> > Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned in older LTSs).
> 
> Greg/Sasha: I didn't add a Fixes since it is not really a "fix" for
> that commit, but if you want it for automation please feel free to add
> it:
> 
>     Fixes: 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")

Yeah, putting the Fixes: tag triggers our tools easier, but we can
manage either way :)

thanks,

greg k-h
