Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793220261;
	b=q1d81OwFVSr8wtr6OD7vWYsjGCcQw1upEA8jIPlykjUSlPV3Q9lT9ItwDf+LwlHOORX+
	 aKqbFCv64GLz8NUSZ3pgX3dJMTtMea06rxIOaQduqXa5Nq6/QqwOnay5FapLTxd8Pi9qv
	 M/cLGX8YnycePYhCjuELB+4pp8TErNWKRor3sRtJcNru861FpVXbVdXVE3RF9KyvIE575
	 GFS1a+Fq+7EE2Ou8lRv4xd7qmoVG3Y8OibyN6h5p5Bp+xnPKie9WpxMdr13HbrKbk2w7i
	 AO94VRGVvB+MybBs6XWwlb/0Bp5PWT8DrhFmPWR/0RnklDLninVsc+Li3DHgZxTrknQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793220261;
	h=DMARC-Filter:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=g+Rym2cDLBRRDNbSlQFoptvg30+FcJygQ4+cHMDKrAI=;
	b=Vxqd06/toVt1LJ6jRGXTACatDphnF7o9e85dW3tM7YQ1FAVhKC3kJLJKXRk/+w74r/9H
	 qijzKf8vfj6iQSt3y4dcV3q+6ZNOGN7M6uAXKOyTqhOFmzqcW0kd8VQv8NyPFweYBVaGV
	 f+ngOjdn467nuxdMWt2BfnHMfbBqPNsaTlvKnaYhQRWZkXf5oLw63lugrgs59CBgpe74B
	 iRBu/UVDeVBzW/iNAqphErAM/dziQR456wWnnA1qgaEl6IkEdvX7EsJqB79sRmkJ8rG7f
	 sYpshvUi51PabS0NkC4tR53Tu/RUV+XQtRLcJoIDvEfioq+pdMBteXvQT85jKK+8EQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85A606A31A;
	Wed, 28 Oct 2026 20:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD85A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Wed, 28 Oct 2026 21:44:11 +0100
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
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
Message-ID: <auJem0IIOw9Ibiw-@karahi.librecast.net>
References: <20261028170459.200466217@linuxfoundation.org>
 <auJTCcqMDEmAS7Q_@karahi.librecast.net>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auJTCcqMDEmAS7Q_@karahi.librecast.net>

On 2026-10-28 20:54, Brett A C Sheffield wrote:
> On 2026-10-28 17:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.191 release.
> > There are 1887 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Build failure on amd64 with amdgpu:
> 
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
>   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
>   AR      drivers/gpu/built-in.a
>   AR      drivers/built-in.a
> make: *** [Makefile:2040: .] Error 2
> 
> No time to bisect just now but will try to have a look tomorrow.

Fortunately it was a build failure, so I just left that running:

git bisect start
# status: waiting for both 'good' and 'bad' commits
# bad: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1
git bisect bad adc8e434cf08c73b0f02dab2c15319315f07172f
# status: waiting for 'good' commit(s), 'bad' commit known
# good: [85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e] Linux 6.12.114
git bisect good 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
# good: [0e1dbd1409918dbd331cd9c382ce64736dcf3272] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
git bisect good 0e1dbd1409918dbd331cd9c382ce64736dcf3272
# good: [617f27c3fa85742e9d468a2145e3676af6b2498d] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
git bisect good 617f27c3fa85742e9d468a2145e3676af6b2498d
# good: [1476a3a7d286ad7763025337f20bb841b24c72ea] io_uring: don't pass restart error codes to userspace
git bisect good 1476a3a7d286ad7763025337f20bb841b24c72ea
# good: [be00113e49ff42c2c007993dd05cf4bdd1c2bfeb] keys: Protect the type name while describing a key
git bisect good be00113e49ff42c2c007993dd05cf4bdd1c2bfeb
# good: [6270098a65994bdf26b736b2ad6614e5b9078ad6] coredump: hold RCU while releasing parked threads
git bisect good 6270098a65994bdf26b736b2ad6614e5b9078ad6
# good: [41af0a793777ede3f1839bcd8abae92a5c901fe4] fork: release the files of a failed fork after sched_cancel_fork()
git bisect good 41af0a793777ede3f1839bcd8abae92a5c901fe4
# good: [6da107042aaa43b05f4c16bee65afc2e9b5f7561] signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
git bisect good 6da107042aaa43b05f4c16bee65afc2e9b5f7561
# good: [da1419eb5d34caf39c1f3abad5b95a601a35114f] fanotify: Fix crash in fanotify_init(2)
git bisect good da1419eb5d34caf39c1f3abad5b95a601a35114f
# first 'bad' commit: [adc8e434cf08c73b0f02dab2c15319315f07172f] Linux 6.12.115-rc1


-- 
Brett Sheffield (he/him)
Librecast - Decentralising the Internet with Multicast
https://librecast.net/
https://blog.brettsheffield.com/
