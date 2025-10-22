Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC2A1DA60F
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112378; cv=none; b=Dasx+LrX78smxYy2jWD/kEJi1a0JHyHjQfOLmjueo8FijgroGfuGzHRM8jO9qHbWWyiqibLDqxVmRVPixNLeSMY1pwN7nq9d0RNX1+pZ0MLLPMM3RFeDtLxKgvu/z+sdVpllhgDAYP/zakwTEZ3ojbuMSVHnDF5a+TMmMeG1dx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112378; c=relaxed/simple;
	bh=H0UxILmUFmJTxC9VGfLHOqB2YBpAU/rL8cCN4AvkYDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UoTfYXj2DHvi2Q2mTCAfOi4IwlDokWkK+yRan+DxANyba70cCvOuBaYDd5zQ4BT/ovQ91BsmXBhUBQB6lvMsjT4HK0tloMoW31aVzToHE5Xrpvj/rWtGlT7IzGR3BqVeV20OSdPyV38zljVSzubUdItFfS4EuN4AZWcq63S6svk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cSz5Rt4k; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cSz5Rt4k"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-426ed6f4db5so294711f8f.0
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 22:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761112375; x=1761717175; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1qTaxXHc0odr/JWFQILy/0jeEMddwplEQInrG8Kvvg8=;
        b=cSz5Rt4kqJALRHSOVu1Fau4srcj+xNyDp7fyDu7LKFxTma5vjOGlnF+Jcr4DXLQ2eQ
         uXUwp/2/RDV+aSFsOvyugHETwl0nj5tbAFj5gwr2BzQn0PQjYJpJS/lPmx6rqWXGdxge
         aXleFJOuicutB7YKLK016bt5hobFbQGlz5izuy6tPa7EHZLC6gyP8J6XfhV5cPLzC4LA
         rKIwnzAHPEyCoUo0HX96uUJ386Q0eZpj9+Kv+PlOmD/zXsgH7JYtqp6TXB59TeDCIZTe
         lG4gOpKQdwkr5KWn5SxQLmgmaqHjjfEQho5YEzhAlp2VnIgdXtoKcfJYq4++lOInsWXo
         QwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761112375; x=1761717175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1qTaxXHc0odr/JWFQILy/0jeEMddwplEQInrG8Kvvg8=;
        b=NQSsY+Bg9zwy+b0ZNWyPUwuS6LWcwUfy+qLiHWOC422KeACx2FwtCb0ueyQPr+TPF1
         0eww1UD1S2flstJmuXl2K/HRxJqXUUsk3pvogWxTa6/Wn4W/L9xE1p10c3BCEqbkFr5a
         b3cdNuqKLiDmRK41gmPdEME4zV/XHt0ZUu/ZDS2heuvlNJd5+EEpMhhljNSBr2NWv7tU
         fjvW1qKJUdcq0MIRwx3lGjhpgP6b7LHmdiqzUDKTK+jRLaAV5XZjIaw93V9EgqMNqJ3x
         wpfECGzlS9NvsjC548OgkUbxXQ4R4gyUnBBgCYQnxhBvq7vMCT/JUQ5HKATjMAZBi1hN
         CnAw==
X-Forwarded-Encrypted: i=1; AJvYcCX0dQKYu3iew0cDuVFnXZKHVWuwmnVrIQnyqCg5EjKIlDvBRrNDT9QauwnIavqkv12YAvgiVpdQ@lists.linux.dev
X-Gm-Message-State: AOJu0YyST9EcLisckgtGYo9uUmwuZDKWzhPf5DnWSutOvGrCBlOoI1FU
	9raZ3brtTs1vsaWZdhfudi8rckvZmogjvU+MED3netsHzFvMFxTEhokTyIkf
