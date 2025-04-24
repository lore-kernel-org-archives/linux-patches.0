Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A825428BA98
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745512210; cv=none; b=fysiUo4FXQsQneXisKR7LLnkBTLoEY7b3XwADL7fBKfaUTlERDgI/90lNstEWplQ2ujpc0FYjjFk8FFUow17gK5JhRNVJsXeMmf7px9koE6SuEOUNV3oMlKhExebtxnS/HrSJgT3yFIN3AGo4SwhweHk7i3gnfc22d9Tt6ILOBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745512210; c=relaxed/simple;
	bh=1WAOjR7sl/MSpDZ3qT3vAy9GwH/ON/SJk1Bx7Fy/GLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ooaBMebqXW/OcY/1xoUVXjOaEbjzyVch6K7M6lEkc9F5QABo/15vULI4oBwJU59SjFYKi7VFxqW9DlRzcRLNQtN96VLB1PZHfJp98cF+dn3T/irAWeNolaGBlmTgZDVaYNI3J/P9xSHDpImf500SZ8cggjTmQ5fYuiodhxgtqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jvTZRf0H; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jvTZRf0H"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb12so1813257a12.1
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 09:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745512206; x=1746117006; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jH7CEZXVUMDd3gCXVEyO4RBZjepJpKTpn2k/QUd2tFI=;
        b=jvTZRf0H1zaG/6qND41fermSX+RaOtpMHvES1Vs2r3YtCpabiNE1TYDtS64+e+b9V1
         xjqHcGKLINaa/K4NLkf0RD5VmFeaANsJHY+WExGtNlGpujsx0ZPVrcdOruN1FPkw2Kny
         HchukeUcvgI0eBFWLFMc0R10FZMDue13qKdqY3oMFkZ4/uRqmqv8fzOD+LnpFFCV457+
         GZyXLNZ/xfUvAb4OGxAbi/RorRvtASFsXbXFejHufYunwz15uBM8LPZw47v3hHx+WK/M
         mPc1pQzNm3TxrPO4N56Bd4l7e0KvkP8cciHbkeWgy6a8WbUWc0SMq6G+fGha6HTTuNTQ
         i9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745512206; x=1746117006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jH7CEZXVUMDd3gCXVEyO4RBZjepJpKTpn2k/QUd2tFI=;
        b=vCbLyTV6nwHbZnaLwwCICr5g6oO7aRc0HZp8vJ6/2Z18A4BTqS+i7sSg2h3BQhqi/D
         b/KSd8LrJRY11iSlsaiB+Mft4vUGPN0EnV/utQkHXnulGdXfqhI9zu/t7b6tGqajKWfG
         Ml3WcbO3Yy+rHKLyHXZB6xkPqOJSC3oAKlJdnALbSTiSMX/U7t/+smuMriPB1mirOpSy
         j7Xe7BpJjHB2oLyqkUkj6jnMJd27unXBYHs5+ocQ5GVS8ZvhqyKYb/v9Hmc6A6M8G7RY
         pozJ41h4vDKtMEKWTEOEijf+236Vt++AJp5MDODbTa7ymAo+wU54P4rev9bzq+AQojoq
         A15w==
X-Forwarded-Encrypted: i=1; AJvYcCVCY6vNWq8bCyznGWwY9vR15hiwjMvqgK0Tc8SXX636zMIMX824aEVuyP+HGzWC/r/ls+DhHFCk@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc2LAVHrb5qGG0Wite5nsXE/ooi6bi3dWOK6RCIHW6ziW5xBGC
	ZKv+chwVUNNhaz5p6KpuQo0rTRL3OSCaOb2tHmq9f+x3nh6eWOb+NEjRWYrQ/IPMYZkHKfnGxsJ
	3
X-Gm-Gg: ASbGncuEVDSwrXZxMbq76eBr69O0xECRgriD+fnPyBSWJp6HUUmftfOf1n7uet/FRbf
	1qgLE0A16hXuHCiE2AuuaxNkdFYoZjJNTlyX4BWM+MvdTeFViOjPhjMDrHD+1QP+2fKByUO/hdF
	f+E26KKJAXmcCqj0+SyNx7uPi1LPU3Prj15jTbaQwe9vLIA0jQX4bIPa/xpNBr6dRA78/66G/L1
	94KlgLpUGMMXkQWXzuLwMbACe2cszc+NtHkOboP0+RdygavxeeQPiR+0aXfMP4erDe/N7ne3wLG
	N9ms/Wqcwz020LysImIgZNn2LFyRzbnXBzj/VenEMLKC8KaJ4g==
X-Google-Smtp-Source: AGHT+IFONF/lCYBw6vekNr7fjobWwHIWN+irjsqyTEIDQ01dOF1plQA90/ozblEmrDjY+pDgvtDc6Q==
X-Received: by 2002:a17:907:2dab:b0:acb:85f2:f032 with SMTP id a640c23a62f3a-ace6b39eb97mr24992766b.13.1745512205811;
        Thu, 24 Apr 2025 09:30:05 -0700 (PDT)
Received: from linaro.org ([2a02:2454:ff21:ef30:d677:e5de:3a6:836])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59830efdsm130857066b.32.2025.04.24.09.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 09:30:05 -0700 (PDT)
Date: Thu, 24 Apr 2025 18:30:01 +0200
From: Stephan Gerhold <stephan.gerhold@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 6.14 130/241] cpufreq: Avoid using inconsistent
 policy->min and policy->max
Message-ID: <aApnCaypsl1VWIfo@linaro.org>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142625.881627603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423142625.881627603@linuxfoundation.org>

Hi Greg,

On Wed, Apr 23, 2025 at 04:43:14PM +0200, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> commit 7491cdf46b5cbdf123fc84fbe0a07e9e3d7b7620 upstream.
> 
> Since cpufreq_driver_resolve_freq() can run in parallel with
> cpufreq_set_policy() and there is no synchronization between them,
> the former may access policy->min and policy->max while the latter
> is updating them and it may see intermediate values of them due
> to the way the update is carried out.  Also the compiler is free
> to apply any optimizations it wants both to the stores in
> cpufreq_set_policy() and to the loads in cpufreq_driver_resolve_freq()
> which may result in additional inconsistencies.
> 
> To address this, use WRITE_ONCE() when updating policy->min and
> policy->max in cpufreq_set_policy() and use READ_ONCE() for reading
> them in cpufreq_driver_resolve_freq().  Moreover, rearrange the update
> in cpufreq_set_policy() to avoid storing intermediate values in
> policy->min and policy->max with the help of the observation that
> their new values are expected to be properly ordered upfront.
> 
> Also modify cpufreq_driver_resolve_freq() to take the possible reverse
> ordering of policy->min and policy->max, which may happen depending on
> the ordering of operations when this function and cpufreq_set_policy()
> run concurrently, into account by always honoring the max when it
> turns out to be less than the min (in case it comes from thermal
> throttling or similar).
> 
> Fixes: 151717690694 ("cpufreq: Make policy min/max hard requirements")
> Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Christian Loehle <christian.loehle@arm.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Link: https://patch.msgid.link/5907080.DvuYhMxLoT@rjwysocki.net
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Please drop this patch from all stable queues for now. It is causing the
CPU frequency to be stuck at minimum after temperature throttling.
I reported this with more detail as reply to the original patch [1].

Thanks,
Stephan

[1]: https://lore.kernel.org/linux-pm/aAplED3IA_J0eZN0@linaro.org/
