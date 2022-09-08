Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF517C;
	Thu,  8 Sep 2022 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CC9EC433C1;
	Thu,  8 Sep 2022 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1662597617;
	bh=b6yDN9tL08hslGgkBfYdfe20UmnjH2C2An5qrfEe4l0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=g2D0zVoaxfwjt7EgshshVXT3i8tRgOvLpgcU0t7KuhI7qf2lW1jxlQTU0zmOxdAGA
	 tf4piocTSKuxcKH7LRIoaYWdWlCy6yjSV/23p+pdEjexdFm7O88toNDAoiJYm9PFRj
	 sWjbxVWs/utmlymcWQ53afnzks0MBUDaZNeJrAfbX63z/HsNRifAaSUOkTl3h4H5Xq
	 vuiz46B/vIC7bBoW3MZyppsIqbbmpcPTgNgSBeeeME9bYLhmA69fwLbLifpVn38vV/
	 OtP/HjwR+KBqtFfTP65IT+sBi+av1e2UtMXUOQuL0WcijJd80bN+SuHbolwac3grgs
	 PcTyFl8L+EmvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D8CBC73FE7;
	Thu,  8 Sep 2022 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] platform/chrome: Minor cleanups to cros_typec_switch
From: patchwork-bot+chrome-platform@kernel.org
Message-Id: 
 <166259761737.4687.8715779672113750090.git-patchwork-notify@kernel.org>
Date: Thu, 08 Sep 2022 00:40:17 +0000
References: <20220830225831.2362403-1-swboyd@chromium.org>
In-Reply-To: <20220830225831.2362403-1-swboyd@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: pmalani@chromium.org, bleung@chromium.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, chrome-platform@lists.linux.dev, tzungbi@kernel.org

Hello:

This series was applied to chrome-platform/linux.git (for-next)
by Tzung-Bi Shih <tzungbi@kernel.org>:

On Tue, 30 Aug 2022 15:58:27 -0700 you wrote:
> A small cleanup patch pile for the new cros_typec_switch driver.
> 
> Stephen Boyd (4):
>   platform/chrome: cros_typec_switch: Add missing newline on printk
>   platform/chrome: cros_typec_switch: Remove impossible condition
>   platform/chrome: cros_typec_switch: Use PTR_ERR_OR_ZERO() to simplify
>   platform/chrome: cros_typec_switch: Inline DRV_NAME
> 
> [...]

Here is the summary with links:
  - [1/4] platform/chrome: cros_typec_switch: Add missing newline on printk
    https://git.kernel.org/chrome-platform/c/8dab6a593919
  - [2/4] platform/chrome: cros_typec_switch: Remove impossible condition
    https://git.kernel.org/chrome-platform/c/bbb5fb85cf48
  - [3/4] platform/chrome: cros_typec_switch: Use PTR_ERR_OR_ZERO() to simplify
    https://git.kernel.org/chrome-platform/c/dc22a33e3585
  - [4/4] platform/chrome: cros_typec_switch: Inline DRV_NAME
    https://git.kernel.org/chrome-platform/c/20dfb7478309

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


