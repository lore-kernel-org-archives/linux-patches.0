Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A298123A2
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 01:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB1C4315F;
	Tue,  8 Nov 2022 01:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667870893;
	bh=hrb63pEYbTDbYcY9kx5aX3xHqe/fPdpBXlyne0tZ7Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRILw4E6jO8Fk9PnVLbOxoYaeLkV2YY6ppxt56ZOXYsvR8XmtaZ4ruEhILvHvf65x
	 kIjK7kBZt3UFmeFfASFJD6g1XPOUoyGXaEPPTFLH8GXQChQTX1kEdARAp6HyfXvlwb
	 E0fdE2T2Wynp7rvY4mafTpAb4YL3Cz3Gt4a0XZdVbpKcKStVz8/x8AWjI754Iuh/mn
	 2NFMc2uOAENd7jaPuvA/PH1p4uwqSZDi3uzYf8VHh74d8DEQFZKbgfIGaukP1xg4Fw
	 wtocHYieGqXXQIE9/Th2wDfVG2ATSnHDtR7Z7QtJf82rzxV9UAW+YBI65n+3VPegpe
	 /O65PK/mt7WWQ==
From: Bjorn Andersson <andersson@kernel.org>
To: swboyd@chromium.org,
	agross@kernel.org
Cc: dianders@chromium.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: Remove fingerprint node from herobrine-r1
Date: Mon,  7 Nov 2022 19:27:42 -0600
Message-Id: <166787084678.599230.17638706199431069085.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221025180703.1806234-1-swboyd@chromium.org>
References: <20221025180703.1806234-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Oct 2022 11:07:03 -0700, Stephen Boyd wrote:
> It turns out that only a few people have the fingerprint sensor hooked
> up on their board. Leaving this enabled is slowing down boot for
> everyone else because the driver slowly fails to probe while trying to
> communicate with a sensor that isn't there. Remove the node to speed up
> boot, developers with the board can manually enable it themselves.
> 
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: Remove fingerprint node from herobrine-r1
      commit: a35ef6df1e61cba41a5266303f6a493d1a71b06b

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
