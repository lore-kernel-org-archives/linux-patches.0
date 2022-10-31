Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80BC17CB8;
	Mon, 31 Oct 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80B05C433D6;
	Mon, 31 Oct 2022 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667189415;
	bh=mWUC04VwzWceu16syPxNcDe+4fCXuAcJ/FBDTTxD9b4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V34jTBkSWJ6ZAto9O4Pg1UXYxwmqWku7+qIC+sEnHOICyeEGCjSctjsiRFic+d5yd
	 MsIE1eht5pXh8CzxPbSpsLx7T3ZiJkRxa4dgAih3oKaWLcfweCDBzzUfVS98aWRkcU
	 +xExDowfldWAHaWZYwiBQhoKzzhLlb66z2hjgTKLjrklWHB/0+loDKYwXdWO55t/iq
	 SDzqI71jS+gztqWYkR3Pkmtkq7hssKQS8XUVtinYkEEMp3a+HGVuh/K3CUloNUmI1S
	 ARnizyXZ6oq4dwFD42D+eMrj+Fl8AydBFvIh/vS5ArkNkabfXj7EzdesPObfVDbgv+
	 o2MmKJ4m0scRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 624C5E4D03A;
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
 <166718941539.790.4332712127794687523.git-patchwork-notify@kernel.org>
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

This series was applied to chrome-platform/linux.git (for-kernelci)
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


