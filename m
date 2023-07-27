Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362E527150
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 17:39:22 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-78363cc070aso50202039f.1
        for <patches@lists.linux.dev>; Thu, 27 Jul 2023 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690479561; x=1691084361;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mD7Ec40nx1InO1mj1sK16jFptJuYvMWAhJeXyIbeA3M=;
        b=Hxk1ZfaalrnceoH6uTLtQ+6q7om/j585QiwZq3MvyxOfwZIvrCEHHVDBcroQ6tBBFl
         wavfyRLx5vN9Jk4/GszclbYn0WebE5j31oNTtbja8jPqA5xjrzjd34vZkhGrC1YPup/4
         tRsL0KlocvjXWspc0poDn4HBOTRHoG24EDO6fUCNvx5eZWlNzfutObia9ebcIP53EoRI
         shP1hfvZnzWabk3tX6rFfgxNqpT1J1SGUrxINaMaPi7HV6m5XWiUNI66d/G9NF6xMotH
         J17kwNnqb1BiYz1P9e1pYa4Po4NzYorm9e40qpLLQYBKFBHHhosYBsZ8aA5K2DDuXuQJ
         tzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690479561; x=1691084361;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mD7Ec40nx1InO1mj1sK16jFptJuYvMWAhJeXyIbeA3M=;
        b=DvvPD5BNEesQfZ4e+rQDm+D1wYtj+oP5y5YbBHgn5VFAoQjzRTF0wO21yvb96Z3+tu
         Y9G7n6Rc7eb2HCvyS7hwUtiRNcKZeK51jI6RbPsGcvHwHBBisPK0Iiry0IK5uOVTTJK/
         ZLbaQQPZ/4uZdOrzh2QxUdnsNP2Ue0U3yBneMUk/qkoeGZWssj6LJrO5I7CUD0D+5pEB
         c0Ka5TBdtb9sPoWBUxh81Ne0uc1HRuxSaXkF6Fqyw46ODbCUC46zgleLUquklm69EDkM
         zlPuwkKW1elki715wPn8KK1fsWm7L2JXda2QY+jzdeb2IC10ZAVzUG/ieSrxFH8Ou0oF
         ++wQ==
X-Gm-Message-State: ABy/qLbZmOqV5qy0OMdf2RzJNbC2Qpcj9T3jYjHePZVbZARPXv+ME70J
	jSveH6WcqlPSGpJQYdH+ujw=
X-Google-Smtp-Source: APBJJlH7IW0hhv0wW+O2QV239cTgAZ/nOWX/T4X6e0QWGiiGCIKSvFqw62CJpUymCRfCjX7+hC4FJA==
X-Received: by 2002:a6b:7116:0:b0:787:1990:d2e2 with SMTP id q22-20020a6b7116000000b007871990d2e2mr221526iog.10.1690479560903;
        Thu, 27 Jul 2023 10:39:20 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3-20020a02c723000000b0041fb2506011sm542842jao.172.2023.07.27.10.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 10:39:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <2f4b012e-1f95-30aa-3f43-c31e84cb2c42@roeck-us.net>
Date: Thu, 27 Jul 2023 10:39:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To: paulmck@kernel.org
Cc: Joel Fernandes <joel@joelfernandes.org>, Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, rcu@vger.kernel.org
References: <ZMJWet00+9yIl/9c@duo.ucw.cz>
 <78722041-D1F7-45FA-BA1C-41B92209BA6C@joelfernandes.org>
 <0751f5a8-2727-4a08-8bb8-50bbd4244c9c@paulmck-laptop>
 <67eba84a-ae24-2983-a756-463f39f3ca71@roeck-us.net>
 <ebe4a969-8a24-4bb8-8dbe-f77db89f65c9@paulmck-laptop>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
In-Reply-To: <ebe4a969-8a24-4bb8-8dbe-f77db89f65c9@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/23 09:07, Paul E. McKenney wrote:

...]

>> No. However, (unrelated) in linux-next, rcu tests sometimes result in apparent hangs
>> or long runtime.
>>
>> [    0.778841] Mount-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
>> [    0.779011] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
>> [    0.797998] Running RCU synchronous self tests
>> [    0.798209] Running RCU synchronous self tests
>> [    0.912368] smpboot: CPU0: AMD Opteron 63xx class CPU (family: 0x15, model: 0x2, stepping: 0x0)
>> [    0.923398] RCU Tasks: Setting shift to 2 and lim to 1 rcu_task_cb_adjust=1.
>> [    0.925419] Running RCU-tasks wait API self tests
>>
>> (hangs until aborted). This is primarily with Opteron CPUs, but also with others such as Haswell,
>> Icelake-Server, and pentium3. It is all but impossible to bisect because it doesn't happen
>> all the time. All I was able to figure out was that it has to do with rcu changes in linux-next.
>> I'd be much more concerned about that.
> 
> First I have heard of this, so thank you for letting me know.
> 
> About what fraction of the time does this happen?
> 

