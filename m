Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7093DA5AB
	for <patches@lists.linux.dev>; Sun, 20 Sep 2026 06:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789887457; cv=none; b=HYz5kgD5zDHG++eyZHRd8Z6OnMdIcTdxPI1k6+Zw2TKsW/DhO8c/Htfme9Ac96pAL2tx9ZS+o3pU1WfqyS0Bfz8HbwY1UKM/01sugpvSgYxDoGI2/5RyxOcxkDZytO1faX+/IDK/yh3EuOuhavYlVTRhH9nhhulzxbkKUuUW4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789887457; c=relaxed/simple;
	bh=eH5yn4eTCtHg/RtdlT0PySrGuTpvGbBnDu2crFsq5VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWP7J2p3VCMx6hin06/yCVqOa2npPY3/804PbCP+2x3D/kx4HtE5DPzp2k83Qwbxjqe4aE2h3TkdDJcZxKLOSZVEH+5dTdFxDhFhpTR6WuBQSs5nImRKKMjmKxxJsGvKfsQPRbt4RBJjIq8zeE+ElGQPy28jT+xe1011NYgpdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYZdaEKd; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYZdaEKd"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-482f633cd78so1060966f8f.1
        for <patches@lists.linux.dev>; Sat, 19 Sep 2026 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789887450; x=1790492250; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gj2ClRr5PH2wM+IzOKEyhBO/dQqq5pDpxYskoF936pA=;
        b=LYZdaEKdy7NNPn3fr1qSzgyZawP1AGB5Sjz7g1hYwR48tUJPTvrGFFMsUNrZW8/fnv
         NubepMt6auEtyRui+4J9nmxifz+KsKNRH6F9KUiDbWGKcT015W/Urmq1ct91Q3vnh/vs
         w88+RSHeAdfvYOh7PBSlTqStSXSNYgW8G0u110iUMLRkna3keDzHy+cffMvTSHrYd8bF
         37fVlBuvSxIQ4OXWzGX9ZWUpCvmOjki1sVVxH8ZkkhHJVhdMVeTRUWuHPrSewq6V4hFS
         LpIfaQjtPDemMzozcnXHY3/YaFuoCg00rktGUc6f4XtsAvuJRh5m2L6L4umbuunYWNJ1
         dBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789887450; x=1790492250;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gj2ClRr5PH2wM+IzOKEyhBO/dQqq5pDpxYskoF936pA=;
        b=TuIcASLZXLYr0ON5lETy6JkaQrYAyo84wqNRTqWlqqT8q48M7034xO7YUpyzEB6pDU
         vuLsEEjRkd4HFWWAPprAzNNdnpDFr41rCGDjM7vXYPb1Bf/3Su+faowibiKY+rctdp8w
         EtHgwUL40E28NZDjOh9eq3zNqYP3A6vMWrPrJd9VYxzrT4/K2hhnB4BvZn5W7aOFL9e7
         i4ko+z6s+F8WOL2W6RZuBw+2ySyGIOtwBGjGUdASWpM6qWn8KVMzPcq9NinjCM1V877O
         8LVN+ohQanfBQfFLSrS+hhm34TrE8qDfoFktajO/5fmZx78JcM/APPEqFKKEH1A+u0Qv
         9Gaw==
X-Forwarded-Encrypted: i=1; AKwUvBzTi1IeDFnm/m2WWrjZqSFDemrsXzjarxSy1ZqbVKDxOy+lS725IzEMFzsv1s373i1eWcyTAJTM@lists.linux.dev
X-Gm-Message-State: AFuF++nWqtesivvGLvoqlAjLhwWd4Bv/u5GwnHp2VmjQQH1m0OhFl1nY
	X4RNa2EwinfzCWHoXMyDqhDd2hfdiRqYMoK9JzAaY4yfR9FysEN/jGy2
