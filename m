Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587408;
	b=PKLYHbYbhb3NMvVYx2eGHJuXIdUIkNnC1Sg/PIEaKumRce6TJ+8E4pzHaKQUEVdw1HhV
	 eq+hBdu6gbsxqZ4iNxkWsI49v17YUbMj2ZKeSGWeIHnnVEWS7Pt0Jy1sFfIBGq2SoENTv
	 sNrttVMUaMgjZK4a3LfHPmfeYTrbMISlWQYuKS6834wfbEA5f5v2SnEVFw1MkpBi8WTG3
	 nM8GIkTbN+K0D/DDJKJOVVACHIUwBSVb392Mn+g5SbTyzHkpqJEYvEq9ohgUN7rOOMa80
	 doOTZ0gyqMyUjAMITKnWOTLcVo1zOrUmfO7MEHgjKXTVu5jNNU+pqoJ9x0fiPaWCXzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587408;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=a05Jwt0oapSs87PUiPXzFARGVbE8ZS0hpaEyecn5Jt4=;
	b=MfcyjmFZKreqLXI6jWAKaBKv4Q2VaX0mdgqARc3I1Q41yQ44fovEbbJx5x5u5LW0c/qP
	 pyi5tlvdbgld6hfCAOJz/vmB93CzE6k84XetpfCJVEs6KlyReOlboGgiQ1S057t4XGETC
	 Uj4ogIf0TjzRij9MucV+rslFNvxNe/acawVC1ERGBDXJW3WCDPeGLx1300wUUuDlkQagM
	 Tu2yN4KmVcKQTv5Gm1niToc2hjuvs2AogbQcheBWIB8gFThknNBcanU0EHI5IvWodRq3n
	 BFhvDLnlc/gaYxkjZs9fMeJ2xv2LFT5pOmGbkwj0k1/wFzh/S/alyJm+Wxux4xksphg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oezRNjfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123F0606A88A;
	Fri, 13 Nov 2026 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oezRNjfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E5E1F000C4;
	Fri, 13 Nov 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794587407;
	bh=a05Jwt0oapSs87PUiPXzFARGVbE8ZS0hpaEyecn5Jt4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oezRNjfBcdX3wZ6PgVIapUnriVLVMyDxIIdKaQ43cul0OGsvkWYMIveRRbnhvh/Wz
	 aZOlQlcELBiCq1EJ0RcSSr8G9opKYtl9m1f7wVEzpJoekXKoxs6sAT1jSUSZjiyRo6
	 T1ekeyePC1u1jMKsoLNiH/+bYEDB968llEU49FG4cJI1jlLQOBoFgxbZrk1gc18IUk
	 hKF6yA0afzbdP7H3XYAvB1xJuyuLE7mBRYX146THajTHRFj6njtasNoCJhiS+HDL3f
	 xy029+t01kKqQjB72FHQL4WuYNH378tAHJPJYDAauYKoFzDcelHORQtLHhedmnlBaF
	 GDad5WN8G/1+A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>, "Reshetova,
	Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian,
	Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>, "Edgecombe,
	Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot
 zero and establish streams after acceptance
In-Reply-To: <20261113145249.GA3706007@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com> <yq5abj7tm7q4.fsf@kernel.org>
 <20261113145249.GA3706007@nvidia.com>
Date: Fri, 13 Nov 2026 21:59:56 +0530
Message-ID: <yq5a8q2wn18b.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Fri, Nov 13, 2026 at 02:24:59PM +0530, Aneesh Kumar K.V wrote:
>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> 

 [ ... 150 lines skipped ... ] 

>> BTW, this proposal does require RMM changes. I have also omitted SPDM
>> 1.3 multi-key support from this diagram because it will be easier to
>> follow once the SPDM 1.2 flow is clear.
>
> IMHO, leave everything alone as is today. We can make it work well
> enough as is.
>

Could you describe the flow you have in mind? Would we restrict
everything to slot 0, without allowing userspace to select another slot,
as this patch series does?

>
> Make a ECN for a 1.3 opt in broadly like the above that fits better
> into how I sketched the kernel uAPI. Do this once we all agree to the
> new uAPI. The kernel will always try to use this new mode if RMM
> supports it and userspace gets a better 1.3 experiance.

I'll reply to this separately to avoid confusing it with the flow we are
trying to upstream without firmware changes.

-aneesh
