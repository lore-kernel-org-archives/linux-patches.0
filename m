Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9431E530;
	Thu,  4 Jan 2024 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPkbsg0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7073EC433C7;
	Thu,  4 Jan 2024 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704358276;
	bh=2diKhHsoe4R6os+8FZ4il41b4+3wRjextX2K9H/ZeXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aPkbsg0ASoupNDfNNg7O6Be7cGJnoZMk0Y54/T43oZkre+P8MVplDDhUImk9+OXb2
	 cSrHDVTNwI7iUMIzQxl+r4OqHUv7rnvPVcaS/7QQ1WpnmSDNFbiJIT0/lHWc2tX77X
	 7hdlq0m68J8tjOGDx7R1psEtkkT7D9e7SUZcVL2s=
Date: Thu, 4 Jan 2024 09:51:13 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Georgi Djakov <djakov@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 37/95] interconnect: qcom: sm8250: Enable sync_state
Message-ID: <2024010452-mobilize-ceremony-f456@gregkh>
References: <20240103164853.921194838@linuxfoundation.org>
 <20240103164859.619846763@linuxfoundation.org>
 <1be48a82-ebc6-44b9-b56d-4629f6bc0f00@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1be48a82-ebc6-44b9-b56d-4629f6bc0f00@linaro.org>

On Wed, Jan 03, 2024 at 06:29:59PM +0100, Konrad Dybcio wrote:
> On 3.01.2024 17:54, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Konrad Dybcio <konrad.dybcio@linaro.org>
> > 
> > [ Upstream commit bfc7db1cb94ad664546d70212699f8cc6c539e8c ]
> > 
> > Add the generic icc sync_state callback to ensure interconnect votes
> > are taken into account, instead of being pegged at maximum values.
> > 
> > Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
> > Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> > Link: https://lore.kernel.org/r/20231130-topic-8250icc_syncstate-v1-1-7ce78ba6e04c@linaro.org
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> Hi, please drop this as the platform will become unbootable without
> some more DT+driver changes.

Now dropped from 5.10 and 5.15 queues, thanks.

greg k-h
