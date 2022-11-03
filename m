Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633056FD6
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 13:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B94C433D7;
	Thu,  3 Nov 2022 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667481712;
	bh=Z0XmaPzB8/5OxlKcz/hqxjFMPGgVEHY0wHqktG+DZyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QMJhet3iZ569LqI2RxhJ5QYzFlGVAz2fMhJvGFncZ9+TDlBN8IsBWwRbCsWNl62rV
	 v3NXT0pBKTJ40xjG8hV4CrITh2ZH2vyuPJFFAFEtT1y3SE7/UfQjdHEZBDpdHOvhDt
	 viiBZPXECITtsksc5raOEclCxfXcbZG0Q02CT79apotPc37nIMwQNOaUemfYUs4SoU
	 FzDeUx9vYw/xVnY7VDJhWzvW2gumGTRAcOx1NqRphIXdFcfhXdmDKxCbdgbZs3MYDn
	 ReUZ7bHw3NeZRPiXZtDR6y02Ri9IzqeyJR+N910XuYeIyn5DjS8qUZGTY8AfpDPU6c
	 pGBWE0xPv4rVA==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1oqaA1-00082F-KI; Thu, 03 Nov 2022 14:21:34 +0100
Date: Thu, 3 Nov 2022 14:21:33 +0100
From: Johan Hovold <johan@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	linux-arm-msm@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Satya Priya <quic_c_skakit@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] clk: qcom: gdsc: Remove direct runtime PM calls
Message-ID: <Y2PAXX2oYL6iFTlB@hovoldconsulting.com>
References: <20221101233421.997149-1-swboyd@chromium.org>
 <Y2JL9/HFrb3E+CYY@hovoldconsulting.com>
 <CAE-0n51Wuc6gVmsTOu4Nf4yx+6Wp-Oi3XZy06syhCMVmePWPEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n51Wuc6gVmsTOu4Nf4yx+6Wp-Oi3XZy06syhCMVmePWPEw@mail.gmail.com>

On Wed, Nov 02, 2022 at 09:53:49AM -0700, Stephen Boyd wrote:
> Quoting Johan Hovold (2022-11-02 03:52:39)

> > > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > > Cc: Johan Hovold <johan+linaro@kernel.org>
> > > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > > Cc: Taniya Das <quic_tdas@quicinc.com>
> > > Cc: Satya Priya <quic_c_skakit@quicinc.com>
> > > Cc: Douglas Anderson <dianders@chromium.org>
> > > Cc: Matthias Kaehlcke <mka@chromium.org>
> > > Reported-by: Stephen Boyd <swboyd@chromium.org>
> >
> > We typically don't add Reported-by tags for bugs we find and fix
> > ourselves.
> 
> Heh, I didn't see anything like that in Documentation/ so it seems fine.
> I debugged my problem and reported it.

I'd say the documentation is pretty clear on this matter:

  Reported-by: names a user who reported a problem which is fixed by this
  patch; this tag is used to give credit to the (often underappreciated)
  people who test our code and let us know when things do not work
  correctly.

  - Documentation/process/5.Posting.rst

  The Reported-by tag gives credit to people who find bugs and report
  them and it hopefully inspires them to help us again in the future.
  Please note that if the bug was reported in private, then ask for
  permission first before using the Reported-by tag.

  - Documentation/process/submitting-patches.rst

Just like you don't add a Tested-by tag for every patch you submit, it
is implied that you found the issue you fix unless you explicitly
attribute that to a third party using Reported-by.

This is the first time I see anyone trying to use Reported-by this way,
and even if you think the documentation isn't clear enough on this, our
praxis is.

Johan
