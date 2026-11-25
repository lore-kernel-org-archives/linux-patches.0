Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616188;
	b=fR3Z2ZwSGdJGrbLM6LR2CT0HZBAx+FwNKtJKhmDDk/sB8zC/y3N5Q8Gcouxor9D3glyZ
	 neybxyHWOqwgzNPAZXS2iItGNJQADA7WemSrt3j3xCD1zVlTSlZ0So09OpJew9tNazclH
	 fb7a7E4RN+yG9hjepKowMEW4rQiECNC/9fy67MOMRXP2yPdnRMiyu5YvsIDGeiOQVwPYB
	 RIjEr2jnZvwMdGX1P49SwOcGel/Df/myiCo+oqX4Pf96Wv/YKdlhqsDQVVqKsMs6UwRPS
	 dRFvDCuzlx7o+wpVPX5c54XJ07TruWsd3L5fIgh/yhO0BPVzv2Gvn++H6TR/rkCGyJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=i/jrBB7rLlSUxUEPdi3kz4rjRXIQytYo5vvcwBrT/JI=;
	b=aO7Ajt9HFGTeFZotkLh807JGkUkiQHBatwEt/69Oo0nKkMd7RdjqAS7R/Y4vlHliWlm9
	 sZFaEaJA4kO2uWkz6tke7SNVqHHwcCsk68sbF7F3DdLQxoKEyTQrqys63znalqlEtzK8z
	 7wYnLD4EgjMvF0fh6fdd5wVABa6hYbWERwVcLlPJY3oGrcZC6TsJHmAAo2pSm78uHNTG3
	 /syqMWexxK0xWoCojeE3gznYotlbqaofB/Q9s/5tT/dnXjxP8QEeVJ5wxKLj8kd6oIVJ2
	 ucDLanA2rm23aDFaLoSWb7+5JtYTDUItd9cQLMo53OB5xPRB4LeL4Dm8TADMdZrwPpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=c6McCBIX;
	arc=none smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F449606A323
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F449606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=c6McCBIX
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-9217800e7f3so11202466d6.0
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795616186; x=1796220986; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i/jrBB7rLlSUxUEPdi3kz4rjRXIQytYo5vvcwBrT/JI=;
        b=c6McCBIXAxfLw4s25EbkG9zoFP6msVqRL8V5KjgDJW1iXYHyByTdPIShm5EPJyHos2
         HwZBtz5AE5GjelgQp6B/Zhb0DAQkNLCv6AfEaqixwvDdPBExor6wI4cXwkkMoohMs3vP
         2l3iUUCSdc7fr/zLY/FeUIn59HuCWN4yD3z10qeT1gK52npjipIEoOdqvr9x3E6FY38Y
         d5k9qyar+uFHNfZKFclxY1bjE6FW9WolR9X3V01NkN7cGQv9/wPIFZK/YIbySQECPiwM
         +KqDqC8m6N667bfunMih5yEBJ2CYftI1JGdOMBJLuL2OEWiJGFZekOIEnyYLCVQ+NgGj
         VyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616186; x=1796220986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i/jrBB7rLlSUxUEPdi3kz4rjRXIQytYo5vvcwBrT/JI=;
        b=goIp6m1WiF7IDFpc+WwWO9T8AS/8l6DXr4jA2Ec5M3l0bj4hW/5Uiuq2qlN2tGq8Ev
         rEDg7zHuEKNevt94Va/TLImPtY2ViLrPM4JWftcJjd/5X854L65oZ7+FlyPLhu8HkzWp
         vfWSd+05p9t+lMt6o+C/ivLeFUBpTlhvCz++XrcE0RY4E8XlhpXsMT6EYVODFolesT+3
         F7z7FYDmSHES7GB8LERrl9JMTgMmUesz81lWKjnwD6RmR+k+S8LYEwHTd4Om0xiq1hdQ
         pLSXlInPtFKiyyNnfK4QF8rGn7+QChauge5VhaWcLcZa8UlBWqJq0NNEXF65KzPsOAg8
         LDpg==
X-Forwarded-Encrypted: i=1; AL+hErHbXdkmBQiZDf7tGu+Z7xxa8tnJQLnWY6iCgoHhgedsXrKrZey1PeSGS+Tzn43NobHi0pOJBwMo@lists.linux.dev
X-Gm-Message-State: APuU4Z+B1fxEcXmUl49KwIGj9M2+0jF9FzGaORd8T2OJ48ltCEe50Bkw
	6+1iUNc+kYnejSSpykx+tyrMYdE/OlAAv5Yx0BapX69D+EBfS50Rjz+8zyKvvHosQow=
