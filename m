Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958314C7A
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096BFC34115;
	Fri, 15 Jul 2022 19:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1657913465;
	bh=x+xlVP4yLav8kNyp2YJMEDuyApybnhhJ7yfzVSRa83w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EGvS8D6erjaw4sSS33OyCRgnt9ZUYNbvWnwLAlXQZ1EFwDzofksLizRUem7A3ElV9
	 Amn35kopAoabsBWUg2aEnLAiMgdzgTU1mrnVLvz/ZyAoeLSDEdk82Ff8A4N7nxOG3r
	 nLYQXb19nTEFB40h3+DPrdEZ2+NLOsiWFOxdnr5Cx0Wgiavr60g4Pde9RxUDq6j1tp
	 oYvaFy8y4HhMF8oUS112a937ODiZGAXunsMr9UCbqhKhwHgBjMWnUs8yugzgkEoNKk
	 MXHdT8CAAfpv0jtYgs+QyqWO4rPsWrHT3AAxO+RPV39BxiY82jy0dHSfsENzBLXZ88
	 a3TerSur2Ef/Q==
Date: Fri, 15 Jul 2022 15:31:03 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linux Patches <patches@lists.linux.dev>
Subject: Re: [PATCH v2 3/3] Add myself as ultimate maintainer
Message-ID: <20220715193103.xoeeqvgsh25pskzl@meerkat.local>
References: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
 <20220707-my-new-branch-v2-3-c378d618b16b@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220707-my-new-branch-v2-3-c378d618b16b@linuxfoundation.org>

On Fri, Jul 15, 2022 at 03:20:31PM -0400, Konstantin Ryabitsev wrote:
>This is not a real commit. I am using it as testing grounds for
>b4-submit. Do not read anything into this. :)
>
>Acked-by: Lol Whoelse <mricon@kernel.org>
>Tested-by: Mister Mismatchy <mricon@kernel.org>
>Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

Reviewed-by: Sockpuppet Extraordinaire <mricon@kernel.org>

-K
