Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4714D719;
	Tue,  7 May 2024 12:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715084158; cv=none; b=S8iQGmZtEh6AGp7bkxESyTyKRqdaX5Pb8XGnmwGZjEUCa1ES5s1bm603ICgA61TsDhQPvUUpAfFKUn2G+sWOEgsQSxFw+9bHMva9kvq26ToUR/mQX0Y3xLepW5KEOoTLNoOYltMD+5aN9Am/Q/QVlnlfwxj+IfA+EnnS/WXpqIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715084158; c=relaxed/simple;
	bh=rvs6zMPvU5aU7gZj50DuWfCA/m8NhLhd7meyZNWlr9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pXmu7g2tKFXseXWxqewfcJur2HRKdoCHBPm6ldEn8Dv0sKdUiEjBp4l8IWkcHosRxT1yZAcU1PSnGP5mSkzyVxMl08vjJZ4ApbYyjoVNnDWIHIZjCLCBGC3Oh7lO4CtwRN5OdMFkvU40A+qq8PLw0HfKYvRiaMWdeP6ipkU+dDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=jcV/EbG2; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="jcV/EbG2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=RVaicM+XRXZFdcQkS3pfOapuHKIDiBxyMS5EwIBM0/0=; t=1715084155;
	x=1715516155; b=jcV/EbG2u4QQ+MHS7bMXDXAfrz47BCI5WkvEUmwfxNvrVj2PNoGTUJ63+OT7B
	u8sJVOrVyzTLNqS4HbE+nGyp1HtCyG5RYv00vQH1sn/CRSEcTNzh+QOMFdEgh6GPzkY6zPLUhpUq0
	q9x7BpviYdyjcWx3S729T/lhgOaPwR5g6HiL9GTWsFN3PtgZPKrg+A3gBINObB/JcEkFybJTDFb1E
	Nv06gRBCYlag7o0V5QNPNdwEP8jqmdBNbNbRdMb/yWMTmlTcWwgQ/geWwrG2A5J9OuqoZVYEMkWKc
	jZ0c7R25q1pP92pKrQFv9XDs/OqNbEYoOJUyr6qUI3YhVxXiFQ==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1s4Jjb-0003er-VT; Tue, 07 May 2024 14:15:52 +0200
Message-ID: <aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info>
Date: Tue, 7 May 2024 14:15:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Build error on -next: Unexpected GOT/PLT entries detected! (was Re:
 [PATCH v9 9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry)
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Moritz Fischer <moritzf@google.com>, Michael Shavit <mshavit@google.com>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: en-US, de-DE
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <9-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1715084155;9618d691;
X-HE-SMSGID: 1s4Jjb-0003er-VT

On 30.04.24 19:21, Jason Gunthorpe wrote:
> Add tests for some of the more common STE update operations that we expect
> to see, as well as some artificial STE updates to test the edges of
> arm_smmu_write_entry. These also serve as a record of which common
> operation is expected to be hitless, and how many syncs they require.
> 
> arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> to any other abritrary STE/CD configuration. The update requires a
> sequence of write+sync operations with some invariants that must be held
> true after each sync. arm_smmu_write_entry lends itself well to
> unit-testing since the function's interaction with the STE/CD is already
> abstracted by input callbacks that we can hook to introspect into the
> sequence of operations. We can use these hooks to guarantee that
> invariants are held throughout the entire update operation.
> 
> [...]
>
> +static void arm_smmu_v3_test_ste_expect_transition(
> +	struct kunit *test, const struct arm_smmu_ste *cur,
> +	const struct arm_smmu_ste *target, unsigned int num_syncs_expected,
> +	bool hitless)
> +{
> +	struct arm_smmu_ste cur_copy = *cur;
> [...]

Lo! My daily -next builds of vanilla kernel RPM packages for all
current Fedora releases started all to fail today on ARM64. I currently
lack time to investigate this properly, so feel free to ignore this,
maybe this is a false alarm and cause by the build instructions in 
the RPM .spec file doing something stupid.

But a very brief investigation made me wonder if it might be related to
the patches in this thread, which afaics showed up in -next today. So I
thought I quickly mention by problem here in case it makes anyone go
"ohh yeah, we did something stupid there":

See below for the first few lines of the error messages; for the full
build log, see
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-aarch64/07422800-next-next-all/builder-live.log.gz

Ciao, Thorsten

[...]
/usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 \
-Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
-mbranch-protection=standard -fasynchronous-unwind-tables -fstack-clash-protection   ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed 
-Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld-errors -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 \
-Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes ' ARCH=arm64 'KCFLAGS= ' WITH_GCOV=0 -j4 vmlinuz.efi
[...]
ld: Unexpected GOT/PLT entries detected!
ld: Unexpected run-time procedure linkages detected!
ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_v3_test_ste_expect_transition':
/builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x6f8): undefined reference to `kunit_mem_assert_format'
ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `kunit_mem_assert_format' which may bind externally can not be used when making a shared object; recompile with -fPIC
/builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x6f8): dangerous relocation: unsupported relocation
ld: /builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x700): undefined reference to `kunit_mem_assert_format'
ld: /builddir/build/BUILD/kernel-next-20240507/linux-6.9.0-0.0.next.20240507.458.vanilla.fc41.aarch64/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:144:(.text+0x710): undefined reference to `__kunit_do_failed_assertion'
[...]
