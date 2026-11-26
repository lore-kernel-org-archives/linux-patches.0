Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710970;
	b=WvdfzUFg59+J5jKuUPPfaqkArgfNlu41Dp0OMZ8P4N4saU15rGmoIV1lSeccXMhPL856
	 boqkM4NBX/0qvFCLT0oNhW7HbQGuCWLioLOlhaYhV/iS3+WXWoNVXI+VlM9KxTGt635XN
	 6TRCdXeX9DimJAb+d3D0+7H+sQFV4+hCwr+oZUSgYC/Irjx2VvmQzyfh5xlsr1kl1aUKl
	 2I8ab8vG/EF8EJKP7BSPsNxU3ty3uBS6kgyP5LDNTCRDX9sLGCDtZezfKGPOaN+TFZ2Ij
	 w8nRqgJu0JMm74q3t5MXfvI3YMepmk70jx4NZBSTDV+p10a7fcjqJYPmHhdCNkkd7eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710970;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/V/q6vN01qyM55wT6FtlhrNcKv+AqGvLCJ3sSHicCRM=;
	b=JJhQMwvLS3lbQLNs8tzYlkzFJFWTP5FU15VL8PwYdLnUHI9/tbJg1OWofFotcxgdaH8D
	 6vKNY8ztm9oyLkINv/9a5pwC5ENIgI9yCs3EVVzkoTL1Xce2lCSAT2DSMVv2YXmzSb+7+
	 msMMAFELsoyOu9pdfc9WZet1UvGlTOaPCuoCZkP6hdRcK7qeDrW0eiJVVU8nUIJLCGBgn
	 jhI9je85SPV22t5ExSZKpw7+rMm6Ajrgke0BZvscS14zSbn/Yk1L+MBh8V0zsTt9dIpIF
	 GvxG9dmdn6EEutup4IRouGOeXA4gCIEI1+cg3vl5+jNDKSQh7AXkjH8xVGd18Bfqcwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=mx8n0jWt;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D976606A33A
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 16:36:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D976606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=mx8n0jWt
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so46930255e9.0
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 08:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795710969; x=1796315769; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/V/q6vN01qyM55wT6FtlhrNcKv+AqGvLCJ3sSHicCRM=;
        b=mx8n0jWtX67MJZGYnshMsbZ93aMEtBPDnuUO1/Q6Wqf7C7xF35/tqxkn4U5KFLtcvT
         KCnzrTjplb0Xo52vjHdnVTR9ofN9HBAsr3VNL/etjK1KB5l6eYTehVLC77EeTaJAzbnj
         lbG3M/Ru1KLoLvhBvyS+fTlReHHSwkKhgnDoSw1Uao5+Of5sj+eIUlOWvB6EZoMfvyOA
         7zSlkKkWor2KjaXQ/3x7TY5bUt4FGxdLNGMXsEw9TbR2nehcOC24tArQ6cT1QpeOWGs2
         d79oz55OaPZ2Nv2PRw/D/YC2u3mqZsvMBS/EcgvjRPJVFDyRyn3LmMl4fIvps77VWvgN
         GY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710969; x=1796315769;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/V/q6vN01qyM55wT6FtlhrNcKv+AqGvLCJ3sSHicCRM=;
        b=BCoKjQ3hVxRwITUCNVH6b+NDk/Jt0oCJjciHOgmhVSj/b0lduHmNMT03W8W55XuAuq
         g2DJQlNjsWGThav+1vHlQR6x+jArClfVcHsAp2MXlUIpHjA0qJc8keLHpCfMADSWstxJ
         3/NDqXL4IPsJUJlC0RC5SNhYd/gzg5g/9lIyvXZVKxTUajZBfoGkmSMrBWXIk0pxFmfD
         muUx8RvqDR5N0D124i9zFFeXdL9QGsKdvENiA9+OFrBZBRZsGN3R2uyb3rXgrF0J3BjA
         wP6l81LUEPIGbmLDyAECNHuOXw8q+DC0BM9ko7g5xxV/cfRCNeikWizwPrrHbyE9UCSq
         J9bw==
X-Gm-Message-State: APuU4Z9KBBk8QedvmJmUL+J84vtCNrRmIAZsQoY+SSwrn5zNA9b+i91i
	tqNXC6tVx2ZL/ySWmQeAybElP/Tk3osCKfeVeZLxNcFQfZ4AFT2Ew4c=
X-Gm-Gg: AZFdTZdph2nvIqkVI8RVVramN0hUZh91MlO5mMjWy+mVEXVOMEhN0rscjBzz3xhSxsv
	urc66oYBxohjB3XHd1FnUkQ6LCNTQLFTWTZ5o3/J61DqXiL/AVOrNHtzRPF0IAvmVq0D+wej7Hk
	vtoHnvBM6PY2L0noVBv8+8njmYDEyDe7BhHxWdctO6TNn9M72Eo41aJPMt6okWAepiDvbDtWdKz
	d1P8vg1HqFRqP4MOWR4trGiNxaAerIINhbExFK2k+iuu367m+zgT3VKs7oQ23MCR8YK+6YCcuvk
	xOmmJHj3z429T+IUhM4Rh1lYTNy7NxtemA6rqErywNaATF54LJPnWuUWqGUq0P1HGs4OzI71jcx
	+rhcxE2Zl8NJ1NPHHBGfU6OJvRGdjlZUO7t/hkRTaeWdYjd4DbaUYnkoGUtEv6IZXI5EqVh9sEn
	Sdh/d45xqgdR/jfD1Fs9DVQ5Zt13vQNA7PI1iEnTAPfLMmdw7V8AR/LcU+M6288DcrYWFd2jIrc
	/vHaXUPlSd2/5KSiB7zmq9kdt/zSQGIp52xzjPlugTTSpOAkSgr2UV2QT7NjIsW15BnaAv5a2N3
	vDjbTWA2iD32WjpL0K4y/3l7Y6F/ycRym09QxyvBsirCCTT2osDDbg6CCBPNiu4cbUGk9/FAsBI
	yjlGg
X-Received: by 2002:a05:600c:64c7:b0:4bb:68b9:f610 with SMTP id 5b1f17b1804b1-4bb887ffee2mr416755365e9.9.1795710968740;
        Thu, 26 Nov 2026 08:36:08 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac210.dip0.t-ipconnect.de. [91.42.194.16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884c3063sm606032885e9.15.2026.11.26.08.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 08:36:08 -0800 (PST)
Message-ID: <2b097c77-6ffb-4463-b154-661f3731c412@googlemail.com>
Date: Thu, 26 Nov 2026 17:36:07 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261126105709.009001842@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.11.2026 um 11:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or 
regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
