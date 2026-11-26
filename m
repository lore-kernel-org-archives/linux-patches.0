Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706473;
	b=PHKGrAxyd/QOSw2WTYY3bsi191r/pXi5oJwta3vKnJNsy78vxoV4XgqvuuGxeoFgkHi8
	 2759UPjYdrlmt10cxViARsjCeQuvUceouc7BUlwxTpsBNeVRzSLoiCE00BVrf7w11uIjB
	 MN6+c5umu6xDRB7Ei/XaFjvwx8NIT6G9MhD68x4+xfNgX/ShRQcf1FgBMURRF/wqzQfxW
	 OclmqWdqs6gKzFxVCAEB9jxaGFTiwcEbKhfcKTCG6MyrYRj3Ksxy/3zoOA7F88lbewTdK
	 +l4PoVQjZZDPgzfq9VN78WZStQb3G5I4hnrwD2gt5bMgNtnlmlZCQ2lviQwmN9A7jMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706473;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=LPCVK2nUqlJeOSs2RKIyxIYO2gZqoAZrPrguVsEqfzs=;
	b=pOCUaiZ7SwAzuKcaS1lokdbn65CzODK2zpxb4+6WwcbqZD0Wh3G6RdKJlHaDr9obp3Aw
	 LixgKIM+eKSe0qJuCA7jnq8E+DnOlhk7wzgKUc6vGdSmWIzhoK/eRnXPaCF2GmwaYot6s
	 Gq9+kEH1SYo8VkOg7YL+fdAWIhIm+Xue0aQ6rof1/wUP2crWpgTZssbFgJtRIKcJIvJQv
	 R/p8WDop2FNyRs1O8yRGRkLE3E/L/bEnlDJO1bq4frY838WkRtkQYXGpCwxoWapks6w+q
	 4Md64j0vzkGRAYfqYLxTTVMSpcuC084x2poFQBpXieErs74R0KOcCD9GTJOdghudmaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=B9qjo5kJ;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD9C606A31E;
	Thu, 26 Nov 2026 15:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBD9C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=B9qjo5kJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LPCVK2nUqlJeOSs2RKIyxIYO2gZqoAZrPrguVsEqfzs=; t=1795706471; x=1796570471; 
	b=B9qjo5kJad71kR/OssxJlLOQgD5zBNxDB4RhdGlfacNeMIOo95GQStWgCJ1pxxVjqmFjWwxRi+1
	FcYNs9s4J+ztWfZAhJLMlLd4o7ls1y0GKNCE2QVvdTiNoUHk/OFFH7XGgYtMzlmIvb4GJmhwzd7QL
	CepB8Ad61AMRHQ8bNKEOGE422YOJYY+RXJ+gkCgZu86ViEt4dO3VQ4M7SZgzUoN7vIAAS86UJ4Hrt
	0LlFCd9tDGALIf0LUkjM400JHjEt0mx0A/6aMnBodfN1yA4i2aPoK8MOjTi+XvIi9T/bNYNrTzCVx
	bLq3VK8f2w5NR3lGU9mU13Jbw7+44lloC1vQ==;
Date: Thu, 26 Nov 2026 16:21:03 +0100
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
Subject: Re: [PATCH 5.15 000/319] 5.15.227-rc1 review
Message-ID: <awhOX69A7DAA_-UX@karahi.librecast.net>
References: <20261126144006.732901931@linuxfoundation.org>
 <awhK_0exBWstjZw7@karahi.librecast.net>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awhK_0exBWstjZw7@karahi.librecast.net>

On 2026-11-26 16:06, Brett A C Sheffield wrote:
> On 2026-11-26 15:36, Greg Kroah-Hartman wrote:
> > -------------
> > Note, this is the LAST 5.15.y kernel release to happen.  After this, it
> > is end-of-life.  You should not be using this kernel tree at all, UNLESS
> > you are an Android system.  If you are running Android, please go get
> > your 5.15.y updates from Google's public kernel tree after this release
> > for any "important" bugfixes for that platform as they will be keeping
> > it alive for another year or so for their specific platform
> > configurations and then it will wind down. But really, even Android
> > systems should have moved on by now to a more modern kernel...
> > -------------
> > 
> > This is the start of the stable review cycle for the 5.15.227 release.
> > There are 319 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 28 Nov 2026 14:39:40 +0000.
> > Anything received after that time might be too late.
> 
> Build failure:
> 
>   CC      init/do_mounts_rd.o
> init/do_mounts_rd.c: In function ‘rd_load_image’:
> init/do_mounts_rd.c:277:9: error: implicit declaration of function ‘init_flush_fput’ [-Wimplicit-function-declaration]
>   277 |         init_flush_fput();
>       |         ^~~~~~~~~~~~~~~
> make[1]: *** [scripts/Makefile.build:289: init/do_mounts_rd.o] Error 1
> make: *** [Makefile:1925: init] Error 2

There's only one commit that's touched that file, but here's the bisect log
anyway to confirm:

git bisect start
# status: waiting for both 'good' and 'bad' commits
# bad: [a9da0b4a13a74d7a1467763436363f282daf1dc3] Linux 5.15.227-rc1
git bisect bad a9da0b4a13a74d7a1467763436363f282daf1dc3
# status: waiting for 'good' commit(s), 'bad' commit known
# good: [4f2df9a01754521fbba3493e8ad91ef65515e68c] Linux 5.15.226
git bisect good 4f2df9a01754521fbba3493e8ad91ef65515e68c
# bad: [47697c180afc80509e5e97988d4d89752e2c2a0b] igmp: use the joined device when leaving a multicast group
git bisect bad 47697c180afc80509e5e97988d4d89752e2c2a0b
# good: [742f6ce280227e06c5733ff398d06ec3493dab21] nvmet-tcp: limit the connections accepted per work run
git bisect good 742f6ce280227e06c5733ff398d06ec3493dab21
# bad: [6b9cba97bd3643bcc6e34d5a820a4355b6338aa9] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
git bisect bad 6b9cba97bd3643bcc6e34d5a820a4355b6338aa9
# good: [61c45b12bc4686b73eebba53ce4c21cc294d4410] ALSA: hda/core: Stop capability walk on empty capability header
git bisect good 61c45b12bc4686b73eebba53ce4c21cc294d4410
# good: [4ce5f905314dc6434f6f1aa3f2d24c7de0d17076] MIPS: Avoid dead code/data elimination when using recordmcount
git bisect good 4ce5f905314dc6434f6f1aa3f2d24c7de0d17076
# bad: [d72db6abd57295c6353918412ce527de32d317a5] include/linux/fs.h: add inode_lock_killable()
git bisect bad d72db6abd57295c6353918412ce527de32d317a5
# good: [c2f40975285feab0a3a0733a193290db0f941a52] MIPS: SB1250: Validate and update IRQ affinity
git bisect good c2f40975285feab0a3a0733a193290db0f941a52
# bad: [099ed898765127422a634c2768820b3de329ef5d] vfs: preserve subsecond timestamps at filesystem time limits
git bisect bad 099ed898765127422a634c2768820b3de329ef5d
# bad: [f1311182306c2b85f4724cb776467034a36baaa6] initrd: flush deferred fput() before mounting root
git bisect bad f1311182306c2b85f4724cb776467034a36baaa6
# first 'bad' commit: [f1311182306c2b85f4724cb776467034a36baaa6] initrd: flush deferred fput() before mounting root

Confirmed that reverting f1311182306c2b85f4724cb776467034a36baaa6 fixes the
build.


-- 
Brett Sheffield (he/him)
