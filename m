Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640B61991D5
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775449; cv=none; b=Ury/0Q95OwcgwzKnTLUS9KSatB9iobyV5zOZXuvGlQODmbLSe5sdVwflHq+tV3ZPEdYFqIHe0dEqHppGkHq3kvBx+tnv4AsgkEVz3ypr/JJv3EQhtiEgzyJFUuJKO7F+0+s83ZjQTDDFWAZfYAFxxMZYk70yfp7iYu8mt/cCtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775449; c=relaxed/simple;
	bh=uZQQT0tWMLKpHLzpjA4+4RgpjpRE41cd6g0mqVVjBlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lA0Z1HZ39QFko/g5I1mBZF6GY4Zpktt+zGYnmn2BqVDQN4wmQ8CZVoKHQ0A0aEioCw9QJgVJoBaDk0RucER+GqbR505TRvCZ8Q2mwdLJYtDVqqEykDaMXsuAlR6J4MxA2ml95/L4v5fek/vYDivKz/RGcHSMhvYlUT/xDNdc7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=LmfHLU0i; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="LmfHLU0i"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-421396e3918so27163155e9.0
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 08:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1717775445; x=1718380245; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8mLYWZnKH+z6ueZhuJkRBxm2z11CPZmpPTaPGv2cuj0=;
        b=LmfHLU0iFBCH4fMLR5IyQ+uiScUda6mt3SNxae+dfbe9KhkAdIL9LoJRpxInhyvdT4
         6xYf5b82yblLlswuhxr0fy2niHqrwIE/EMnJq80IZ7vMmJzm6ioIgwiZ95BOuKU2enDp
         lrm8ViJboHlcaPrl4NSiJiHtSL2yqR6bJ0Uhy+wWZ2aj2fQ74flgtGgjc7uOQEV4sSg6
         DZJMPqnQ/9v8phSMDLNxWdtDmXP5gSMMXBB9vTgvQZbjm2y5Zm77v27vTO8A/+7Xsidh
         XdJsf6955mK0PhtDpP/ZMvgu9xj8WSFmwQReKEoSmTjeaoSvp9IPahAXG4FGWDDOjZAs
         keKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717775445; x=1718380245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mLYWZnKH+z6ueZhuJkRBxm2z11CPZmpPTaPGv2cuj0=;
        b=OPCJufnRCz6vK9TrwxkavINoXMEqeCH/b58HAd3c7iycGGqmHNThLojpyI16H6SFw4
         9jwWM7AH+eQ2tRDG0sAzFKzx2cdb6KN0qcw1myEm3AJMIlSYpuddQ2Vf/VvfH4oVO+dH
         1en1wOu23eRrWK2zxA9VQqRVgfohno7dbuIGXFslfoisOcVUhhqBgbm279zqKfkeUVMK
         Xyeyy3zSRboVg/WvG32JyYZPEwYaIhaVpBfA8dpa0IrDQ8JLcOJyJfkuHS53Z+PS8akv
         a034VpJ9mXKXQio39mi7LYdg7W2T9lGmfSusbKXSMx46SmaLtrSLjXTqaNZeZ5xNeZ+m
         Orcg==
X-Forwarded-Encrypted: i=1; AJvYcCXhPDenU8bj/MjanI6t0CT4Fu6gM6d3okphWeWXlFVrHvHJTqfLYWLhjaIHGwfvy4vvdL0V4pZRCwWsa+0wHKgCroD/czCGpg==
X-Gm-Message-State: AOJu0YxgUsNgY1jMsmrEPvFIphUKq+mjUTXUwcyUo74h3TxO63gCk9L5
	BqRDSE4t0ya3+be4wAisOMQOZLTZzDUHvrlh5O3AUuyJAiVLFJLC7k9LLICX3QA=
X-Google-Smtp-Source: AGHT+IHG8WszpcEWn5y0Ergt20tKhSOz5/rJxXqP/p8U9bIooclfDP/A70icjjOiWOdZ+5jrSUBNHw==
X-Received: by 2002:a05:600c:3496:b0:421:2429:7e46 with SMTP id 5b1f17b1804b1-421649fbb46mr33986435e9.13.1717775445415;
        Fri, 07 Jun 2024 08:50:45 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35ef5d66cf6sm4237732f8f.49.2024.06.07.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 08:50:44 -0700 (PDT)
Date: Fri, 7 Jun 2024 17:50:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <ZmMsUYFvUOndiX8g@nanopsycho.orion>
References: <665fa9c9e69de_4a4e62941e@dwillia2-xfh.jf.intel.com.notmuch>
 <20240605135911.GT19897@nvidia.com>
 <d97144db-424f-4efd-bf10-513a0b895eca@kernel.org>
 <20240606071811.34767cce@kernel.org>
 <20240606144818.GC19897@nvidia.com>
 <20240606080557.00f3163e@kernel.org>
 <4724e6a1-2da1-4275-8807-b7fe6cd9b6c1@kernel.org>
 <ZmKtUkeKiQMUvWhi@nanopsycho.orion>
 <887d1cb7-e9e9-4b12-aebb-651addc6b01c@kernel.org>
 <20240607151451.GL19897@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607151451.GL19897@nvidia.com>

Fri, Jun 07, 2024 at 05:14:51PM CEST, jgg@nvidia.com wrote:
>On Fri, Jun 07, 2024 at 08:50:17AM -0600, David Ahern wrote:
>
>> Mellanox offers both with the Spectrum line and should have a pretty
>> good understanding of how many customers deploy with the SDK vs
>> switchdev. Why is that? 
>
>We offer lots of options with mlx5 switching too, and switchdev is not
>being selected by customers principally for performance reasons, in my
>view.
>
>The OVS space wants to operate the switch much like a firewall and
>this creates a high rate of database updates and exception
>packets. DPDK can operate all the same offload HW from userspace and
>avoid all the system call and other kernel overhead. It is much more
>purpose built to what OVS wants to do. In the >50Gbps space this
>matters a lot and overall DPDK performance notably wins over switchdev
>for many OVS workloads - even though the high speed path is
>near-identical.
>
>In this role DPDK is effectively a switch SDK, an open source one at
>least.
>
>Sadly I'm seeing signs that proprietary OVS focused SDKs (think
>various P4 offerings and others) are out competing open DPDK on
>merit :(
>
>For whatever reason the market for switching is not strongly motivated
>toward open SDKs, and the available open solutions are struggling a
>bit to compete.
>
>But to repeat again, fwctl is not for dataplane, it is not for
>implementing a switch SDK (go use RDMA if you want to do that). I will

switch sdk is all about control plane.


>write here a commitment to accept patches blocking such usages if
>drivers try to abuse the purpose of the subsystem.
>
>Jason
