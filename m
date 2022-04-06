Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B18E28E3
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 12:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD9C385A7
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 12:46:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="MS3ehJE+"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 6 Apr 2022 13:46:48 +0100
Resent-Message-ID: <Yk2LuDmwEgi0qEog@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 06 Apr 2022 10:54:05 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=aQsj=UQ=opensource.cirrus.com=prvs=709516e40b=ckeepax@kernel.org>)
	id 1nc2MU-007eB9-UK
	for broonie@sirena.co.uk; Wed, 06 Apr 2022 10:54:04 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 2E751B82153
	for <broonie@sirena.co.uk>; Wed,  6 Apr 2022 09:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E44FEC385A8; Wed,  6 Apr 2022 09:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E62FC385A1;
	Wed,  6 Apr 2022 09:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1E62FC385A1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2369gXSf007091;
	Wed, 6 Apr 2022 04:53:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=ipm/ngHMypCesWys/XTa0OgI71t3t3hjG5sHl/IPXrk=;
 b=MS3ehJE+I5jkKUoSg8zUxweUJxNXtKR12L6XE/vZCBgoOovXNVIuLaRDld8uxChMvklv
 nbm7sy28ll+ZmA0NZbI5dvfIpxTwtyqF83CzESeo7Gyo2sm7YqMhgEJ6aDxF8oLKWpDS
 TnAa8W5FCETxSP3SmexLAvykSRRb7wEb+69ofx/9WE27f5OG3m5AyrYxXN1rKc+iIjPI
 1hMbCrbXRs16alZKDOw8okvQgEHhjyGBLMI/p3XqlQIh77r9Ge1m5w3GcfD0oLYGZxW5
 5MiL1UA5J9kqKvUfL9tyCNiUwETUeAHqFl3HBcp8X/68tRjgYk7WvOR4sET/fMotSbPh ZA== 
Received: from ediex02.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3f6kw2d06h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 06 Apr 2022 04:53:56 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 6 Apr
 2022 10:53:54 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2375.24 via Frontend
 Transport; Wed, 6 Apr 2022 10:53:54 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 0EDABB1A;
	Wed,  6 Apr 2022 09:53:54 +0000 (UTC)
Date: Wed, 6 Apr 2022 09:53:54 +0000
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: Stephen Kitt <steve@sk2.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <patches@opensource.cirrus.com>, Wolfram Sang <wsa@kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20220406095354.GT38351@ediswmail.ad.cirrus.com>
References: <20220405173952.2180743-1-steve@sk2.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220405173952.2180743-1-steve@sk2.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-ORIG-GUID: YkNeHWFXdysIDpp7KySJ9IqP0vEH1COc
X-Proofpoint-GUID: YkNeHWFXdysIDpp7KySJ9IqP0vEH1COc
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=aQsj=UQ=opensource.cirrus.com=prvs=709516e40b=ckeepax@kernel.org
Subject: Re: [PATCH v2] ASoC: wm8731: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: UHClHxYB1ORE

On Tue, Apr 05, 2022 at 07:39:52PM +0200, Stephen Kitt wrote:
> The i2c probe functions here don't use the id information provided in
> their second argument, so the single-parameter i2c probe function
> ("probe_new") can be used instead.
> 
> This avoids scanning the identifier tables during probes.
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Thanks,
Charles
