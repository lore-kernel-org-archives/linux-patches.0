Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CC41CE6F1
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630322; cv=none; b=MzRpGTa3dZ358e3S1nIjINe1VxmM5mWHrZPvwtORvRJuc9Tb9757ubv3uNttSOVPWvt/xszHLgsoLJ8HIEuWX5nObFV5eSA9aMnpCaTj2WGUBUxMTFvHLi7LYUAxRO+RJwwTQt/8f8Lzyx0qJo6kKpk6IaKfOgeQVP1Hwwu1gVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630322; c=relaxed/simple;
	bh=LzRu9zx/RUvzGJLN1xZh1Ep1FK6fI45Qs5Gss1BDzLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U6oDhnEdlj6yMujGW4a4CZS0MKMLXntSvJT32HBaKFWT+q++9m2Xw41n1W1y3RBkCEEXQn0x2ehnQXZ/kz2nMaSN60FZoIbmrOEKZiNmJhn6GjfFbx2Or6xvEJ7jZORsM8NvrMhQ7Q7G5mRzgPBHfkZuKftlezlzJX8/84n66DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NaJY5jbg; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NaJY5jbg"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5c251ba0d1cso2283641a12.3
        for <patches@lists.linux.dev>; Fri, 06 Sep 2024 06:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1725630319; x=1726235119; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t7QnaMeuAhRWgF7/G1QpvRene3BE387G8iUVU/cYI6I=;
        b=NaJY5jbgXA/ZtfZUpIAWIlsqrdDk421fhlkMNwIAzoVpBaH7QJ9MYxWa++J0OuetPb
         RcyGEE0eFLzic9yvW3JDHdj22q1wGniMr2P43EB+0XoKWumwGVioCzSBjIg+xNEgGrmt
         NnpyI8FnIFaogIvMqZWOHajBAZBrWMxE2cVbL7Wg4980X0i5FGRmO66JD8KNI06mXip+
         VyeQNdCTe0uOSxblW8uiau+1WUSXAt/Uv+he1Tjwvrt/NfLhgCl+3qF6L/2s0gSEvYLv
         kmewN6ZjBRIV2e2+p9H9NlevoTS9i6+0aOCLLnGNNZXxgP626Gh3hxwk4nIElTLvpSD9
         dIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630319; x=1726235119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t7QnaMeuAhRWgF7/G1QpvRene3BE387G8iUVU/cYI6I=;
        b=TcDBzbRtSxro9TGRDCjdecWXgPyQj883QKbTNYi4qG1yQocxH3lb/a3RNqew+1PXCY
         DDZ4vGCvgQLbkjn4HEE2vXt0epfXyRm/7EYmca07Tlgd2U3jazyhAD12fg5iT71F8tfS
         95oKjAW8roYrDGEPbMjvCQeW8Yal/Tf4E5MHPLv6e3j4QDJRZalfUWa9tLtAJl4htesn
         7N2GbqTR1EnKsjrqzjlLwEyO5PgTUD8HNinONSUUUOukXwtPy/vhyteoYxFOYwz7J5da
         mF+qEIzjfLZS9yMcGzyZRsy0IDMe7U6I4VKIleN/a1I6y+jR1g5CzOC0XplHkoXzXi3A
         mKow==
X-Gm-Message-State: AOJu0Yy4JmNobIQ1ycBL4oQc2X/hN9GVjL8UVQtkBM+kT5KZAoFtqDt6
	cjTpmIlb0BhX32IhispqTE148ZetXSiHV66HOg0EUqBX9x/8Gmg=
X-Google-Smtp-Source: AGHT+IEv8YGmNOmoxLrIE4zsDNN/4eYRy5OvNPIBzaSoVTJV/vA5tWTyX1TUK/eEESiUddviQvTMwQ==
X-Received: by 2002:a17:906:4796:b0:a8a:7898:1420 with SMTP id a640c23a62f3a-a8a88667910mr200813066b.31.1725630319134;
        Fri, 06 Sep 2024 06:45:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b40f2.dip0.t-ipconnect.de. [91.43.64.242])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a77140b3dsm206649166b.213.2024.09.06.06.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 06:45:18 -0700 (PDT)
Message-ID: <63922fdb-6aa0-483c-ad57-1c310df160b0@googlemail.com>
Date: Fri, 6 Sep 2024 15:45:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/183] 6.10.9-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240905163542.314666063@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240905163542.314666063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.09.2024 um 18:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
