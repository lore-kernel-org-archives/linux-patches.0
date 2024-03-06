Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35A663AC;
	Wed,  6 Mar 2024 01:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709686908; cv=none; b=d9h7Jt4ZHUipsa4rf26b+aG21M/Iiy7ZZUUbRgzKlkCJvswYyxK4zdmVg5omlAoIvyYL8gfo/MGFHvxbPMrHJ+Up8DQLQUL7EMhAZYjuNlbza87Wuop1bfVoN5eMZkXy2z3bRs4GW25JLY+LXUq4k6phQf4+JMQBkcR+6J5qvVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709686908; c=relaxed/simple;
	bh=5/ZcX9ajZLf4owQGJwX2dlOzBzGOssvyw5Rcw44gWks=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Pe5f40qDVKaKCmBkz7BH1cyiBgr48FdG5oBG0d+bJFHu3brKioWuMohh3WUVx9joVVAxSzAk+9z5cwd6K6HN6oWse+cV/2VYU01IfFZPm0lVnkJVORKhPGrpOOvDQPz3gAAScgRcBDLFHT7h7ADWK/SVzGpJ9IuSzWhPcb3+v6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=NOLu9Nd0; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="NOLu9Nd0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1709686905;
	bh=YmcB4bK+MAKOOiOWr/fno4pQrOdfHy3DeEfNvA3NQaI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NOLu9Nd0MJ7pHaMczG24P2AAIjuQhVM3wPtp80cRNUCsBxFuSbZi0rDg8RCJBLKNb
	 XFRzYoSHM3yALoOIr/THxV8/0FuBguR6Vw/I+aqE+cAOBTQWsqEzKwwuhpJ9+IHrpA
	 ju3TWGuhoA0jqbHyAZdTmfzhuopD/JXB+zzZuTG+/vdc/dSRd7hcLWxt+6N9pX2xC0
	 uW4QiRWZncUEoTDNcuOcaOsRjuVp965laKOqAwu2ynMQcFQ8KESP9blQkn9wOOijpi
	 Zrs1DUqcfyz813+tLqBkYHLuGgEysiDhfYakRkusLJe+/O8f4nzAthwOcf1XGuU3qz
	 VUhL8TZ4n22GA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TqDfH2BRXz4wc8;
	Wed,  6 Mar 2024 12:01:43 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, morbo@google.com, justinstitt@google.com,
 linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev,
 llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: xor_vmx: Add '-mhard-float' to CFLAGS
In-Reply-To: <20240305224315.GA2361659@dev-arch.thelio-3990X>
References: <20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org>
 <20240305224315.GA2361659@dev-arch.thelio-3990X>
Date: Wed, 06 Mar 2024 12:01:42 +1100
Message-ID: <874jdkp409.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Nathan Chancellor <nathan@kernel.org> writes:
> Ping? We have been applying this in our CI since it was sent, it would
> be nice to have this upstream soon so it can start filtering through the
> stable trees.

Sorry, I was away in January and missed this. Will pick it up.

cheers

> On Sat, Jan 27, 2024 at 11:07:43AM -0700, Nathan Chancellor wrote:
>> arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
>> powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
>> error when building with clang after a recent change in main:
>> 
>>   error: option '-msoft-float' cannot be specified with '-maltivec'
>>   make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1
>> 
>> Explicitly add '-mhard-float' before '-maltivec' in xor_vmx.o's CFLAGS
>> to override the previous inclusion of '-msoft-float' (as the last option
>> wins), which matches how other areas of the kernel use '-maltivec', such
>> as AMDGPU.
>> 
>> Cc: stable@vger.kernel.org
>> Closes: https://github.com/ClangBuiltLinux/linux/issues/1986
>> Link: https://github.com/llvm/llvm-project/commit/4792f912b232141ecba4cbae538873be3c28556c
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> ---
>>  arch/powerpc/lib/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
>> index 6eac63e79a89..0ab65eeb93ee 100644
>> --- a/arch/powerpc/lib/Makefile
>> +++ b/arch/powerpc/lib/Makefile
>> @@ -76,7 +76,7 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
>>  obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
>>  
>>  obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
>> -CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
>> +CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
>>  # Enable <altivec.h>
>>  CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
>>  
>> 
>> ---
>> base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
>> change-id: 20240127-ppc-xor_vmx-drop-msoft-float-ad68b437f86c
>> 
>> Best regards,
>> -- 
>> Nathan Chancellor <nathan@kernel.org>
>> 
