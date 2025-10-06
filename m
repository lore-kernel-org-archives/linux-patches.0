Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB615667D;
	Mon,  6 Oct 2025 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759792424; cv=none; b=gpazi+8AyE4ZchmZyz2N9TsloKwQ/XCeUjoagNiVLw59Dt0YIjvrJpoKsbpXmbAGb87bnWiXY4eRkXFUDYvAq6kTEfTDBP4rGrx2Ag5F2UHVQvMbXQiVRlnengBjolUOdTpGqX1PfLYaLO82GWFKYD+06Oj8elYUmfNm65yN/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759792424; c=relaxed/simple;
	bh=tLxUDT8VxXFPFnuT+CrckMnld9Zv9Ckx1PPsCInUXNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8c7aeP92caA+1FKc0SjjcgNQAhBXYGL4rn8MqHkEsYCG09jCp+H2VC85QDt2nftwo4EzRMB0gdahZna0jKQx1vP1cC2G9V3zsXH9CDI3CZgas3KJ4iVSDEgnRr1qBYTegEwTAHd6q7k095e4W0LLLyviTImW1w8/UIYWAKNXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANrGMgQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANrGMgQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4797AC4CEF5;
	Mon,  6 Oct 2025 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759792423;
	bh=tLxUDT8VxXFPFnuT+CrckMnld9Zv9Ckx1PPsCInUXNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ANrGMgQUebt+vnoKrOkHX9a8pceog9ly8XuX9PtfTyjMk0YSnKnlde22xzVYIp6/v
	 JB5y2YpQdveQSUOEb/nwuwXXKXw3DywiOGVLW9oTv3RfR/nRYbuFW1gDrzdrs+PxTD
	 sXb0qwOD5YjT90IFApp0q8tjbnWQrtixEAlrHj8o62CdF7M7V6MIryU/QHSAE4R+WE
	 TXQJWyhRQPOe3SHCabis8w5W7Mk3y3iFm5xDjh7O6zqp9VAlbFr1BS8cqAixQk+wjO
	 Dz2CKHfy8gAC8+RJxz+NxSqlwu2Hr97AxJ+NBPaR8wHHyn1djSVdA42XTP8LqCMoW2
	 ahr2/YVOldHNw==
Date: Mon, 6 Oct 2025 19:13:39 -0400
From: Sasha Levin <sashal@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.17-5.4] x86/build: Remove cc-option from stack
 alignment flags
Message-ID: <aORNI3nnm5PRvNuT@laps>
References: <20251006181835.1919496-1-sashal@kernel.org>
 <20251006215505.GB3234160@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251006215505.GB3234160@ax162>

On Mon, Oct 06, 2025 at 02:55:05PM -0700, Nathan Chancellor wrote:
>On Mon, Oct 06, 2025 at 02:17:33PM -0400, Sasha Levin wrote:
>> From: Nathan Chancellor <nathan@kernel.org>
>>
>> [ Upstream commit d87208128a3330c0eab18301ab39bdb419647730 ]
>>
>> '-mpreferred-stack-boundary' (the GCC option) and '-mstack-alignment'
>> (the clang option) have been supported in their respective compilers for
>> some time, so it is unnecessary to check for support for them via
>> cc-option. '-mpreferred-stack-boundary=3' had a restriction on
>> '-mno-sse' until GCC 7.1 but that is irrelevant for most of the kernel,
>> which includes '-mno-sse'.
>>
>> Move to simple Kconfig checks to avoid querying the compiler for the
>> flags that it supports.
>>
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Link: https://lore.kernel.org/20250814-x86-min-ver-cleanups-v1-2-ff7f19457523@kernel.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>...
>> ## Backport Status: NO
>...
>> **Dependency Analysis:**
>> - Requires minimum GCC 8.1 for x86 (introduced in v6.15 via commit
>>   a3e8fe814ad1)
>> - Requires minimum Clang 15.0.0 for x86 (commit 7861640aac52b)
>> - Both requirements are satisfied in 6.17 stable tree (verified via
>>   scripts/min-tool-version.sh)
>> - GCC 7.1+ supports `-mpreferred-stack-boundary=3` with `-msse` (per GCC
>>   commit 34fac449e121)
>...
>> ### Conclusion
>>
>> While this commit is technically safe and provides a marginal build-time
>> performance improvement by eliminating unnecessary runtime compiler
>> checks, **it does not meet the fundamental requirement for stable kernel
>> backporting**: it does not fix a bug that affects users.
>>
>> The commit is purely a cleanup that removes obsolete code after compiler
>> minimum version requirements were raised. Such cleanups belong in
>> mainline development, not stable trees, which should focus exclusively
>> on fixing bugs that impact users.
>>
>> The fact that it was auto-selected by AUTOSEL does not override the
>> documented stable kernel rules. This commit should be **rejected** from
>> stable backporting or **reverted** if already applied.
>
>Based on all of this, I would agree that it is not really suitable for
>backporting (at least not beyond 6.15, whereas the subject says back to
>5.4), so why was this still sent for review?

Sorry for the noise, I thought I dropped this one :(

-- 
Thanks,
Sasha
