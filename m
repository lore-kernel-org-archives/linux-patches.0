Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3B31BE872
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945380; cv=none; b=M1XK5i190jSSeqjSVyK6BBKy51XGP3fW8b2HMehQt65oC/d7O7qzZ/9vgwd5ZMmtzvXgFoNmzU7mbPpZAuSi2MxQdRq2WA8SOiUh2L30yMrKzXNGu9jCSytbIUZWWEVNXbPpvUPhxtxhwjyANCJdYtnvSRHJc23O8t/7Fsjaajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945380; c=relaxed/simple;
	bh=SqcTNNDd9nRTolrKc+mWijvYG8+PTjzzc6fe1Z9Xxpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HLKocdOasFdqmolsXw4rQPPATgeOZdrf21pugk9fmX8+LH3DNnf8Rk1P5jMribuMRsm/GfbF+AVIhRti/DCM2g/IGvjT1xkDN6IZnxHBH1mySGdgxQc++FpaTFN/S60+r+UpCGa3sMYJnuOnYneWxsRyZR/mjhugJ+5OWIEaQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrqNEEBq; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrqNEEBq"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-706a1711ee5so2739937b3a.0
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 11:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719945379; x=1720550179; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jp1wG1J0v7C+G8VHJE3Gda9lKbvY8xYDX/vh4sVeNrc=;
        b=LrqNEEBqJgYr0H47lRjgOtDF0jDyli2eWx4/o87VXNAyXP6zK/oBH/AIhMozsGqJTK
         vmys+ERdMv3nVE1RjVr7vrBNC4q3L+bBQRUzsqP5AjbUEwYc3/ShKDvjn91/EENuKbSh
         bPr5PdC1n47Rv76hCRwtYjjd3CFbi0gJ8SKHC1KNeeSjVGfR1BDyVuKwV1W6V21J+N5J
         Z3JuS6woabK9Vcm4ZG08sHlkHGNnAMOBqravDHRa4f2/745B7k1eDTbSYp8jeUMSy9hE
         IRSF1niD6rQkK3AG5tkDhIsJ1fZXC50Mj+a8jFd1OXb9iZrynuy9qB1jrVHjKh2xjWr2
         PcIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719945379; x=1720550179;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jp1wG1J0v7C+G8VHJE3Gda9lKbvY8xYDX/vh4sVeNrc=;
        b=WpDIzzxPiPLQjoniPRAW9ibUHO7WcGBJ2ZpMBd5oztqCdSniAqTK7mO/04G8DURg7A
         AvubB0YtRc8HWug76gRhd5RQt+jeMoJmWWOdU8XK+TL3XYN16vLNNicZKyUn1hQNrR4c
         js+yVtXunCfAx5ytlsL2jUkxbqoBbvb1qbBEj6ihZqWc7SI9YbipcoD8I9cq6ULBvK3u
         HAGinyz+464kp9muF787LKG7WzLdOLl4aR92v9mlswWz2L2zqbtEAfwdiq3uZ+eMg0+S
         p/AC8GxupfI4a1ktrzerWxf8LHK8csSMx8bmzGOe6+xm0IxP3bUo0mQJOWdkM+vdHwVo
         xZEA==
X-Gm-Message-State: AOJu0YwTAWEvW9fTDQae+dZvsT4X4VRy9MQaoJg8Y19eMA4xAxGbY1zH
	AlJm0sIYR0dkqN5axybr487+msPM0Yp3nP0qzMEsVOa0Spd8GBBj
X-Google-Smtp-Source: AGHT+IFcsLam/MSeG0HUGJeRLfaeAlDZB4KQmP+fPaINRxq8KBKS4Xz/en3aYlsjh5UmV0OJImHHxA==
X-Received: by 2002:a05:6a20:258f:b0:1be:ca6c:d93 with SMTP id adf61e73a8af0-1bf041bd923mr6925335637.52.1719945378544;
        Tue, 02 Jul 2024 11:36:18 -0700 (PDT)
Received: from [192.168.50.95] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91d3be561sm9175494a91.43.2024.07.02.11.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 11:36:18 -0700 (PDT)
Message-ID: <4bc8b342-1390-4247-86e1-9a6d55f8ff93@gmail.com>
Date: Wed, 3 Jul 2024 03:36:13 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 035/128] tracing/net_sched: NULL pointer dereference
 in perf_trace_qdisc_reset()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, netdev@vger.kernel.org,
 Yeoreum Yun <yeoreum.yun@arm.com>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>
References: <20240702170226.231899085@linuxfoundation.org>
 <20240702170227.560603901@linuxfoundation.org>
Content-Language: en-US
From: Yunseong Kim <yskelg@gmail.com>
In-Reply-To: <20240702170227.560603901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Greg,

On 7/3/24 2:03 오전, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yunseong Kim <yskelg@gmail.com>
> 
> [ Upstream commit bab4923132feb3e439ae45962979c5d9d5c7c1f1 ]
> 
> Fixes: 51270d573a8d ("tracing/net_sched: Fix tracepoints that save qdisc_dev() as a string")
> Link: https://lore.kernel.org/lkml/20240229143432.273b4871@gandalf.local.home/t/
> Cc: netdev@vger.kernel.org
> Tested-by: Yunseong Kim <yskelg@gmail.com>
> Signed-off-by: Yunseong Kim <yskelg@gmail.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Link: https://lore.kernel.org/r/20240624173320.24945-4-yskelg@gmail.com
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/trace/events/qdisc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index 1f4258308b967..69453b8de29e6 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -81,7 +81,7 @@ TRACE_EVENT(qdisc_reset,
>  	TP_ARGS(q),
>  
>  	TP_STRUCT__entry(
> -		__string(	dev,		qdisc_dev(q)->name	)
> +		__string(	dev,		qdisc_dev(q) ? qdisc_dev(q)->name : "(null)"	)
>  		__string(	kind,		q->ops->id		)
>  		__field(	u32,		parent			)
>  		__field(	u32,		handle			)


Since that code changed in 6.10 and the stable is in an intermediate
state, I had to fix some other things as well.

So, I submit another patch. Please check out.
Link:
https://lore.kernel.org/stable/20240702180146.5126-2-yskelg@gmail.com/T/#u


Warm regards,

Yunseong Kim
