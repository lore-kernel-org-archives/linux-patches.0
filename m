Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA613815EB
	for <patches@lists.linux.dev>; Thu, 26 Feb 2026 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772109440; cv=none; b=lKqEnckaDJXZLfdYt9B3quABL884hgX2myCvURqLQRRXCJIFNIqwbgD8sWYiocfrgvIIzBzA9dqmvqUogVeSSGchdZXqD1nhk0TTonL3sb5oXKaB02J6J5su0ZA5onaU1yfP3E7W2IRYjtyHMq5VPDPWH2OtkaHJwpmsi74frcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772109440; c=relaxed/simple;
	bh=+1Uxs4sCFCr/De/3z06l+Ih/M148pK/yQchnDWWBtxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NEdVHo6G6fTHyaBlul2BsAbYe0SyG773R9XJX5VvVr94Tl/OwFGOrOT/5pBZ9I+NmNn5PMkEt2FXqKPeLfK+iIBf8+au8MW+oMJCsGK2Zc2xGw1SfxHW6HX9aEvrd3CerGrilcvPXc/GdSeAZEtQaLPt0B/T6aTC5anwIsHqQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e2sxpqqz; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e2sxpqqz"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-66307e10d1dso590045eaf.0
        for <patches@lists.linux.dev>; Thu, 26 Feb 2026 04:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772109438; x=1772714238; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZOVykxEneTCF5yLl6mpMyii6tbNiavNGxREq+wigW4Y=;
        b=e2sxpqqzO1IAxpsgN0sGQY2D/chi7SsUKN32NnD9QSmUlFYds22EV8HRpu7rpfNQV0
         RzWQgCPcNNVY/QFgK0Yg6M81XLKxXXlwWGCq0OE3K0t7cH/8irYx6W6mgUPFUxJ0o6fS
         Xz73NX8ia7yIWvBl+OArIZ8TO5yI21xWAVNNQv5jQGcvjKCObl4+PlASJP0lllkhmvSG
         MvxaxJNe6bWPFDqPmxH2p7hoMpj5VuFWP3ygNxti+jDZH4XWOL36QAfavBt8qizkhAdz
         52PN6gOGRPnchHlsPOinLBrAQZqK6mjWwySM1urL3InZG0QqZ8yjR0WKZL/cwUDrDiai
         wnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772109438; x=1772714238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZOVykxEneTCF5yLl6mpMyii6tbNiavNGxREq+wigW4Y=;
        b=mOuAsO96Yhr/x93hxgz+YC5riG/KJByIZ72v5NlheNQXTxxjU+F5x+bdbUvjWuLYQJ
         W3x9+58zndVYpKb4gqL6407FkygyoChUHJs9SPeDPaPXD+/aLP1cs5Grg0FfDBy0ziTY
         E5M148eGyjn8XjNmSznb9OcDtGeRrEsDLg6pqedTlCsayUtODipryT2th0qBh0DWHmmL
         DxFOcrIeTy2WRPjXPpzY9dQcItyZ6RwtXoKZlEt7vNskWEX6w4sAQC9BapuwPuKYKKh4
         s7sWIQigHiajs5RQZSTaaKunEMrXnEEPJw/9viNW+B8gwZiR1KCM56x7SBlbZ4muEn/+
         WN/w==
X-Gm-Message-State: AOJu0YwrOBohf3BnLmtdLLY+JkFRZphUgrRXmUNE9KClVWLZfLHDS/Oc
	sJp5gSxeqQI5ku+flAfAuUcPyeKckjOA5LrNPZyeqwEZiG7FlLfvGe4as5UaYVbvRZ4=
X-Gm-Gg: ATEYQzxTCZWUnIntMFf5ws3uPjkeXKwvNzeea7+A3KuLugp6xUEgKIL+9tRA7M8Sxdk
	nKJ+eIWv6LbSa26vHrambjFpgWquwfHTmLngVwocNRtALzNznlqVTXhOHKhK40CevBjQpLxWN8K
	Xf2PMnSOvAT+XWb+2LBCRQmGUf9C0ABemYAm0PaBD5pL6MoIRbKtBO650uYEaUgtsIg6g2+59FZ
	zQ6jAHw8afNkprcVmuvgwy9XGaJxHfm6Hfrok5iyGjHpvq2wBWWpzJ7zScYzEEBUhmzoIgldgDv
	ypDxKonhujkkIBUnASzX0FEcTLxIwEbfutVZdh4ERz3TSKdTZHp+HkaLNYk+k+ZjIlSpLk58G8+
	7I0zABejxW3V8V56OAlg4TP74S/dw1MaFt3zYce1Y/Do1l85pflhjmezTqXK2f2dl8JQ40nYi+6
	0tQiMO/w/Hy0U/o2cAfU/hnp/+OtvupdjvEvCQpR13UqRpLxdv26VsLBUzmVt5uSnXT7vpQNd5i
	mAuoZ/ecw==
X-Received: by 2002:a05:6820:606:b0:679:953c:746e with SMTP id 006d021491bc7-679c44e34ffmr9357523eaf.41.1772109437836;
        Thu, 26 Feb 2026 04:37:17 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bcbf22sm1424436eaf.2.2026.02.26.04.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 04:37:16 -0800 (PST)
Message-ID: <dc3079cf-15ac-416f-993c-9b81dafebeef@kernel.dk>
Date: Thu, 26 Feb 2026 05:37:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15.y] io_uring/io-wq: check IO_WQ_BIT_EXIT inside work
 run loop
To: Jianqiang kang <jianqkang@sina.cn>, gregkh@linuxfoundation.org,
 stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20260226062711.426301-1-jianqkang@sina.cn>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260226062711.426301-1-jianqkang@sina.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/26 11:27 PM, Jianqiang kang wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit 10dc959398175736e495f71c771f8641e1ca1907 ]

This, and the one for 6.1 is fine to be applied for stable, but if you
add this one for 5.15 then please also add it for 5.10 as well. Those
two codebases are the same in terms of io_uring, and hence any io_uring/
patch applied either should also go to the other.

-- 
Jens Axboe
