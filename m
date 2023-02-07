Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0C20E8
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 09:43:42 +0000 (UTC)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 3D42C5C0102;
	Tue,  7 Feb 2023 04:43:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 Feb 2023 04:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to; s=fm3; t=1675763021; x=1675849421; bh=3M3iH4rrEW
	APo7oiKzxVdGL8I3tHzD4LYYQmpY5RCJE=; b=n9k6wmvjaEyA71gqFlnqRrRjgl
	ssl09QPQhOIY7lTKitZ7r62SLvs3W12cltzQsqJnW08h2vaTevCHY6ymFzYOayeX
	Ptutp1uEUEgPn2nzB7arX/CeMBHjMczhPRAcaewKZdZ9lFMUoSHIGUD7d5aPCGQE
	uP3811imsqHbDjsiN+SPVc7rO2KMHINgmgd6rZKfmW54bS9np3CsojfVkTYxPqAo
	pbQds4H29RQpp4oSORxoNKS+IPNOJceTkcSBIdDCvpn/o+CNT/r+p/eu0ZPVevKy
	ywFbWeRkSrGym6WW04nWDERak/zuJaKQnzFLRM9Nl2I3Gz/zTBNAEBofVIZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:sender:subject:subject:to:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1675763021; x=1675849421; bh=3M3iH4rrEWAPo7oiKzxVdGL8I3tH
	zD4LYYQmpY5RCJE=; b=IoGxfGGEEDlYwmbd6n33zQxbRoaEFmT+D+RQShwSIs9m
	WhPM50gSyKD3GSHEOcUa2R/8ObyD7Wyq3we/IdqCEsj+4WhLkJhEUCuu51zehlCS
	ivCaqRnghoiREeAdd2Y6gZxMHg5q4Eud3YkD1bHHn6iYzc6sP0d1X3qHPxnWd+Kj
	hwybMy90g/a3UrhhGnfChWMTbRM1hkgd5Vfb8dPcDvv7AUncg8IHBeGTBRJ6SxuF
	Sopmn7W0CWnRo3YwBU0p1DqDOoS0+JaYvNMCRJn985caMUYJNvEQa4225Cv5Hz7T
	li15CSD1xKSGOebJ/vcMW6r1u8UJbSf7EZZ+uTZW3w==
X-ME-Sender: <xms:TB3iY0ZCEpZghxL91PX-ogpjuA_OCbWds2hKsO2U9DebRWmUTPHeXg>
    <xme:TB3iY_Y3z2GF44x4NAVU_Xox5jq3BEcS3N17wQl0-ZfTzbB-GdKGXJH5VzYiDweGD
    Jf3-OrYfaaPTA>
X-ME-Received: <xmr:TB3iY-8vqrNOOQs04GgNq0ZCSkMWRlqW64ErMHaLoRfr2Wxl08Ix2VsOHNI_PictSwrGBHvAwb6_nbpdPVVUVfJ0nPpLF1r43mL5WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TB3iY-qOvh1h-zLELyuVMbjZz-GNZeFOzitDDj-WnrKSyO9s8B7QqQ>
    <xmx:TB3iY_rZhMasNK1CDlFVCqQRi-Xy47WrQANzNyX2EB3keejoZOFBzA>
    <xmx:TB3iY8QHxiHZCq_MV-6CfdpKd3Knz6qRCrg1V5xhRmRFA599c6CWtw>
    <xmx:TR3iY9jqurut_kghDLpx31Kr5nO1iMUpDLHhGxezrQgpCadaruc06g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 04:43:40 -0500 (EST)
Date: Tue, 7 Feb 2023 10:43:38 +0100
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 6.1.y] phy: qcom-qmp-combo: fix runtime suspend
Message-ID: <Y+IdSjVsaXOH9oM+@kroah.com>
References: <20230203222820.2958983-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203222820.2958983-1-swboyd@chromium.org>

On Fri, Feb 03, 2023 at 02:28:20PM -0800, Stephen Boyd wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.
> 
> Drop the confused runtime-suspend type check which effectively broke
> runtime PM if the DP child node happens to be parsed before the USB
> child node during probe (e.g. due to order of child nodes in the
> devicetree).
> 
> Instead use the new driver data USB PHY pointer to access the USB
> configuration and resources.
> 
> Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

Now queued up, thanks.

greg k-h
