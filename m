Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245159B71;
	Tue, 22 Oct 2024 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729631367; cv=none; b=pBpP9U3UYKS3sv6dPhSn0qLqse/DfBgzV8usOxJd0qLb7u4gHR67ywwhXroKkrPOD5xfOgG+6giyZnvMNMEw9FTfvhtd+QF1zOE0C5q2g/xJ1dT0RHBqeQqTJltfNB8+FZ6hlzwZK5OGyV8diE9ylo2YclOSp5GkJePdTOjOxu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729631367; c=relaxed/simple;
	bh=Sls1pC3x7RnvpCJwxp94bwSPKYDFgvZiA7txDD5bPqY=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=E4icZ7eRLwQ8BWv2wAaPZGfTZn9i6wdnTtor5n04yjdLWomFDWgNFSsbEpOADcbmQsfIF38ISiqXDBQ5llTyzXbjRGu6St+Hs5ED2a/Sy5uMEz4/gy/KWCfa8W0E0m9ag+j/y87dF/DndK8ekw1ZRsZqXwNodWz5nqBGASSV78k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSJAMfGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSJAMfGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101FC4CEC3;
	Tue, 22 Oct 2024 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729631367;
	bh=Sls1pC3x7RnvpCJwxp94bwSPKYDFgvZiA7txDD5bPqY=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=RSJAMfGhQrKDPT45L8i5kDgaULY/+o2Nqeiaha4MSQYd65jS+YZJMioOtE0iyZ3N3
	 BpwOPho81mMqIhou/O6F5XFec2S5kEHEzODmjjcTSdYfQDhjZ8/+En8iWyVcCBpLbE
	 HjtxXrBQRzRVunjG9uDb6J/7DWrKvq9zJloYnri36yqUbNe2WRo4GBbMw9HPvvP8YY
	 7MDZWKbNvjH+7Y+SVWhySMb1RTNdTHnUYclYrUElA0FAV9MOokbNjATIQMFRCmxZkA
	 vvlIWTDVvSJABNjDVVaiUbX/tzYQSuTzV5Jb76Eb1Z6DzqIPQAPg3EJ8R2JwY3C9id
	 MhaS0jQUNdSrg==
Message-ID: <8b284963604b070970e37a438b137146.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241016212738.897691-1-sboyd@kernel.org>
References: <20241016212738.897691-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: Allow kunit tests to run without OF_OVERLAY enabled
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, kunit-dev@googlegroups.com
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Tue, 22 Oct 2024 14:09:25 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2024-10-16 14:27:37)
> Some configurations want to enable CONFIG_KUNIT without enabling
> CONFIG_OF_OVERLAY. The kunit overlay code already skips if
> CONFIG_OF_OVERLAY isn't enabled, so these selects here aren't really
> doing anything besides making it easier to run the tests without them
> skipping. Remove the select and move the config setting to the
> drivers/clk/.kunitconfig file so that the clk tests can be run with or
> without CONFIG_OF_OVERLAY set to test either behavior.
>=20
> Fixes: 5776526beb95 ("clk: Add KUnit tests for clk fixed rate basic type")
> Fixes: 274aff8711b2 ("clk: Add KUnit tests for clks registered with struc=
t clk_parent_data")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
