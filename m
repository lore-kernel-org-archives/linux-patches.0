Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A44318FDAB;
	Wed,  9 Oct 2024 23:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516985; cv=none; b=Dupk6FUMBEw1KT0ee0MloSFaqZ2KXyiF91QWvspUM7CtrNr+IYBfWYDxOUIgdvryWs5aHQtWaXagsTGnkUZzV0kPsXQ5+CXlKBn8nID91ItbnMGJ/hI1XENe7+y2MNYQvwVPjLxuk+uYSlQUHSwIWzDmgeQks1vc1FXM07jlnXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516985; c=relaxed/simple;
	bh=/VfS4CHIQj+iCyyZqg1FjUxPBhsxt0XrNouVO7Jdyeo=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=HEpgFLMUhUqjcscQYTNQX6utZTf3d+qRrWNTK6HcbEMhZrJ1G5FpiwwS/1E+t1WeYPYyMAtmB76wPrUkuWofXPIzFX9Q7chHbI3jn3i5VJO7ejNys2EhVJepqjQlJyvur7Pkx26QwEHOlGPvK+V75tC10dJKbtkQbm/1DB5MoVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPAShg6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPAShg6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B96C4CEC3;
	Wed,  9 Oct 2024 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728516985;
	bh=/VfS4CHIQj+iCyyZqg1FjUxPBhsxt0XrNouVO7Jdyeo=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=uPAShg6MCbY9aqslhpIouTyzmfHcbVey4OTAJ0tsbgqmmDH3/oo7SbBRiTxXI6eDZ
	 ILCSSdQsengNgFPEV6H6gzWy3Gl1P84tIktNxw6ApKa9B+vzdKgltOJvkESO89eoWI
	 CeNqHfTHo7FSQug0R9UMJhV+enkwDzwB7A4GuS+VOr06IHJ9I/vnZ4goAVJnEk9riH
	 2LlvAgnfJ3PxlUaaSp8P5Lm66zEPXY9133Y6oDDsg6icBMFpEUQ82lktcJM0psfAQS
	 yMaNUgc7YmHSa0k8XWk087iaPcd8570J1P/kXwgPDrX2qowfFkMKouma7PxlYYlTBt
	 ZMrCYi2ItBZNQ==
Message-ID: <db18990385891d2c47c0c007965b7f41.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240822002433.1163814-2-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org> <20240822002433.1163814-2-sboyd@kernel.org>
Subject: Re: [PATCH 1/3] clk: test: Add test managed of_clk_add_hw_provider()
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, kunit-dev@googlegroups.com, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>, Peng Fan <peng.fan@nxp.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Wed, 09 Oct 2024 16:36:22 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2024-08-21 17:24:28)
> Add a test managed version of of_clk_add_hw_provider() that
> automatically unregisters the clk_hw provider upon test conclusion.
>=20
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Peng Fan <peng.fan@nxp.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