Here is a sample test log from yesterday's -next. This is with x86_64.
Today's -next always crashes, so no data.

Building x86_64:q35:Broadwell-noTSX:defconfig:smp:net,e1000:mem256:ata:hd ... running ....... passed
Building x86_64:q35:Cascadelake-Server:defconfig:smp:net,e1000e:mem256:ata:cd ... running .................R....... passed
Building x86_64:q35:IvyBridge:defconfig:smp2:net,i82801:efi:mem512:nvme:hd ... running ...... passed
Building x86_64:q35:SandyBridge:defconfig:smp4:net,ne2k_pci:efi32:mem1G:usb:hd ... running ......... passed
Building x86_64:q35:SandyBridge:defconfig:smp8:net,ne2k_pci:mem1G:usb-hub:hd ... running ....... passed
Building x86_64:q35:Haswell:defconfig:smp:tpm-tis:net,pcnet:mem2G:usb-uas:hd ... running .................R.... passed
Building x86_64:q35:Skylake-Client:defconfig:smp2:tpm-tis:net,rtl8139:efi:mem4G:sdhci:mmc:hd ... running ....... passed
Building x86_64:q35:Conroe:defconfig:smp4:net,tulip:efi32:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:Denverton:defconfig:smp2:net,tulip:efi:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:EPYC-Milan:defconfig:smp:tpm-crb:net,tulip:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net:mem512:scsi[AM53C974]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net-old:mem512:scsi[AM53C974]:hd ... running ....... passed
Building x86_64:q35:Westmere-IBRS:defconfig:smp2:tpm-crb:net,usb-ohci:efi:mem1G:scsi[53C810]:cd ... running .................R........... passed
Building x86_64:q35:Skylake-Server:defconfig:smp4:tpm-tis:net,e1000-82544gc:efi32:mem2G:scsi[53C895A]:hd ... running ............. passed
Building x86_64:pc:EPYC:defconfig:smp:pci-bridge:net,usb-uhci:mem4G:scsi[FUSION]:hd ... running ..................R.......... passed
Building x86_64:q35:EPYC-IBPB:defconfig:smp2:net,e1000-82545em:efi:mem8G:scsi[MEGASAS]:hd ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:efi32:mem256:scsi[MEGASAS2]:hd ... running ...... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running .................R.............. failed (silent)
Building x86_64:pc:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running .......... passed
Building x86_64:pc:phenom:defconfig:smp:net,i82559er:mem512:initrd ... running ........ passed
Building x86_64:q35:Opteron_G1:defconfig:smp2:net,i82562:efi:mem1G:initrd ... running ...... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci]:hd ... running .................R................. passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci-old]:hd ... running ................... passed
Building x86_64:q35:core2duo:defconfig:smp2:net,i82559a:mem4G:virtio-pci:hd ... running ......... passed
Building x86_64:q35:Broadwell:defconfig:smp4:net,i82558b:efi:mem8G:virtio:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp2:net,i82558a:efi32:mem1G:virtio:hd ... running .................R... passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp4:net,ne2k_pci:efi:mem2G:virtio:cd ... running ......... passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp8:net,i82557a:mem4G:nvme:hd ... running ...... passed
Building x86_64:q35:Skylake-Client-IBRS:defconfig:preempt:smp2:net,i82558b:efi32:mem1G:sdhci:mmc:hd ... running ...... passed
Building x86_64:q35:KnightsMill:defconfig:preempt:smp6:net,i82550:mem512:initrd ... running ...... passed
Building x86_64:q35:Cooperlake:defconfig:smp2:net,usb-ohci:efi:mem1G:scsi[53C810]:hd ... running ....... passed
Building x86_64:q35:EPYC-Rome:defconfig:smp4:net,igb:mem2G:scsi[53C895A]:hd ... running ......... passed
Building x86_64:pc:Opteron_G3:defconfig:nosmp:net,e1000:mem1G:usb:hd ... running ....................R................. failed (silent)
Building x86_64:q35:Opteron_G4:defconfig:nosmp:net,ne2k_pci:efi:mem512:ata:hd ... running .....................R....... passed
Building x86_64:q35:Haswell-noTSX-IBRS:defconfig:nosmp:net,pcnet:efi32:mem2G:ata:hd ... running .................R.............. failed (silent)

