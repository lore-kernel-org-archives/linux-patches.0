Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8726349CFC
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784701172; cv=none; b=Ug1QhvWwFvQEqWjp7PrF4wefAMScXwfcxd3y/RHGu5lII+4afae3WcA4k+AsA/q0keOjq7TZxyapGgj+RRJqjyTjbD3F4YbgtKyyiAJcTBhlnLOFO8aFYEjad7XZDCQ5jB50q2gg97Bn3RrMoaIz16tZDLkZke6ZkNfswq9UPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784701172; c=relaxed/simple;
	bh=Qpb1d0GHzL+G9TS01THPckd47t2UjVveIGe2QMKwZoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6BQ7wAPPgj44fAnpT5W1xQXt6n1aGo+0seEdQJLg/FFbuWbV9ku5kofCV1iGd/YpxF1NwjcurTt8yLJdtrW4DcN3vna5LX2V4xo1Y767VfMM1l8Q+qDKC4i9XU/l387eQPNSI8I7R0VeXzQSkZc9C0WnEBhSMKpwRildYF3u6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=FGiiRsX5; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="FGiiRsX5"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 55C5C225A1;
	Wed, 22 Jul 2026 08:19:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784701165;
	bh=87GBEGH3PZuqoJt/vIk8qatkLNReNHzHh1+GVFWo3o0=; h=From:To:Subject;
	b=FGiiRsX533owCRCIktZkn7h97SYpEf4/usmlyWLJqiDwqNGTZfl4KZgadKKpVRoJ/
	 FFxBwJV1d+buZtfF3WwnbHM8z0kauSb3nA+CNt8SkqXEYwc6oJPkpZCOGAyAwG4tnL
	 ZH05TnKRW/AJaBKn0O36zHNHVESk0V2xYVIhKNaMNSK97LteM7QNga9CKog+p/59qA
	 CS7T6EbNSEzuHazAmSXaDQ6DiwmBPL24i0PHPla3NjiCKfvtoyq1sA/ye5ETDLU1w7
	 cP3rTeI7KfxV1VM/Us8G5T4ZMHzn2Yt2zIznuvdaee/0TshkD5vuF12JvDTFL20RTd
	 O0jWKQ22er76g==
Date: Wed, 22 Jul 2026 08:19:21 +0200
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
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
Message-ID: <20260722061921.GA23972@francesco-nb>
References: <20260721152424.521567757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>

Hello Greg

On Tue, Jul 21, 2026 at 05:10:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

It does not build to me.

file_offset in struct perf_sample missing?

07-21:17:58:43  |   arm-tdx-linux-gnueabi-gcc  -march=3Darmv7-a -mthumb -mf=
pu=3Dneon -mfloat-abi=3Dhard -fstack-protector-strong  -O2 -D_FORTIFY_SOURC=
E=3D2 -Wformat -Wformat-security -Werror=3Dformat-security -O2 -pipe -g -fe=
liminate-unused-debug-types -fmacro-prefix-map=3D/workdir/oe/tmp/work/apali=
s_imx6-tdx-linux-gnueabi/perf/1.0-r9=3D/usr/src/debug/perf/1.0-r9          =
            -fdebug-prefix-map=3D/workdir/oe/tmp/work/apalis_imx6-tdx-linux=
-gnueabi/perf/1.0-r9=3D/usr/src/debug/perf/1.0-r9                      -fde=
bug-prefix-map=3D/workdir/oe/tmp/work/apalis_imx6-tdx-linux-gnueabi/perf/1.=
0-r9/recipe-sysroot=3D                      -fdebug-prefix-map=3D/workdir/o=
e/tmp/work/apalis_imx6-tdx-linux-gnueabi/perf/1.0-r9/recipe-sysroot-native=
=3D  --sysroot=3D/workdir/oe/tmp/work/apalis_imx6-tdx-linux-gnueabi/perf/1.=
0-r9/recipe-sysroot -Wp,-MD,/workdir/oe/tmp/work/apalis_imx6-tdx-linux-gnue=
abi/perf/1.0-r9/perf-1.0/libbpf/staticobjs/.nlattr.o.d -Wp,-MT,/workdir/oe/=
tmp/work/apalis_imx6-tdx-linux-gnueabi/perf/1.0-r9/perf-1.0/libbpf/staticob=
js/nlattr.o -ldw -std=3Dgnu89 -Wbad-function-cast -Wdeclaration-after-state=
ment -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmi=
ssing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definitio=
n -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wswitch-=
enum -Wundef -Wwrite-strings -Wformat -Wno-type-limits -Wstrict-aliasing=3D=
3 -Wshadow -Wno-switch-enum -Werror -Wall -I/workdir/oe/tmp/work/apalis_imx=
6-tdx-linux-gnueabi/perf/1.0-r9/perf-1.0/libbpf/ -I/workdir/oe/tmp/work/apa=
lis_imx6-tdx-linux-gnueabi/perf/1.0-r9/perf-1.0/tools/include -I/workdir/oe=
/tmp/work/apalis_imx6-tdx-linux-gnueabi/perf/1.0-r9/perf-1.0/tools/include/=
uapi -fvisibility=3Dhidden -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -=
D"BUILD_STR(s)=3D#s" -c -o /workdir/oe/tmp/work/apalis_imx6-tdx-linux-gnuea=
bi/perf/1.0-r9/perf-1.0/libbpf/staticobjs/nlattr.o nlattr.c
07-21:17:58:43  | In file included from builtin-sched.c:28:
07-21:17:58:43  | builtin-sched.c: In function 'latency_switch_event':
07-21:17:58:43  | builtin-sched.c:1182:34: error: 'struct perf_sample' has =
no member named 'file_offset'
07-21:17:58:43  |  1182 |                            sample->file_offset, c=
pu);
07-21:17:58:43  |       |                                  ^~
07-21:17:58:43  | util/debug.h:24:44: note: in definition of macro 'pr_warn=
ing'
07-21:17:58:43  |    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_A=
RGS__)
07-21:17:58:43  |       |                                            ^~~~~~=
~~~~~
07-21:17:58:43  | builtin-sched.c: In function 'latency_runtime_event':
07-21:17:58:43  | builtin-sched.c:1260:34: error: 'struct perf_sample' has =
no member named 'file_offset'
07-21:17:58:43  |  1260 |                            sample->file_offset, c=
pu);
07-21:17:58:43  |       |                                  ^~
07-21:17:58:43  | util/debug.h:24:44: note: in definition of macro 'pr_warn=
ing'
07-21:17:58:43  |    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_A=
RGS__)
07-21:17:58:43  |       |                                            ^~~~~~=
~~~~~
07-21:17:58:43  | builtin-sched.c: In function 'map_switch_event':
07-21:17:58:43  | builtin-sched.c:1622:34: error: 'struct perf_sample' has =
no member named 'file_offset'
07-21:17:58:43  |  1622 |                            sample->file_offset, t=
his_cpu.cpu);
07-21:17:58:43  |       |                                  ^~
07-21:17:58:43  | util/debug.h:24:44: note: in definition of macro 'pr_warn=
ing'
07-21:17:58:43  |    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_A=
RGS__)
07-21:17:58:43  |       |                                            ^~~~~~=
~~~~~
07-21:17:58:43  | make -f /workdir/oe/tmp/work/apalis_imx6-tdx-linux-gnueab=
i/perf/1.0-r9/perf-1.0/tools/build/Makefile.build dir=3D./arch obj=3Dperf

Francesco

