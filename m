Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F11B6116
	for <patches@lists.linux.dev>; Mon,  6 Feb 2023 22:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E32C433A7;
	Mon,  6 Feb 2023 22:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675722511;
	bh=LnS3RLxon9gQ/YttfT5ZYdobqpfQma2EEkoraZrnk8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rymJT/9/wV3+N0i3TixFLyizvmO/ShkSNPOGN6Pk4wiJPP/oFb06t/FVi/uSSfuQH
	 cFbvmL4r9ZfxXDnl6D7Wx2FjbX3wqwtC9BUncvPkIf0gjm9A5zaFR1flxNKr/pwDe1
	 bTR8Agf99V1JqHxQzvymSiN7qsXgg18dQhG2P1F+7BeiVkGId5jEe9PbJTuPzPZW/O
	 qPiKh4+fCAiPtaPxf7Cd7V8zj2mX0dXUtRnNzI6F+HX1vXKgK+lir2wEsu3z0zM2Q6
	 XhgAVDy2dVptFVBlDwuWghWek74naPgyqCGBVEkqo2IejLeg0LlE+gVG9R/FTzN9a/
	 SXf8jRfbW9p/A==
From: Bjorn Andersson <andersson@kernel.org>
To: Andy Gross <agross@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: stats: Populate all subsystem debugfs files
Date: Mon,  6 Feb 2023 14:30:38 -0800
Message-Id: <167572263441.3569822.17857027363435426191.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230119032329.2909383-1-swboyd@chromium.org>
References: <20230119032329.2909383-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 18 Jan 2023 19:23:29 -0800, Stephen Boyd wrote:
> This driver relies on SMEM to populate items for each subsystem before
> the device probes. The items in SMEM that are being looked for are
> populated by the subsystems lazily, and therefore may not exist until
> the device has booted. For example, if I build this driver into the
> kernel on Trogdor Lazor and boot up, I don't see a 'modem' debugfs file
> populated, because the modem boots and populates the SMEM item after
> this driver probes.
> 
> [...]

Applied, thanks!

[1/1] soc: qcom: stats: Populate all subsystem debugfs files
      commit: acdbf5f9b2c492505145f6e50c65418521a547c4

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