An earlier test run:

Building x86_64:q35:Broadwell-noTSX:defconfig:smp:net,e1000:mem256:ata:hd ... running ....... passed
Building x86_64:q35:Cascadelake-Server:defconfig:smp:net,e1000e:mem256:ata:cd ... running .................R....... passed
Building x86_64:q35:IvyBridge:defconfig:smp2:net,i82801:efi:mem512:nvme:hd ... running ........ passed
Building x86_64:q35:SandyBridge:defconfig:smp4:net,ne2k_pci:efi32:mem1G:usb:hd ... running .......... passed
Building x86_64:q35:SandyBridge:defconfig:smp8:net,ne2k_pci:mem1G:usb-hub:hd ... running ....... passed
Building x86_64:q35:Haswell:defconfig:smp:tpm-tis:net,pcnet:mem2G:usb-uas:hd ... running .................R.... passed
Building x86_64:q35:Skylake-Client:defconfig:smp2:tpm-tis:net,rtl8139:efi:mem4G:sdhci:mmc:hd ... running ....... passed
Building x86_64:q35:Conroe:defconfig:smp4:net,tulip:efi32:mem256:scsi[DC395]:hd ... running ......... passed
Building x86_64:q35:Denverton:defconfig:smp2:net,tulip:efi:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:EPYC-Milan:defconfig:smp:tpm-crb:net,tulip:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net:mem512:scsi[AM53C974]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net-old:mem512:scsi[AM53C974]:hd ... running ........ passed
Building x86_64:q35:Westmere-IBRS:defconfig:smp2:tpm-crb:net,usb-ohci:efi:mem1G:scsi[53C810]:cd ... running .......... passed
Building x86_64:q35:Skylake-Server:defconfig:smp4:tpm-tis:net,e1000-82544gc:efi32:mem2G:scsi[53C895A]:hd ... running .................R..... passed
Building x86_64:pc:EPYC:defconfig:smp:pci-bridge:net,usb-uhci:mem4G:scsi[FUSION]:hd ... running .................R.............. failed (silent)
Building x86_64:q35:EPYC-IBPB:defconfig:smp2:net,e1000-82545em:efi:mem8G:scsi[MEGASAS]:hd ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:efi32:mem256:scsi[MEGASAS2]:hd ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running ....... passed
Building x86_64:pc:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running .......... passed
Building x86_64:pc:phenom:defconfig:smp:net,i82559er:mem512:initrd ... running ........ passed
Building x86_64:q35:Opteron_G1:defconfig:smp2:net,i82562:efi:mem1G:initrd ... running ...... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci]:hd ... running .......... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci-old]:hd ... running .......... passed
Building x86_64:q35:core2duo:defconfig:smp2:net,i82559a:mem4G:virtio-pci:hd ... running ...... passed
Building x86_64:q35:Broadwell:defconfig:smp4:net,i82558b:efi:mem8G:virtio:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp2:net,i82558a:efi32:mem1G:virtio:hd ... running ...... passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp4:net,ne2k_pci:efi:mem2G:virtio:cd ... running ......... passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp8:net,i82557a:mem4G:nvme:hd ... running ....... passed
Building x86_64:q35:Skylake-Client-IBRS:defconfig:preempt:smp2:net,i82558b:efi32:mem1G:sdhci:mmc:hd ... running ....... passed
Building x86_64:q35:KnightsMill:defconfig:preempt:smp6:net,i82550:mem512:initrd ... running ....... passed
Building x86_64:q35:Cooperlake:defconfig:smp2:net,usb-ohci:efi:mem1G:scsi[53C810]:hd ... running ........ passed
Building x86_64:q35:EPYC-Rome:defconfig:smp4:net,igb:mem2G:scsi[53C895A]:hd ... running ......... passed
Building x86_64:pc:Opteron_G3:defconfig:nosmp:net,e1000:mem1G:usb:hd ... running ....................R................. failed (silent)
Building x86_64:q35:Opteron_G4:defconfig:nosmp:net,ne2k_pci:efi:mem512:ata:hd ... running ....... passed
Building x86_64:q35:Haswell-noTSX-IBRS:defconfig:nosmp:net,pcnet:efi32:mem2G:ata:hd ... running ....... passed

"R" means retry, and the dots reflect time expired. It looks like it happens most of the time,
but not always, on affected CPUs. I don't have specific data for non-Intel CPUs. I don't think
I see the problem there, but there is too much interference from other problems to be sure.

