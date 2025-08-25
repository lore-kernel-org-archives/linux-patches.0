Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E93EEBD;
	Mon, 25 Aug 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128305; cv=none; b=dYvIvRuNoZMcRRB26OhjqYaypkP4AEYy+cVHGzSbw9LjkzoDMBuOlbDStas+972/X7AcAWEHpb6Zl4gSLUkVX7WTMMOVGqICsHHNUKV6Avblo/akygNs6Z+4PpZcLFsjTek4k3JM8IAzUl+w1kfz//mFQBzKjilQDDdpL9AIKJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128305; c=relaxed/simple;
	bh=oxp9yvF+n0i71BJjAd2BA7FgZBFAQoFQbazz+ja8VsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WA1Q3/h4GajNGatJUTXu3w6P3Rg1GUU9myRHGZt4cV7Gef6gHMTez9+CoCMlFoGs+8fEaSlmpDMBUuKDMMR+cgqsHet+fRriJ1h9kRKD0Q63rFDK9cGvp6v74vWqZ9gPwDRcdNZdivQClOQY/Oukf0qNyUgjp9LuounlIa994d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJ82w7fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJ82w7fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DD8C4CEED;
	Mon, 25 Aug 2025 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756128304;
	bh=oxp9yvF+n0i71BJjAd2BA7FgZBFAQoFQbazz+ja8VsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJ82w7faSbCM0h7bldpujTb59xvahMEOm0pDooR6fCy7ievEilcx9fy9RNraYAosi
	 GlWbt5N2nBqWUnHfhnZNgeVYYZjRWSPzyxx+k16cCjing1CrYCfeJojEenNu2hRqzV
	 3WLTMGRFk6Fcz8PlOpgpFyQv2oOepx89UWRYSnI/soXp+PiAi0XE1Y2yJJB2ZVkoq9
	 +Vwq74CmREUkXjAz9qadvs6X9iMYmiB5iEk1gE4NRTDS9gxjMjNg9/GaPFv+UpU8NJ
	 MkpXH0p/wU4lWofymkoo8ft48YBfSrXPoiIcPXc6utG4Fhe+tcNJ560j9sCpAMBahx
	 WbSKuqe4NAywg==
From: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
Date: Mon, 25 Aug 2025 06:25:01 -0700
Message-Id: <175612830030.1493362.14216012036494775840.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 07 Aug 2025 14:36:28 -0700, Nathan Chancellor wrote:
> After an innocuous change in -next that modified a structure that
> contains __counted_by, clang-19 start crashing when building certain
> files in drivers/gpu/drm/xe. When assertions are enabled, the more
> descriptive failure is:
> 
>   clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayout &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Assertion `D && "Cannot get layout of forward declarations!"' failed.
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] hardening: Require clang 20.1.0 for __counted_by
      https://git.kernel.org/kees/c/871fcff457f9

Take care,

-- 
Kees Cook

