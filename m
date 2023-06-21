Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828AD1B8EB
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F4BC433C0
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:32:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="K1Q6713z"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 21 Jun 2023 17:32:49 +0100
Resent-Message-ID: <ZJMmMXrGvowfGqm8@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 21 Jun 2023 17:27:05 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=8jRf=CJ=opensource.cirrus.com=prvs=15365ad499=ckeepax@kernel.org>)
	id 1qC0ff-002op7-BF
	for broonie@sirena.co.uk; Wed, 21 Jun 2023 17:27:05 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 79B54615F0
	for <broonie@sirena.co.uk>; Wed, 21 Jun 2023 16:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 0237AC433C8; Wed, 21 Jun 2023 16:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1E07C433C0
	for <broonie@kernel.org>; Wed, 21 Jun 2023 16:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C1E07C433C0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LBDGhu010301;
	Wed, 21 Jun 2023 11:26:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=d8JreXZ75IDiLgR6knGCMcIZ5+mpLUYJebvy5GoWPig=;
 b=K1Q6713zYcjNm6gIOdvvNs1KF384zbhaRhK8YaFNNxDNCRd8frzVwIs9rVCVwLNYk+rr
 zf4jg/74eKi1dsLtGbSfLsMSLvh0w8kJ3qKdZIfRsGJnPR1kioPv9hyq6wbVpolF/pOq
 1E5oHBUVgUOMAF2+thbNFVn6ZOD/jFXRRqfcnCPnIK3GbQ/fIHLCQ1X7grSufNJvOGym
 vVTe+rliIZkr8UTPc0E6QXviiNZz1GFtM0xN11lw5syKD9BQY8dA59czIDMci2or14CV
 70fxXY5pxb2apUwM3fnO6v9DOBQO2i5/ySW69TsVBoWM7SsKhh+k60FYFSZHz8Fk3tOo DA== 
Received: from ediex01.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3r9a80caj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Jun 2023 11:26:54 -0500
Received: from ediex02.ad.cirrus.com (198.61.84.81) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 21 Jun
 2023 17:26:52 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by
 anon-ediex02.ad.cirrus.com (198.61.84.81) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 21 Jun 2023 17:26:52 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id E1E1715B7;
	Wed, 21 Jun 2023 16:26:51 +0000 (UTC)
Date: Wed, 21 Jun 2023 16:26:51 +0000
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Phil Elwell <phil@raspberrypi.com>
CC: James Schulman <james.schulman@cirrus.com>,
        David Rhodes
	<david.rhodes@cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>,
        <patches@opensource.cirrus.com>
Message-ID: <20230621162651.GW68926@ediswmail.ad.cirrus.com>
References: <20230621153229.1944132-1-phil@raspberrypi.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230621153229.1944132-1-phil@raspberrypi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-ORIG-GUID: FdSpcAPVok7jmxJDWmJedO3THnwksH2c
X-Proofpoint-GUID: FdSpcAPVok7jmxJDWmJedO3THnwksH2c
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=8jRf=CJ=opensource.cirrus.com=prvs=15365ad499=ckeepax@kernel.org
Subject: Re: [PATCH] ASoC: cs43130: Fix numerator/denominator mixup
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 6aj5OWBavodK

On Wed, Jun 21, 2023 at 04:32:29PM +0100, Phil Elwell wrote:
> In converting to using the standard u16_fract type, commit [1] made the
> obvious mistake and failed to take account of the difference in
> numerator and denominator ordering, breaking all uses of the cs43130
> codec.
> 
> Fix it.
> 
> [1] commit e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")
> 
> Fixes: e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")
> Signed-off-by: Phil Elwell <phil@raspberrypi.com>
> ---

Thanks for that spot, apologies I missed that in my initial
review:

Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
