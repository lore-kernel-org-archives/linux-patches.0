Received: from smtp.domeneshop.no (smtp.domeneshop.no [194.63.252.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1323B66E;
	Sat, 17 Aug 2024 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.63.252.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723909816; cv=none; b=NDv+OoUnIhhimVG3LCluy9QqurM3U5tG2QSptkRNq+Mz80apTIXp1g7mgnt4Th89XmDBxnZyNa4MScf2d6QiqyMW2R1r4HPnPk8Zntu868ea4MI6yPqZ2nki8Xg4D5hq+6xJycOgIFnjM/l2RExJs+NPTQZUiKsfMujvNMpDvMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723909816; c=relaxed/simple;
	bh=Zl0ChTncPMNN6mk6yeaJjrVWBKqPdcuuKU+3vckHno4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxUeIrDiR1jSPh7oB/QIj3z+ds6YZVSz50p5z3XduLx54wE7jJublReJax49qZ9oQGrfQmPe93QYJd0yltQg5v4IwCa/RrphFeQN+ERwTbY+F0fgc6NQZR7bCX62vh8a5jsczpuTZQ+woczB5ONHm3LAMOCwh0hXwIiPnAExKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu; spf=pass smtp.mailfrom=fjasle.eu; dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=COPnU63L; arc=none smtp.client-ip=194.63.252.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="COPnU63L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fjasle.eu;
	s=ds202307; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=N0nHQd2qcdVDpmiUaUdSsKPxa/AL8k1EyCsqP9bD/9o=; b=COPnU63L9IYgDxhVeEGTvKfbJZ
	f2dHftrv8PwXzZrtfOEslnCZ2kVxkTtWVsUQa/6gT4pqcGPWXiullIJzi8IXmJwRA9tRvztdFFcSo
	m2WmvTrcIV5FIX+lbFlzNvfGyCiKJDiOW0ZEXfeBNIxQJ9ESCCokH8c304HjVo4WcMWAJBP2zUtZJ
	pIDLnvxYOiJqEaHD/CU9r6KkXjmPPqa7fv+8kNNawNCHiQQrvpj5UF1ADdvS94Eg095x7URM4X/WR
	t5X/sGLjrc9a8CodtkfsKqp2zMlk9AO1Ck3m0JHWqJ+QxYEdv1x37KCdxhkndIndXNjBkEMhPOgPY
	+TGs9UQw==;
Received: from [2001:9e8:9db:8201:3235:adff:fed0:37e6] (port=60180 helo=lindesnes.fjasle.eu)
	by smtp.domeneshop.no with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <nicolas@fjasle.eu>)
	id 1sfLgp-00E17M-Aj;
	Sat, 17 Aug 2024 17:50:03 +0200
Date: Sat, 17 Aug 2024 17:49:58 +0200
From: Nicolas Schier <nicolas@fjasle.eu>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 4/6] kbuild: rust: rebuild if the version text changes
Message-ID: <20240817-ambrosial-zealous-reindeer-de0f25@lindesnes>
References: <20240808221138.873750-1-ojeda@kernel.org>
 <20240808221138.873750-5-ojeda@kernel.org>
 <20240817-cute-doberman-from-shambhala-6f42db@lindesnes>
 <CANiq72nkBoiLUDQjBZi57OYwMpnH8D5Q4wR7XKWMry+mdwFOHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nkBoiLUDQjBZi57OYwMpnH8D5Q4wR7XKWMry+mdwFOHw@mail.gmail.com>

On Sat, Aug 17, 2024 at 03:36:30PM +0200, Miguel Ojeda wrote:
> On Sat, Aug 17, 2024 at 3:04 PM Nicolas Schier <nicolas@fjasle.eu> wrote:
> >
> > Looks good to me, but I'd prefer something like the suggestion from
> > Masahiro:
> > https://lore.kernel.org/linux-kbuild/CAK7LNAQBG0nDupXSgAAk-6nOqeqGVkr3H1RjYaqRJ1OxmLm6xA@mail.gmail.com/
> 
> Do you mean for `core` (here), or for `macros` (in the next commit)?
> (if you mean for `core`, please see my reply to Masahiro there).

oops, I missed that 'core' is delivered external.  Sorry for the noise.

Kind regards,
Nicolas
