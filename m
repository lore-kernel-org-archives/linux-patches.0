Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FECF1857
	for <patches@lists.linux.dev>; Tue, 18 Oct 2022 03:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490DBC433D6;
	Tue, 18 Oct 2022 03:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666062924;
	bh=DT65j//oric+pMOzKCXqE1m3smntmRWIzSbeC8NUSN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2OU0My195TKv2ixbANStwiK8hXPuX2+LUM0Z7KFU2WnHKbMcqk9ssx1Pdo0Smxzl
	 EGsgvRxXE4vRvqkt+dkgdsXQLaQ+k+yCswfkgFohunmlHJWju6hSp/f3GIVNaPlK9R
	 Vu0GSH2+l4QnPW5wsY4n2LHieBlV6YtJlFwcTzSEcKpnirdLm1dXqmnoGl4d9bQl02
	 m1xX8/cI+UhGBTk+xCfscFeigVouv5TKbFVzkspr1kttNNeBRlQQQaAv9DhoAC+bhf
	 gNIaL4nZhL4rVlU+Xd+Mb+2we/NOFJkA+I1PrYPd7Vqn+tkrQHt/JqdYT8MfLjw/m+
	 n1GaKMC84Iemw==
From: Bjorn Andersson <andersson@kernel.org>
To: agross@kernel.org,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] soc: qcom: cmd-db: Mark device as having no PM support
Date: Mon, 17 Oct 2022 22:15:18 -0500
Message-Id: <166606235861.3553294.1853267063018582956.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221015004934.3930651-1-swboyd@chromium.org>
References: <20221015004934.3930651-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 14 Oct 2022 17:49:33 -0700, Stephen Boyd wrote:
> This driver purely exposes information from memory to the kernel. Let's
> mark it as not having any device PM functionality, so that during
> suspend we skip even trying to call a suspend function on this device.
> This clears up suspend logs more than anything else, but it also shaves
> a few cycles off suspend.
> 
> 
> [...]

Applied, thanks!

[1/2] soc: qcom: cmd-db: Mark device as having no PM support
      commit: 5f7e2cb56af6800a4158514cc27921141e67ae19
[2/2] soc: qcom: stats: Mark device as having no PM support
      commit: 367b9c70e9b25fe9ad5346b0f3544682d8b112b9

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
