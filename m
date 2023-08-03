Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A59200CA
	for <patches@lists.linux.dev>; Thu,  3 Aug 2023 14:17:48 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-686b879f605so694109b3a.1
        for <patches@lists.linux.dev>; Thu, 03 Aug 2023 07:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691072267; x=1691677067;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=eeZ0g3Pg1jlVI4GeXZe/av2+/magkTFnYFdTEYNZShw=;
        b=htVanGTjwP4sE0bCDPRsLOkBLUqnl0uObcuqCOyCeYEzIxdK9ArChpvAVDfMlEACMw
         MIQGOH+S9jOZl/UK4vdHHbMBcBfwC9qUpa5YGdsUm5z4dVSPNt4xn1/1I1qDuEaYY+Uw
         N/BgZhUYUxjpO4D3crHYPjnmhv1jj2MQPNr8QV2pUgtp6gDKSE823vimEkYe8CsRHS73
         lby1P1hMlMMteIrdq5gfPAcdahgdRZF4c8+QFFlupLOFL/ArDtkxV8Q4AvcmC/OLdrC5
         ZxRp8pu5fGG8I8N/W7hG7DkvjcLmiDUhRbBgdpLHV1E0ZuHJna5b7Y0/dwuryCWfhkk2
         8KqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691072267; x=1691677067;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eeZ0g3Pg1jlVI4GeXZe/av2+/magkTFnYFdTEYNZShw=;
        b=lCZZeag5MaqeSn6BsRK1Dqix0TFdlnAzgm9uVrzsvpyJYQnTAebPeJp2MxYtQgMQhM
         aRTSToBhirAmcAXEFGv9QEprISgr5cVZj8UREcQdwbqzVHIa8wq8mBq9SXCX8U1JolWX
         FBmV+45qnNydK0SFVAuV9LoBFdUpYS+R6uDpOmc2bJHrGganXAFxchkzZe1cl16m/7KX
         inztAFfZ1Sa/KuTEr5aaa9YqLG4Addk7bHC3dlhOA92JFFL32pWhqOutTR7Y3vFvXWPc
         jnxntH2Qos8U7abbaCnErBNTAZKMS4CoJLWFMZQW2TUVlxvFAMJduEvozG/VMY2mtu/x
         XcqA==
X-Gm-Message-State: ABy/qLbiI7uA9eUK+C3jv+LPSJGHTSCqv4NjJD8AhIX46VYduhbKwG5e
	7dJjVn3aIAEteOZREhwm/XI=
X-Google-Smtp-Source: APBJJlGAOe03snGL2p0G0H/z6QCt91mhrpXIvEiDb4tF/KKoByHXUoRLi2Qvsb4BXeizxgSM+5TXJw==
X-Received: by 2002:a05:6a21:4882:b0:134:2fd0:73d6 with SMTP id av2-20020a056a21488200b001342fd073d6mr16522360pzc.31.1691072267500;
        Thu, 03 Aug 2023 07:17:47 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y13-20020a63ad4d000000b00564b313d526sm28827pgo.54.2023.08.03.07.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 07:17:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <874c28aa-63da-df09-e44d-c6079771606b@roeck-us.net>
Date: Thu, 3 Aug 2023 07:17:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/225] 6.1.43-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230802065510.869511253@linuxfoundation.org>
 <e5e1bccd-8e73-43c6-bc7c-052428e7c3d3@roeck-us.net>
 <2023080308-mountain-gyration-06ff@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023080308-mountain-gyration-06ff@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/23 00:32, Greg Kroah-Hartman wrote:
> On Wed, Aug 02, 2023 at 04:18:19PM -0700, Guenter Roeck wrote:
>> On Wed, Aug 02, 2023 at 09:41:55AM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.43 release.
>>> There are 225 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 04 Aug 2023 06:54:28 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 157 pass: 157 fail: 0
>> Qemu test results:
>> 	total: 521 pass: 519 fail: 2
>> Failed tests:
>> 	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:rootfs
>> 	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:rootfs
>>
>> The failed tests crash while attempting to boot from a f2fs root file
>> system, suggesting that f2fs support may be broken.
> 
> Thanks for letting me know.  I've now dropped the f2fs patches from this
> queue.
> 

Confirmed that v6.1.43 does not have the problem.

Thanks,
Guenter


