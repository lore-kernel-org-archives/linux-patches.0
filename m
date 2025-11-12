Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B328F33970D
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762959626; cv=none; b=YBDhmpXNnsvdZrtqy9A/YbBjWmoprwrx1RyMEvLj8NQLMdFzCQpYMfSMoLqgS2PhTbQq0Iuz8xumhRHQyky0ThLeshq42J9eKGkH+ZpXx2lS6BO9w8R1OvAM2lHJctwol1XvqN3gUVSNRZ5kSoxfifd4frOOjhiBSRaPzQmHiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762959626; c=relaxed/simple;
	bh=PJk3WBrYdf7Tyo77E02znNUc50rN6CzDR9RBvtG6MM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZ+/sbyMzFsAqVKnSqnnaRe3cZv1EwXjwxfwq9LIJ4m7VXJyQ9v7Z8VuHONvIWg06dhKvUdZUL56s1J3+5RSHldNg+aR+34A7pl/CJOHUQRYdB/6dnf6DWyyV/rjp18dWULYogZv9LkgQGiDLeu99CvA3uKGrgcn9arVzQAf2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=l2qmIgdk; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="l2qmIgdk"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b29ff9d18cso68929685a.3
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 07:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1762959622; x=1763564422; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zXj8Vw0xd/qX3+ihzUkZ+DSqDm45u5a8I3Mp92b6iE=;
        b=l2qmIgdkp79M7Rt2xvmCPzvudkfe6WhYwXR8rlwRcQVQUyZdKzj9pd4nQrOXyUbRww
         4SHQsaEA/2seUMgSTrAIbrtpzOnzgqAre6IOGeoovsgaK1TPz5dB+2gCLySKLZQWhYI2
         n8Uo/wGaUXXK0URzkiY7v1/tMr+NVq6mVnY5xPk762hqndeCqWGvT85YxzdqTTnh7l8P
         poMydyoH3oHAWMObjPt6AI1+Aa3b3T1tcKFCCqmC5zXofTg3ZHHmKoHoVn5erADeQ9d9
         EAiSu3o3EkOajEbWX0ybrAWIhZslVoo0RZhHAYX8o2uvYk4w/XrpiasiDQCtiAA6/OgZ
         wUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762959622; x=1763564422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zXj8Vw0xd/qX3+ihzUkZ+DSqDm45u5a8I3Mp92b6iE=;
        b=GZrMLFkimPOFZ1KfKO8QnBRLRE8c3zZxFXbkAQp2Bpwjf9R+5R90dV8eg8RMNZdtZy
         a+/0zqB1sY+ndRil9BxBTiIVaL4TsUBUs5ITWC21ymewOV2eUdATlc8K8eCwKVfhmHRO
         Bnkfi0sEapi6wVVBAjDaQoUnHOyzi/CE3esqTl/nK1JLR7YtdMN8C/wZrg9kW8OlTMN+
         ss25P+EV/up6POd+1n0OUYO20rsjXxfPLabzk31rcSJfmcvDmZSub2a/UYpBKN0eJVU4
         pX01gFFi0xHr1VwcoLL4b/hUcGNpgOaD3FLIKcnEVliiANUvXDDYyzb/x7Bfe+ArQIg/
         LEvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5J7YMCdNBYJ9T7SL7tSr7kH+DPb1lK6Y/ZLrr9ho1zvJZkVAXHc+IhgB+VkwzPhfy9AT0ECQp@lists.linux.dev
X-Gm-Message-State: AOJu0YyHP21i+vM90DeolnNp+NtTsibcI9K9aYYf03Y7S5EBOTse8WKK
	CAqxnZ78guQEA1no16Lu7W1uwR1sVi+RqVpgLYZozGY8AwJ4xMlNSMHx6bBcVXk0wpudm6gNZpy
	7ey7p0kI808/ZI5vzfKWstPJdGgjo4C2FM8sWYxdbQw==
X-Gm-Gg: ASbGncsvYMVJqXnQCwB0jl2K+Fih9qYrL6Gtmw8kM3GbCgC8N646reKuPAV8sd+84Lk
	3R83cTYsG3Xgx5Wbj/6UE/cYZEESm+yk3JPZsYALF3IWBnbasz79t7OtshZtD8i22Bv5gLbAr2m
	sLA+MEFlo2hQ+UBG8XqUvZW/eUcJkyUNVNcec2xMaHpBuUV3AxltB3PfeiMdkjV697Nzr1WlBo0
	vSgakxUY3fE9wsGaqI8S78Dey2UA6KIy7ki0Cg7O+XCNAxk+dh5eCjKOdoRl8mwI7x/4Pb2
X-Google-Smtp-Source: AGHT+IGGxwpT70xdgCvNPIbAid5Yr2yjLeHLPdRKOlMlldVAPeBVEplLhReQ6HO49sUo8UA+RLI8nmybAhzhOWfAiQg=
X-Received: by 2002:a05:620a:4452:b0:8b2:295a:bcec with SMTP id
 af79cd13be357-8b29b96dacemr411166485a.88.1762959622363; Wed, 12 Nov 2025
 07:00:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111012348.571643096@linuxfoundation.org>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 12 Nov 2025 10:00:11 -0500
X-Gm-Features: AWmQ_bm34fQ2h4Ko5Ao74lfhzAP12s6Mwur0ANO5wwfSG1IMc_s2OBnSCBibTtU
Message-ID: <CAOBMUvgGc=a9BQzoEjZVR76=RjYVBA5QSFh7bGHCGZi4VEddVA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 8:41=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.58-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
