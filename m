Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2CD1E32A4;
	Wed,  9 Oct 2024 23:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516994; cv=none; b=u9Ic9NqYI81KnNPBnzkSBubmBV5uz2LJY8rNOs2xL/KQGsdBhYwdzCNEjGn0c99O/FC5boTvfyBDKJNL9lSX+Yvh7jEsCZLiMGewfRbuRFxWqvkY6zeU8JwZ+1nrFNoZfUR8JTiPi7QwBir7kHiYPJIYl4S4SguAjJTRXKBF4ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516994; c=relaxed/simple;
	bh=j468/JrUCf8OH1l6E2BU4gitw/nNjoblADSJAg2D+y8=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=nAjeB3DkITjL4QhvSi9QVXC0l+N3UmRwOXG9TJVQa/kB/SZk6xnUx3JIFMHawr1OLHGSkBwdyibKiO/w9nVfmMMebgabLXV4bl51MJbABxeT6N3c2YIdw8Sr1WBxilEN+sLH3aCrolv/lD8Kq2bVPjwgbRO6GabMAEdnkEmhvdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFWSr6wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFWSr6wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797DCC4CEC3;
	Wed,  9 Oct 2024 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728516992;
	bh=j468/JrUCf8OH1l6E2BU4gitw/nNjoblADSJAg2D+y8=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=IFWSr6wT7snG08pwMTGtFcE+9iMbDi6/hVmmSU/qu7Pw0S0HRZea53zK5Wz2G+y78
	 nSnXq+hxf0U2FxV+gyxP0PnaUze3BsldKbE+fHKSvnUSEu/7J5JxQwTj2Uo/U9d2so
	 7pR8bnNimJSZJg4nnq/oPI/6i+Yd4p4keDfwvmoXecPWRsPRy34Dq8LVm1/yWGI6Gr
	 6hzyJJY9the9oqacKJg0ncfctj+7IW7xBByKhRbvRCWcdPRH+7op2uOtxnQtnBR8Dj
	 O7zBUUY9IQElGqdBK3oQRSxj3xv9uB3IeXr6FBZM8KL+VuaH6dgkiX/E6RX0FDAIMs
	 lKfCB7NjNvlJA==
Message-ID: <50a53bf0a9829ead3f4eac386018a3d4.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240822002433.1163814-3-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org> <20240822002433.1163814-3-sboyd@kernel.org>
Subject: Re: [PATCH 2/3] of: kunit: Extract some overlay boiler plate into macros
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, kunit-dev@googlegroups.com, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>, Peng Fan <peng.fan@nxp.com>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Wed, 09 Oct 2024 16:36:30 -0700
User-Agent: alot/0.10

Quoting Stephen Boyd (2024-08-21 17:24:29)
> Make the lives of __of_overlay_apply_kunit() callers easier by
> extracting some of the boiler plate involved in referencing the DT
> overlays.
>=20
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Peng Fan <peng.fan@nxp.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
