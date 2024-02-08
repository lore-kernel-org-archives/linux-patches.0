Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAE22E401
	for <patches@lists.linux.dev>; Thu,  8 Feb 2024 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707365852; cv=none; b=V1ZNQL7WmG6v++ehhAgEuGCy7Og7hMcumZOYlu06+aeHilVvCfU5iP6Svl6dFjL9KDXcrgsWq6Y62suXwZJ6yWHaPXko5L6qNuhUOI7YrVoOtm11YmtKRPTAciKqxwg/wSXFhxniHRcglFOMBmODj/Dn907r+86fu34Aq04PIIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707365852; c=relaxed/simple;
	bh=cAHh4xjhBUsUvi6dV0lRc25LSMG4QeXOE/23496L/SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtX0gbZEojpYY0xLJA8LWYFvVqO+zeS810UdwhYltbvkpTfatzFu8bA3c4Kwdu0+ETLi8focZ2lIWiN+eMnFopXT4SpFg0iFplVDWX/8bTkdXYBGrXcTbWu9mGhSqO0UYPjp0ksJYvDwLMBpPR1BSlpmt0Wjq8PI4Blieyn+ZcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=FiGCVF4c; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="FiGCVF4c"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso996659a12.1
        for <patches@lists.linux.dev>; Wed, 07 Feb 2024 20:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1707365849; x=1707970649; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VMfM6tLjsjGv++dP9ohEDO8bzLO9AXA9FZHQRHDHuD0=;
        b=FiGCVF4cymlsM2iBgItQuopEK6v0xIZk+7/uHMcnywToxZvm25Ke6TrfLzgaJS67nB
         Ba0EgZuFqxNlR3BZBFkJYKNtE2WdqnMt30Eo73LM1gZHtsRC5Y360o43rBzR9Kz1O+Tr
         t5VJBOiLGWmOErJeLjnpOMXOKTtrYpGRHCFtWw/pAZam9QyxrlbAH0DOjyNWOoWKunxd
         M200rY+JlAjTGOMNbolXGgfP2P3ee0pPjUjEzUhZye5AJfYAwSNe481gEIyJp3qk73jv
         0HJOMCeGOkxpZRCwUq9fUt48HcW8yKpQQrokvwQk3rbtnO2HvfOAwdeg5uPLK+ULOm9V
         sv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707365849; x=1707970649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMfM6tLjsjGv++dP9ohEDO8bzLO9AXA9FZHQRHDHuD0=;
        b=JTSC5kdEQtMpCwx4qrtw6+jEHgfOM+waJKO/L2zosOuxRFl7YnjKi3nhgAd8+/6Cy6
         egB2CeD9yilNztCmArDejX0LzkSn24cKdZM+MS/Ued9uibkMGZJMe/hhGXF6cFo56fSW
         2tYx8Z1EV8IZfyWLr6O+YWqdVQ7uidOyJx86XzH/AvamfZpDBcz3O7zbQqZ4lJjwqqUj
         ixmaVSbR3+qltgIaNgukjlGJemLVCloGeGb2GfXPF6tsx566blNLPxOr6bwq7vf2EcZ4
         JBsKENpj30jVqg7XXLPul+dcSahVARponU6F6WIXhZAMK+w1DlT5K4EiHYG9yOpLXUnA
         jDQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwwas/GIhb1IiVNfTIbX3DV8RU8GPku8RERijOTOVAV4/NzqcrDH5OkmL+NI2Go8RFXAp0oqDtgmBhuZF4ZCjcX2tbanICQA==
X-Gm-Message-State: AOJu0YxmHsYM3M4rzWz+rftlmXBQGmAdluOQcn2PmYXYu6xWlmVk05p2
	iJJ/ADqC5DIZacE6eA+yH7BrW48xwHquO4D1btObLzEcyIHI5LY8Kbfuqv45dpY=