X-Gm-Gg: AYBFou2u1LPOScYVuMLJm2OikSVolomffyBEEbbOiCQ02V8KoZliQRc8pfSzmA53MeA
	+2AvAuZLhZMl1EfwnRHn8VKZ9kXQQI6mLTEmV7/ie99elpPDwyXXuPqdq1mIMIMaRoreSicyhoe
	8ASocipKN0Y6pg56O/rFtWUym0ckTYbsTbdscdRCm8Jnig5dwCz78PfK3X3pYauYsJCYji4wI9Q
	FV0W5HsSJp5vTQe6sdMGoqNBRMyhajbJiTIodEzflcdgk9Dydtq19ryw1BPso6nhkGvF+Q7N6n1
	usKFjVGJHKDHzwNs+LdNGINaoUV9T/sfroKjeqElMmYf6AVs/C/wOX9mBGe74u7xdj16Sgb5L4h
	gxXc0PRHWjpZ0W/XNh8rmQKAhXr/KP3TuhtoJUTBsvmghWaPRDNnPHLmqBppDRvsamCusGtl0LS
	GNnbPitIRmFkccAjLUQxU48T0MTQjdcjABoikXdg/dMSf3j42mz/8VEWa6X48irM8lEGcq9h6yF
	+WiPdh9K3M0NjurIj2rNWLOiHK2wQvA3Q==
X-Received: by 2002:adf:e18a:0:b0:487:fb1:4f01 with SMTP id ffacd0b85a97d-4871e22679cmr11203945f8f.16.1789887449923;
        Sat, 19 Sep 2026 23:57:29 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724562aebsm13446161f8f.14.2026.09.19.23.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 23:57:28 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 6FAB5BE2EED; Sun, 20 Sep 2026 08:57:27 +0200 (CEST)
Date: Sun, 20 Sep 2026 08:57:27 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Ben Hutchings <benh@debian.org>
Subject: Re: [PATCH 6.1 0705/1191] perf cs-etm: Flush thread stacks after
 decoder reset
Message-ID: <aq-D15YcGtltATrG@eldamar.lan>
References: <20260912065548.086904252@linuxfoundation.org>
 <20260912065604.104459724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260912065604.104459724@linuxfoundation.org>

Hi Sasha, Greg,

On Sat, Sep 12, 2026 at 08:57:13AM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Leo Yan <leo.yan@arm.com>
>=20
> [ Upstream commit ea5075e3776846d4941dddf1549426ebd3feb81f ]
>=20
> Perf resets the CoreSight decoder when moving to a new AUX trace buffer,
> this causes trace discontinunity globally.
>=20
> For callchain synthesis, keeping thread-stack state after decoder reset
> can leave stale call/return history attached to threads that are decoded
> later, producing incorrect synthesized callchains.
>=20
> Flush all host thread stacks after a decoder reset. When virtualization
> is present, flush the guest thread stacks as well.
>=20
> Reviewed-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Stable-dep-of: ec99be8a31db ("perf cs-etm: Avoid truncating AUX buffer si=
zes to int")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/perf/util/cs-etm.c | 45 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>=20
> diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
> index 3b54baf79bd4a..361b75b0882c4 100644
> --- a/tools/perf/util/cs-etm.c
> +++ b/tools/perf/util/cs-etm.c
> @@ -1635,6 +1635,45 @@ static int cs_etm__end_block(struct cs_etm_queue *=
etmq,
> =20
>  	return 0;
>  }
> +
> +static int cs_etm__flush_stack_cb(struct thread *thread,
> +				  void *data __maybe_unused)
> +{
> +	thread_stack__flush(thread);
> +	return 0;
> +}
> +
> +static void cs_etm__flush_machine_stack(struct cs_etm_queue *etmq, pid_t=
 pid)
> +{
> +	struct machine *machine;
> +
> +	machine =3D machines__find(&etmq->etm->session->machines, pid);
> +	if (machine)
> +		machine__for_each_thread(machine, cs_etm__flush_stack_cb, NULL);
> +}
> +
> +static void cs_etm__flush_all_stack(struct cs_etm_queue *etmq)
> +{
> +	enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq);
> +
> +	if (!etmq->etm->synth_opts.last_branch)
> +		return;
> +
> +	switch (pid_fmt) {
> +	case CS_ETM_PIDFMT_CTXTID2:
> +		/* Clear the guest stack if virtualization is supported */
> +		cs_etm__flush_machine_stack(etmq, DEFAULT_GUEST_KERNEL_ID);
> +		fallthrough;
> +	case CS_ETM_PIDFMT_CTXTID:
> +		cs_etm__flush_machine_stack(etmq, HOST_KERNEL_ID);
> +		break;
> +	case CS_ETM_PIDFMT_NONE:
> +	default:
> +		break;
> +
> +	}
> +}
> +
>  /*
>   * cs_etm__get_data_block: Fetch a block from the auxtrace_buffer queue
>   *			   if need be.
> @@ -1657,6 +1696,12 @@ static int cs_etm__get_data_block(struct cs_etm_qu=
eue *etmq)
>  		ret =3D cs_etm_decoder__reset(etmq->decoder);
>  		if (ret)
>  			return ret;
> +
> +		/*
> +		 * Since the decoder is reset, this causes a global trace
> +		 * discontinuity. Flush all thread stacks.
> +		 */
> +		cs_etm__flush_all_stack(etmq);
>  	}
> =20
>  	return etmq->buf_len;
> --=20
> 2.53.0

