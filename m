Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535CE46B3
	for <patches@lists.linux.dev>; Wed, 13 Jul 2022 17:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE4EC34114
	for <patches@lists.linux.dev>; Wed, 13 Jul 2022 17:22:31 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 13 Jul 2022 18:22:28 +0100
Resent-Message-ID: <Ys7/VHUl9v877Ys2@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 13 Jul 2022 17:48:07 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=/8Ij=XS=arm.com=alexandru.elisei@kernel.org>)
	id 1oBfWv-004SQA-9Z
	for broonie@sirena.co.uk; Wed, 13 Jul 2022 17:48:07 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 0A77FB820F7
	for <broonie@sirena.co.uk>; Wed, 13 Jul 2022 16:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D5AADC3411E; Wed, 13 Jul 2022 16:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id F1B44C34114
	for <broonie@kernel.org>; Wed, 13 Jul 2022 16:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org F1B44C34114
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A800615A1;
	Wed, 13 Jul 2022 09:48:01 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FEE93F792;
	Wed, 13 Jul 2022 09:48:00 -0700 (PDT)
Date: Wed, 13 Jul 2022 17:48:26 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chen-Yu Tsai <wenst@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
	alsa-devel@alsa-project.org
Message-ID: <Ys73WtpaZLdpsCdL@monolith.localdoman>
References: <20220713130451.31481-1-broonie@kernel.org>
 <Ys7SS/ueE66CBpZK@monolith.localdoman>
 <Ys7n+/9v+CygvODo@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys7n+/9v+CygvODo@sirena.org.uk>
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=/8Ij=XS=arm.com=alexandru.elisei@kernel.org
Subject: Re: [PATCH] ASoC: rockchip-i2s: Undo BCLK pinctrl changes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: gCQlDhBfxVaE

On Wed, Jul 13, 2022 at 04:42:51PM +0100, Mark Brown wrote:
> On Wed, Jul 13, 2022 at 03:25:27PM +0100, Alexandru Elisei wrote:
> > On Wed, Jul 13, 2022 at 02:04:51PM +0100, Mark Brown wrote:
> > > The version of the BCLK pinctrl management changes that made it into
> > > v5.19 has caused problems on some systems due to overly strict DT
> > > requirements but attempts to fix it have caused further breakage on
> > > other platforms.  Just drop the changes for this release, we already
> > > have a better version queued for -next.
> 
> > For what it's worth, I am now able to boot my rockpro64-v2 with this patch.
> 
> So Tested-by: then?

Yes, please:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
