Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5989F198E60
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478811; cv=none; b=qSVMssdNUys2wtEdBQ872fXODVa/sZ1VCCpcbQQtieEq9IIEwLyEg2OjtYoTVm73iZSP82FhdpWTUQTP1wMUmkl81INLJzClWyJF1nUiLlEdMNCsdPnh/c4qx9Ziu1UPevsPg9DlhDwYuG8uhvBfZyOrqCKqcTuizM6qjNlSHIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478811; c=relaxed/simple;
	bh=2qAEBj0gIIHttyMJJjx8WJhzhR4Vy4BIRoF4xlnlwvU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=e46CRavmpAhg/5Kj6QOwpYIyYhoRMooBg4YxQuYggEiPasWxZjC+aVGYWYhN1TmcX/RMlrkQ54sqC7xIgHSZkSE9J2bzD76h973kuprlfWfxhN3wsLrXSht9o7t6l+bppdKBzDKL67mMcwsmvxWV1FL2pMld47jEzpngeGhiDyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mI6A4HgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mI6A4HgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA852C4CEDF;
	Tue, 21 Jan 2025 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737478810;
	bh=2qAEBj0gIIHttyMJJjx8WJhzhR4Vy4BIRoF4xlnlwvU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mI6A4HgU2k+2Lpr4CA9X0b/Be2JU/ezWG95InDiPsDsPDk049BxHit4nmhXfAx0uU
	 P16z9vfEWChmIVwtcxpwo0AgJ7T4aEvXhsBEs71KPOaOYOO6iy+Gr/N9p1EW1PTXKX
	 opxSLS6k75R6cecY5m6EhwnQdKKDnrr+PSCNEzWXC8yQM2iT53gX/1Y/AY+Megu8Uz
	 nDWHTO9Wq1ezf9hrIdWMHc75DTOpVi+aG6cFf+7CfLVf4Zj/qwsDkIn35ZDZAMqhl3
	 eaymlWQJ6rV7QFJfk5xvttSOBdglr3rcHS1fjKMh67jcAtXsOoHNHTCSXbkCeJYFvO
	 EH44Nd5opeZAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34725380AA75;
	Tue, 21 Jan 2025 17:00:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: Fix format specifier in
 sanity_check_inode()
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <173747883502.55169.8800766127346491409.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jan 2025 17:00:35 +0000
References: <20250120-f2fs-fix-wformat-min_inline_xattr_size-v1-1-508cac1474fe@kernel.org>
In-Reply-To: <20250120-f2fs-fix-wformat-min_inline_xattr_size-v1-1-508cac1474fe@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: jaegeuk@kernel.org, chao@kernel.org, patches@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Mon, 20 Jan 2025 05:59:44 -0700 you wrote:
> When building for 32-bit platforms, for which 'size_t' is 'unsigned int',
> there is a warning due to an incorrect format specifier:
> 
>   fs/f2fs/inode.c:320:6: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     318 |                 f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %lu, max: %lu",
>         |                                                                                                 ~~~
>         |                                                                                                 %u
>     319 |                           __func__, inode->i_ino, fi->i_inline_xattr_size,
>     320 |                           MIN_INLINE_XATTR_SIZE, MAX_INLINE_XATTR_SIZE);
>         |                           ^~~~~~~~~~~~~~~~~~~~~
>   fs/f2fs/f2fs.h:1855:46: note: expanded from macro 'f2fs_warn'
>    1855 |         f2fs_printk(sbi, false, KERN_WARNING fmt, ##__VA_ARGS__)
>         |                                              ~~~    ^~~~~~~~~~~
>   fs/f2fs/xattr.h:86:31: note: expanded from macro 'MIN_INLINE_XATTR_SIZE'
>      86 | #define MIN_INLINE_XATTR_SIZE (sizeof(struct f2fs_xattr_header) / sizeof(__le32))
>         |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: Fix format specifier in sanity_check_inode()
    https://git.kernel.org/jaegeuk/f2fs/c/18653662b1f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


