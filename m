Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793040079;
	b=DprlVZwGi75mUVdt4FirvU8ZcgKUaOxBixq3uG2rLt6lTE/jF4LVsjqauGm6nKhKQZps
	 vqsLx3V/fV8HUg7pGMw08IpGfNRII+88bw3xdPdh4IrnGA0PQSDjvpWKsO9okgHMbc0BM
	 6W5pCscUyV/McQmK1cdXJ4TNHJkC7xtzFKL6PvGvUhoVUk+kFPV5ojP2iVMb+yrJCAp4H
	 0wQAIqM/P+SWbxfzmBVWNLD4v7TklkNH0Ly9uZ5Jq5BzWn5/dMi3l5jGULhhPdUkQ0DZN
	 7bDpoy34WBvi23Gxd83j2arWfsciDKdHtYj9Q/EbDeBEnivPkZA4NCSFqmAkeV97fig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793040079;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=g1SrbF6MexHYCEG2Z9HqDiWdRSH1K217RRXRSida3VI=;
	b=4ozO8LjX9LWxMe3XdCEQXNwvG7siJJmZRUhNCkbGBwTLNl1iNqpqAZrlK+qrqFckKNAm
	 btgoxcHC+0Hr6+zbhB0bRQ5Lm+KQS/lbqqk1fsm+msk/FEYRikHWTZVHA12du3ADfXNJQ
	 nOPt/uIN1xuHgiWh3S6d6gVo0BBtr3Icb1V/ZvbQbL+kAbnpTBzjJj5GgixQoeSuTfRkt
	 mxSa7XlzbMrJ1eY1P9+wZ2aIkYSCL8uENIgGEDD/Wwh3fv3Z8LmT8qOagv/e17pyvj2iC
	 535fYtMCBZiULRmQtvx/wqL5sWL2yMGdO2CWunlhQ41ltP4SwZ1BOoYb5oLNvzTUd2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=NPHQsTmH;
	arc=none smtp.remote-ip=209.85.167.171
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC9606A32C
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 18:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CEC9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=NPHQsTmH
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-55650fe1f0dso1824587b6e.2
        for <patches@lists.linux.dev>; Mon, 26 Oct 2026 11:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793040076; x=1793644876; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g1SrbF6MexHYCEG2Z9HqDiWdRSH1K217RRXRSida3VI=;
        b=NPHQsTmHZI9QnRBN2TYbRFmqJb1PEBaZ+WGPoln5YSei27YFYy2TMPsDM1cwPidr0E
         TCfg5Y4etbJnl3TCe3q3G9XqcbhtRU16HjCK4v7euuU1LKZYgObtnK3b+KN9r+tVCufq
         NFK9UOAn9VEDyCJD9Zlg5/dDmvBgq5BVUbjL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793040076; x=1793644876;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g1SrbF6MexHYCEG2Z9HqDiWdRSH1K217RRXRSida3VI=;
        b=CPBjKSum3mA34EeyOVdppS1DVA4tj6fK9KbgwWeDeiuuYjsMo64/FLtiv6+2dYjRz9
         g+SZyJi9fFQiHDqeYA9NKO4sawuK6dlRCvQNp3HH3efH/e5B80SEFsOsCW6MS4OZyYES
         7D6bdlw2splxyfMJECG/7BtYmH/49TWPh1L5KDS6Y2OVDam285o30kMXQj2R6f+w8bkK
         WABS0oU6dsYia5/X9J96SxvGbnb1e0fgYT58HqdhYXP1wLFWayU3JOXjBi+PQLbr309A
         rGKYJaqwq+gNdA+fLERsI43WVeSmuWzeqOaOMq2W3+Yb+T2cjbApd+b5BNCBefJBlZvU
         QmiA==
X-Gm-Message-State: AFq9FYJ/7XDESye9kO86dp024RRCBJskgJDE2tIFBIjvr5/EcFlCz01X
	MoAqJUuPe8WfuItIMUTCamWXufr3O4e/eAAfBRkUIGg0aZdZGZf+IKSUIMxNIRuut4c=
X-Gm-Gg: AYBFou1KUwzJbmA2vAjj8gfdMNErYYyedg7DWNJoqYVJB7Iq4o5khvr5ESX/kWvNzCC
	JSSE0YrNNw4t/ZeNdhekPiP4NinE/QC5m/SDsmaZEdJ0/xUldM5Uywji1/8TTQuV7z/yHwP4SxT
	QH2FZi5xNhDPwj0Fp3cHAdRlIsBpMy2Td3pTtGBy5y23QjrX+fkVuichgBQek+VDBGXM35ryquX
	jaIbqkgB71knUWJ8Pm+dO6Uu0ACA6MYtHbpc+vkF5oXQvO2RiU6AM4N4PYedFiWltzi6PdThif4
	Pfiv+4GlpFO8UqxC9KZmy9LdCU7LdQUfyrttiF3nHj77nkplu4gC9DOi27bqnXKtmAKVpB7T2Vl
	0LZRCQ0HUNQeCmjZU6lUtxmFNkgOWzByrS0r4mz8wewskHF+O7BRxt0P4UaEYOMF3v8xTBokz2w
	2moEypUJSntSybznCHE3U0oMkmG+bC6PalnIEG0UpWrp7847rPvtg5N9eKvtNvvfnCAgJuJJ9F/
	cBtNmhiLt1QjH5sEE4DEneZxLV114LlTTMvsEGzeKh9IvNxgn63Mga9LpMNTYcvoQ==
X-Received: by 2002:a05:6808:c40a:b0:4f5:c4b9:dbfa with SMTP id 5614622812f47-55c0030f23amr5326997b6e.48.1793040076466;
        Mon, 26 Oct 2026 11:41:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c04074375sm6051582b6e.1.2026.10.26.11.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 11:41:15 -0700 (PDT)
Message-ID: <855636a8-36f3-412d-b4e6-d780fd1ff85c@linuxfoundation.org>
Date: Mon, 26 Oct 2026 12:41:08 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 10:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 25 Oct 2026 16:36:50 +0000.
> Anything received after that time might be too late.

Might be late but here it is.
  
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
