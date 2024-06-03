Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412B1F602
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 08:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403215; cv=none; b=u2GjZvMZwD8724BRIVbWZ/M13Up13pGa+lhIOQBq2YTC3K4ytOKiXkVBj2ZoRL1bCMc9J0apdsVOmqSr7ddodE9kfXokbhLph55WBQ0xZQEtjV5o9ZVeFTABYDHVjnsVkjw2z+PdIT3ydn3rHoH3se8wkXJt4jYVNkY11Uhzngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403215; c=relaxed/simple;
	bh=DCx2r/p/OFxtmxhQQlPl/IZZVkzLeeoV7K53BAsOblg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TK0bhPiIHvB6YgcJqhbfJWNXMrftvlxJDBBMN+IrUyMGxYsCcx17PF9PECzHbc5/YQaQL4s7B11BdHhHvlNBVbcrtsNGOmTjHkduMmZs7iMtdHSVWbkE60oq6JcfZBBherIE0IJLUlGzkRcV+BCANDldosWJtXn4lW4z5LlEh78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=e2WBLhak; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="e2WBLhak"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id DJeksWifCSLKxE31jsbxHY; Mon, 03 Jun 2024 08:26:47 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id E31isdStN7gKWE31isUxV2; Mon, 03 Jun 2024 08:26:47 +0000
X-Authority-Analysis: v=2.4 cv=QY1gvNbv c=1 sm=1 tr=0 ts=665d7e47
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=oyxFDGXHj6VF3crgWAIVWQ==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=wYkD_t78qR0A:10 a=xGRsDScCAAAA:8
 a=rifHBRH1XTZtWdLw4JwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zEVfNvAIcUWeczMkmY0T:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CpKO348auTtOkpaYxnYFFOrDsx8VkfciEW5JtRsobmk=; b=e2WBLhak2xvyRkPsJmDRs3IROQ
	YVXA+bZDSAY8Di4iBWMtbISchapu1sHGzDwmq/5+dXSgHIAW1ie9mIg/BIVkkKh5yUT9QCAnMOoER
	j7xlKy9eSy2nlP0AO2CI+owhmjla/lpFxGA1aGCZF1itJUBajvl5H5sv4y64nx0kNFb9Vf/UotnDq
	Kfs/u85G0HY1vlLlw6mQkyHXties1riA0UUskDbyrXCRcRRrYYffJ9zGn3Jw6PlALiVo3cEuBAqWv
	qsXMfvNBe72rde9k84Mkwis5PZl0W5HpniYIM7KzwpmXgyRB0RHuPNE3RZfCFamzBsj45qDWU6Y/n
	BDTgayGg==;
Received: from 81-67-36-78.rev.numericable.fr ([81.67.36.78]:35236 helo=[10.7.154.191])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sE31f-0022kp-1V;
	Mon, 03 Jun 2024 03:26:44 -0500
Message-ID: <4da5ba72-6dff-46f1-b596-158c62b34f18@embeddedor.com>
Date: Mon, 3 Jun 2024 10:26:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
To: Jiri Slaby <jirislaby@kernel.org>, Bill Wendling <morbo@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
 <2024053008-sadly-skydiver-92be@gregkh>
 <09445a96-4f86-4d34-9984-4769bd6f4bc1@embeddedor.com>
 <68293959-9141-4184-a436-ea67efa9aa7c@kernel.org>
 <6170ad64-ee1c-4049-97d3-33ce26b4b715@kernel.org>
 <CAGG=3QU6kREyhAoRC+68UFX4txAKK-qK-HNvgzeqphj5-1te_g@mail.gmail.com>
 <bee7240b-d143-4613-bde4-822d9c598834@embeddedor.com>
 <1313c7a5-d074-4a8f-9ab9-07e4a7716fb9@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <1313c7a5-d074-4a8f-9ab9-07e4a7716fb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 81.67.36.78
X-Source-L: No
X-Exim-ID: 1sE31f-0022kp-1V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 81-67-36-78.rev.numericable.fr ([10.7.154.191]) [81.67.36.78]:35236
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 2
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEfawsyLW6vbItrtWEBJERP/VMPs5hPtt4IG1hj7maIP3Jah5KMjmF6gmHMTGtbiBZgMZj3vx1FDm7h7DKCLMhhenLvaS/kuX9PVwF4ER+RobM2zeCF0
 DTD5SshsemQEvs9+RW49Cm8tC57ZrJqCk906aTBca/CXBdsTt1nq0L4bl0spnEZM0RnyfcfAC9JT3+R2T4Q/fNoaSHUHPxYE0Pk=


> FWIW undoing:
> commit 7391ee16950e772076d321792d9fbf030f921345
> Author: Peter Hurley <peter@hurleysoftware.com>
> Date:   Sat Jun 15 09:36:07 2013 -0400
> 
>      tty: Simplify flip buffer list with 0-sized sentinel
> 
> 
> would do the job, IMO.

So, not even _sentinel_ is actually needed? Awesome!

I wish all of these FAMs-in-the-middle were like this one. :)

--
Gustavo
