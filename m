Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2711E1C36
	for <patches@lists.linux.dev>; Thu,  8 May 2025 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686921; cv=none; b=qlXS3575IsaV6BTa29yoeEue5Cd43520tUjpvhN/7yuT6SW4FEKDTpjYmcUp2vDJmpL3cBVxU0P/q8WVuKeQLNMEeoVgD0Jo2yaPpay/AheM2mAZARrrJDA1wNKoowuxztDNusSE4qki3TN85jLc1FJjbMvSh+XzIfbKQ/MT0+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686921; c=relaxed/simple;
	bh=J+DaIgmJc2plhSf97aDyRcr9UEcA9j0U/cy24sN24Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXOguASO7hQoQbArGoeQ3GnMXXb/rkA71Ocf+sOJDTjhOHdoiOJQTTjSWCGwYFQ5t6+i7hURa3nBCpGCUQcIqQMOaGgwWtGo6WfqqIykteNaBweN00EsHpWnl4c5xU4zuSRuzuoCxXb5NKT2gQUaSkady1+x2pegS2kE372Cby0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FHiBCF6v; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FHiBCF6v"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so464082f8f.0
        for <patches@lists.linux.dev>; Wed, 07 May 2025 23:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746686918; x=1747291718; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oN/u1yOXlCYt4DjjZZ0j855cjiGoWgslKBLO+dZCp3s=;
        b=FHiBCF6vinNbtmzw7IrCHXskGBDVI+CryzIA21OeoIosurTmYNt3aaade9A3xb9br9
         qMw4h7U6GEzlB8TeGjV+HI7wypLt9A7E796RMg6fmbC3a5MKyGffTE1MFVf4MiPP5IPA
         y5qpwjb9N/tua13F9NY6TrIb4U4KGG1tv4T6VF7depDh1tBz6kF8pVzF2mh2po1An6F7
         SYN/CActljIVYI7q0TIX8m/hrE7/GJjHHv19vtm+d8s8FGCKoceQe+q7oVl50FMb5Qx7
         UPX8v++jy1B4UUQsol4HTtZPc5Y8Ka2155MpSc0EDCiNNL5Zhmo/lQBqZhQqdJIKrxiv
         rnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746686918; x=1747291718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oN/u1yOXlCYt4DjjZZ0j855cjiGoWgslKBLO+dZCp3s=;
        b=Ql06Gkc8W8IGfnL9N172GA54GCsusL/vAfATgovfl+wa92a119uaTthQ7zT9fp2NdG
         JipA4QybM5n1zSnpowkYtaWiHrTNKT96cgf/tI+mL+lqxLF1Kk5XwQQ1P9+63mPLAT75
         aqy0DwAwl7qFWywInObkzHBYBmun/Zg6xIot/j/TtNV6v11EqPWKw6zS2fdpe8b6bJpL
         byIqri2+34nxRVujBwyA9413360NeGe6wmtWR3i7kiUylp+4GgdZqsHcLW8rBk5+mRn1
         VY3yRroZFJ7up0Iz6rwSFYBzW2QIUdH5WDUs5sA3b8fsFFEktGKz6Csw7pXIOfcSLG/y
         OLgA==
X-Forwarded-Encrypted: i=1; AJvYcCWahQqxeF+u1KJNL4pn0j+yUZdmpLJci+n7Cztt+WmHh1NiIsLK6Igu26gw9VWuAp5Dia89MKot@lists.linux.dev
X-Gm-Message-State: AOJu0YxI3IX+UBcVATb1eqI0nduHXm35pA4eoc086l01EoIBjAhu7DXn
	19IHf1nk2MIG8V/tKaiJ69bLA5nZqF+fNT9JUhMT/gQ7XvJjqHphv+7m6Sz2XCE=
X-Gm-Gg: ASbGnctveUfxuLwg3srL/pkRX8+zpVOZtqaZutnz+FbGOrKsm+KsWKjOjiQsbTmcumA
	AD4Hu1pp3YCWP1XHwIdcuhcztM9NvjOfoDwZdIFMR1Xpgcp7r6K9Lld+U4uolpSAs+ipK4D5OLx
	a/VS8HpcjD2sxKpQ0pU27zbMS02DfxuIxd/friZzX5ARWaiJ29BoP2JtdBOq280NOIstAyPAL9S
	ZHablczoZsnBtsd5+LYuIfEjnBSxt3tGUX11kO0+llr8Jy3bvxcBNKv6iS+IsJmig6+b8KLJ1FB
	5OiQCdV/mh9GNsbXDWmUAooYNLTX4vhBCiG8ImCTw55xsfsDpijsCpZu
X-Google-Smtp-Source: AGHT+IGABSvZpPx8hobskr6H9QpVVUUq1xHoj+hrZLygN8wQiQyv3UOkrESVz2X/i1IQ9NOEjwb+4w==
X-Received: by 2002:a5d:64e7:0:b0:39c:2692:4259 with SMTP id ffacd0b85a97d-3a0b4a19281mr4086914f8f.21.1746686917754;
        Wed, 07 May 2025 23:48:37 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442cd38179csm25448035e9.39.2025.05.07.23.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 23:48:37 -0700 (PDT)
Date: Thu, 8 May 2025 09:48:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in
 __qcom_smd_send()
Message-ID: <aBxTwhiMelFjvrjP@stanley.mountain>
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
 <aBxR2nnW1GZ7dN__@stanley.mountain>
 <2025050852-refined-clatter-447a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025050852-refined-clatter-447a@gregkh>

On Thu, May 08, 2025 at 08:46:04AM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 08, 2025 at 09:40:26AM +0300, Dan Carpenter wrote:
> > Hi Greg,
> > 
> > I'm sorry I forgot to add the:
> > 
> > Cc: stable@vger.kernel.org
> > 
> > to this patch.  Could we backport it to stable, please?
> 
> What is the git id of it in Linus's tree?
> 

77feb17c950e ("rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()")

regards,
dan carpenter

