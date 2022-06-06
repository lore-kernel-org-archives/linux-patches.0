Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651471FD5;
	Mon,  6 Jun 2022 03:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07FCBC36AFE;
	Mon,  6 Jun 2022 03:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1654486430;
	bh=GvbnNdDO95Viv4J08oBd15X/hC/cew08t9KpoUk6BoM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=q0E3wy1n1jEU0ZITn0noAJw5W16quomE4u+H5T2nj+WCyMpxDRu7XnKzpN26wCR61
	 MnmEq2m9czldbZte/wDySuCe6JaEva7mT2ZOlQff4mae2rs3k6+JEY/KpC+FVNwnOi
	 VZnU6aqhEwLbKW1JiCXksE4dLALpzk055saaImz2LHAhCTXFwdCUtv5dUbQyd2XXo2
	 O4qzcRofc760Q1wjdNxim3EipfH16Z4I0p/3SSCoIp5ZhOuGIX6Ul4JtEaNzy9BNew
	 fF9zWS20pUM2bDMqyGlsQ5CpwM5abPloa+eFxyGT9BGT1AOYZOyhUdrnkrZ1KytrYU
	 IZZqzlvC9G1ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFECBE737F4;
	Mon,  6 Jun 2022 03:33:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/2] Input: cros-ec-keyb: Better matrixless support
From: patchwork-bot+chrome-platform@kernel.org
Message-Id: 
 <165448642991.20111.2194828010616443866.git-patchwork-notify@kernel.org>
Date: Mon, 06 Jun 2022 03:33:49 +0000
References: <20220516183452.942008-1-swboyd@chromium.org>
In-Reply-To: <20220516183452.942008-1-swboyd@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, chrome-platform@lists.linux.dev, krzk+dt@kernel.org,
 robh+dt@kernel.org, devicetree@vger.kernel.org, bleung@chromium.org,
 groeck@chromium.org, dianders@chromium.org, hsinyi@chromium.org,
 joebar@chromium.org

Hello:

This series was applied to chrome-platform/linux.git (for-next)
by Dmitry Torokhov <dmitry.torokhov@gmail.com>:

On Mon, 16 May 2022 11:34:50 -0700 you wrote:
> This is a followup to my previous patch[1] that skips keyboard registration
> when the matrix properties aren't present. This adds a compatible string
> for this scenario so we can ease existing DTBs over to the new design.
> 
> Changes from v4 (https://lore.kernel.org/r/20220503204212.3907925-1-swboyd@chromium.org):
>  * Make switches compatible fail probe if no switches present
>  * Add description to compatible list
> 
> [...]

Here is the summary with links:
  - [v5,1/2] dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
    https://git.kernel.org/chrome-platform/c/52dc6d3bea3b
  - [v5,2/2] Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb compatible
    https://git.kernel.org/chrome-platform/c/ca1eadbfcd36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


