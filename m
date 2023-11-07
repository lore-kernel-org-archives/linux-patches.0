Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CC0335C0
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="bbCnIH9B"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5ae143e08b1so69680597b3.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:15:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699377303; x=1699982103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cIon2aC/U+pjndRF0dPULvHTvHn2n3TpUOM6ACbZ2jA=;
        b=VvUYKJ3nhYX1xvzdcdObIPyoJdaiFjcqRT4CrRm170X7429Xzfqi1v0BHxLjAtLlvB
         qukeyq57xKdyWh6LTdeKcWK3On+79P8N8N2deKSQfGr5ALnTCWxwZ1xlqp5M8uEZqDUw
         nWa1LgcWhJd71FSzJ9V6KWX6EUYcoY9rfF+meByJDWv79YY5rvidaJge646R6qU+C4AX
         /csPjfCMWDxbwcMDa0Oynsz5x5CmRi7AvOPFSs1ppA/2jK6Da0v7IEnKRBr0bDaHrR36
         pKVDy3s4fdIYrgUMOz+LqOIm4BOFp1KiwXRsboghF8DR0zCHJmlDL4VZNC/jGFkY3RRC
         /tIg==
X-Gm-Message-State: AOJu0Yza6uZ1KIRhlppN5URn+enL5fXspdxbFrBVjLsHQvdeBR+CO4/8
	V7BE8YEYa6hI1e6qWV2UkNU=
X-Google-Smtp-Source: AGHT+IFWC6f2Uj8Jdr1pY2RERI9LKb7PGdwkIwudFpTnthj8yiNCwbEHg+ZmcAd2KlWjrdFlnyH2wA==
X-Received: by 2002:a05:690c:ecf:b0:594:e97b:f6fa with SMTP id cs15-20020a05690c0ecf00b00594e97bf6famr18146260ywb.30.1699377303169;
        Tue, 07 Nov 2023 09:15:03 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id n206-20020a8172d7000000b005a7d50b7edfsm5734827ywc.142.2023.11.07.09.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 09:15:02 -0800 (PST)
Date: Tue, 7 Nov 2023 14:15:01 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1699377300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIon2aC/U+pjndRF0dPULvHTvHn2n3TpUOM6ACbZ2jA=;
	b=bbCnIH9Bpe0CchplrmTvTuRV2sWMi69SLdOiuwX1CAk9FTx9187LU6rZCmcLm1aEXUDQDl
	iuMQZlh7SfGxzIFIEkBiaDRuYxPGtrzdt7NaEHuSRXZuxgxxAoKnILu9RAuv8bZnQc8PpV
	jZyrONHd4I7fY/eFEgkalEd6YTbDl2ASOnhIsvDYsDmMG+W8a4Sa+GrLewDlQzTHlofw5R
	E5DLQ+uTjzj4f4txwkp9o+wTKb/B8AIMoRhE/da34xUbltuEmn1DguXmZNFEMjzdiVuPzV
	Oh6G11D1wWh5jjbgJ3mi6Ucj75h8+EamS5mrn275/jVnyb3ugi/9xevWmKbGFQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Message-ID: <qoak3rxpamcuiimvzixvhx7z2pgqdu3nbnvqf2alw726jojveb@2oeqwzq4t3dc>
References: <20231106130301.807965064@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>

On 23/11/06 02:03PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No regressions on my system.

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thank you.
