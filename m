Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE22953E18;
	Tue,  7 May 2024 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715086521; cv=none; b=u78ON5nt4q8B1d4zlE5mj/uQqpiE9ZMCE7emYJXlNbm9JzLDj2aqWwythu5zTAlB6S04BqDPb2XUlGAwGP81NfonXjRIpYGRG3L5Gqh6BBLlhEj/o4+k4SnOYsMHmljhqOctwHzhgTLZSjtmsQDUNwpj3dHK+b3uffSDVeAVfyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715086521; c=relaxed/simple;
	bh=GovtL26z0dynz0gsr8OxVZGCQxL/xlw+mALGp/zzkes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SH3mOp47HD20yCRra6si9WjPiCn49ZDCQJyAWJj+wIwTSXSkqUr6sVEgOizN8s028tQnPcwJr34UWtn78gWOSUuqVq68dU4W6hGQGLgvgS9kd8Sa7fKmAU68pdNaak9+SpCcEf3LfQBDDlhqRbTbHHtzpNnHwTxURI6KfyNizrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=lmO9wPwd; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="lmO9wPwd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ES1ZQRLMgFTcBN79n1CwBZhWvJ0hzyo/xnanjpamae4=; t=1715086519;
	x=1715518519; b=lmO9wPwdoEDj+g66so3q5Cb5833F38LnQdnrYFEf4CCqPleXAG7iISCZL1WpU
	y19Nk/CFx7pE5c+hdQajCH1cVZit0gHhPuNE2C/ofYfAkbULXSv09jH3C5znziecUihJOqORwcOhf
	OQ1HfpF9lGJRGV9EgySbzervdgZD/6BqWo3zdz3VSuLmIx1UoJS+cWAN8ueTXdH40b7Zn3hUV7jQ9
	SeRuuRg/aBGmZ59+UmfkzZ4DzjUwJAsoGHcpD0VSYEimCVXTbNPvLFNcFzAXI/ricUeANelvXPFK9
	X6WezdGSiR3tclvv0TulgCMcSWEtuJV0wkKNVprLLaqc0H9f+Q==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1s4KLi-0003Lq-01; Tue, 07 May 2024 14:55:14 +0200
Message-ID: <b276b76a-1b71-475b-b5ca-a07e7d8d9e52@leemhuis.info>
Date: Tue, 7 May 2024 14:55:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Build error on -next: Unexpected GOT/PLT entries detected! (was
 Re: [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry)
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
 Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info>
 <20240507124134.GN3341011@nvidia.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: en-US, de-DE
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20240507124134.GN3341011@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1715086519;980fd8b1;
X-HE-SMSGID: 1s4KLi-0003Lq-01

On 07.05.24 14:41, Jason Gunthorpe wrote:
> On Tue, May 07, 2024 at 02:15:51PM +0200, Thorsten Leemhuis wrote:
>> On 30.04.24 19:21, Jason Gunthorpe wrote:
>>> Add tests for some of the more common STE update operations that we expect
>>> to see, as well as some artificial STE updates to test the edges of
>>> arm_smmu_write_entry. These also serve as a record of which common
>>> operation is expected to be hitless, and how many syncs they require.
>>>
>>> arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
>>> to any other abritrary STE/CD configuration. The update requires a
>>> sequence of write+sync operations with some invariants that must be held
>>> true after each sync. arm_smmu_write_entry lends itself well to
>>> unit-testing since the function's interaction with the STE/CD is already
>>> abstracted by input callbacks that we can hook to introspect into the
>>> sequence of operations. We can use these hooks to guarantee that
>>> invariants are held throughout the entire update operation.
>>>
>>> [...]
>>>
>>> +static void arm_smmu_v3_test_ste_expect_transition(
>>> +	struct kunit *test, const struct arm_smmu_ste *cur,
>>> +	const struct arm_smmu_ste *target, unsigned int num_syncs_expected,
>>> +	bool hitless)
>>> +{
>>> +	struct arm_smmu_ste cur_copy = *cur;
>>> [...]
>>
>> Lo! My daily -next builds of vanilla kernel RPM packages for all
>> current Fedora releases started all to fail today on ARM64.
> 
> Fedora enables kunit in a production kernel????

FWIW, I'm just a interested Fedora downstream party here that uses
Fedora's mechanisms as a base for daily -next builds.

But yes, kunit is enabled by default. All the modules then then go into
a sub-package that is shipped, but normally not installed.
>> I currently lack time to investigate this properly, so feel free to
>> ignore this, maybe this is a false alarm and cause by the build
>> instructions in the RPM .spec file doing something stupid.
> 
> That's surprising to me.. this has been in 0-day for months now and
> it's kconfig randomizer didn't hit this combination.

Wild guess: maybe the Fedora stuff that generates the kernel
configuration does something odd that later confuses olddefconfig to let
this pass?

>> /usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 \
>> -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
>> -mbranch-protection=standard -fasynchronous-unwind-tables -fstack-clash-protection   ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed 
>> -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld-errors -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
>> -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes ' ARCH=arm64 'KCFLAGS= ' WITH_GCOV=0 -j4 vmlinuz.efi
>> [...]
>> ld: Unexpected GOT/PLT entries detected!
>> ld: Unexpected run-time procedure linkages detected!
>> ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_v3_test_ste_expect_transition':
>> /builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x6f8): undefined reference to `kunit_mem_assert_format'
> 
> It is because your .config has kunit as modular but smmu is not. I
> thought the kconfig prevented that in the usual way, but I see it
> doesn't work :\

Ohh. And thx!

Ciao, Thorsten