X-Gm-Gg: AZFdTZcvQ706h7glIptZsdxpWGnP72vuzY7MTTEBnpxP0dCWv1y1LOFBZ6c46etiQSz
	Ss6OAsiZDKiN4mq7A6xqfiaAuo/aT4CUhfDM4FNGBO3u1JgoKXUNaez/27z1wi91zbcEoBfTCE5
	4ZTp3ySpxrWpKDuvkUUPlb0uc+0FcJOECzTC77OQQlCencCpPTcOnH+jVULXIl/p4HXlbZ7ZcrZ
	IYjKyf72VME7fijEcbNdrZv6Pka04cs/7U20E72y5ZrH6UJGm8oIvUzJj4ifwQzPkqYTESC9JaL
	z3/ghNSYL6sNOfil9Z7TLIuzLXNdK/SkRp8XUC6EBHZxnXrNzJPeLClTY62KuERzp04iCTeIcoj
	NyBvaQ+l3BGgxKTYL9lbpkjlMv8eCUkM1W8k9I+kQIzQFlT6qHs6R0HpX5eA5mXZOpfhPN5Ost1
	6N718sNekeVX9GcEtOwqxjqCibXXpokWVb+bJt961hix8OQPpugCua3HjJ6SNa2rYB34fXCB4/W
	xWf8ym2YhGN/r6bpOEPDRoJbbrL3bvMom3tebrotcoAoNEr3B4LgmkZCgy4maxU0Li7tfdboM6f
	GGCa22cvyEjRPT4M7A530/5dago=
X-Received: by 2002:a05:6214:2f08:b0:921:5102:6b02 with SMTP id 6a1803df08f44-92151026b60mr217389976d6.38.1795616186267;
        Wed, 25 Nov 2026 06:16:26 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9217fd18b2asm6696336d6.21.2026.11.25.06.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:16:25 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWDnN-00000001jAp-0WzE;
	Wed, 25 Nov 2026 10:16:25 -0400
Date: Wed, 25 Nov 2026 10:16:25 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host
 bridge
Message-ID: <20261125141625.GA246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
 <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
 <20261124024842.GB9566@ziepe.ca>
 <yq5azeux9xxm.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5azeux9xxm.fsf@kernel.org>

On Wed, Nov 25, 2026 at 12:53:33PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Tue, Nov 24, 2026 at 11:11:49AM +1100, Alexey Kardashevskiy wrote:
> >> On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> >> > From: Dan Williams <dan.j.williams@intel.com>
> >> > 
> >> > The first attempt at an ABI for this failed to account for naming
> >> > collisions across host bridges:
> >> > 
> >> > Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
> >> > 
> >> > Revive this ABI with a per host bridge link that appears at first stream
> >> > creation for a given host bridge and disappears after the last stream is
> >> > removed.
> >> > 
> >> > For systems with many host bridge objects it allows:
> >> > 
> >> >      ls /sys/class/tsm/tsmN/pci*/stream*
> >> > 
> >> > ...to find all the host bridges with active streams without first iterating
> >> > over all host bridges. Yilun notes that is handy to have this short cut [1]
> >> > and from an administrator perspective it helps with inventory for
> >> > constrained stream resources.
> >> > 
> >> > Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
> >> > Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
> >> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> >> > ---
> >> >   Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
> >> >   drivers/pci/ide.c                         |  4 +
> >> >   drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
> >> 
> >> I'll take to the tsm tree, thanks!
> >
> > Lets not take any new sysfs APIs please. These all need a careful
> > thing and we are not having a good history right now on any of these.
> >
> > I'm not even sure what this is supposed to be for, is it debugging?
> 
> 
> I think this helps users identify active IDE streams and determine how
> many secure streams remain available on the host bridge. I would not
> classify it as a debugging-only aid.

It looks like debugging to me..

> A sample output for a toplogy given below
> # lspci -t   
> -[0000:00]-+-01.0-[01]--+-00.0
>            |            \-00.1
>            +-02.0-[02]----00.0
>            \-03.0-[03]----00.0
> # 
> 
> # pwd
> /sys/class/tsm/tsm0/pci0000:00
> # ls
> 0000:00:01.0  0000:00:03.0              pci_bus  stream0.0.0  trust_policy
> 0000:00:02.0  available_secure_streams  power    trust        uevent
> # cat available_secure_streams 
> 255
> # ls -al stream0.0.0
> lrwxrwxrwx 1 root root 0 Jan  1 00:48 stream0.0.0 -> 0000:00:02.0/0000:02:00.0
> # 
> 
> Here, I have set up an IDE stream with 0000:02:00.0.
.
> The previous discussion cited in the cover letter indicated a need for
> this because the number of streams available at the host bridge level is
> limited.

So explain how the imagined "systemd device acceptd" is supposed to
use this automatically?

Explain how it works with the future need for a more complex P2P
scenario

Explain how it works inside a guest to accept IDE streams setup by the
host.

IMHO we are no where near understanding streams well enough to have a
uAPI implementation, nor it is even clear sysfs will be enough to get
us what is needed for everything.

I would prefer we focus on the things we are starting have a consensus
on, there are so many right now, lets try to get them merged before
opening up even more topics.

Jason
