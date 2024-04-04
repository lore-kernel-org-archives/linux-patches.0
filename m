Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2694513D882;
	Thu,  4 Apr 2024 21:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712265825; cv=none; b=c6we7RLY+R/fPzPrsIyNgLGEMZEqIvrQqB9bZHqhlbuEOXooCYvy1n4CMImC5ibClJjDP8mnIN5bID9uUXq9I6z8x9T4RJ9KSFbpw20fH+MswvzzKdmGBliLAi1o8SknAcpMalpKL8glBGaoWS8DzODV09vwlOwbFs2i9fPyXkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712265825; c=relaxed/simple;
	bh=8TXsyTFoPvfNdDHM7/oaby8QXltUmQb9FnsTZNZ5+R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uc6Zv8YWPDBT/ZGP5BZFzSD0UJ81hsRYDYRCYmITr3Eml35IJ+pIypFOb10US7ADGHflRJSomYOMcBT5JnJL2P7zPNX67LFBKjiaiWZdKw8T8pF2egbyRpD2+IEWKYop9YTEKUuF1kATU6IvcS8f1em6kC8yRH0hjEv95tb1ITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EP5KafwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EP5KafwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AB7C433F1;
	Thu,  4 Apr 2024 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712265825;
	bh=8TXsyTFoPvfNdDHM7/oaby8QXltUmQb9FnsTZNZ5+R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP5KafwOU/N/A+rg1ngV1ckm+b2koqxh3D7KKUZy26npBgxFu/v3pjlyzBYksfoeH
	 oY397pYdvPcxCsGlJpwxteL6yblb/+QjtvnvsNrEyv+OvJb6J+OvHLA9JsejCj6H+v
	 uM+bAsl6/8SJAE7esCb/gLX3Pslmwh4L8owDsCgy3j3DfI8xQ2w6YhYLIIlz3+uQA8
	 BIUXQLeJgoZgfH793HZVy3+baayXmf9XA3xL/Pc7oCVyoSB+JM8HafGQCunQbEYrf6
	 9qo9gjHEDBjzkV5gi+8hcXKItiTSnYi3NjsuywYqE84agnBmXDiQlKDQVGvQKcz5H1
	 fjXf4TBUxq/xg==
From: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	cros-qcom-dts-watchers@chromium.org
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Disable pmic pinctrl node on Trogdor
Date: Thu,  4 Apr 2024 16:23:10 -0500
Message-ID: <171226578671.615813.16450668357677583127.b4-ty@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240229012828.438020-1-swboyd@chromium.org>
References: <20240229012828.438020-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 28 Feb 2024 17:28:26 -0800, Stephen Boyd wrote:
> We don't use this pmic pinctrl node on any Trogdor devices. The
> AP_SUSPEND pin is here, but this pinctrl device isn't a supplier to
> anything in the devicetrees that include this file. Disable this device
> node in the DTS so that we don't waste time or memory on this device.
> 
> 

Applied, thanks!

[1/1] arm64: dts: qcom: sc7180: Disable pmic pinctrl node on Trogdor
      commit: cb69e758d5918cc03e449e159162e263e8bc7ec1

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
