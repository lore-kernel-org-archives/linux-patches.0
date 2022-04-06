Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC0F2F2D
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 12:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A23C385A7
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 12:47:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="kS8Jququ"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 6 Apr 2022 13:46:57 +0100
Resent-Message-ID: <Yk2LwZfrU3rg6z19@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 06 Apr 2022 10:54:30 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=aQsj=UQ=opensource.cirrus.com=prvs=709516e40b=ckeepax@kernel.org>)
	id 1nc2Mu-007eBj-9M
	for broonie@sirena.co.uk; Wed, 06 Apr 2022 10:54:30 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 03D4660AF8
	for <broonie@sirena.co.uk>; Wed,  6 Apr 2022 09:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E16CC385AB; Wed,  6 Apr 2022 09:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91B6BC385A3;
	Wed,  6 Apr 2022 09:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 91B6BC385A3
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2366Aowd008097;
	Wed, 6 Apr 2022 04:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=ZWtYtEP6ksjFQqnyEmmOpZ3NxAIAdcKEON9VScCRpts=;
 b=kS8JququnS/P433jjj4yjCHo3EvYeF/l6X80KjiVJ+H48moB8mHAU6LHqBwAC3eSlFVf
 mSUvu3vyqMiKN7FcJLCq1+baEy7bOAXI6B3m3mxE0SL9dEuatMUoNEaZfE6XB5qplrOh
 y6ppnN5EFutCLbuJ1Lri4ovPNYVNSGqozOdoPPT8kTUSYjRgNLKAk1W8HNNhuoN7yrZl
 jpa6BXX+E0FkWYtaie8TxKyaBBuQ/dZzoqVXjmVB57Tpx33o69zBda70L4Vs1ULYLMkp
 cVP7VM0e9d9CNM1rGg4F7B4g4C/Q6Yys7y2HSt5ohwU2W4H5whtTaUZPfVMe0IEr/g8D Wg== 
Received: from ediex01.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3f6kw2d06t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 06 Apr 2022 04:54:24 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 6 Apr
 2022 10:54:22 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2375.24 via Frontend
 Transport; Wed, 6 Apr 2022 10:54:22 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 095912C5;
	Wed,  6 Apr 2022 09:54:22 +0000 (UTC)
Date: Wed, 6 Apr 2022 09:54:22 +0000
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Stephen Kitt <steve@sk2.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <patches@opensource.cirrus.com>, Wolfram Sang <wsa@kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20220406095422.GU38351@ediswmail.ad.cirrus.com>
References: <20220405122411.2096387-1-steve@sk2.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220405122411.2096387-1-steve@sk2.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-ORIG-GUID: J7OSmPskFQrUtpATmrtUgfaSwannSLbK
X-Proofpoint-GUID: J7OSmPskFQrUtpATmrtUgfaSwannSLbK
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=aQsj=UQ=opensource.cirrus.com=prvs=709516e40b=ckeepax@kernel.org
Subject: Re: [PATCH v2] ASoC: wm*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: qGQZLZFlxPeH

On Tue, Apr 05, 2022 at 02:24:11PM +0200, Stephen Kitt wrote:
> The i2c probe functions here don't use the id information provided in
> their second argument, so the single-parameter i2c probe function
> ("probe_new") can be used instead.
> 
> wm8731.c is excluded and will be submitted separately.
> 
> This avoids scanning the identifier tables during probes.
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
