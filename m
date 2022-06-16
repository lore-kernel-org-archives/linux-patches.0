Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4317A;
	Thu, 16 Jun 2022 08:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F2E1C341C4;
	Thu, 16 Jun 2022 08:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655367013;
	bh=4zJWCpL4TkpFCIThxAUHRIFItc9DcBKJyPDS2b3DJWA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=h02NyT0C09WkNFKQPYx4wa2NprYGxt9GJeH2wnfP2kkA/1SLQ+qrgwVgRJGZmD3Jc
	 XcR33qfH4uLzvWOMx6P8ISSrNq/keW1b3y++hw3sYGzLrEGUQmPI3E+Hq/zRKTqVKm
	 /tQ3Ynvw+duR/GWJH4XffCoZdb5f4IJ4APzKzYtlSOIwpaLaVE7H+mgDzFw6a7m7ri
	 46wAS8qVwAtFo6lIAL7+qagu5b7J2xYmPMHYCcAxunFSoRZtY1h2zsu0dMy9EysUHR
	 SwOSz5C8me5SpdyaoWSGd7+2RDsZFTYeeyJQ0G8de1irj2PU+4EXhR9IONUXlN4Bko
	 ZnTWKTyAfu9Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13AB0FD99FB;
	Thu, 16 Jun 2022 08:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] platform/chrome: cros_ec: Always expose last resume result
From: patchwork-bot+chrome-platform@kernel.org
Message-Id: 
 <165536701307.22788.1595612355814981291.git-patchwork-notify@kernel.org>
Date: Thu, 16 Jun 2022 08:10:13 +0000
References: <20220614075726.2729987-1-swboyd@chromium.org>
In-Reply-To: <20220614075726.2729987-1-swboyd@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: bleung@chromium.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, groeck@chromium.org,
 chrome-platform@lists.linux.dev, rajatja@chromium.org, mka@chromium.org,
 hsinyi@chromium.org, tzungbi@kernel.org, evgreen@chromium.org

Hello:

This patch was applied to chrome-platform/linux.git (for-next)
by Tzung-Bi Shih <tzungbi@kernel.org>:

On Tue, 14 Jun 2022 00:57:26 -0700 you wrote:
> The last resume result exposing logic in cros_ec_sleep_event()
> incorrectly requires S0ix support, which doesn't work on ARM based
> systems where S0ix doesn't exist. That's because cros_ec_sleep_event()
> only reports the last resume result when the EC indicates the last sleep
> event was an S0ix resume. On ARM systems, the last sleep event is always
> S3 resume, but the EC can still detect sleep hang events in case some
> other part of the AP is blocking sleep.
> 
> [...]

Here is the summary with links:
  - [v3] platform/chrome: cros_ec: Always expose last resume result
    https://git.kernel.org/chrome-platform/c/74bb746407bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


