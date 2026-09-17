Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF03F497396;
	Thu, 17 Sep 2026 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673747; cv=none; b=urRiE/GsUnot1ykAh1x6XbQuL40GyHXZHg//CIKpohpApwdAvhkObrr2ifLiAR2H8cC0q7vBNjQKWPkW4xY4eL5d+V1yeLYo79VOtCzC2tVFm7SmUUG3fUlYShDl5YpWi0NOp42ObADO+pJGdVcAMBAJrGDgDCv66A2tm6vezG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673747; c=relaxed/simple;
	bh=omY/NeZCi/3VxuAc6JP30WeLJ3esTsutz1YtUvdbJYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKOa3gf84cFhRsiGmZseyfvp+khuTk0Wr2bZyAOMAsN4+BFYBYO2NNti/gF40GXp5ZFQXEt+ijJVj+7iv93nYtbrviBjwKJu4+2W6lz4BB4McEQ1cMz7Jeak5t53/1fit5YB3yEQRY/s+oOcplITMAn9fke504uO479+J//o5IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Thu, 17 Sep 2026 19:35:34 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
Message-ID: <aqxBBu5GXVhHcqTz@auntie.librecast.net>
References: <20260917151539.408551884@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>

On 2026-09-17 15:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.111 release.
> There are 1102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:13:49 +0000.
> Anything received after that time might be too late.

6.12.111-rc1 hangs on boot on this machine (AMD Ryzen 9 9950X).

Bisected:

git bisect start
# status: waiting for both 'good' and 'bad' commits
# bad: [18db24293f4d9b64614e0adf6dbe298073aa8860] Linux 6.12.111-rc1
git bisect bad 18db24293f4d9b64614e0adf6dbe298073aa8860
# status: waiting for 'good' commit(s), 'bad' commit known
# good: [fa5b06866b643cce7072a4e7c6be7ee3f0f1b95c] Linux 6.12.110
git bisect good fa5b06866b643cce7072a4e7c6be7ee3f0f1b95c
# good: [06d602e1997cdab008184b921c752f5b07fa16ef] Bluetooth: btintel: bound firmware ID by TLV length
git bisect good 06d602e1997cdab008184b921c752f5b07fa16ef
# good: [a126d69b9dd9f2cbd25d1672053851ae90ec549b] accel/ivpu: Limit firmware log name prints to field size
git bisect good a126d69b9dd9f2cbd25d1672053851ae90ec549b
# good: [efe1f0c0257ae22c17fab4f1b55c1863a4d5bd98] ipv6: add some unlikely()/likely() clauses in ip6_output.c
git bisect good efe1f0c0257ae22c17fab4f1b55c1863a4d5bd98
# bad: [8a1320dc29ad21696ba7f0aa99a3fabf295e74c5] NFSD: Prevent client use-after-free during delegation revoke
git bisect bad 8a1320dc29ad21696ba7f0aa99a3fabf295e74c5
# bad: [5e4974a45323fd751aabfdd78c04457d231ac126] mm/slab: move and refactor __kmem_cache_alias()
git bisect bad 5e4974a45323fd751aabfdd78c04457d231ac126
# good: [562e14e2bbc8c9ad3c72c193a3afadc3a0cc1527] KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests
git bisect good 562e14e2bbc8c9ad3c72c193a3afadc3a0cc1527
# good: [4eaf9e48d2a7b9a5067206d54ae260c0292d595f] mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
git bisect good 4eaf9e48d2a7b9a5067206d54ae260c0292d595f
# bad: [091b6f51c9330d9e2cacb8d6e4ab3e6e2e8d93fe] mm/mglru: reset page lru tier bits when activating
git bisect bad 091b6f51c9330d9e2cacb8d6e4ab3e6e2e8d93fe
# good: [8417718d642fbef80df65fb3369c3fc4b38cdbdd] pidfd: hold exec_update_lock around namespace ioctl
git bisect good 8417718d642fbef80df65fb3369c3fc4b38cdbdd
# bad: [22ae428b0045981bd19f8c75f700a67198062f32] mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
git bisect bad 22ae428b0045981bd19f8c75f700a67198062f32
# first 'bad' commit: [22ae428b0045981bd19f8c75f700a67198062f32] mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier


Brett
