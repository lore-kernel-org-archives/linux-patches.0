Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333B46B4
	for <patches@lists.linux.dev>; Thu,  8 Sep 2022 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4064FC433C1
	for <patches@lists.linux.dev>; Thu,  8 Sep 2022 16:59:24 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 8 Sep 2022 17:59:20 +0100
Resent-Message-ID: <YxofaN1Op6PFp7UU@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 08 Sep 2022 17:24:13 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=JZU2=ZL=arm.com=kristina.martsenko@kernel.org>)
	id 1oWKK3-00CAbm-Kj
	for broonie@sirena.co.uk; Thu, 08 Sep 2022 17:24:13 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 58754B82065
	for <broonie@sirena.co.uk>; Thu,  8 Sep 2022 16:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2ED1BC433D6; Thu,  8 Sep 2022 16:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id 16D6CC433C1;
	Thu,  8 Sep 2022 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 16D6CC433C1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AE6F106F;
	Thu,  8 Sep 2022 09:24:13 -0700 (PDT)
Received: from [10.1.32.166] (e126864.cambridge.arm.com [10.1.32.166])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE1B63F7B4;
	Thu,  8 Sep 2022 09:24:05 -0700 (PDT)
Message-ID: <059c12a5-7b38-9f53-a037-909db6a154e8@arm.com>
Date: Thu, 8 Sep 2022 17:23:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20220905225425.1871461-1-broonie@kernel.org>
From: Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <20220905225425.1871461-1-broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=JZU2=ZL=arm.com=kristina.martsenko@kernel.org
Subject: Re: [PATCH v6 00/28] arm64/sysreg: More system register generation
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 8Oq81QQ4hap/

On 05/09/2022 23:53, Mark Brown wrote:
> This series continues on with the conversion of the system registers to
> automatic generation, together with a few cleanups and improvements that
> were identified as part of looking through all the register definitions
> and bringing them into line with the conventions we've been using.
> 
> v6:
>  - s/SMEver.SME/SMEver.IMP/
>  - Update some more uses of ID_AA64MMFR2_EL1_LVA_SHIFT.
>  - Correct ASIDBITS value for 16 bits.
>  - Update ID_AA64PFR0_EL1 conversion to DDI0487I.a which has been
>    released in the time this series was pending.

For the whole series:

Reviewed-by: Kristina Martsenko <kristina.martsenko@arm.com>

Thanks,
Kristina
