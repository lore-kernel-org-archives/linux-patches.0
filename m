Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAA7252912
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745957385; cv=none; b=JQtGEebINq7VR/OtxS+IUjx0TvhK0B6vBG7h3cVJmqXO9zUH6i/fnTsfViTau4xRTdaAxGljHJ88u9qv0x7sG/urb4PthZjnZQPteE/N9bhOL3UGIoFqEd9DYPac3DjBG6fO9vi9iyGwfvWJz7JszAy5Dy644klN2D0IIiCqaXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745957385; c=relaxed/simple;
	bh=Q7QKw8N/cgZtjXlKAmrrGTKH8uRwhmmrFJ7rhBdmy8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIoNpLDanFKlDh98wdgetMCCk5iBfcrj+y3NKN8UQZNcQEYNg5blpcBXy0378+oHwhWlJcac6yYIA3FGI7doj9yShsSdhb5WC10XSlOfn2dPe82hYUL4gpunEejHiIYiD/ChtPw02ZJuLfpHQhHIaB9mcpHneTFaZK2pjmc1VkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hTqjn4Cs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hTqjn4Cs"
Received: from [100.65.233.247] (unknown [20.236.11.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id 84D8A203B856;
	Tue, 29 Apr 2025 13:09:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 84D8A203B856
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1745957383;
	bh=nT+qbFOoqrArZHYF0Rxabbfuu36E8ZnT3GnfS2ZqkEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hTqjn4CstXpP6YgK0f3fcO8g6MDVgHW+1YcF/kC6xC9CtuwIZnTWoxN9qsnAvL1pb
	 YvdtKwfZ+IksV6NJcJ4PDk1OGAME33V0yRbn9Rxuxd76N7eKhX8z9zfk/NJfU5mYOt
	 4GgNp/s+fZ061U5A7248qOKBopmXpvhkvAvj7GoQ=
Message-ID: <2ca09c27-c13b-424f-aee7-1b94817eda40@linux.microsoft.com>
Date: Tue, 29 Apr 2025 13:09:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161121.011111832@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The kernel, bpf tool and perf tool builds fine for v6.14.5-rc1 on x86 
and arm64 Azure VM.
Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
31679632  14224334  6311936  52215902  31cc05e  vmlinux
Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36856310  15166805  1048656  53071771  329cf9b  vmlinux
Tested-by: Hardik Garg <hargar@linux.microsoft.com>
Thanks,
Hardik
