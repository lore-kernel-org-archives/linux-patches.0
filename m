Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7190D25CC69
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 10:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755686597; cv=none; b=dCLG6m79ko0wdox4pIaNfPkQ8c251ZxrlmgMDRAX8Yj735TDQU7Lh6AtxH0nCa94LzPzaanP4Pk02b9Ris3fAEWifWlyR7XWJvajMnemKNr/hzcPJr0VIysi1McY3CeB/YQ1EeBT0ioK0CSrINKoeee0p4FIndbl+byAe882pSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755686597; c=relaxed/simple;
	bh=Y17Rj5E/GRtenqS3b5BfPh0zb3y9f6UoHKe5XhkCVjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iR73Zxc3pe2F8RVklUzv2ny/VgexTD0ciR2L2fCF5i+hO0aKG23aDkwKbvk6froQPAValZdxDiRKr82ruX87oMq8GHO2XichzGz8BAMOi69hk+B/3xiq0eZOhGSAkZiDOcoZnTS2n2Y69SmJERZS4a5eu31ccyB2+eMm6CwlWnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=URNtyePt; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="URNtyePt"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9dc5cd4cbso4370951f8f.1
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 03:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755686594; x=1756291394; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+6JbHXLCu1gk8Hmp+tYteMxiM391FXMH8MSo5yWpG5E=;
        b=URNtyePtI/wgz0ixQyQROvmwNofYFvET86BzKMpK4uyDTYfoQPQBLWsFojhBlmcUG7
         jbbQgBgxNNvW9LtoetxegOLeL4BbUeYLlBFzZejD7U4nbBplV7ebiiRGk9HH8d2iljmJ
         tNfylz3O5OO4n+6P6xyKtPwZaI+SlzmdC3IP1SOA06ohC2F8dz5p4eb4/+9+8gxKGliz
         k9Zrdjl+s1JDe7JVQwyJjHBb9ZWML15q1aLRXgKdjALoH6dSdrXZ34Tg8Xin0f3E0rp+
         AyTkd8DdOnkpMWLo0dug90Bwsr7Ubictwba59zG01kG0CeACFkLD44k6AmirRj2ISY2i
         RdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755686594; x=1756291394;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6JbHXLCu1gk8Hmp+tYteMxiM391FXMH8MSo5yWpG5E=;
        b=sdUSUwhMKN0OqnNTQfLGGpC7QHjnZA7Reh1FtEAidKAP1fymW4/aDSEkqAbG79dMA+
         g2AuZkoDv5jp0AH0DNSVoCPqpK3MJBJ2Ly6UcSLi2c0cFuFSi2u2uCPenreM0s1vuQZd
         FpQdumVGRirAUnPlB/CmkSbdVLKYFoXRzVMeepInVuirAQkY2T6REQCKH4YaHtUHWrB8
         X+wdQ8nXxJg93b8biAp5Py+V81S8C6iEnOOSPFROmkfAZF4hx9DaimB7h+RNOqSCPOCG
         hcrLHOnLmSTzxFNF9vT138eVrcgmiUuZEWSm+Dh0QuNgGF9jKfHEYmaUDkRkKmhwtSXC
         BkZg==
X-Forwarded-Encrypted: i=1; AJvYcCUBRQamEWVM+Pys4NYgT45aZwqe5FTASwIAa31B0jlLjGM+LLc0dFD/xn17rXVSGtzHWEuRFXw7@lists.linux.dev
X-Gm-Message-State: AOJu0YxsuljDOsKLka3vhp6rjFzHRBk5zAkGFEiE0z/7l2e74lTQF6tU
	8dfFWg7PwqB/a1e+EeZrUBOWSeUimvG0g9k3LUvHL14mEUeFaUD2ZuvmHe06HN/nIpk=
X-Gm-Gg: ASbGncvg7uXL1drsDLER8OzUgYeCANxQz2s2RMTeC+SFKQ7NgUanzzpbKERetKDRvIr
	zJDVXw+qU2sRIsoVj/E55nW6rAjrdusD2gZjOR1innr93n8yOHNYGNkH2pPcGoFw5OCjIYV9VEA
	z5BGPIuO4JfkKJLCt/aTD/INuiskSoD0XaPp99tSNQPhH840DT95zIMj+Iyx1icA7/ya11cKaFd
	fYYFzAotUe9LTHdGzc7xmsSmiyfmLW0xhnzfjL7RdjjfJsh3mIL9w6Yq13PYTOUj6M6HmnBkiVA
	vUF1AvowJkrOg2qoOEUfIBQHeLcF5yXoYjAja2AMfYgIfcXqIqiO59k4M+r6rbDVTktm1GsO+Vl
	6AkmoLd8QwRw7b/UeYqMLge7WhqPUOALO/R7r+GPO+yg=
X-Google-Smtp-Source: AGHT+IFfThC5sQ086sb4zojIb5S4YMtFRvJBKvING/uRhqmvc617M0JjqPhE3vfuS8adHjIcpEJ+Qw==
X-Received: by 2002:a05:6000:4210:b0:3b7:99a8:bd10 with SMTP id ffacd0b85a97d-3c32e606ce1mr1724387f8f.42.1755686593663;
        Wed, 20 Aug 2025 03:43:13 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0748797a1sm6893279f8f.5.2025.08.20.03.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 03:43:13 -0700 (PDT)
Date: Wed, 20 Aug 2025 13:43:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: =?iso-8859-1?Q?Beno=EEt?= Monin <benoit.monin@bootlin.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] mmc: sdhci-cadence: Fix -Wuninitialized in
 sdhci_cdns_tune_blkgap()
Message-ID: <aKWmvWTtQ_QZYgEm@stanley.mountain>
References: <20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-v1-1-94aa2d0c438a@kernel.org>
 <2560300.XAFRqVoOGU@benoit.monin>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2560300.XAFRqVoOGU@benoit.monin>

On Wed, Aug 20, 2025 at 10:07:35AM +0200, Benoît Monin wrote:
> > --- a/drivers/mmc/host/sdhci-cadence.c
> > +++ b/drivers/mmc/host/sdhci-cadence.c
> > @@ -288,13 +288,12 @@ static int sdhci_cdns_tune_blkgap(struct mmc_host *mmc)
> >  	void __iomem *hrs38_reg = priv->hrs_addr + SDHCI_CDNS_HRS38;
> >  	int ret;
> >  	u32 gap;
> > -	u32 hrs37_mode;
> >  
> >  	/* Currently only needed in HS200 mode */
> >  	if (host->timing != MMC_TIMING_MMC_HS200)
> >  		return 0;
> >  
> > -	writel(hrs37_mode, hrs37_reg);
> > +	writel(SDHCI_CDNS_HRS37_MODE_MMC_HS200, hrs37_reg);
> >  
> >  	for (gap = 0; gap <= SDHCI_CDNS_HRS38_BLKGAP_MAX; gap++) {
> >  		writel(gap, hrs38_reg);
> > 
> Thanks for the catch!
> 
> I don't get how gcc does not raise a warning here, only clang does. I
> did build with gcc-11 and gcc-15 and they don't complain about this
> uninitialized variable.
> 

We disabled uninitialized variable checking on GCC.  It was too crazy
and especially if we want to use -Werror.

Smatch also detects this bug.

regards,
dan carpenter
