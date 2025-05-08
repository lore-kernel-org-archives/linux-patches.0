Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A112192F1
	for <patches@lists.linux.dev>; Thu,  8 May 2025 06:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746687023; cv=none; b=ZkafT5dA2LP3PgT9UnHKS3fsL9SCge2xChaycmSHFEJbtre8oQ2NhOqiI2++2ySA+Awlet3RTYCaunu/OmIq7rsl4Uc8ZKjPN0YDXMPoqgkXi+qL6YBiHEb5CdR8AbgNDeGIWTG62BBXIIThILkImpckZFuxVwAWtHamr1qj7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746687023; c=relaxed/simple;
	bh=VkMWVX/SiY6jp7xQYEDQPhAzra4q9xN9l5OzXXCtRQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgshBJimvqVoyjY1n95BvahyVfJa6KTmardmElw661UIxEiFUNjX2NfmCgIrcfIWdQ4L8Xx4o3+OnrIct7LKpleEEsgCso5h7N2BP04dmf2qUWBE0K7sNf/ptPWsrRFPxgH1AvDYx26uNbtE2Heq9OVzh6ruLRMAuQOGOGUby+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IzNntYsV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IzNntYsV"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so4578785e9.2
        for <patches@lists.linux.dev>; Wed, 07 May 2025 23:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746687020; x=1747291820; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sswvW9Qq2pJQk2SsX4r7xkXE6gJyDJCPnoM6S1kt3zo=;
        b=IzNntYsV26dxpPqWVLeknEq+JV+PyvFyLDs9uqCiKMBFDjeenvZPPOoxVSe9pl396J
         49u4SEx0duY0xb/7aJ9p+gm0L4+qPcSmx94QVqzKuFFYI/tCKUG3AaPoxN/srLXQe5it
         HyTgz9WyinnvS76Nxy32jFjKXnaRmYAJyIHyns5ywhoS9NNq5x7XgzVC0FiPZdeYskXg
         qp+dfgNZFI6KOd02tslkHxu3Vu9Q5olF9kFMoZxmswCp5QFn+NGZf4TpBeKO6iv/49vY
         w/Yfe0GVJ/cuoVFYGLG6vqYR4DCDDgVFTALdwXRSqztW542onWW0invfEHCjNSw/v+Qm
         Lh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746687020; x=1747291820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sswvW9Qq2pJQk2SsX4r7xkXE6gJyDJCPnoM6S1kt3zo=;
        b=xOpeNZj5/QC792FUfNFdsu/KakB19du7Oar9yMJHOCGUVBsXMwJ9IY+Ll6CdMAgOwS
         f15E8oAH/sN3uFKDzZDLTfR0cFxGne39y2zBxJBYIrWLUv+J0Cbg7ZliI66tQih7evT+
         SjJDMf6PMUJY/YPjlvdVBtefJ5RJJv0iNrbMAj0m5NdQ0sYFCNaaSoA2tUY5Ew+pflS7
         NT1jnlIDaJzwg7qmEsAzT25rr8YJZDkZB5iaBzcWVeTCvRbeDL0BcKPpnJb61k2at9Cg
         ZixcrKUtawxaJYnx+1K2z6GU/9cyTFM0+laqYo64kMSZ1HL6M6I8vGLjlyGGbNYvQ7A9
         +88Q==
X-Forwarded-Encrypted: i=1; AJvYcCUd1AqFXxRYyKeSMAICV4iiUmHr+U8QfSLQ2bh56SycLp7LkXyFcVJchkS2dy42E87ORyQi7aLt@lists.linux.dev
X-Gm-Message-State: AOJu0YyRlYciCo+o0AqD6DYxVjdAX/ay/gi2j2PFH9c3xGptqJMMPeef
	SOyMk/gYJje9fBumzXoSi5sifOLjFnr79ICtBlDtnAbVUTAcmjw+Xg4YJx39YNg=
X-Gm-Gg: ASbGncvN22s92/qTHGTQpY/ozEbPKXillMYiiBBUKUNlVhgeINX4UybNAyhSFDS478B
	UU9jLW7FM2fqESKnDAABGSkBoPDJl+JVae8130U1fkINjKBD/t7mgs1fDGhrYeFgTsF5DGV/9Z/
	rTKvp71XuWp/aVNUwNB4wnYOIBmXkwiXQS7WGQCa2wSTU3dzXSU0L2kg5B0NUSbpgD203Glttw0
	TkprpbmUsh6IeVUnVtTQoYL9odyg6VdiOCzmVwcnVF95r/d0kc/5PyqJxvBkssfeQbyGvCDjkSO
	Lyray/lx7fmP6vItV+SNRK/x6CigvWffT9XXG+L9nfW9ng==
X-Google-Smtp-Source: AGHT+IFSnH7/hk7YsAwIfMrID1Szme78bKEZ0xLGnBiKKY6ADD+OwDpp3cph0URuF50p1QHS0OhXXw==
X-Received: by 2002:a05:600c:3d15:b0:43d:9f2:6274 with SMTP id 5b1f17b1804b1-442d02eadb4mr20122025e9.14.1746687020047;
        Wed, 07 May 2025 23:50:20 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442cd32f3c2sm26019325e9.15.2025.05.07.23.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 23:50:19 -0700 (PDT)
Date: Thu, 8 May 2025 09:50:16 +0300
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
Message-ID: <aBxUKEpdszTDduMk@stanley.mountain>
References: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
 <aAkhvV0nSbrsef1P@stanley.mountain>
 <aBxR2nnW1GZ7dN__@stanley.mountain>
 <2025050852-refined-clatter-447a@gregkh>
 <aBxTwhiMelFjvrjP@stanley.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBxTwhiMelFjvrjP@stanley.mountain>

On Thu, May 08, 2025 at 09:48:34AM +0300, Dan Carpenter wrote:
> On Thu, May 08, 2025 at 08:46:04AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, May 08, 2025 at 09:40:26AM +0300, Dan Carpenter wrote:
> > > Hi Greg,
> > > 
> > > I'm sorry I forgot to add the:
> > > 
> > > Cc: stable@vger.kernel.org
> > > 
> > > to this patch.  Could we backport it to stable, please?
> > 
> > What is the git id of it in Linus's tree?
> > 
> 
> 77feb17c950e ("rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()")
>

Ugh.  Nope.  It hasn't hit Linus's tree yet.

regards,
dan carpenter

