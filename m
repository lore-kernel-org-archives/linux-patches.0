Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E294A0C;
	Sun,  9 Mar 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741543608; cv=none; b=pJobhv1eJJEnL3h8vzwRatBKy3m5DbARejZ2S/cOv/ldUIFnZgz0qU8VwsmVzYbKof1ecVgLdLU2UbYzjVutrESTM4yuk4xrvbUBbasHxHWq0ThOUbNkyMgCbCdJbCef7VAu6tiBnSySheNkuvPOtburzmBLiq24BWQYglG2In4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741543608; c=relaxed/simple;
	bh=IcBptB44Pp2GCp+DT+lWCvzQ7EZtuHKGjKG0M0du4Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTArxSuuTA0MXzZu9AlVzXERi/+hGefc6gvQ/R+sh7P2KveEtCfchAbW2tgPOyP915mP+6W1Mdp+ZzbxEqPNFRgoobPgzsl68Ckn+pr3JRXJlBadqenVdPeMPLwZ1BKmA0puwgB+TqRDTdaaU0CzXJ5MAbPb2qLHHH4ls9tq6IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPKXnHPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPKXnHPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFFC4CEE3;
	Sun,  9 Mar 2025 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741543607;
	bh=IcBptB44Pp2GCp+DT+lWCvzQ7EZtuHKGjKG0M0du4Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KPKXnHPSYV8MZZUueeRB7MF9nZHHkXIrs8ADSDGSbG2dIoGT5V0ePUff7/60AkhG4
	 yE5Hap+Q1T6dWlqLtvpUsn3hkR7gdfoRwZNI+VuqCaLlTpBPxXBNkcxyxO/yghq7Zf
	 k8llb7le44tFiTCL4rC8erXymQCsfjw3V9DkMVMlR9gniT6pr5b076z9fb3qHgNWnX
	 0lR31zhvh0SGref7vZDHE70NGz/IU1AgmdM0Pp+bdqH7nn6lrTqgx+fepKlJxLShxd
	 wxoMvEfq3weyvmVN7Ct/OApDkZf+xDzdbChtDYQSAOFG7aC9/yl52Tyu55JU5fZW/s
	 CYZ8druUXqprw==
Date: Sun, 9 Mar 2025 19:06:42 +0100
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
Subject: Re: [PATCH] MAINTAINERS: rust: add tree field for RUST [ALLOC]
Message-ID: <Z83YsnKdB7eYiXDs@pollux.localdomain>
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

Acked-by: Danilo Krummrich <dakr@kernel.org>
