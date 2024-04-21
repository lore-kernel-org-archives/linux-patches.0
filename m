Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65550A65;
	Sun, 21 Apr 2024 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713738586; cv=none; b=CsZ6hQkS0SH83ScU+a4a8CpZJUTbk+Y+9k8fMNk1QWAuHlHF9Mr+JQ5092QCSm7yUTIM6hl5M0zhtExFKDc3AMj7bN16LoxQ1eskXDoVR6636xefde3PeQ4+M9tftJ/kA64KXT/Ma0t9SqheSNzC6b/mguhTSD3qmPgOuXV7AVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713738586; c=relaxed/simple;
	bh=w/xWsMj6GMAy+FKXfCKW1NhgakVrHhumWn47xc68dIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Osgv/vrquXbJGZMfrIa0Dt6Tm3VDW98kVJSleKyUUUwPNXZQjO5fwW1/3seY3LLYBYp3QyKuGiudXZyFd+yuvbI5RaJc6sFh2HJX9fUykdHvrn4FVvf3ttT4Jq1OUpCkMfn2q9O7J5jbIBuxWBOrqX5z/g8X6LwuuGVXoBNX+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyJDrPu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyJDrPu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBCC32783;
	Sun, 21 Apr 2024 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713738586;
	bh=w/xWsMj6GMAy+FKXfCKW1NhgakVrHhumWn47xc68dIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyJDrPu/pADswzE8YtcbuOocNYOqRxJk6uKRyhDu06RKUZvns0b45tXnpUZAV0hi4
	 OCa67HN1PZWc7kA9X9yWA134cn9MYUxknFYzO1xtCNXh5D3rKDzzjTp4Nlvl2nWdox
	 TZOYUY9EWK7X/68/K4LpJuCerzv2f1cF22zFmVoHvSLcSmH8RcihoGvbd0mhsGreGo
	 GfX3QiSHLW2E73zH3xjgWPMnlXYv0cHGipBKHTJaupg5yvcnwGN+tKB/qptdp89JRB
	 KEeNUGge6GmvV6PUghPVtKvjxvUxsdrUBStHkYUTxNKW1OMklbvbSCBA1X845QZrEr
	 OrmivM16PqVOg==
From: Bjorn Andersson <andersson@kernel.org>
To: sboyd@kernel.org,
	Nathan Chancellor <nathan@kernel.org>
Cc: konrad.dybcio@linaro.org,
	mturquette@baylibre.com,
	bryan.odonoghue@linaro.org,
	neil.armstrong@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/2] clk: qcom: Fix two driver Kconfig dependencies
Date: Sun, 21 Apr 2024 17:29:20 -0500
Message-ID: <171373856767.1196479.14241619358074535915.b4-ty@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240318-fix-some-qcom-kconfig-deps-v1-0-ea0773e3df5a@kernel.org>
References: <20240318-fix-some-qcom-kconfig-deps-v1-0-ea0773e3df5a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 18 Mar 2024 08:18:09 -0700, Nathan Chancellor wrote:
> This series fixes two Kconfig warnings that I recently saw crop up in my
> build tests because the dependencies for newly added drivers in 6.8 are
> not correct.
> 
> This is now the fourth set of changes to avoid warnings of this nature
> for the exact same reason... is there anything that can be done to
> ensure this does not continue to happen? See
> 
> [...]

Applied, thanks!

[1/2] clk: qcom: Fix SC_CAMCC_8280XP dependencies
      commit: 0e79d702bf7fac2e63fc32a1b4ff307d71db692f
[2/2] clk: qcom: Fix SM_GPUCC_8650 dependencies
      commit: 551eb5194bf328652decc5531edd9c65a5d2a17c

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
