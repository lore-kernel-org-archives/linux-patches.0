Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF5A189F59
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 10:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113207; cv=none; b=C9LfxOgw5jJpHflpcjNy3xeeL/bFe9Q90fMkbOiehQ+uLz9RbduPPO1d9PeD0sknXzuSoR1ffKqdmwmKbPOz7aO91MMiZ8NeJx/DSzGX+Miohl8oYZSyhLEE8KZvT6q1x0F7Ypx14znTx8WfM87Zf21Vb1C77/woWwtoTDHsm9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113207; c=relaxed/simple;
	bh=zfoUC1RZMVYImiCRXTCBlEdjYLCdW0y6Nbj+Kr/vNQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pj4M7bg2VdXPnTr3davgJUONwuD8X3yZOpAOXCqat92+M6JGMM51kSj+LllDTT5rmDKxhzLxe+GtEHEeQ+OyQ1tkmXnY+NLwz7WrjuZX403cEtiB34B2JHTHBzE3m/SHCr3r1vLVxJADQBqEqlKJaBNStJomMaAAD3SWfI1Wrn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KuUAYkmh; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuUAYkmh"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4280c55e488so4576585e9.0
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 03:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723113204; x=1723718004; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVgfmqO4N1UcKjueG5axm5NDRPcdykTA/HI4HFye/Gg=;
        b=KuUAYkmhPKgx3lJ9vjvZUvgeqSkYmndpL2qyZrI5Vv6C0eLeraREFxf32urt6PO+Lj
         M4tO7d0ZToLP3pCjxFL5pKhqCkRfFPBqGRmrhnDSICCnGwqz8Ifmb/yW/h5jL+iIhAFx
         0/WntImr300MgEjJqdsF7hfFFCTTEoG69P1EIBoAA8x88vtpVj7V5N7ZxpUH6I0347Tf
         Xg++q8f53nDDEuaWWwO4/UaRwFbe6rNrxEeq3r4iY34F4pK1/q9zmUL0NpjMZiHkuTEL
         eQGMiJqESbR190b7QkZUqAvl86MAghxIBACzGSGVUgq3TpGKhU9jaLygrO9PxjwOTq6O
         yrYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723113204; x=1723718004;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVgfmqO4N1UcKjueG5axm5NDRPcdykTA/HI4HFye/Gg=;
        b=DtrT92da5JmPLh+I/EJoxIbFMuWgcrlQnARmGDffhf/JJaMCmSxuulcBGJ2EFXRn7D
         BnkigRWxazw2uAj4ZOZDdXz9RMJMfDooZGA2VTYKys5FYvaD7yCiVzgmaWhxXXshaR4f
         0E1XB9Y6QYGM1v9dvFZ/aibmEXL8zdPSEUkkwRSPLXj7COYZCyqiGeZbMZZnmgHRUT31
         5oYp6cZRpsz5jONsaTTIUdkFsrbOR+mi2Gjca+1Qfg5vdFaz4uEYb8eHV7MGZvR6Yggf
         vKIxkeyVI8dLIRz9Yh8MU/Ks6Ir6kDnnch19wTvKGGHAlq4Eb4uze34c/4u9v/0b3oVR
         KpCA==
X-Forwarded-Encrypted: i=1; AJvYcCUS7LauWmQwmNxh8lHljBGXx1Et+wjhycq5aWKEyQw37sfkZIt9uaydQHxF3gLt2swPBMdC8Zr0@lists.linux.dev
X-Gm-Message-State: AOJu0YybzQ3FOQxAIpBhyUNtSZpdQ6SVqEE6VyMRIqas9LykofoFM7++
	eyl/Zy+oPyGygaGMJDByt/F39pN8NX1i2tK1Y3ybgS2w+1a3rZql
X-Google-Smtp-Source: AGHT+IGFB8sKobly1QwgEljiG/nuvcwt4YBigGPTsgv7cP5nDct/nSGQFGM/lnSWfentBnbSLZQDWw==
X-Received: by 2002:a05:600c:1d28:b0:424:8be4:f2c with SMTP id 5b1f17b1804b1-4290b836e0dmr11077165e9.2.1723113203457;
        Thu, 08 Aug 2024 03:33:23 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c72d8ffsm15181085e9.7.2024.08.08.03.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 03:33:23 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 3794BBE2DE0; Thu, 08 Aug 2024 12:33:22 +0200 (CEST)
Date: Thu, 8 Aug 2024 12:33:22 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
Message-ID: <ZrSe8gZ_GyFv1knq@eldamar.lan>
References: <20240808091131.014292134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>

Hi Greg,

On Thu, Aug 08, 2024 at 11:11:49AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 Aug 2024 09:11:02 +0000.
> Anything received after that time might be too late.

Sorry for bothering you again with it (see previous comment on
6.1.103, respectively 6.1.104-rc1): bpftool still would fail to
compile:

gcc -O2 -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wundef -Wwrite-strings -Wformat -Wno-type-limits -Wstrict-aliasing=3 -Wshadow -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ -I. -I/home/build/linux-stable-rc/tools/bpf/bpftool/libbpf/include -I/home/build/linux-stable-rc/kernel/bpf/ -I/home/build/linux-stable-rc/tools/include -I/home/build/linux-stable-rc/tools/include/uapi -DUSE_LIBCAP -DBPFTOOL_WITHOUT_SKELETONS -c -MMD prog.c -o prog.o
prog.c: In function ‘load_with_options’:
prog.c:1710:23: warning: implicit declaration of function ‘create_and_mount_bpffs_dir’ [-Wimplicit-function-declaration]
 1710 |                 err = create_and_mount_bpffs_dir(pinmaps);
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
gcc -O2 -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wundef -Wwrite-strings -Wformat -Wno-type-limits -Wstrict-aliasing=3 -Wshadow -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ -I. -I/home/build/linux-stable-rc/tools/bpf/bpftool/libbpf/include -I/home/build/linux-stable-rc/kernel/bpf/ -I/home/build/linux-stable-rc/tools/include -I/home/build/linux-stable-rc/tools/include/uapi -DUSE_LIBCAP -DBPFTOOL_WITHOUT_SKELETONS  btf.o btf_dumper.o cfg.o cgroup.o common.o feature.o gen.o iter.o json_writer.o link.o main.o map.o map_perf_ring.o net.o netlink_dumper.o perf.o pids.o prog.o struct_ops.o tracelog.o xlated_dumper.o disasm.o /home/build/linux-stable-rc/tools/bpf/bpftool/libbpf/libbpf.a -lelf -lz -lcap -o bpftool
/bin/ld: prog.o: in function `load_with_options':
prog.c:(.text+0x2f98): undefined reference to `create_and_mount_bpffs_dir'
/bin/ld: prog.c:(.text+0x2ff2): undefined reference to `create_and_mount_bpffs_dir'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:216: bpftool] Error 1
make: *** [Makefile:113: bpftool] Error 2

Reverting 65dd9cbafec2f6f7908cebcab0386f750fc352af fixes the issue. In
fact 65dd9cbafec2f6f7908cebcab0386f750fc352af is the only commit
adding call to create_and_mount_bpffs_dir:

$ git grep create_and_mount_bpffs_dir
tools/bpf/bpftool/prog.c:               err = create_and_mount_bpffs_dir(pinmaps);

Regards,
Salvatore
