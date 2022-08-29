Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE86100
	for <patches@lists.linux.dev>; Mon, 29 Aug 2022 23:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0FAC4347C;
	Mon, 29 Aug 2022 23:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1661816808;
	bh=w3QGP3QwMPeUPT6nfHCPCvAmzXw/tWqsdz3iVKu+JeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0ZPMVJMQMnvSdIjYZz87sjCLc8kr5pU8EFzjpVCuTT9AH9zhYSsY7HJPxiR9pyhs
	 eNYW3n8wwtCHKlvwpzJpoNPuCp+2j4EbI43o1szxGf9ou5sP+/lZ7J4PNonaStKzR7
	 FVhFbgHgBO5YEh8KY1r7MmLcdvZngRU2M71w3KufbTPYBONRQ/18+o3SiiF/qun0jZ
	 fUwr+RUoEb29AIgXzwqKziRYNWKBtK0+XuOw9jNaYgg7i7ue0D6r1X83kNl3/TRgk9
	 zU9CiW2SCT7li7/F+c2V9U+uD18N/JKrJRD6OUPKiVdgSKIhp+QmCvwQZY9UndiHJc
	 L2ioMR/1Vv7WA==
From: Bjorn Andersson <andersson@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>,
	agross@kernel.org,
	swboyd@chromium.org
Cc: mka@chromium.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc enabled for TZ
Date: Mon, 29 Aug 2022 18:46:11 -0500
Message-Id: <166181675988.322065.7864125729099787019.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220827004901.511543-1-swboyd@chromium.org>
References: <20220827004901.511543-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 26 Aug 2022 17:49:00 -0700, Stephen Boyd wrote:
> There's still a thermal zone using pm6150_adc in the pm6150.dtsi file,
> pm6150_thermal. It's not super obvious because it indirectly uses the
> adc through an iio channel in pm6150_temp. Let's keep this enabled on
> lazor and coachz so that reading the temperature of the pm6150_thermal
> zone continues to work. Otherwise we get -EINVAL when reading the zone,
> and I suspect the PMIC temperature trip doesn't work properly so we
> don't shutdown when the PMIC overheats.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: sc7180-trogdor: Keep pm6150_adc enabled for TZ
      commit: 144fbd028fdec2deeb3b99d5e60dbf3167950ebe

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
