Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79853AAF6E
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195694; cv=none; b=HCvELGRiTuFH3ZKKA6xb43QkvW/2j2KaueSvdmaSKrGA8PK+/7f0llj1g0MDVbe2zofl+SDFPprUpoe8Bwn743/FJFfd0VzWYz1WSlYJhM9571FXFGAmXZIdip+j43Ybz40ykvXyx6XPUxQIuq9xhrq9jpG/r3YqOh8QrbQ5UZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195694; c=relaxed/simple;
	bh=yq3sAt1weRagllmnbj8GWuHou+5wuA4UeE2rWNk0/Hw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBXeHMZDSJLi1Q2APQyt3BYCzFjp481hj33jtOgpnimdzbZ9r57JkktfwtnkPFBbsJ7e+jsxfbLMpYJj9irHr/HHqQaEwM/M2uYl5U0o2aoDwBZqVMiXtjU3Hv7IXGjvExiEldKHtllKAya+CTEQarKBdPGDR2Q9OnogKDkHZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S1ZZBAFK; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S1ZZBAFK"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so74580a12.0
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788195692; x=1788800492; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=awVImKUzcLY0/XtG0S5LJamAqn3OfyX50g+7J1OI4Wo=;
        b=S1ZZBAFK8yPzfoQDsyylfqtzVAHiWLWvQpHKloU85DFnvQYCl9VLGphJIietqdXtKN
         Fvtp/AoVuqiZGETiSpalOdZMSq7jkv4U86urQKKYskbJpr18fNj09mxljAJbeNpM9QnC
         CZW+grMoIvw2a0WRG/jD3IxNiccb4wUoV1ClsOrUmlbXnx2y1i05UUVqlkQY4L5WCU14
         oCvK3MvVELP+StQXezaOZB4MXFvggZZRwvBmK56REPkFx7G+ZfAQwDSBIdDFhKb3GRmy
         WlmaTEPkl9RK8zhukXrNvykZfHGOGKxfTaviuqVzI8ImJZsdyu7MdklUGtTo5A/PquDm
         J97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788195692; x=1788800492;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=awVImKUzcLY0/XtG0S5LJamAqn3OfyX50g+7J1OI4Wo=;
        b=sG3OGucYNvzV3DleKiNDgwfe7GyZvsrPdyHwAFjtXv+xD0mp2vyJ7osMjAxq7FAl9d
         OPBshIiiz0XBArpV43LTnxP0TM/gq7i0/8sIwASzMrDSYNl4wLXDPRd9lCue9yNt4Hoa
         bc1NHt5TumXlMOcSmir+qe4J6EXIG6asFaJLjgrG+/zjdugNDhqkTrRWMhEzdc1Wann+
         lTS16HcvEdVO9A8QMHFjIBTFNU1xVTLHEUL1tLg+RYIgDOs/hXVnHO1GS9HHlTa5rSIZ
         mLxtBMgcT33Kh4S/woicAlqH+Il0Uz/t/E/UfTY5S2EjVzy6htondN8LrirNZ+SWFgkn
         0IQA==
X-Gm-Message-State: AFuF++moRzeFdAikVJFtrorYXmIQBfpCzXAfNau7n6ME66BIKZcSFjEF
	TdWIZCDf630vIH5wkzeMdE3nindzXTtevkNqldTYcwVZrj1OVCHXouM6RjcxrA==
X-Gm-Gg: AYBFou14/ZZh5x/EFdiT6qSRb9i7Vp6nzkysMcB5K26VT7QB7pp/udPUfm0C9qpucGe
	dsKH+gYYiiHJhTnqAH9XPenyUIyw7k7Wk01ETUy+54oBwW3mEmQmf+ZeTYhyoIGMH6VuKaMaslt
	1N6P1/ejJQYVrsMxsaMaRUn4e+MdYo5XyFQ83vIeWO4nH9O2qINVhYOIjRtNhwUS6cOK4zt8gQx
	6hN1zbre+x2vDlUY+1hkb6mF7gX+Sa/6jFGiYHMYZMIjP2MCVboJXxn0vq63zJr8sPCtJkzbHQF
	HQlraOK3RGNyfyf4boZAEoWBNgz5T5eiL0ahQJH7gupDvE1Xph/W9OcIqw3lgZ5beXx5/7k6exD
	XA3XmTfNS2fCE2dzBZnMN/rojK4nA9JJ91DKCwOftE0s9ar4JB8LPdHMegt+SxzgSn9/qO+uqD5
	/ZSo6A35DB2PICZjFAwy5DMgZfXu4TJnAbG9VBM+sT5QF3x4IUs0mpLKiXP74aZEkMlH05ZTyx4
	+g0TOL3NaBaifmYNTJ4p/18mcIj1g==
X-Received: by 2002:a17:90b:4fc7:b0:37f:e5b1:ec4b with SMTP id 98e67ed59e1d1-398da5e8fa5mr9325730a91.5.1788195691825;
        Mon, 31 Aug 2026 10:01:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm34437702eec.29.2026.08.31.10.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 10:01:30 -0700 (PDT)
Message-ID: <bbf4711c-f12c-42d8-95f7-0f21df214b71@gmail.com>
Date: Mon, 31 Aug 2026 10:01:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/43] 5.10.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133358.571886287@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.269 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

