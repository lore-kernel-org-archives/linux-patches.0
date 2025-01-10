Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F224B19F421
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736475854; cv=none; b=nCoNUlGJqd9BDodcCqlhX92yM9FMQu8+J1qWPX7oPyu5+9pm8KJru1rhcxqoHdqsvUQXO5aLGri7ukb/zXfRnF+sM8+/ErtdUEELEI7rVOghuu4Z5wtxRknnwhoUYHRF9h80aTHSXL4s9Ggg5KZlhWgEfInxB7SluZ8kDypRo5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736475854; c=relaxed/simple;
	bh=HPbJTAOZCcEw1vPjoee7BGtZeeHn6BbIBbKmaAl3eug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d32snllyuhKDn5/zIwiMtLgach3rTXQ8V1bO5dSrAhvO0rhxd83LBMDLl1OXAsTn7rXb0epdTm9gk10fOdS9CbbdECaib6j4qg68nAVPBysj/VPC8eCPlAoz41QRRsuZdoFyqr5SCD4buk/vtmqA4hyrs6JiDR/m524l6ObxyRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=jy8JDrdj; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="jy8JDrdj"
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=jy8JDrdj;
	dkim-atps=neutral
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 1F2ACA5C
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 11:24:06 +0900 (JST)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-21638389f63so20020355ad.1
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 18:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736475845; x=1737080645; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RT99AIOWKsdh3kIu1d1CPLSjddf8N740x5d+oosRGww=;
        b=jy8JDrdj+FPYmSxK4jAOoggvOUr9AYBhTrmyZk5egFCoy7Mp9MyhNulTf7UahekAH/
         nCeONXA+l0sgqg32l/xZqMYlyzZRL0udaU9+g14ZFOABXFCPlfMDm1Nb0Pm8BQkybSvV
         45CDOyAgSCRuIzhY9jL868Wul/3yfdrOoDRFjcSH8DevEkfszBFtZBY4ndi4zHjOIFpH
         L/meJqhM/JLzxKk/45bTGlZZekQaXJeQ79fEDPlivIoeGmQKID4VmnA3gtGWg2kU69+Q
         0qGEccivVQC7QFe+uqTZUXWJty0wGcEpIj/wdf2dLmhZ3eogYXM/7KuXYlDcXN6GaouT
         k22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736475845; x=1737080645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RT99AIOWKsdh3kIu1d1CPLSjddf8N740x5d+oosRGww=;
        b=sk97BDOuqx5OGzfJ9jCF66w2L2oebYQKB0RA+RBYASl4ZDRaS6dlx90tl0Wggq12ma
         7w03SnXmdwaU240k4uTumf5bjhKuf7hTFUgfHsVMoRzCCxmbRaoxm7ZzOH3HDrZGV7rY
         psnadQiWq8D+M/8oHHkcyUqEL6ve1xZP7T3KPJD3hwv0i6SbE4vYJx56b6aOQqadMqRG
         2AUQKl9uC03Ax6aCcHMR9VJcTJSyNtJdpBzbrc9XruXv8PsyhjIkPwbmQyFkCW5bsbhV
         m39AgF9+U62p/fYz5ER7f+B9gUsYZGTrqlsN6QEL9xh45v081R9cyIcKbqvoN1J4VHcw
         S0yg==
X-Forwarded-Encrypted: i=1; AJvYcCXfOBrk9OBb0tAiJnARlrnjKgqK358bnnbMMK9QEcBlvWmC9CNh1PxfkZFiAR3gxfupa6dTABFp@lists.linux.dev
X-Gm-Message-State: AOJu0Yzqvvzw5qC0Z/iRYlSKiPsoXUuF5M79H5kO3LWV0MxQq4L21IyB
	BCY+AYp6gAd8NKWabxo4Ol++jQaBo+bKO0TpxCHaJxTV8yrZhORPzD7w/gpriYLWp7e5esC41Ia
	5Tj8u7099aTpppdbjgUpDp72gd5XSHZgSIBwGs/sFdRKlPgA+kBAY9xbM
