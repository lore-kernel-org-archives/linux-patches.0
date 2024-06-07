Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4EF1C2BE
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 07:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745666; cv=none; b=gOuy2Ad8K4FhDUwqABz6XIgbpSUl8oAvBY9SENNNlAGla5ktwt3FO1tuvc17nkUTwkdga24TdwyFcvUkNXXthMVsT3mMGAyWbRyrrbpKxYc4FPqWrI706EBk21XltuQVmcbiiQtKtMIZGwxgMF4SYZr13Pn9E0nLR8zv/euk6aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745666; c=relaxed/simple;
	bh=wc7V8buAFkBh3ydPjed2ipAWNFc5GmI1OVqByAfWSWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZkfj7awAtbyTgRR5uXdl740+qkw10UpUZwl5XYXqoZI4NjrP6LKT4GzdCva68mXVIbMBciKHNXgTq35ZAbKFX7mxTIpabNUKb4tJWpIjGnP4QUPE8/RyjFxq2Jb4XWPty13uHM8zBskf1w5TvF5r/DwVXeKXkZ/Ns84GV0w+2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=G/TSlz/d; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="G/TSlz/d"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42155143cb0so21842095e9.2
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 00:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1717745662; x=1718350462; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9p6Ea3BEh/GCrntLXXZZkFilZ40QZybHi/QN5L8Zn8=;
        b=G/TSlz/doE7voeZklYfMMuvqcMQh0OzmsZiaSWuGhg3eZaO6Ics+ROio6HF930R+Eh
         6hi3MssKCP7H6RLu2kV/Wzh7FgtZFdboZo2i6HKyzjt014THnXOEHD6a78KHSBaphqHu
         bQ+mI23K3Jkf5JrOqEUYP9CaSZBeYk2BqfehjRtqT8WQH+StNKYPEwFlBv9YcOI1/fL/
         OkAL0T1faMcmYlkqT+7s3xURB59YQbsyqkc6dSmN2yE9blhxXXt2JL/vGPZY+bAzxOoq
         H7IF0iwCGNU8dEJeOTFmzvDbRp/qt7QP5OxYM9p5zOLlHUvLmrV8t3sNHOi3fuZ6t7Uo
         QWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717745662; x=1718350462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9p6Ea3BEh/GCrntLXXZZkFilZ40QZybHi/QN5L8Zn8=;
        b=i8q1MCr2cQbnTdZvWau7BrtC53cS5xAwh/SNRtmJSiN1Z9at70E+AkppgyFb9LF+Q0
         JgShboBIleLRhV5w3jzD8Tx1L5YYMv5foQV/aA1IZxzRkHNHs+9trcTnRNyyfsIw+1jZ
         6AN0Z6ZGBzb30U5Fr/2gmIkmera2KaR2liyuTl8IEm36iGxpb2wl57D8KnXAt84G12ov
         1+NvQKXuOLdUM5S83VVnJHv8rka7lQYqRM/9fj5ZhDQBwmMo/gziqwVFCLgnYBdy7XNu
         ktskXFUtS1ufGt0/SuliHSvbm0TyOZu5cECLbV8NgwXjx1sa96wndp9HvZtA+6WT5FKD
         mkIg==
X-Forwarded-Encrypted: i=1; AJvYcCWzIvhRUSZhIrmxx4uZNh9M3WJsQuebNioyDwgTaGT0Pv7hE+mJ6AzgRT5G4KVoGR0VQsSeW5Xw9zMpxl7mpFnQcymXk4WTvg==
X-Gm-Message-State: AOJu0YyC0e85sN+3cHqyHDSS8uL2BCY7CAFyx5IFB78vLkRHzqoTm3za
	66SKC4r1hWVtSLZ/DAnQbdlH4JrndaBxQ4APfR5UHlPLFDUALQ1Ie9eBZTFSBVQ=
X-Google-Smtp-Source: AGHT+IH+3m7gv/wXKg1IjZX1gSf7JkbLx10qHeS1+1YDQg9+/tqA6LeQaS0aSWtLgR0eEgd8FaiPpw==
X-Received: by 2002:a05:600c:1383:b0:420:182e:eb46 with SMTP id 5b1f17b1804b1-42164a44859mr21469665e9.38.1717745662064;
        Fri, 07 Jun 2024 00:34:22 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421580fe3bfsm79619795e9.8.2024.06.07.00.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 00:34:21 -0700 (PDT)
