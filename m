Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA614334C6
	for <patches@lists.linux.dev>; Tue, 11 Aug 2026 21:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483356; cv=none; b=UhmJ4dgCeIMaKQ4yQmMQYNynTz+Z0KXlp9UOdGI7js6RasiNtivpfp4e/PZymaShnSlzGHvaKTJNFGmmfIqjjcu4QB/QvvNed25FNe+cIcL5R5Zwt0Rt7SCEGXlyG1QMU91HndoZKbADHC7ieM60sGbg5f/l2ixZV9vg9JNW+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483356; c=relaxed/simple;
	bh=NdaLGblalh7y8lVJYv0NjjfAvsT9Ho42+c6mULsp9Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlQyk8ufZSvj3aA2kD9b4yBsqiIuNjKEH5nhTguSoVJLsEiiB8f003rSMg6WxYVaf/egBbA3nctSPj/1Wh3j3kQkYWNQxCP05/xPSkzYPD8KLhiPlLsysuFjOb5RDvRdG9T89/lTCVzj2VOhz6YFm9vzQP7NiuRM1vsydZ47uJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utCX4AmC; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utCX4AmC"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso500322a91.1
        for <patches@lists.linux.dev>; Tue, 11 Aug 2026 14:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786483354; x=1787088154; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hg+Yr9bSAREbkWFulA8TyFK9VZyeo5bqgSMI0IG+zlA=;
        b=utCX4AmCqODdjRm6eJ3wT3PE95EVdlwzsFLddONW4VDt3bJjufRw3OOIY0L9Z4CKed
         b4k6OkYAmT9PEHpkS3TkIHjAHrQDO9D1YgvwFBUZRQFACGPUA3+VoyCY0URy7TIy2N6h
         WF61j5yLzEsuQXVcLQ+v18MK+aciaLlItNRjFhM6pJvv/pnKg0QACobTN+CLsp1hwQTT
         P1eLmU/l+2L4/1y2dMnbJTXPCFyMQn5siZ0+h9fTMKVwVYT/w0GKa9gWOe8wSGttiKos
         /eKLXhhEvvs4qLaxenVzMUoCfK4cfkxSKM9iTjTYIO72uoe0vbFHTY+33MVa9hbAe28E
         gfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483354; x=1787088154;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hg+Yr9bSAREbkWFulA8TyFK9VZyeo5bqgSMI0IG+zlA=;
        b=FS5GXJm2ZjhYcWVm+pK+C4S9Pxng14sHL2xMAMhNoYOLHUdF8TEjlsdUDk54UxKpYt
         Itpi1CTrqlmjzOpy102I0LXuYL2q54fhW3NpziqFi0XB/MvYtzsuyag8/xyCTOluKMw8
         Df7eVUlwmma/0wZd7KJiKUQNRavUNcVyqjqaXV2lgYmz/SxRo38oFJZUD3HSU6w4IMj6
         KWzDih+c/n9ihD3LtlHdSxUGOkFPQKIc5T7XC9JHBZaJgxg9lbASB1XKvjuETBfV+rNz
         8UB/SOAUlqXyY+s+T1I6Nrfd98HhtegjsAeBj0qPDnulvQNXLIJPLjueOW4hHRPFGhlv
         Wz2A==
X-Forwarded-Encrypted: i=1; AHgh+Rpyb+51gU4FbWGCkNdu67WcsPKz9Qc9EpDTWDzPheHVBU1E9rwn8PYp/i2awzbjv8KeSRqSUVLc@lists.linux.dev
X-Gm-Message-State: AOJu0Ywus9w1Mks5oRe2zNj+ch9tR/rpiNigjj1QP3ezcdA5y846ZCB+
	+IKsjKc+JCjPXo/D8Vz/Ay2MHgyXWlY7eIjHxXZPkOPPA0jcF6jeDXRbY5Edbr+M7g==
X-Gm-Gg: AR+sD13xSjocVgN92kd3UJVQV4C8CnE3rReEehDDTWqDy2QEJRhG3/GsUXFCI1XUgwn
	vbj7718t/FO6audquq8jypVByCA7LxC+vgvHSrLImVaSHNDJqugscd7/YG1EaEcw+tVSNTtfi0O
	qOTJvbVkGGiPRuPCXfxGyO2MQuwKZjSWr69bqc/pWf1cWRvrr/ch1WpfZdUHbR6PEBbM1IJkchj
	dECnxAxBAnrh6lz6sTjXk/vLSdw3L/KN9MVmBDIwzWjZKAk9zf+qdVHHLbgGVkM4ZQhZaMFY3br
	aBzNEtZH4JMZXCl3VG+rzDMhx6xDrof9jC6Oz5q1u1Tkl8CfCXnMcgB1jcps1A0lOEJF7QF4yxm
	yeoGqvUbRmu+q/hcQ3UTfbiMCc2T//LdCe7KIX0ajaXK4b83eg75QattqKDiurAGZDERDjnh1ce
	wCs7BPb5uT1JFsCHioDflEx9uxJk5b3ikqzDvvJa+b8LElmr9RQ06R3wjx3iUA4YGRuk7LH4KYT
	ft3uKybcPGhEEPMKHiW0ZPcOVSA/Q==
X-Received: by 2002:a17:90b:4a82:b0:38e:101f:c867 with SMTP id 98e67ed59e1d1-392ec672d1emr6461856a91.18.1786483353815;
        Tue, 11 Aug 2026 14:22:33 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f85feb67sm1080532a91.0.2026.08.11.14.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:22:33 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:22:30 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 10/11] vfio: selftests: Add mlx5 driver - data path
 and memcpy ops
Message-ID: <anuSlnCd7NERCp4B@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <10-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> Complete the mlx5 driver by adding CQ/QP creation, QP state
> transitions, WQE posting, CQ polling, and the
> memcpy_start/memcpy_wait callbacks. After this patch the driver is
> functional for DMA tests.
> 
> The data path implements RDMA Write self-loopback via an RC QP with
> force-loopback.  WQEs are posted to a 16-entry send queue with an
> NC doorbell, and completions are polled from a 16-entry CQ.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: David Matlack <dmatlack@google.com>