X-Gm-Gg: ASbGncvgzJGJorHFa3h2p1FbERmDTDjkdCXIAtbEjFiTASpFWZ6Qr4GwD9rKzvXVExM
	HXFbLWOu+T15g9mb+v+4T3BBEs73uBADbruaXWSMi/cyZlydwgjw6dbZYsqoSZBV8Zg1VIIiAaq
	TUzNP+GzJopwLBnM7rWa+KCF+rzwnj3KIhT9jZfnveY5YudxMIaSc0eyyFLAjo6dgxKyzTqJxTO
	fQimvQc9XCSU16aZc/jrK1JihASbdLmGD/DyIUjo+7O5c3OVyOyMZmO/v6IQEwt+cB4Y3Iya7/7
	xgtSD5fo8P9FZEngxTTG8HsyYrYYqiMEBTv0ILSU
X-Received: by 2002:a17:902:d491:b0:215:54a1:8584 with SMTP id d9443c01a7336-21a83f4c070mr132141975ad.17.1736475845068;
        Thu, 09 Jan 2025 18:24:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7zOCxWxdSOPki70L4ZSLPi+nEkzbIqt3vmIoV52QigSXWXfd5vnC+IeYGVUSlUiO0mwxYaw==
X-Received: by 2002:a17:902:d491:b0:215:54a1:8584 with SMTP id d9443c01a7336-21a83f4c070mr132141685ad.17.1736475844693;
        Thu, 09 Jan 2025 18:24:04 -0800 (PST)
Received: from localhost (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f2199ebsm4453335ad.143.2025.01.09.18.24.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2025 18:24:04 -0800 (PST)
Date: Fri, 10 Jan 2025 11:23:51 +0900
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 5.15 6.1] zram: check comp is non-NULL before
 calling comp_destroy
Message-ID: <Z4CEt5k3DWz4J9SK@atmark-techno.com>
References: <Z3ytcILx4S1v_ueJ@codewreck.org>
 <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
 <2025010929-nutmeg-lustiness-f433@gregkh>
 <2025010916-janitor-matching-0136@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025010916-janitor-matching-0136@gregkh>

Greg Kroah-Hartman wrote on Thu, Jan 09, 2025 at 11:09:38AM +0100:
> On Thu, Jan 09, 2025 at 11:09:02AM +0100, Greg Kroah-Hartman wrote:
> > > Before 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
> > > device") that was indeed not a problem so I confirm this is a
> > > regression, even if it is unlikely.
> > > It doesn't look exploitable by unprivileged users anyway so I don't have
> > > any opinion on whether the patches should be held until upstream picks
> > > this latest fix up as well either.
> > 
> > Looks like Sasha just dropped the offending commit from the 5.10 and
> > 5.15 queues (but forgot to drop some dep-of patches, I'll go fix that
> > up), so I'll also drop the patch from the 6.1.y queue as well to keep
> > things in sync.
> > 
> > If you all want this change to be in 6.1.y (or any other tree), can you
> > provide a working backport, with this patch merged into it?
> 
> Oops, nope, this was already in a 6.1.y release, so I'll go apply this
> patch there now.  Sorry for the noise...

Thank you! I hadn't even noticed the patch had made it to 6.1.122
earlier, good catch.

So to recap:
- 6.1 is now covered;
- for 5.15/5.10, you suggested squashing this prereq directly into the
74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
device") backport ; given the patch got merged to 6.1 as is does it
still make sense?
I can resend both patches together as a set if it's become more
preferable.
(... Perhaps adding a tag like [ v6.1 tree commit xyz123 ] even if I
doubt it's standard)
- (for completeness I checked 5.4, 74363ec674cb doesn't apply so I won't
bother)
- I don't think there's any rush for the latest fix[1], so it'll get
picked up through the Fixes tag when it does and I won't wait for it to
resend whichever version.
[1] https://lore.kernel.org/all/20250107065446.86928-1-ryncsn@gmail.com/

Thanks!
-- 
Dominique

