Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04AF1E47A5;
	Wed,  9 Oct 2024 23:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728517001; cv=none; b=GWzxAWkU0hYlD8DUHkmgNXWip6gc4ZQvDd/qCLOrxWqEnRdQIH8R416HqqUIoR71Srsn0XRUX2zu6sUZ86dOj9MtAmlaMfxmU5HlLqSnZ9A+1gWB0f6DOFfakinmhxHKl+dQAYp8sBp53UjG7ojzUyC94wFX8SgcrWLF1Pm3RsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728517001; c=relaxed/simple;
	bh=hwDlfa3ra04ZdUArBbyefdHz8Us7A772ktBDQcegki8=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=DRshIDgzUf4SursZM8qNSt0AkUTL81n0vXqhWgjXcNPuhhnESbMaILac+PHAsrbwWVWfYat/0jRCKxv8fA/057Xc7Hxc/XbatNCUmxLI8gl0A2cMuL+IWuR4n08rAkX1dY35NhlndIh41/DKIYT93dELwEF2EPdPueZJYbaxm8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvmxhVdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvmxhVdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B427C4CECF;
	Wed,  9 Oct 2024 23:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728517000;
	bh=hwDlfa3ra04ZdUArBbyefdHz8Us7A772ktBDQcegki8=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=fvmxhVdKylBQGIf6/yOpqX0klEYGhBpIb1MufmshPWCkUurI0zy/3iLYeJG6sMHHq
	 t6CVIGY5YCdLMQfJfOuRACTD3V8vMXcuF/fwrmR4ELKOUjg6ATNe58jj0hrfzD8B33
	 k9KnXR9sw17gLwHkXKeR57b8ta7428pLetg6yu4FcSAJmLCG067/Aq5/Qm4S65Anox
	 P2VbimmXXKMsz4kbmbEUnrVIECXEuiSIvOO7NeA0Li/Q5qwQ5CkWUAOgdgsqCvogOO
	 Cfh9oWD3mFwTH4LUp0cw/uWchwR2sdP0gZ56au+zrIkeyPItCaKjDs5mQaJakmxJGD
	 SwpXNTB8heK3g==
Message-ID: <859add80e7737b1f9efffceb88c54e75.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240822002433.1163814-4-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org> <20240822002433.1163814-4-sboyd@kernel.org>
Subject: Re: [PATCH 3/3] clk: test: Add KUnit tests for clock-assigned-rates{-u64} DT properties
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, kunit-dev@googlegroups.com, Peng Fan <peng.fan@nxp.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Wed, 09 Oct 2024 16:36:38 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2024-08-21 17:24:30)
> Add unit tests for the two types of assigned rate properties. Test
> different combinations of assigned clocks and make sure that rates
> aren't assigned when the DT properties are malformed or are zero.
>=20
> Cc: Peng Fan <peng.fan@nxp.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
