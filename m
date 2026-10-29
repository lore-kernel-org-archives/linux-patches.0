Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793250053;
	b=Q33li4nGurlhe3FXQ3pYXWqqXLf/VPWGYho/WxehgIFU80jNo8dXmDNZyUhNEBtMGTsN
	 bvV3DdkHxYKPqRTh/fGBMhBKpBHorIFiXGBh3P/ZPg5Qg+TvvOCJkUYCaPN+RdROxM2Jy
	 cidoZvwXjdj/GZYkuR0Hf7583mNECEkZ1QUhzXXpzgc+VQhCqjjTIhcY1WqJaJpulMbwR
	 xo5tgtlb22nyo2aRqRiG0EZwSFSkVWY4W5BRZ9R1S2WIKOuwO0FqtwAp+1EJBeJt2xXeF
	 NphdOxAYdpuCKMx6svSg7DxAO/Bl0zMeRMPFQtlVTlrwtM6O3B/ok/2LAowB2uCDZyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0FmQ940rulC16JggvuZSFuarwnsVy2/MOkII+LL+oxs=;
	b=ytDvOxPnqUBAZ8eo/hzYCVk73HmiARkTd/JQNsOowYdEwQtEQB/ITNwS6a0JDfaw+cTt
	 3vDoDVZgl2ODeX60TXBDJCdjGFbeHGJJ7v+9UvrQJ1ikiXZ6hLqI/rA1AlL52O55S3nb6
	 6hgg4z5R2IPxm8kcXOJU8YfwPXMBOcXFAXhWeWa63W5pYhIEdSVcu1FCa13EcRAY4Xa8H
	 mxWo2ddWrABgtuPFjFvKoZKxLvQx9e6N5chU9U+rTH2LNMsAnMVDf3v5SoTXdCqiOvO49
	 B6OW8bGmoA+V0sPBpqqTfOhf8D9s+yHmEXt2+HosidDUQgMr7UOuAj0rjZgyXf5bXBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=Y5yEgaIp;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D83E606A327
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 05:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D83E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=Y5yEgaIp
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a208d93758so17447745e9.3
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 22:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793250051; x=1793854851; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0FmQ940rulC16JggvuZSFuarwnsVy2/MOkII+LL+oxs=;
        b=Y5yEgaIpi00pmIS9PzM3ZyPtDJRdB0P3tsYtx8p0CkfcD0lihYTQXgrh4l5Rn8JyXc
         ajQKy9cvq9F3exRkukwjeOe+Kx5NTNxIyNGse4RmqRRwvIccYPrq0vjMNH96jBC+yPXJ
         U/Rv4v/zSiw00F7BLpY8jCBf+F7WnOdnP9PN4xiQ/g8lCTxRDe6QmvLkNy2wdsV/yGFX
         ZMkRbTFl4SLkoFOo4lgnn7w2vABEvZZD6o3YEGZ5Eah1On6CIspUSvCSAjOPbS7iS/in
         2DG0ex6Xx/sbizZFN/N17CkG0vIf5+HcDhtvPd4xfD7BzTD7ubBIIws3zuDLW8LpzHck
         QUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793250051; x=1793854851;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0FmQ940rulC16JggvuZSFuarwnsVy2/MOkII+LL+oxs=;
        b=KWJR5iyYD3phkaktPbE3vij0wDi9jdjemPlV4RHk8/rRU77XYYCBm+Gvr7vuQfFC/n
         b3NrMlKtnGCL0nE4qOnVB61igseoEw0bXOCTCT5VTpMmxaiqsKkpzqRI0XHCIHibWV3h
         d+oNuW66/RG+kTi81B81iizqVijuwZATnLrtj52I3u501/fDxUViLwEU20jf8Nmxg4Qw
         +7YgFb5ftOGP7umt2/XRIqw+luYZBpOwxxjbTfBnSsIWdyVRHVLWaB094VTCWqxNw7nV
         SlTIPTe9RBLSujffLkyCv+OyGkzewVsssImFNeHgf9Xn5SaSB3YMa13KSFFSjcqJCAyJ
         e3Ow==
X-Gm-Message-State: AFq9FYKQr5C7wcD+hw6W9/NnsdpEHC9iwh/rOOokKtKtN9sDoyOpGTmG
	Kf7s3S34W1ZKxhHLtb3Yb1pl8Soem1qTy9Jb6gFvUJGLMqNKb2v90aE=
X-Gm-Gg: AYBFou0nxF+gnVn0D0u8m1dach9BRqMmtyd5TgVSSzuuwMmzhNC7pmzzrPClqZ9FfM/
	lKLMoqRGi/rmmE48b6m3hlCnBtutnagTtxKBj/+m19NK8sn2hlqEzghZzBfdmjp6NLO3P6sdi/r
	iUEeNRjow1qzR+/1vuI4Wtjs6z4iPDNIgSvNQznc/vcTmswYE27mKmriQMdQVLGiU8fxC+NrD2x
	jBfJUZF4VQebeWXxhxkcQYt2E1BtovfDvhIRi8SazXX+AUCuaWWcKYvBWR79gjTjLAHQzfC+WeS
	RrhwYAuMvE+5ln13Vdu23FaACCBh6rkhpBem5VCCKNIuSIf1LC/aFGhHlzZ+fwbT31G5AtRNkWn
	/jTKeff/3esCcF8In+bkIyTIaYnF2o2pnrCc7hl1ff7sl7moI7NYV4FwAmpOF8x1DPaXsCR/2RD
	IdV13aPkX3o2dFmt08a6uY65ogQ5xRQkHk5OZqGksnguUqzpw9IPk8N0OPvNYv6mJ3nYpR7XYl/
	3SpT6laqKh0PVWKQ9A//JwU+QnHk9l/FWF/u+WO7dTBG5w8+3M1H3IjG6wCAhstCMrZsfOcdEdY
	OrSeZBaqYADiub7eGvaaUqE5NWE0m4fIozegG0/trLthLBSzDb+6JQ0YpCZfna+tsU0wZpGIIe0
	5SeyB+WvPtq9XAdu4k8jZl3WIPlQ=
X-Received: by 2002:a05:600c:6209:b0:4aa:15b1:d4fa with SMTP id 5b1f17b1804b1-4aa15b1d512mr72370735e9.5.1793250051594;
        Wed, 28 Oct 2026 22:00:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3f1.dip0.t-ipconnect.de. [91.42.195.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3932sm33329612f8f.18.2026.10.28.22.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 22:00:51 -0700 (PDT)
Message-ID: <786d7ae7-b713-49da-9e28-0f276da7e6b5@googlemail.com>
Date: Thu, 29 Oct 2026 06:00:50 +0100
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
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165940.394092994@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
