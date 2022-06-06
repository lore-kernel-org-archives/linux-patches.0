Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6005A1FD3;
	Mon,  6 Jun 2022 03:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0013C34119;
	Mon,  6 Jun 2022 03:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1654486430;
	bh=/D6r6eFQWaD3GHW97LkfW9aZgvs8+Kd3rwRNonwC4fQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=APog56fByH20BF5ETxDCvtvc98kmki8O/2BYAAA8nrPs6BENtxw+4jFY3X7zEzD45
	 q4DbIwUlALUvb8wpG2IY2scv4G8MjCrezrFqBI5QtviBYgo6KKlOB4slbHfvf581SU
	 Zvp2AZw0Np6buiZcOsTL6lo+fXfFBjYP1dclowVpZrL+D+jebHHLEMIeDOfzyetqfs
	 TPVtUFWwy4taP+7uY551/RtItcvkIAifYq8iKlcwh82wE1H8IZNtUhxiXTfDZmVxnk
	 e91E1wCGwvgBexkxfA36EvRrd1jxlr80W3uCgGzfebWC7wqaf8YDdZZqrD4m4qY6a7
	 1U0IPfNxTCySQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE19CE737EF;
	Mon,  6 Jun 2022 03:33:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] dt-bindings: cros-ec: Update for fingerprint devices
From: patchwork-bot+chrome-platform@kernel.org
Message-Id: 
 <165448642983.20111.12412315955580522831.git-patchwork-notify@kernel.org>
Date: Mon, 06 Jun 2022 03:33:49 +0000
References: <20220512013921.164637-1-swboyd@chromium.org>
In-Reply-To: <20220512013921.164637-1-swboyd@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
 chrome-platform@lists.linux.dev, groeck@chromium.org, dianders@chromium.org,
 hesling@chromium.org, tomhughes@chromium.org, amstan@chromium.org,
 tzungbi@kernel.org, mka@chromium.org, bleung@chromium.org,
 lee.jones@linaro.org

Hello:

This series was applied to chrome-platform/linux.git (for-next)
by Lee Jones <lee.jones@linaro.org>:

On Wed, 11 May 2022 18:39:18 -0700 you wrote:
> This patch series introduces a DT binding for chromeos fingerprint
> devices. The first two patches tighten up the existing binding and the
> final patch introduces the fingerprint binding. As there aren't any
> driver patches this can probably go directly through the DT binding tree
> if Lee can ack the patches. Or go through mfd tree if DT maintainers
> ack/review.
> 
> [...]

Here is the summary with links:
  - [v5,1/3] dt-bindings: cros-ec: Fix a typo in description
    https://git.kernel.org/chrome-platform/c/f93afd8e7567
  - [v5,2/3] dt-bindings: cros-ec: Reorganize property availability
    (no matching commit)
  - [v5,3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


