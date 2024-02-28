Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDFA40869;
	Wed, 28 Feb 2024 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146720; cv=none; b=cUAPxTPmjxfYznIC+3bGEtIPbvxihUxI9PikZNnHCY0e/ZdNTOUT1s19ayxbJ1OgedmzmlTkIPfeiEG2pYMKLPP4fHCqURvlgZbeS56MvNH6XO0v8MezhS0WWFiI9ettAQuWU2Jr6V7glOQRh0e9en3+VkmiY8e2+7bvGL4SkIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146720; c=relaxed/simple;
	bh=N9PlxSvglwl6DPxclJkiWxytKFHxELBDz+lSk8O0zwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myDTEuFsBpyNUxDiJSiSubeOV4LM22CIo1CFLBJ7WVqC5iiGJBKejKq+VYwhO5cDsn9x/0NzAhWGgcvkr251Ch2Z3jzoa2W1YZcURrRODhLzQuuUr0d1WiXR+FHbohvjYNPdDiQkZNl5je84WCEh4QL303iYwro2DOlQS6Tc9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7225C433F1;
	Wed, 28 Feb 2024 18:58:37 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Jason Ling <jasonling@chromium.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev
Subject: Re: [PATCH] arm64: ftrace: Don't forbid CALL_OPS+CC_OPTIMIZE_FOR_SIZE with Clang
Date: Wed, 28 Feb 2024 18:58:34 +0000
Message-Id: <170914663626.3370652.5443900457103339584.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223064032.3463229-1-swboyd@chromium.org>
References: <20240223064032.3463229-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 22 Feb 2024 22:40:29 -0800, Stephen Boyd wrote:
> Per commit b3f11af9b2ce ("arm64: ftrace: forbid CALL_OPS with
> CC_OPTIMIZE_FOR_SIZE"), GCC is silently ignoring `-falign-functions=N`
> when passed `-Os`, causing functions to be improperly aligned. This
> doesn't seem to be a problem with Clang though, where enabling CALL_OPS
> with CC_OPTIMIZE_FOR_SIZE doesn't spit out any warnings at boot about
> misaligned patch-sites. Only forbid CALL_OPS if GCC is used and we're
> optimizing for size so that CALL_OPS can be used with clang optimizing
> for size.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: ftrace: Don't forbid CALL_OPS+CC_OPTIMIZE_FOR_SIZE with Clang
      https://git.kernel.org/arm64/c/a743f26d03a9

-- 
Catalin