Date: Fri, 7 Jun 2024 09:34:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Itay Avraham <itayavr@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Aron Silverton <aron.silverton@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
	Leonid Bloch <lbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-cxl@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/8] Introduce fwctl subystem
Message-ID: <ZmK3-rkibH8j4ZwM@nanopsycho.orion>
References: <0-v1-9912f1a11620+2a-fwctl_jgg@nvidia.com>
 <20240603114250.5325279c@kernel.org>
 <214d7d82-0916-4c29-9012-04590e77df73@kernel.org>
 <20240604070451.79cfb280@kernel.org>
 <665fa9c9e69de_4a4e62941e@dwillia2-xfh.jf.intel.com.notmuch>
 <20240605135911.GT19897@nvidia.com>
 <d97144db-424f-4efd-bf10-513a0b895eca@kernel.org>
 <20240606071811.34767cce@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606071811.34767cce@kernel.org>

Thu, Jun 06, 2024 at 04:18:11PM CEST, kuba@kernel.org wrote:
>On Wed, 5 Jun 2024 20:35:49 -0600 David Ahern wrote:
>> Until a feature is standardized and/or commoditized, it does not make
>> sense to create a uapi for every H/W vendor whim.
>
>This is not about non-standard features. I work with multiple vendors
>as my day job. I ask them how to set basic link configuration and the
>support person gives me a link to the vendor tools! I wish I could show
>you the emails.

Even without emails seen, I believe you. Well, isn't it just natural? I
mean, it always takes a bigger (sometimes much bigger) effort to
implement things properly introducing/extending apis/uapis.
Implement things in vendor tool is easy, low hanging fruit, people
naturally pick them.

I've been around in netdev for better part of second decade.
I think, for the sake of discussion, it is worth mentioning, that
a big part of netdev success despite complexicity is that in the
past, any attempt of kernel bypass (I recall few) was promptly rejected.
There was always big push for proper abstracted solution. And I believe
it helped a lot all over the place. Is this approach depleted?
I don't know, maybe. (And yes, I'm aware not everything could be done
this way).

I understand the reason and motivation for this patchset and what it
will solve, don't get me wrong. I kind of like it, it will help to
remove all painful detours we currenly have.

My concern is, it opens a pandora box for netdev *for sure*.
It that desired and anticipated?

Do the gains overweight the potential losses? Will it help the
ecosystem?

What is motivation for vendor to take the hard way of using proper api
(even existing ones) after?

Moreover, wouldn't this serve for vendors to go out of leash and start
to introduce even more H/W vendor whims?

I think these are serious questions we need to ask before this is merged.


>
>> All of them are attempting to solve real problems; some of them will
>> stick. We know which features are valuable when customers use them,
>
>Yes, once customers deploy a feature implemented via a vendor API
>they will definitely migrate to a different API. Customers like risk
>and wasting their engineering resources reimplementing and redeploying
>things? And we have so much success move users to new APIs in Linux!
>
>> ask for them and other vendors copy them. Until then it is a 1-off by
>> a vendor basically proposing a solution.
>
>Certainly. Because... who exactly will ask the second vendor to
>implement the common API? 
>
>And the second vendor will most certainly not mind the extra delay and
>inconvenience having their product shipped via the publicly reviewed,
>and slow to deploy kernel, while the first one is happily selling
>the same feature already.
>
>> Not all ideas are good ideas, and we do not need the burden of a uapi
>> or the burden of out of tree drivers.
>
>This API gives user space SDKs a trivial way of implementing all
>switching, routing, filtering, QoS offloads etc.
>An argument can be made that given somewhat mixed switchdev experience

Can you elaborabe a bit more what you mean by "mixed switchdev
experience" please?



>we should just stay out of the way and let that happen. But just make
>that argument then, instead of pretending the use of this API will be
>limited to custom very vendor specific things.
>
>Again, if someone needs this to ship their custom CXL/Infiniband 
>AI fabric magic, which is un-interoperable by design -- none of 
>my concern. But keep TCP/IP networking out of this :|
>
