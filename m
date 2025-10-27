Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707412E5B10
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761601869; cv=none; b=O+WSD5YgRbsWLKfiFHpONfdBrN0Xo4FxAK4EonRRQIkd1sAsXz7e0GEGcYdmy9pvRkaaQps7L91Io7XWaLv3JUZJkXw5OL2q2G2Wo1a/rkRz5zVTI+cAdCjWq31lac44hvElvJ5TCLcqgHlLMDXgJNt0Cpdo/Q7sm1BvEhbnIpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761601869; c=relaxed/simple;
	bh=Ihe7iMGeY3MaWfpghNgRKj16o/BXEhA4IQIEAteLWFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZwRCBywEUJm6hAUy+bCyl9ygLJilQbKSc7MwVJllE6+O8wL1mLhC0eO2XnWbBBcmFIgZs7uymSIz7I3Z9N44lbHoOjDJuf85xEN8sv5raXsfjYmhhz/rTVXV7hmkHhDmyT4TAzqrb9+eu7lZEaPGGFXZvLIoi/OuztyCz9vqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jtHZT5TA; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtHZT5TA"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ecee585f23so15281301cf.0
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 14:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761601867; x=1762206667; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tVNnHyP2kvRHu0KNHL4DYJenS905nS8x/EseI8qNXgs=;
        b=jtHZT5TA/YGdwhVBEOfp9mwk463+fr999T6PxJ/GWYANxUWwACkGd0AJN33Phf1cgz
         XMrwPmNI+pKe6SaoRj7l5SNIribrXYRzEHUdX/15ebupuvm9MLht/M1lazaREF9hD9aS
         SIfSH2udHdz/LmO7jdkYJmdwQM/TiI8pNyAZdaadPvxpbB4LyWcP1QYmnORzozM+s9dX
         9msM48UNy/XmQijl87UZZOPafRDzS+7/kOXfbhdzwl0afGvVvd95uycMye3QJVxyzH9o
         z08v3gSeXAhvgYYGFl1ZHXdFjpg4tIWn5vP0BKfxFqFl5zq5LwXzycLQbCLUAQ7QU/fC
         Blaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761601867; x=1762206667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVNnHyP2kvRHu0KNHL4DYJenS905nS8x/EseI8qNXgs=;
        b=pBpYiXikp+b4vh9LLtd22yuR8B5LzxBkbxYxFERbezPCaWlB0TUvflE7HyKw/Id3iV
         0A2T8rpwaVnY7ktcxvqqpMOJ7bw252cPdK8QdtTrqcR1ljqulcyOqixwHy3f2v3xIUma
         UMz1r6Vhb9Q6Ic4P93jEBV1ohIOe660GG1lkhnCFOJuoMRbp/SrpKVCfcorC/z/vxrqo
         zDAwD8MhfUNgEr3CFou1fJFhj2Fsk70Ujc0Mg3tqDhV42GOmRP8L/mkxz+9mD8Qx2r8I
         4rdAcrB9XrUJbkYOcI+a7DKo0+ypHKgM5YLwyMewTchta0LABZ3dZXfggS7RlZgsI+UU
         9I+Q==
X-Gm-Message-State: AOJu0YyLvySOiC3DbYdHWE7vGbRFTjepJEV6vSpmVpRDaDwZ6bpCzHYL
	NF+dO70zfoUOChdwSSpgeeMwBcdkgore+eYOUFkdzl3cAXpmKWwquk3+
X-Gm-Gg: ASbGncsyitY2jGMJSBvxQo40guUiA2387NZ4MVLCeO8M2CqYMSRolK2Gvn0upNj5pKx
	fIUniE/UXw/tqS55z4pyknioBBOhsOGa0cYoFLb95K2siedNEJUq+quSRh7I8RtnS61w5dHG9HM
	lxnbLr3Rtt6RJGeUdRyadtdJmPyLtw9haYE+xCaCJ1xzUFHAjNlhLlnbNno1xW/5cri7WlkRbVA
	AEf+g6n33cwlRcjisLti1DAIFQ2s/2jxOhvh0nWZ+mXKsCAVs3q8fnh/d51bGzsIDFzjJdrrViK
	d7izrMvA46hZsARG5S9a5Kbei2KQEQrfEDfoYlcgeDkGZcnqs8AHcjKrWFh3AOs4VF4Z9MlE91L
	EahExF3JlbEJRV+mk183xy4UpSq5ar+jpJ0NKcts9821iU8ooi+nFi+s0pIo0KYEtP2FAynuzf0
	lUBaZgScdlB6Wer6H2s9XmqZY5O8M=
X-Google-Smtp-Source: AGHT+IH9Cj1acWdK8g+zx9f3zGo9gHf7/2+ldMTysUUzxIINsdMd7G/Ku9++UeRXutjL0OKbUCJtlQ==
X-Received: by 2002:ac8:6f0f:0:b0:4ec:f0f8:22f6 with SMTP id d75a77b69052e-4ed074da1ccmr25283401cf.19.1761601867150;
        Mon, 27 Oct 2025 14:51:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48f7323sm63559206d6.29.2025.10.27.14.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:51:05 -0700 (PDT)
Message-ID: <939799e1-615f-4246-869b-03ca162bc49f@gmail.com>
Date: Mon, 27 Oct 2025 14:51:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183514.934710872@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
