Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E262C6B0;
	Sat,  6 Apr 2024 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712395139; cv=none; b=WBfAq789Qk/rECah4p0T+g3PzW10zWnJjcWyFC8c3VjS83jQoCexQMPQ0pXarG0dprgEXr8BGrsF6zhrHTHe4J77AaAqhjx/k+1CsUy5AfGrN+qwlHrrGdEevnJRu3EcL6Zti4cQhutoy2YBGW4hddGPKN/6JALAGXhN7Z6EKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712395139; c=relaxed/simple;
	bh=CKx+Sd6xfsfIpNID92BJjS5Q/0Wk3rO67hmInznC/5Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JLyAwQa8adA2cwG2IZrTG5N4T4+XmKJUsYWm/sIcRhMT3kRKiGqx8P3mbJe+JNahW1pL1MIK3FPy8+8jhMPXCJ0gdv9BdAxbpClv7rqb1ip36dLtkbYeU9A0sHwwGGhFJUNzonvskt+jeRqCScvzfkTvdw0Oby8Q/xV/5ROlPOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ryhhr482; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ryhhr482"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905D4C433A6;
	Sat,  6 Apr 2024 09:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712395138;
	bh=CKx+Sd6xfsfIpNID92BJjS5Q/0Wk3rO67hmInznC/5Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Ryhhr482/stDZaEN/VQttZWuBNtZbYJa+0k2Mm+MCL97kevMFtmJKqRZUejPMxS/C
	 fCIwj6Y+Rq7elkWblvVBrKlHsphTOM+EHjgREosXHjMkEjMm9QlLAD31sAT6kUWE7k
	 h5BCmCMvkPjYqaoRILptvnDhA9QIKjWun8biVBOBK7hVQXq5NL4P61vc9RsyOlBw0I
	 AQCj0Rv+PwqrwwsjAhmjZYEvv46bKyKG4kkbE3wOGIL/DApCw706tUDstqBcuNDWK5
	 +XdvZHT5+VwjQxBdNAU/6KmJU+Dgxvgx5C63RU3pIYxxNtOZgRYujdpbWZgVVFmED3
	 QWskxeTmOmb8g==
From: Vinod Koul <vkoul@kernel.org>
To: Kishon Vijay Abraham I <kishon@kernel.org>, 
 Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
 linux-arm-msm@vger.kernel.org, Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Bjorn Andersson <andersson@kernel.org>, linux-phy@lists.infradead.org, 
 Neil Armstrong <neil.armstrong@linaro.org>, freedreno@lists.freedesktop.org, 
 Douglas Anderson <dianders@chromium.org>, 
 Abhinav Kumar <quic_abhinavk@quicinc.com>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20240404234345.1446300-1-swboyd@chromium.org>
References: <20240404234345.1446300-1-swboyd@chromium.org>
Subject: Re: [PATCH] phy: qcom: qmp-combo: Fix VCO div offset on v3
Message-Id: <171239513422.352254.9763002024133782932.b4-ty@kernel.org>
Date: Sat, 06 Apr 2024 14:48:54 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.3


On Thu, 04 Apr 2024 16:43:44 -0700, Stephen Boyd wrote:
> Commit ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to
> setup clocks") changed the offset that is used to write to
> DP_PHY_VCO_DIV from QSERDES_V3_DP_PHY_VCO_DIV to
> QSERDES_V4_DP_PHY_VCO_DIV. Unfortunately, this offset is different
> between v3 and v4 phys:
> 
>  #define QSERDES_V3_DP_PHY_VCO_DIV                 0x064
>  #define QSERDES_V4_DP_PHY_VCO_DIV                 0x070
> 
> [...]

Applied, thanks!

[1/1] phy: qcom: qmp-combo: Fix VCO div offset on v3
      commit: 5abed58a8bde6d349bde364a160510b5bb904d18

Best regards,
-- 
~Vinod


