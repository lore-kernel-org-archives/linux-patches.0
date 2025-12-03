Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49432FBDEC
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803280; cv=none; b=HvgXRChvbIEth/5F25LlHCpE+rWrJrSH1T2C9DVTiIGAOIdOGyYIalyLP5WCyIOlkH/8HLi9ToFx21nE5M4SDZJpXMR3pAdGx1AFbHNCig14oo+cbqA3GrAiwcMYy82uuEuf154lr371LjykinyzbkQcXhIKQ5ML5IgLht8LIMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803280; c=relaxed/simple;
	bh=Eoet59v9NDM9yExmyw7/HLdX9sL//OyFUJBCjmIUPVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=DTzxRBI7s+2xbOxA3kxB6bjnzdoCyxDKowW/O7vVFKD5PyUZWkpBzD3zMOeXUITweYsM31OKr0W7XyPLwv/Vy8ZRCBBSItByCayN86imSyXuMrzpVZCjf9vn1FgnTI3YyWS2tq1GWqD9p0JdaiIZ91aiQQNPaJIEBI4e1lQEIME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=d1vjTj3l; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="d1vjTj3l"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7B4442120E8B; Wed,  3 Dec 2025 15:07:58 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7B4442120E8B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764803278;
	bh=FufHA6vatTicfZXYwuk8Js4jZIlb8UU96Vkg54BVm/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1vjTj3lAHATAjXojlKgrsc3D+b0oviFCf196aJamPh3YQqULDHcEYIEAGryI9gUS
	 e5JaU7gWFKkfdFV1XyZ/IhK0yUGrBuWJXbxOcd67bFzkOVsgz9RLrZhkup70xMkCqY
	 neDBGxqsYqG+stByS327KKh/grtdmH29a2Cw6Dqk=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
Date: Wed,  3 Dec 2025 15:07:58 -0800
Message-Id: <1764803278-18393-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Build error on arm64 Azure VM:

In file included from /__w/1/s/rpmbuild/BUILD/kernel-source/tools/include/linux/bitmap.h:6,
                 from ../lib/bitmap.c:6:
/__w/1/s/rpmbuild/BUILD/kernel-source/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
   14 | #error Inconsistent word size. Check asm/bitsperlong.h
      |  ^~~~~
  CC      util/smt.o
make[4]: *** [util/Build:299: util/bitmap.o] Error 1
make[4]: *** Waiting for unfinished jobs....
In file included from tests/bpf.c:5:
/usr/include/sys/epoll.h:134:12: note: in a call to function 'epoll_pwait' declared 'nonnull'
  134 | extern int epoll_pwait (int __epfd, struct epoll_event *__events,
      |            ^~~~~~~~~~~
make[3]: *** [/__w/1/s/rpmbuild/BUILD/kernel-source/tools/build/Makefile.build:143: util] Error 2
make[2]: *** [Makefile.perf:658: perf-in.o] Error 2
make[1]: *** [Makefile.perf:238: sub-make] Error 2
make: *** [Makefile:70: all] Error 2

Build error on x86 Azure VM:

In file included from /__w/1/s/rpmbuild/BUILD/kernel-source/tools/include/linux/bitmap.h:6,
                 from ../lib/bitmap.c:6:
/__w/1/s/rpmbuild/BUILD/kernel-source/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
   14 | #error Inconsistent word size. Check asm/bitsperlong.h
      |  ^~~~~
  CC      util/hweight.o
  CC      util/smt.o
make[4]: *** [util/Build:299: util/bitmap.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [/__w/1/s/rpmbuild/BUILD/kernel-source/tools/build/Makefile.build:143: util] Error 2

Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