This one is a problem for at lsast 6.1.y and older, when building the
tools in 6.1.y the build fails. for instance CS_ETM_PIDFMT_CTXTID2 is
undeclared.

  gcc -Wp,-MD,/build/package/package/debian/build/build-tools/tools/perf/ut=
il/.cs-etm.o.d -Wp,-MT,/build/package/package/debian/build/build-tools/tool=
s/perf/util/cs-etm.o -g -O2 -fstack-protector-strong -Wformat -Werror=3Dfor=
mat-security -Wall -Wdate-time -D_FORTIFY_SOURCE=3D2 -I/build/package/packa=
ge/tools/perf -I/build/package/package/debian/build/build-tools/tools/perf =
-isystem /build/package/package/debian/build/build-tools/include -Wbad-func=
tion-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Win=
it-self -Wmissing-declarations -Wmissing-prototypes -Wno-system-headers -Wo=
ld-style-definition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch=
-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat -Wno-type-limits -W=
strict-aliasing=3D3 -Wshadow -DHAVE_SYSCALL_TABLE_SUPPORT -DHAVE_ARCH_X86_6=
4_SUPPORT -I/build/package/package/debian/build/build-tools/tools/perf/arch=
/x86/include/generated -DHAVE_PERF_REGS_SUPPORT -DHAVE_ARCH_REGS_QUERY_REGI=
STER_OFFSET -DNDEBUG=3D1 -O6 -fno-omit-frame-pointer -ggdb3 -funwind-tables=
 -Wall -Wextra -std=3Dgnu99 -fstack-protector-all -U_FORTIFY_SOURCE -D_FORT=
IFY_SOURCE=3D2 -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE=
 -I/build/package/package/tools/lib/perf/include -I/build/package/package/t=
ools/perf/util/include -I/build/package/package/tools/perf/arch/x86/include=
 -I/build/package/package/tools/include/ -I/build/package/package/tools/arc=
