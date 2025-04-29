Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FB3770E2;
	Tue, 29 Apr 2025 20:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960112; cv=none; b=sxKej5gNqaD65aRypXJ1vEth9NwHTyzv8SiOsEu9+lfH4JuHpTfnQfKQ5TV3f3Lk5SOLq2GUmp67ZLv1xh5hACXw1NK/bYWboypnutthIa3YDy7920oHLHdCg4VtIAydmlZg2PCcDTQm9wQhLkVB3/e+Mjvuv043mxZ+8KXrH1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960112; c=relaxed/simple;
	bh=BYF3v7PG7JIEiJOzB7iZ7aBTy5cUuCUpVXTbXDDOWsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=goiUPGGLcxaIt4RLODHz/jRHn7xkT7Y73rn2vsjjP4nyYi//Y6rZD9gM1GbNuoWO5kfMP9LOcPHeG4N5j/tNYzt7hc/Utja4BuU2lKgEmb/gtuJsL4GGI494wMhGEwQyc+Cr+4KCeu1dTsEgDnjnYD8Dwrpwa+eNtCHgRqxbhrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=riKHIL0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="riKHIL0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E68C4CEE3;
	Tue, 29 Apr 2025 20:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745960111;
	bh=BYF3v7PG7JIEiJOzB7iZ7aBTy5cUuCUpVXTbXDDOWsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=riKHIL0JJvMRf3XuX0xXnUqDdUSTJf90Ks+kvntI3D9DUtP1qHqs9kS2CglbjaDh9
	 9MH4XRTOd7sbMGQsHCkLclO/xVXo36XQqaUazwsk41k/2NmQZHQWck5eAVnrLx+tdm
	 qfK68Hnr4gO3Ynq/BevEVeuc7A3lUcjMEvv9Uyembi2WyM79JErjmhGvtCgWzVo9ys
	 A+pluBWYKrsUyK34J2Ui0gmgn/mJvhPPVcywk+Al8WrJbGaLqguvnwkUFTmyrBzllm
	 paOvOSRjzErhS6hx3T6M66W7l6UHgIsN6wvpnEUIr36o6TDpQ32ryoMIcBR+r88RGD
	 ZJyN0aqRaH3Lw==
Date: Tue, 29 Apr 2025 22:55:05 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] rust: device: allow `dead_code` for `Device<>::parent()`
Message-ID: <aBE8qQrpXOfru_K3@pollux>
References: <20250429150346.392050-1-ojeda@kernel.org>
 <aBEXUG7QH0ymRuLm@pollux>
 <CANiq72nf86+OcMTNPQVnF=pXuaJVw0bFixMxs6qwS5vTh7RWxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nf86+OcMTNPQVnF=pXuaJVw0bFixMxs6qwS5vTh7RWxw@mail.gmail.com>

On Tue, Apr 29, 2025 at 09:05:21PM +0200, Miguel Ojeda wrote:
> On Tue, Apr 29, 2025 at 8:15 PM Danilo Krummrich <dakr@kernel.org> wrote:
> >
> > Maybe there is a much better solution I don't know about.
> 
> There is `cfg_attr` for that, and we use it in a couple places, e.g.
> 
>     #[cfg_attr(not(CONFIG_AUXILIARY_BUS), expect(dead_code))]

Well, that is much better, thanks!

I prefer this then, I really want to catch if some other code starts using this.

- Danilo
