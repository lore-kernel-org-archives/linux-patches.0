Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B11738398
	for <patches@lists.linux.dev>; Wed, 15 May 2024 04:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715746830; cv=none; b=O3tgr8cn/j6a6zuF0BqM7amhWd7PWr6wWREXwIiGKcbmhBARTYSAqgOc1Fvy8ARqQfeKYHt+A6PP0rV2Wnf97eYh31XIlSEMYIwICwzi66SoGqQEW9Jyj8QlJ5pfZN2Jov2wXOehsKbhXL22hTwV0BgnL0IUI2U8O8YIE2RqHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715746830; c=relaxed/simple;
	bh=1ofwj436NrM34CmDoFPWr6B9luRSA0vYiPnU6O+IvR0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=r+ciUOEWLN2VQxx5RD2Uj9ziO3WKrF8ZdjSvG5WotkTq52Pz/d0k772S+tjtdTLDMdv0pqh0I8kftIGbdU0qNrkAKL12cqx9Ec9Pes6P08wYdmyjJO+F4JP8lrNOyWOrH5Q3f1nKDj7Z0Pk/lGRcNKKSQSphqahEuSPA2wzjAiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slhaMT9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slhaMT9U"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 158A3C4AF07;
	Wed, 15 May 2024 04:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715746830;
	bh=1ofwj436NrM34CmDoFPWr6B9luRSA0vYiPnU6O+IvR0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=slhaMT9U5YMhWbSV4GckC1qRJExaU2zxOEQNKR9hn/uCYRM/hHLiecfvi68CUT9Ij
	 WY628LpcAEpydEm6eX9jMWsusEZRw+bzIOolJgSzLtgmG+QfQjIB3WW3au4PatxP8X
	 kid41D7Tf4CY5CVVUMrFA/LiA1djzc2Q28oW0gonLIovExihIP9S7/8WtewByOy2/c
	 posgsjqqWM8L51l7Z7lGe1av6n1J2VP/1Se8YoizXp/kushG6kSYTkOZ7aXFqX5Ptt
	 GJl2e8/YgnWj/6UlMBrmSkLgPOwhQcONyQQYm5FHEDHXGzPTue1gabrRhy57awhT+O
	 rm8xbULO1hBlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02D95C00446;
	Wed, 15 May 2024 04:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] f2fs: Add inline to f2fs_build_fault_attr() stub
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <171574683000.29254.6275532589303918207.git-patchwork-notify@kernel.org>
Date: Wed, 15 May 2024 04:20:30 +0000
References: <20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-v1-1-c3ce1c995fa2@kernel.org>
In-Reply-To: <20240513-f2fs-add-missing-inline-to-f2fs_build_fault_attr-v1-1-c3ce1c995fa2@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: jaegeuk@kernel.org, chao@kernel.org, patches@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Mon, 13 May 2024 08:40:27 -0700 you wrote:
> When building without CONFIG_F2FS_FAULT_INJECTION, there is a warning
> from each file that includes f2fs.h because the stub for
> f2fs_build_fault_attr() is missing inline:
> 
>   In file included from fs/f2fs/segment.c:21:
>   fs/f2fs/f2fs.h:4605:12: warning: 'f2fs_build_fault_attr' defined but not used [-Wunused-function]
>    4605 | static int f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned long rate,
>         |            ^~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] f2fs: Add inline to f2fs_build_fault_attr() stub
    https://git.kernel.org/jaegeuk/f2fs/c/0d8968287a1c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


