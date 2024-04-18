Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F3179204
	for <patches@lists.linux.dev>; Thu, 18 Apr 2024 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469142; cv=none; b=PHzLbA6F3hDgXdlAJChuT8i+ngGOTx+Zc1Jtk934VGEo7Fkui70+pcgQ0FVMefSVTm8Eyo4/W3lAs7D7U9hHsuSoTwzBLutEhMFz5DHtXozXVCljGKybuxX1nVA4p5JbrVookJPNmMfxfdew/6Lytd8k/Sz4z9g7mKXNkJfTGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469142; c=relaxed/simple;
	bh=3AmLu6fuTglDHdN6HuJ7Xq3eNdZpOuUL/x2iprMEBP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oen0DzOfRk8TK2XmEyLz0TeSlThyRv3hFz7pK/OaJQZ/GPS9UW67BpaS0gBPPS7JObPcmlngsC/1ZmdqiNuSp+W1FkIrR68oOyRcxYXNtmoJv8BqsE09Hq9MLkM10aysFYJ1kZQzlzVwvwi4iB0+VVoyW7RV96TN84gzbwrulYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aPP/sxs0; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aPP/sxs0"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a2dd2221d3so1097345a91.0
        for <patches@lists.linux.dev>; Thu, 18 Apr 2024 12:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713469141; x=1714073941; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EgmECHn+IUJlMNN8CLsfysKsR/Z7Bc7D2FVBk+o+7qQ=;
        b=aPP/sxs0GIlUSjrUwsZqES2oNBNDUBWuupSQsI8P/5jEjyjAcG4Edt5Xa07yQtsaKu
         1J9LKQALhQFfOxMNKO6L3uoGmdo75gbvGYz8dZHIsBxYb4jqN+6lI3h14pAYdh5ioyj4
         lbNd45Sd/8aUUUyDw4kY6Kcvl3DBx5FuA9SHjvD/iZPSRq6U4ndtKz4AJ7bhICKyBPTK
         Yxn4HtbDKTirFUL+/iBbvhkfykf7hKi6fQ6a8pzAoMkGnlEHpgiVHsw8axVTEjU+Xjad
         kE2SrU+LPLSP3NKw0iEYnS0U5PdbbhXrc/DViMSsVhHWloZlM63SZnWoT5sb5bPf5sAE
         7ceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713469141; x=1714073941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgmECHn+IUJlMNN8CLsfysKsR/Z7Bc7D2FVBk+o+7qQ=;
        b=DEYjFPDu9+iBmrPH8dWby530XzKmPc5qv575NYwPPBM2NRX5cuk4PNoCIsLQYHTud+
         BdYcpHSuVd661joQ2Qh544FlkVkPS/Dg76TYVnWDuaO8WpYLdIm8M+1Ehf0nM8eFwmCT
         2vZIRKQjvzu/RYYgmEBvXznAINUsmaTYtJofnG3+kOV282Owdb9GCrvM0Qn7NLt5D96C
         GdTQqMQax7lDakchZBcJ1omRG1CdAQtjgwUleS0x7SIFPazXsOCHcDtdXwX1VdXjDSeR
         yepL5wKemtH5LrUDfRQi99sBdG2uzZSGq1zDiknBv7dGuc0Ukahd66+8Zxcp8TJiuWKB
         O6yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV0PD6vzYyWSHk323W0FM9Y9fkKAICMOlJsbNSVzwLrhS1evq9EqTr6pCPP3hx7laJi96sv5nfduo4DBUjY14qPCCS0vP/iQ==
X-Gm-Message-State: AOJu0YzcUueQ9R6a4w90+VdeG2lxuPkbRWNUeo9UFpZ/Fbd148AH0/dv
	ZFm7AFSkiWmNCGwSetjYOadaGminRnNwBq6Dgvpa/LaegLTm4glo
X-Google-Smtp-Source: AGHT+IGcl83ls5csOd31qry2hdPL3nzhI3ZTNwSoEJX1jZOXPdbKQ92PAX5/q90K087n49o0YP/DnQ==
X-Received: by 2002:a17:90a:ebd1:b0:2a3:be59:e969 with SMTP id cf17-20020a17090aebd100b002a3be59e969mr114833pjb.47.1713469140821;
        Thu, 18 Apr 2024 12:39:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a390300b002a232e4f9ddsm1982272pjb.34.2024.04.18.12.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 12:39:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 18 Apr 2024 12:38:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Phillip Pearson <philpearson@google.com>
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
Message-ID: <c5d0c7f7-96a0-4806-b3b6-269d9189037d@roeck-us.net>
References: <20240411095424.875421572@linuxfoundation.org>
 <787e0ac1-cb31-47d9-8200-3f6a3b4119dd@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787e0ac1-cb31-47d9-8200-3f6a3b4119dd@roeck-us.net>

On Thu, Apr 18, 2024 at 12:25:21PM -0700, Guenter Roeck wrote:
> On Thu, Apr 11, 2024 at 11:53:29AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.274 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> > 
> > Sean Christopherson <seanjc@google.com>
> >     KVM: Always flush async #PF workqueue when vCPU is being destroyed
> > 
> 
> This backport is bad. In kvm_setup_async_pf(), it removes a call to
> kvm_get_kvm(). However, it does not remove the call to kvm_put_kvm()
> in its error handler. Also see upstream commit 7863e346e108 ("KVM:
> async_pf: Cleanup kvm_setup_async_pf()") which explains that one of
> the error paths in kvm_setup_async_pf() which is not supposed to be
> observed can be observed after all.
> 

Reverting the above commit from v5.4.y fixes the problem. Alternatively,
applying commit 7863e346e108 on top of v5.4.274 fixes it as well.

I added Phillip Pearson to Cc:; he did all the testing and can provide
additional information if needed.

Thanks,
Guenter
