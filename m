Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A851538E8DC
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789287298; cv=none; b=uqO46FU1HujdoR4go192SPuTF1uD91wXK8ndfbHGe5tVX3xDR7xDZ0oRWIRAOzwQSOdrNXMdVeelbPZEMzCUrqTyN1+K9IHRFeHTTReE/OYH0YN3daG/hs/uqtcAygsNkVXEaRfG2nEUTWvtG7hJh9gtVOvPx9son+USjOnDbXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789287298; c=relaxed/simple;
	bh=m5swu6BEex9V5AaPMHfNsr/iBf+bVORmSIXFDz+GKk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=If8tK8QQ719YEi8inQG1igvlRvB3FofwNRxflT9b/iE9kxv/LXcQtL2O/EDTYxbPHb2zMRpEPBE5FKwwoC4aIdmbZUROPk8EKCug5SecRTz6yRbksso84ffUaLzfqCFUizmPW0NqNGpyeYT7vUQyWQOorNg8/XRdOG06Tda0pWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ECszoUmK; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ECszoUmK"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 78F1F1FA4C;
	Sun, 13 Sep 2026 10:14:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1789287284;
	bh=SFvb+Qhfs5IVjsdclCKp9xV59tobJTv2o9FsR4gXA+8=; h=From:To:Subject;
	b=ECszoUmK+2dQV2l5wnwH2qM4K7AXvUb7xu8X/9ZsT48QT2R/PkrWXeevl3zuBAo/n
	 RB/wt9mWMSiobtJ+TvymjfPF6+VKftGCXg+tNw+qVfTKZK/zpoxoQMnbk2CB6+XHUO
	 10DE+NxdjFJCd0z0QWFJwXpT9c8cnqjmMqgTOJowH6v/wwsElAHyFydIuGQkR+zg48
	 M4sUHutVbZcTeCgZuXkjYI61rzw9SzNQNdrj3BMGf1LKrL0LIdAwU9wqsHCdl3H55+
	 /fWpbFPdRaAnfta2xD7l1BrP27RfVljzHIsdFYzJDZUXhpHeeRMz95hmVlMIB4TtPu
	 lsLbIngD1VuSg==
Date: Sun, 13 Sep 2026 10:14:39 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
Message-ID: <20260913081439.GA8024@francesco-nb>
References: <20260912065548.086904252@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>

On Sat, Sep 12, 2026 at 08:45:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.1.188-rc1 fails to build for us: the tools/perf host build breaks

  | util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:14:10: fatal error: linux/unaligned.h: No such file or directory
  |    14 | #include <linux/unaligned.h>
  | compilation terminated.
  ...
  | util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h:13:10: fatal error: linux/bitfield.h: No such file or directory
  |    13 | #include <linux/bitfield.h>
  | compilation terminated.
  make[4]: *** [.../tools/build/Makefile.build:96: .../util/hisi-ptt.o] Error 1
  make[4]: *** [.../tools/build/Makefile.build:143: hisi-ptt-decoder] Error 2
  ERROR: perf-1.0-r9 do_compile: oe_runmake failed


  [PATCH 6.1 0302/1191] perf hisi-ptt: Fix PTT trace TLP header parsing
  (upstream commit 2b8a2e5d4240 "perf hisi-ptt: Fix PTT trace TLP
  header parsing")

I would drop this patch.

Francesco