For comparison, here is the result from the latest mainline:

Building x86_64:q35:Broadwell-noTSX:defconfig:smp:net,e1000:mem256:ata:hd ... running ....... passed
Building x86_64:q35:Cascadelake-Server:defconfig:smp:net,e1000e:mem256:ata:cd ... running .......... passed
Building x86_64:q35:IvyBridge:defconfig:smp2:net,i82801:efi:mem512:nvme:hd ... running ...... passed
Building x86_64:q35:SandyBridge:defconfig:smp4:net,ne2k_pci:efi32:mem1G:usb:hd ... running ......... passed
Building x86_64:q35:SandyBridge:defconfig:smp8:net,ne2k_pci:mem1G:usb-hub:hd ... running ........... passed
Building x86_64:q35:Haswell:defconfig:smp:tpm-tis:net,pcnet:mem2G:usb-uas:hd ... running ........ passed
Building x86_64:q35:Skylake-Client:defconfig:smp2:tpm-tis:net,rtl8139:efi:mem4G:sdhci:mmc:hd ... running ....... passed
Building x86_64:q35:Conroe:defconfig:smp4:net,tulip:efi32:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:Denverton:defconfig:smp2:net,tulip:efi:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:EPYC-Milan:defconfig:smp:tpm-crb:net,tulip:mem256:scsi[DC395]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net:mem512:scsi[AM53C974]:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp:net,virtio-net-old:mem512:scsi[AM53C974]:hd ... running ....... passed
Building x86_64:q35:Westmere-IBRS:defconfig:smp2:tpm-crb:net,usb-ohci:efi:mem1G:scsi[53C810]:cd ... running .......... passed
Building x86_64:q35:Skylake-Server:defconfig:smp4:tpm-tis:net,e1000-82544gc:efi32:mem2G:scsi[53C895A]:hd ... running ....... passed
Building x86_64:pc:EPYC:defconfig:smp:pci-bridge:net,usb-uhci:mem4G:scsi[FUSION]:hd ... running ............. passed
Building x86_64:q35:EPYC-IBPB:defconfig:smp2:net,e1000-82545em:efi:mem8G:scsi[MEGASAS]:hd ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:efi32:mem256:scsi[MEGASAS2]:hd ... running ....... passed
Building x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running ...... passed
Building x86_64:pc:Opteron_G5:defconfig:smp4:net,i82559c:mem256:scsi[MEGASAS2]:hd ... running ......... passed
Building x86_64:pc:phenom:defconfig:smp:net,i82559er:mem512:initrd ... running ......... passed
Building x86_64:q35:Opteron_G1:defconfig:smp2:net,i82562:efi:mem1G:initrd ... running ......... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci]:hd ... running ......... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci-old]:hd ... running ......... passed
Building x86_64:q35:core2duo:defconfig:smp2:net,i82559a:mem4G:virtio-pci:hd ... running ...... passed
Building x86_64:q35:Broadwell:defconfig:smp4:net,i82558b:efi:mem8G:virtio:hd ... running ....... passed
Building x86_64:q35:Nehalem:defconfig:smp2:net,i82558a:efi32:mem1G:virtio:hd ... running ...... passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp4:net,ne2k_pci:efi:mem2G:virtio:cd ... running ............ passed
Building x86_64:q35:Icelake-Server:defconfig:preempt:smp8:net,i82557a:mem4G:nvme:hd ... running ....... passed
Building x86_64:q35:Skylake-Client-IBRS:defconfig:preempt:smp2:net,i82558b:efi32:mem1G:sdhci:mmc:hd ... running ...... passed
Building x86_64:q35:KnightsMill:defconfig:preempt:smp6:net,i82550:mem512:initrd ... running ...... passed
Building x86_64:q35:Cooperlake:defconfig:smp2:net,usb-ohci:efi:mem1G:scsi[53C810]:hd ... running ....... passed
Building x86_64:q35:EPYC-Rome:defconfig:smp4:net,igb:mem2G:scsi[53C895A]:hd ... running .......... passed
Building x86_64:pc:Opteron_G3:defconfig:nosmp:net,e1000:mem1G:usb:hd ... running .......... passed
Building x86_64:q35:Opteron_G4:defconfig:nosmp:net,ne2k_pci:efi:mem512:ata:hd ... running ...... passed
Building x86_64:q35:Haswell-noTSX-IBRS:defconfig:nosmp:net,pcnet:efi32:mem2G:ata:hd ... running ...... passed

Guenter