h/x86/include/uapi -I/build/package/package/tools/include/uapi -I/build/pac=
kage/package/tools/arch/x86/include/ -I/build/package/package/tools/arch/x8=
6/ -I/build/package/package/debian/build/build-tools/tools/perf//util -I/bu=
ild/package/package/debian/build/build-tools/tools/perf/ -I/build/package/p=
ackage/tools/perf/util -I/build/package/package/tools/perf -I/build/package=
/package/tools/lib/ -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP -DHAVE_PTHREAD_BARRI=
ER -DHAVE_EVENTFD_SUPPORT -DHAVE_GET_CURRENT_DIR_NAME -DHAVE_GETTID -DHAVE_=
FILE_HANDLE -DHAVE_DWARF_GETLOCATIONS_SUPPORT -DHAVE_GLIBC_SUPPORT -DHAVE_A=
IO_SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT -DHAVE_SETNS_SUPPORT -DHAVE_CSTRACE_=
SUPPORT -DHAVE_LIBELF_SUPPORT -DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_GELF_GET=
NOTE_SUPPORT -DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_DWARF_SUPPORT -DHAVE_L=
IBBPF_SUPPORT -DHAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID -DHAVE_LIBBPF_BPF_P=
ROG_LOAD -DHAVE_LIBBPF_BPF_OBJECT__NEXT_PROGRAM -DHAVE_LIBBPF_BPF_OBJECT__N=
EXT_MAP -DHAVE_LIBBPF_BPF_PROGRAM__SET_INSNS -DHAVE_LIBBPF_BTF__RAW_DATA -D=
HAVE_LIBBPF_BPF_MAP_CREATE -DHAVE_BPF_PROLOGUE -DHAVE_JITDUMP -DHAVE_DWARF_=
UNWIND_SUPPORT -DNO_LIBUNWIND_DEBUG_FRAME -DHAVE_LIBUNWIND_SUPPORT -DHAVE_S=
LANG_SUPPORT -DHAVE_LIBPERL_SUPPORT -DHAVE_TIMERFD_SUPPORT -DHAVE_LIBPYTHON=
_SUPPORT -DHAVE_CPLUS_DEMANGLE_SUPPORT -DHAVE_ZLIB_SUPPORT -DHAVE_LZMA_SUPP=
ORT -DHAVE_ZSTD_SUPPORT -DHAVE_LIBCAP_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHA=
VE_LIBNUMA_SUPPORT -DHAVE_KVM_STAT_SUPPORT -DHAVE_PERF_READ_VDSO32 -DHAVE_P=
ERF_READ_VDSOX32 -DHAVE_LIBBABELTRACE_SUPPORT -DHAVE_AUXTRACE_SUPPORT -I/bu=
ild/package/package/debian/build/build-tools/tools/perf/ -D"BUILD_STR(s)=3D=
#s" -c -o /build/package/package/debian/build/build-tools/tools/perf/util/c=
s-etm.o util/cs-etm.c
util/cs-etm.c: In function 'cs_etm__flush_all_stack':
util/cs-etm.c:1656:14: error: variable 'pid_fmt' has initializer but incomp=
lete type
 1656 |         enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq);
      |              ^~~~~~~~~~~~~~
util/cs-etm.c:1656:59: warning: passing argument 1 of 'cs_etm__get_pid_fmt'=
 makes integer from pointer without a cast [-Wint-conversion]
 1656 |         enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq);
      |                                                           ^~~~
      |                                                           |
      |                                                           struct cs=
_etm_queue *
util/cs-etm.c:167:28: note: expected 'u8' {aka 'unsigned char'} but argumen=
t is of type 'struct cs_etm_queue *'
  167 | int cs_etm__get_pid_fmt(u8 trace_chan_id, u64 *pid_fmt)
      |                         ~~~^~~~~~~~~~~~~
util/cs-etm.c:1656:39: error: too few arguments to function 'cs_etm__get_pi=
d_fmt'
 1656 |         enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq);
      |                                       ^~~~~~~~~~~~~~~~~~~
util/cs-etm.c:167:5: note: declared here
  167 | int cs_etm__get_pid_fmt(u8 trace_chan_id, u64 *pid_fmt)
      |     ^~~~~~~~~~~~~~~~~~~
util/cs-etm.c:1656:29: error: storage size of 'pid_fmt' isn't known
 1656 |         enum cs_etm_pid_fmt pid_fmt =3D cs_etm__get_pid_fmt(etmq);
      |                             ^~~~~~~
util/cs-etm.c:1662:14: error: 'CS_ETM_PIDFMT_CTXTID2' undeclared (first use=
 in this function)
 1662 |         case CS_ETM_PIDFMT_CTXTID2:
      |              ^~~~~~~~~~~~~~~~~~~~~
util/cs-etm.c:1662:14: note: each undeclared identifier is reported only on=
ce for each function it appears in
util/cs-etm.c:1665:17: error: 'fallthrough' undeclared (first use in this f=
unction)
 1665 |                 fallthrough;
      |                 ^~~~~~~~~~~
util/cs-etm.c:1666:14: error: 'CS_ETM_PIDFMT_CTXTID' undeclared (first use =
in this function)
 1666 |         case CS_ETM_PIDFMT_CTXTID:
      |              ^~~~~~~~~~~~~~~~~~~~

Not sure if 5414b532611b ("perf cs-etm: Make PID format accessible
=66rom struct cs_etm_auxtrace") would be suitable for backporting.

Sasha, could you have look?=20

Regards,
Salvatore
