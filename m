Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CD817F3;
	Mon, 31 Oct 2022 04:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2F29C433D7;
	Mon, 31 Oct 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667189415;
	bh=98IPoPC1iu1/QYau2t3pixc7zFRlHs5420vy0HvPhfA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ej/GeSJAuF2JVtcADveQ5KUHxFdSWSN1F8/knq3EFnVee+aaOVzEMF3wiHV3sr2N5
	 69Q9gCz4TNzUKu42lJkzxnqr8voSK/9qwDt47Qb/JZP78xdhsxedY1nlOALPyFB4EK
	 GoQR8sb+kuWdpinR0+OXSVPXIBrE0jRzoJzwT+qBLW7BNZgRQp/SHDprWOPnBanVOy
	 MaQxJFQsBik1s5uWx9PC5Z07fBuD/4TZreF7Vxipo+uWMDlIM38LTzBdISiU9htMK2
	 kBVcM8MLh8wSehgPJnCfpBWc0nSpDToU8FBEnaspDnMd2+oL9mE4ni/xRDw8n35S7Z
	 KNpuTUZey2iPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D048EE4D03A;
	Mon, 31 Oct 2022 04:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/2] dt-bindings: cros-ec: Update for fingerprint devices
From: patchwork-bot+chrome-platform@kernel.org
Message-Id: 
 <166718941584.790.602379860967156019.git-patchwork-notify@kernel.org>
Date: Mon, 31 Oct 2022 04:10:15 +0000
References: <20221026003641.2688765-1-swboyd@chromium.org>
In-Reply-To: <20221026003641.2688765-1-swboyd@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 devicetree@vger.kernel.org, chrome-platform@lists.linux.dev,
 groeck@chromium.org, dianders@chromium.org, hesling@chromium.org,
 tomhughes@chromium.org, amstan@chromium.org, tzungbi@kernel.org,
 mka@chromium.org, bleung@chromium.org, lee.jones@linaro.org

Hello:

This series was applied to chrome-platform/linux.git (for-next)
by Tzung-Bi Shih <tzungbi@kernel.org>:

On Tue, 25 Oct 2022 17:36:39 -0700 you wrote:
> This patch series introduces a DT binding for chromeos fingerprint
> devices. The first patch tightens up the existing cros-ec binding and
> the second patch introduces the fingerprint binding. As there aren't any
> driver patches this can go directly through the chrome platform
> tree or the dt-binding tree or the mfd tree. I sent it to the binding
> maintainers in hopes it can go there directly but it doesn't really
> matter.
> 
> [...]

Here is the summary with links:
  - [v7,1/2] dt-bindings: cros-ec: Reorganize and enforce property availability
    https://git.kernel.org/chrome-platform/c/7a2f36828c7b
  - [v7,2/2] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
    https://git.kernel.org/chrome-platform/c/e068bc0b01cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


