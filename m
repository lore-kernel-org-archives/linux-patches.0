Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFDB82488;
	Sat, 28 Sep 2024 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727557181; cv=none; b=BsQGz6cg1LYOAgS6f77S486PlJ+u41PhaScSNxrASj2wmfndjeAzW9xxCm6FRoQ1qXLLW1XwcaY+7oY3kJsFBVf+BFoc3VoOtI/Up0HNpreuSc8wxlSM4fUXk6+LFpFl4Hj7GpNl+ayLNgzUaw35LLlvgarfGQyzYd0jl4gAhJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727557181; c=relaxed/simple;
	bh=tM0LEarIrzCVhjEIf42iz3zcmyu4fF0r633gNd57Lfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjE7LKNIJfz+OsKQ5/GqUunA/q1M6xme4OyZbXDGi5AA7+idQivHPyxYsHQnZ5mX9WwgMzlaQrCJRh4tEQwJERXfn6rjzHpoaeQWocLxZHOWIlyv3mQVNdOEmoHiBHxnYu2s7SXR1KB5P6k34tHeB1RB9b4bbjoJhVeMRHad0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptCv7lej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptCv7lej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51C5C4CEC3;
	Sat, 28 Sep 2024 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727557179;
	bh=tM0LEarIrzCVhjEIf42iz3zcmyu4fF0r633gNd57Lfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptCv7lejTZLSYcRD/O9wPxb1a65eGdyonom6uBAKpynBAMF67EU7cb5tKgjzFsb+Q
	 Kas0RETX79L8MOkj+UJadJmOjzQdNbUCXMtcMcb+i6cXFQTWYSR7J2URx1X5ESeJps
	 rCo4scyxh+cY3yxoFj7RMkngSbRvQCvlCPRTYHj2zeMkbEfIWos9nFsoutmECdEbf0
	 VvUvz2c7SbrqmVJLBb9v6DMKTznuhClfpSemWKMN9cBB4PXdcPpV07ne9gySsMztxt
	 sO2yb6PJXC6Eq/teFG+AqYlb6Kdt1KgZ/dsGKFBk3j8QSLv6HG8wwW78QuxH0qNqg2
	 bbZ6extxJVSLw==
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] hardening: Adjust dependencies in selection of MODVERSIONS
Date: Sat, 28 Sep 2024 13:59:35 -0700
Message-Id: <172755717414.3162722.13873506895313493619.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
References: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 28 Sep 2024 11:13:13 -0700, Nathan Chancellor wrote:
> MODVERSIONS recently grew a dependency on !COMPILE_TEST so that Rust
> could be more easily tested. However, this introduces a Kconfig warning
> when building allmodconfig with a clang version that supports RANDSTRUCT
> natively because RANDSTRUCT_FULL and RANDSTRUCT_PERFORMANCE select
> MODVERSIONS when MODULES is enabled, bypassing the !COMPILE_TEST
> dependency:
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] hardening: Adjust dependencies in selection of MODVERSIONS
      https://git.kernel.org/kees/c/dd3a7ee91e0c

Take care,

-- 
Kees Cook

