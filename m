Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067947E
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D242C433EF;
	Thu, 23 Feb 2023 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677178848;
	bh=o+9OUCJEUF/e/DNRPCuGj5G4gOxfD6JOcy8ro1x4DlY=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=UOl6KisagTexv6cBiOuPq+pi7uj8GUp0CMkJdMz/aub/RrKd7vvV4by8Q87gAJ6Vz
	 zFSJlSl6+41PSZ0xee5k+G/wjEfrbyzwTxuQNODrrm5v5pZwE3F1XZBI/1Fqp6Mu2x
	 HbHJdjJnsu+vTNfKjARXvNhIudRJJIfgW07ykrC7B3N2TeACHjj1sZUmav31/d6r46
	 TPQgLt8Vl2bsZq+C2rnEUEtjPzphmFyIge1T7IgFGPind3u5UXiapHNXrrp3+dhyRi
	 1jmKES6DzpSKNfZhCv2HLIrveybXxKaL5AljE6qhcSmRIKT5purGAC0GDS9eBS86Hg
	 2RO4yhQdQsijg==
Message-ID: <9e408dc917cbbc08d68c7a3195c12484.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230223013847.1218900-1-sboyd@kernel.org>
References: <20230223013847.1218900-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: qcom: apcs-msm8986: Include bitfield.h for FIELD_PREP
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Thu, 23 Feb 2023 11:00:46 -0800
User-Agent: alot/0.10

Quoting Stephen Boyd (2023-02-22 17:38:47)
> Otherwise some configurations fail.
>=20
> Fixes: 027726365906 ("clk: qcom: add the driver for the MSM8996 APCS cloc=
ks")
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