X-Gm-Gg: ASbGncvpENouSYC9xid4/tFbz6uqoG+yJa57fCZ00U3mshHcVXqd4rs/MziXvNAznMn
	iAd85BpjeQujdsxDc5dx+L0hiOcte5VecPEy8b5Ibs7Za5wINfAxP4AoSaXXHSwzODlDF3VYD5Z
	xBhOikDdKDerSO+1k9laehcw4PIVdTuZnho4mnh9p6qsHyAGD8rLfTzRTwGRO2vNgCwT/fWAd8+
	pkJ5qJyItsU+KupmRynZ1A7dpvVqip/1+QU4iRRMumnu/SuI4QbovjfVXQTnMZdOiBYR9gdIVbp
	r0b65O6scvROJv6+AGXz30LA2QfBO3xf1hNeEj4qPaxg9HMulo8dD6iC61OvhLi6Rol3hvv9FFN
	vAR1gqhYiCNN9VabXBzk7qC2IlWfehhvOH2lPWpifA/lfDSRcPpRTbL/6yLeGjpbvCdz1M4JnFd
	3E2yaMLn1/SopMW8DBrc3Cbb2Unux9QpVaBrUT9ROAQYymxW3EfapFzeTv+E5eJg==
X-Google-Smtp-Source: AGHT+IGaXuonT12yrC1omcvmYN8cKYZBhHbfpNOj1J7o5Hhyd3k15v1KQ0NH5QOy4oOd+nt52eeBHg==
X-Received: by 2002:a5d:5847:0:b0:3e7:428f:d33 with SMTP id ffacd0b85a97d-42853264c37mr1533870f8f.16.1761112374479;
        Tue, 21 Oct 2025 22:52:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b057850.dip0.t-ipconnect.de. [91.5.120.80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3f5esm23079194f8f.20.2025.10.21.22.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 22:52:54 -0700 (PDT)
Message-ID: <af5633f4-f339-49a5-9047-2b0682e50584@googlemail.com>
Date: Wed, 22 Oct 2025 07:52:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 040/159] drm/ast: Blank with VGACR17 sync enable,
 always clear VGACRB6 sync off
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Thomas Zimmermann <tzimmermann@suse.de>, Nick Bowler <nbowler@draconx.ca>,
 Douglas Anderson <dianders@chromium.org>, Dave Airlie <airlied@redhat.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org
References: <20251021195043.182511864@linuxfoundation.org>
 <20251021195044.163217433@linuxfoundation.org>
 <499eb508-5f24-4ef4-a2a3-f3d76d89db66@leemhuis.info>
 <2025102235-pediatric-sandlot-f2de@gregkh>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <2025102235-pediatric-sandlot-f2de@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,


Am 22.10.2025 um 07:28 schrieb Greg Kroah-Hartman:
> On Wed, Oct 22, 2025 at 06:49:21AM +0200, Thorsten Leemhuis wrote:
>> On 10/21/25 21:50, Greg Kroah-Hartman wrote:
>>> 6.17-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Thomas Zimmermann <tzimmermann@suse.de>
>>>
>>> commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.
>>>
>>> Blank the display by disabling sync pulses with VGACR17<7>. Unblank
>>> by reenabling them. This VGA setting should be supported by all Aspeed
>>> hardware.
>>
>> TWIMC, a regression report about 6.18-rc2 that was bisected to this
>> commit just came in:
>>
>> https://lore.kernel.org/all/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
>>
>> To quote:
>>
>> """
>> I have encountered a serious (for me) regression with 6.18-rc2 on my
>> 2-socket Ivy Bridge Xeon E5-2697 v2 server. After
>> booting, my console screen goes blank and stays blank. 6.18-rc1 was
>> still fine.
>>
>> [...]
>>
>> When I revert this from 6.18-rc2, the issue goes away and my console
>> screen works again.
>> """
> 
> Thanks, I'll go drop this patch from the stable queues for now.
> 
> greg k-h


So Thorsten (thanks!) was 20 minutes quicker ;-) But I just tested this with 6.12.55-rc1 and 6.17.5-rc1, too, and can 
confirm that this offending patch breaks VGA on my machine, and that reverting just this patch against either RC makes 
the issue go away.

I'll retest -rc2 too when it's out.

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
