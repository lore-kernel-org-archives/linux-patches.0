Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F74D286881;
	Fri, 20 Mar 2026 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774032766; cv=none; b=KNcgl+o/rqiotKFGN5MrhqXtAoLN0bg7MjY9HSX6czihJDjZroircM6iywRBcZuZl11Pol8lKfnY3Zia10ZzfmaHtFjruxATi8ORhYwYddBM5aSqsAhXzEZW5GyBskXbweWaTOqasRF6lPNdCvw92cGG704zmJEdy+60kyJL0gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774032766; c=relaxed/simple;
	bh=yZxmNupLjMnOVyoVWs6WeaGs693HPuq7zByuOqLBqsE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gi6/rK9Z7I5O4eNqSISldMY4XSAkyY4MVEF9yR3L9+vdTs/tJ71RNhH5jBrIhw6OgnGkpvfrOnB01sZOzwD9OEk3a6etCTvV9RRITIlSU8ahR3ghF4rAUzaKqRSGzKRqf076s/TbsUG8l5ctkkq+8KqbaBM80GV9wg433r1H6Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0WJEZd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0WJEZd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F39C4CEF7;
	Fri, 20 Mar 2026 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774032765;
	bh=yZxmNupLjMnOVyoVWs6WeaGs693HPuq7zByuOqLBqsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0WJEZd/D8wpi8ysSQnHaf0MkjQCJTR0+U5/8AUsnpws4eMIRPuTjZhPCNEvheoIO
	 eQCdjMru8TLGPkB89E5bBIFxYZ8fYkcRSeVg8szcjeD18YP/fP+nuTXETGRhAvPTD5
	 LAO1xmPSPbHSewCQgKt9sbciqtQvVEEyCBNV71Arn5MwICPhHvBPwHvgqxe4szQpna
	 bUEX+C8+JCUAVXBcZdxZHg0iN5qWuIddfrpPqe4bLoKv8INVYCEweS0XyDMHqZS0oD
	 KB+vOwQTgi3d87P349WofmjtzbBufiTRvGhwVe9f3j1LmpJDAYYSY3ud2iAbPtP+2F
	 773vOPNa6zXjA==
From: Kees Cook <kees@kernel.org>
To: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] init/Kconfig: Require a release version of clang-22 for CC_HAS_COUNTED_BY_PTR
Date: Fri, 20 Mar 2026 11:52:41 -0700
Message-Id: <177403275866.3826131.2167472865845160418.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260318-counted_by_ptr-release-clang-22-v1-1-e017da246df0@kernel.org>
References: <20260318-counted_by_ptr-release-clang-22-v1-1-e017da246df0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 18 Mar 2026 17:20:18 -0700, Nathan Chancellor wrote:
> Commit 150a04d817d8 ("compiler_types.h: Attributes: Add __counted_by_ptr
> macro") used Clang 22.0.0 as a minimum supported version for
> __counted_by_ptr, which made sense while 22.0.0 was the version of
> LLVM's main branch to allow developers to easily test and develop uses
> of __counted_by_ptr in their code. However, __counted_by_ptr requires a
> change [1] merged towards the end of the 22 development cycle to avoid
> errors when applied to void pointers.
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] init/Kconfig: Require a release version of clang-22 for CC_HAS_COUNTED_BY_PTR
      https://git.kernel.org/kees/c/7a618ca9b9c4

Take care,

-- 
Kees Cook

