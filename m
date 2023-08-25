Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6115F18AEB
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 18:25:05 +0000 (UTC)
Received: from [192.168.0.5] (71-212-112-68.tukw.qwest.net [71.212.112.68])
	by linux.microsoft.com (Postfix) with ESMTPSA id D00DA2127C95;
	Fri, 25 Aug 2023 11:24:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D00DA2127C95
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1692987899;
	bh=lTiAq6TIQlz3/KRzBrYOW9Zloaa6S2j8QsR1OWQ9nd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O7+HQDi40dbcU5ZJ+REsZOWEZbODS6aqRVj4DMw9c6KTpW6MGAoCJiEkoiHCN9+lb
	 qeO/sDXHDMnr3G3VhGWUbUBoBwRvv009PLONJU70BqfDsHZJ+EUTSjer4YwBIGwRdZ
	 jJPkTnenGtlRUjYJeGFRyc2zXJLb3eQBXaQU9Y1A=
Message-ID: <c4482a6a-aed0-4750-aa1b-421f0e541cfa@linux.microsoft.com>
Date: Fri, 25 Aug 2023 11:24:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/15] uapi: hyperv: Add mshv driver headers hvhdk.h,
 hvhdk_mini.h, hvgdk.h, hvgdk_mini.h
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>, Wei Liu <wei.liu@kernel.org>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-arch@vger.kernel.org, patches@lists.linux.dev, mikelley@microsoft.com,
 kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
 ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
 stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
 catalin.marinas@arm.com
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-14-git-send-email-nunodasneves@linux.microsoft.com>
 <ZN6m2gVmtVStuEfA@liuwe-devbox-debian-v2> <2023081923-crown-cake-79f7@gregkh>
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <2023081923-crown-cake-79f7@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/2023 3:26 AM, Greg KH wrote:
> 
> My "strong" opinion is the one kernel development rule that we have,
> "you can not break userspace".  So, if you change these
> values/structures/whatever in the future, and userspace tools break,
> that's not ok and the changes have to be reverted.
> 
> If you can control both sides of the API here (with open tools that you
> can guarantee everyone will always update to), then yes, you can change
> the api in the future.
> 

This is true for us - we contribute and maintain support for this driver
in Cloud Hypervisor[1], an open source VMM.

We also do a check of the hypervisor version when the driver loads, and
refuse to proceed if it is running on an incompatible hypervisor.

Thanks,
Nuno Das Neves


[1] https://github.com/cloud-hypervisor/cloud-hypervisor

