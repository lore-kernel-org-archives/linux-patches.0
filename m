Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D93405E9
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 23:37:01 +0000 (UTC)
Received: from [10.0.0.178] (c-76-135-56-23.hsd1.wa.comcast.net [76.135.56.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2294820B74C0;
	Tue,  3 Oct 2023 16:37:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2294820B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1696376220;
	bh=tsip8nWvlbps3k11kkyVGy2+8yeAGiiGZPurvzAPE14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C+EH+ZFfOJLP32l5gUhfgckBSI+ZFNZKDVMrKVnd98UhkWNMSwPGbCF5RRrGmG7Ty
	 s+2bZf/590Ek6L1hvVy/dIss4fpBiPry8a/1xTDjehOQrpGCdw59aBRvB+l2G5BZVK
	 17n4LJMibOWB4335M2rEm7WLeM52xH8yTw73kExw=
Message-ID: <dd5159fe-5337-44ed-bf1b-58220221b597@linux.microsoft.com>
Date: Tue, 3 Oct 2023 16:37:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] uapi: hyperv: Add mshv driver headers defining
 hypervisor ABIs
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
References: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1696010501-24584-14-git-send-email-nunodasneves@linux.microsoft.com>
 <2023093057-eggplant-reshoot-8513@gregkh>
 <ZRia1uyFfEkSqmXw@liuwe-devbox-debian-v2>
 <2023100154-ferret-rift-acef@gregkh>
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <2023100154-ferret-rift-acef@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/2023 11:19 PM, Greg KH wrote:
> On Sat, Sep 30, 2023 at 10:01:58PM +0000, Wei Liu wrote:
>> On Sat, Sep 30, 2023 at 08:09:19AM +0200, Greg KH wrote:
>>> On Fri, Sep 29, 2023 at 11:01:39AM -0700, Nuno Das Neves wrote:
>>>> +/* Define connection identifier type. */
>>>> +union hv_connection_id {
>>>> +	__u32 asu32;
>>>> +	struct {
>>>> +		__u32 id:24;
>>>> +		__u32 reserved:8;
>>>> +	} __packed u;
>>>
>>> bitfields will not work properly in uapi .h files, please never do that.
>>
>> Can you clarify a bit more why it wouldn't work? Endianess? Alignment?
> 
> Yes to both.
> 
> Did you all read the documentation for how to write a kernel api?  If
> not, please do so.  I think it mentions bitfields, but it not, it really
> should as of course, this will not work properly with different endian
> systems or many compilers.

Yes, in https://docs.kernel.org/driver-api/ioctl.html it says that it is
"better to avoid" bitfields.

Unfortunately bitfields are used in the definition of the hypervisor
ABI. We import these definitions directly from the hypervisor code.

In practice the hypervisor, linux, and VMM compilers all produce the
same layout for bitfields on the architectures we support.

Thanks,
Nuno

> 
> thanks,
> 
> greg k-h

