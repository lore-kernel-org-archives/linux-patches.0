Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FD28FD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 04:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363FBC433C1;
	Tue,  8 Nov 2022 04:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667882195;
	bh=OG44KWmZaIEMvgjyKsQDKtAHHYFHCw8JOB7XLYtFQz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4CW+C6G+WsNwVA7W/x/7fuvoirJpjyOHlxfvLJfTQhf/DnKaoflzf2G0ahPdC1Ya
	 6HpXg3sr1w5969R9mNAdgoptDYAhyqbOlFbOlfrB384V8v1Wa9qcWYj0xRS1FKNkCr
	 E9NZZGnuARFGVT5Sd170I15w3eJxPtbD/SOgo4fD2uiYgPtrOF7RjgI2MSHUYPHq3A
	 rmcbvKv5dCr3O1kc9JHzIS6SBRebp4/ZHYmb++MNxaF+VD63QAnFwfp0AgLGD7HwFn
	 XkxMUvgZ+WQ2D83Qmc6DfPfTwxs0o1AT1xSuar4Y/XBFCm0+//IfMWMHzRZ1ll4Tse
	 UjJOIYlWDU0bw==
From: Bjorn Andersson <andersson@kernel.org>
To: swboyd@chromium.org,
	agross@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	dianders@chromium.org,
	amstan@chromium.org,
	linux-arm-msm@vger.kernel.org,
	mka@chromium.org
Subject: Re: (subset) [PATCH v2 0/2] Update fingerprint node on herobrine/trogdor
Date: Mon,  7 Nov 2022 22:36:29 -0600
Message-Id: <166788218318.625965.10548024842918828007.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221107191535.624371-1-swboyd@chromium.org>
References: <20221107191535.624371-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 7 Nov 2022 11:15:33 -0800, Stephen Boyd wrote:
> This patch series updates the binding for the Trogdor and Herobrine
> boards' fingerprint node. Now that the binding has been accepted[1]
> we're ready to merge this in the qcom tree.
> 
> Changes from v1 (https://lore.kernel.org/r/20220317010640.2498502-1-swboyd@chromium.org):
>  * New patch for trogdor
> 
> [...]

Applied, thanks!

[1/2] arm64: dts: qcom: Fully describe fingerprint node on Herobrine
      commit: aefd5370ab5e55a18c94573b9602083132e24601
[2/2] arm64: dts: qcom: Fully describe fingerprint node on Trogdor
      commit: 9ec68fea9e53d25177618d2ce1bc4a1b1b724938

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