X-Google-Smtp-Source: AGHT+IGy56Ygai1gEesu11gcC5X7oygZYFdrRpd1VgYGiAFJeE0xjOR3DXoJ2a9vLefMqnwckTySXA==
X-Received: by 2002:a05:6a21:9214:b0:19c:5ae6:4425 with SMTP id tl20-20020a056a21921400b0019c5ae64425mr8350230pzb.59.1707365848984;
        Wed, 07 Feb 2024 20:17:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXWeDIoarGsQx3+UKEz2tEshr1jtFWhOljZpJblOlXsUweFB7dY+oThk+1y+Uw/fQWVuSyPNYrKLJ5eq0PdMVe1Tatbj8GTEK9MG0UfNls1BEwdwsc93HkJDUXV1CX0PP7N4Du2STjp+fU4OslOUawzmCn67uTAQ6p7/7vyZymWNQ+RKGnISD5lsF6xJI2MtRIH3rdbZSMlDMW5fGF18O+Bh0tOBcmemCm63n65N7Ze1V9FR8cfmCYPFW7OLTwro/yrfouI+AemQx+cnDlhVHZh8t9GQtavASrrdOq4PTKYhlZXhlBqZOV/2nr6vMPSOal2MeECG3/DBHzfZ5LpnQ6+0TuUWjkUtnb9TiaCtYa+ROQeiLpPqsldrnzZxH0jMu1LYcDlwGzxiG3G3ZE7x8P0cliIh8+fln/sdIL253DhGUvTQv7yrUV42VsD45tS6GFFQdqAx/dUV5Jmk91NcC5qQdBO6/CXEcxpD7Cc/PfaSbmqxBnA0pw=
Received: from x1 ([2601:1c2:1800:f680:3e6:72a3:7bf1:6e29])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902c74b00b001d9ef367c85sm2171292plq.104.2024.02.07.20.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 20:17:28 -0800 (PST)
Date: Wed, 7 Feb 2024 20:17:25 -0800
From: Drew Fustini <drew@pdp7.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v15-RFC 0/8] Add support for Sub-NUMA cluster (SNC)
 systems
Message-ID: <ZcRVZYtmFMz0fdjU@x1>
References: <20240126223837.21835-1-tony.luck@intel.com>
 <20240130222034.37181-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130222034.37181-1-tony.luck@intel.com>

On Tue, Jan 30, 2024 at 02:20:26PM -0800, Tony Luck wrote:
> This is the re-worked version of this series that I promised to post
> yesterday. Check that e-mail for the arguments for this alternate
> approach.
> 
> https://lore.kernel.org/all/ZbhLRDvZrxBZDv2j@agluck-desk3/
> 
> Apologies to Drew Fustini who I'd somehow dropped from later versions
> of this series. Drew: you had made a comment at one point that having
> different scopes within a single resource may be useful on RISC-V.
> Version 14 included that, but it's gone here. Maybe multiple resctrl
> "struct resource" for a single h/w entity like L3 as I'm doing in this
> version could work for you too?

Sorry for the latency.

The RISC-V CBQRI specification [1] describes a bandwidth controller
register interface [2]. It allows a controller to implement both
bandwidth allocation and bandwidth usage monitoring.

The proof-of-concept resctrl implementation [3] that I worked on created
two domains for each memory controller in the example SoC. One domain
would contain the MBA resource and the other would contain the L3
resource to represent MBM files like local_bytes:

  # cat /sys/fs/resctrl/schemata
  MB:4=  80;6=  80;8=  80
  L2:0=0fff;1=0fff
  L3:2=ffff;3=0000;5=0000;7=0000

Where:

  Domain 0 is L2 cache controller 0 capacity allocation
  Domain 1 is L2 cache controller 1 capacity allocation
  Domain 2 is L3 cache controller capacity allocation

  Domain 4 is Memory controller 0 bandwidth allocation
  Domain 6 is Memory controller 1 bandwidth allocation
  Domain 8 is Memory controller 2 bandwidth allocation

  Domain 3 is Memory controller 0 bandwidth monitoring
  Domain 5 is Memory controller 1 bandwidth monitoring
  Domain 7 is Memory controller 2 bandwidth monitoring

I think this scheme is confusing but I wasn't able to find a better
way to do it at the time.

> Patches 1-5 are almost completely rewritten based around the new
> idea to give CMT and MBM their own "resource" instead of sharing
> one with L3 CAT. This removes the need for separate domain lists,
> and thus most of the churn of the previous version of this series.

Very interesting. Do you think I would be able to create MBM files for
each memory controller without creating pointless L3 domains that show
up in schemata?

Thanks,
Drew

[1] https://github.com/riscv-non-isa/riscv-cbqri/releases/tag/v1.0-rc1
[2] https://github.com/riscv-non-isa/riscv-cbqri/blob/main/qos_bandwidth.adoc
[3] https://lore.kernel.org/linux-riscv/20230419111111.477118-1-dfustini@baylibre.com/
