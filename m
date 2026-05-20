Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4632E3C4542
	for <patches@lists.linux.dev>; Wed, 20 May 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779314514; cv=none; b=IETMhrjXViWvfmZOj+E5NaiAu+td4ByXGLs1oPI2ZAGFau9RTaFnc4pLGWjPrKyIWO0EwU5qjXK2HiK/2xZw5nq99JuiB5TFgZdCDH9Q62XbigtFGt3gL4RfBGXqkT1o++DnciWS68ed9TkRjE59I/Qvuzb4BUg9Ammehbb/Xo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779314514; c=relaxed/simple;
	bh=XUsZplKzqK8gAQebRInCSlTKmWr/ICMuMJAwgalEV90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4pkIUf3zbjZ0u9wbkkixP1qVbF5Pruw0s1YkLyH6JlZ6HEzpgjIxxiveWI4O0bJxXjaVKrOUDcfqcpEEcj1Frpg0EVexoeC0u2MrDP2zxxCJLVtqAKkdjgVQXsYAYA7jDfn+m4wZlX8GNi0pT/cmQ2qtJ34YrtmXlZxLTEkjOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhPtWwsx; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhPtWwsx"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48e82c23840so43971325e9.3
        for <patches@lists.linux.dev>; Wed, 20 May 2026 15:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779314508; x=1779919308; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WJTamhefML82kg15lhvjPFQFbeI1fp3z405qfk0p2nY=;
        b=RhPtWwsxngomUTF8PyT6EPt5vE6MW8WXMU1s5/khVcokq2Ld4l+fO4AIkaKZpNrb0d
         j06/sN+jLAxjhyGROIrdS2Agi/5RjHVHk+AA8kqEGjYM69qYVpvamPHWhF9Qf6atYIOM
         qHgAzrgdg7qB705vYc477yCmTifBL41ATi8Z2600NUTcZOe+QfA/XQ0y9OZ9WPUt3rAv
         s/RJpPLnwUWLnQL8FVURw5MyVyRJUjN3N9T4kRyh+F0S/xGIeFFwnJvpsUBS1zC6ooaH
         PvCzJeacBAQLPKFZHx0C8Wu5MmYL+WXqjHgwQzOzIkdz/gj6QAWzLKjZOINWFTT0O3BD
         Z7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779314508; x=1779919308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJTamhefML82kg15lhvjPFQFbeI1fp3z405qfk0p2nY=;
        b=bJYPXmQNHhulBJwu2pzHVfCOnbZ3IbXRviwDcAO8/kD1BuA05doIn5mE9wFJFbAMpE
         /eQp0QaedPoQwrme8VEISmAzh6nGSl7rKMQ4AVzmmgI8TtqzYMLsdTQ8XcO46+W6wTmf
         qcCLkEpJKM31TQiRxNQMa2nKbBTnRuQmIVabNoSol2xESlH++8MAQDent5MsmQv0xdfW
         0bVUaRWdSJDPgF4jJj/d9GDfyj0qAOngOxLpxSNBr2ZjNXbYqRlwScl+Z8iZm9WTwK5J
         ytMOckaA26Y7Uo2uvwoeOhR632j96n969Q6b5jYhXFi4Uv57VCZxHGFL8apGXB9xx0cb
         Lrhw==
X-Forwarded-Encrypted: i=1; AFNElJ84gm1kXnbNAy+WUjlrrXR7q5rgAXTcLdvfY1khzZhpzzEWwVSPuPTb41G3kwPxBMxvd9IrW/Bi@lists.linux.dev
X-Gm-Message-State: AOJu0YyS3KUHKRBfhmocYGAWEoAze396uRczht/RdXqvPxpp2mVbgR7B
	ouy3q2JvOTbFPCUaDZspanBZvvqM7d6qqQmB1J4BCKv3ifkYDyhZCyZ8
X-Gm-Gg: Acq92OGGOjXCW5Pw5b+6TGOSddsdlcoNF165WdJ4dMoGfVRVonmBGGv3IkGHusGJIY/
	F+jnbmpgP+4ZmA1MewHcGnNiQELCV3RICenUOjYEM61iXMUaZubXlLkbOK2PvWeSM1jZ6g73Gqm
	uRXyC1ig0hpO9yPXY4i72eZeIzhCLawszkWuhHLzvFISUvT7Y7g8UJrK4SbpCzAPGH3iFk4MkD3
	QBIRoqyX8IkQTDMimpR5gzunrssV+Rpgjsg76FfUYXF9rjVwzjiiamKDqhNx5U/yB4MbOKQ3iKS
	6u+mp58jI9BByf4gI7rWsRkbwkhgpVRBUpF4aulHykoC6JjCD/UEO4IwtRiHl2k6sO9fRn75+aG
	TDmP0O0EQiZe7/C8Elj2RmOL9QasuvPyoqre/pavOIgBVMNKBTJv86t4TH73e2gDk8eEY4Zk8+7
	aXWSRS8I2DJ8JYwbeT7OLMYXThLftOuIi9Qz2b4rKOLmeJc7M+9POwwUZdKnwd5YMlse1s5x+oU
	x+g7dJT
X-Received: by 2002:a05:600c:2d85:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-490360b142fmr1009575e9.21.1779314507349;
        Wed, 20 May 2026 15:01:47 -0700 (PDT)
Received: from eldamar.lan (c-82-192-247-196.customer.ggaweb.ch. [82.192.247.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d60247sm20238425e9.14.2026.05.20.15.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:01:46 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 8093BBE2EE7; Thu, 21 May 2026 00:01:45 +0200 (CEST)
Date: Thu, 21 May 2026 00:01:45 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 354/666] libbpf: Stringify errno in log messages in
 libbpf.c
Message-ID: <ag4vSWzIUCsRlpKv@eldamar.lan>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162118.906982302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520162118.906982302@linuxfoundation.org>

Hi Greg,

On Wed, May 20, 2026 at 06:19:25PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mykyta Yatsenko <yatsenko@meta.com>
> 
> [ Upstream commit 271abf041cb354ce99df33ce1f99db79faf90477 ]
> 
> Convert numeric error codes into the string representations in log
> messages in libbpf.c.
> 
> Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20241111212919.368971-3-mykyta.yatsenko5@gmail.com
> Stable-dep-of: 380044c40b16 ("libbpf: Prevent double close and leak of btf objects")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

This commit caused a build failure while testing 6.12.91-rc1 to
prepare it for Debian:

make -f /home/build/linux-stable-rc/tools/build/Makefile.build dir=./arch/x86 obj=objtool
In file included from libbpf.c:54:
libbpf.c: In function ‘bpf_object__elf_init’:
libbpf.c:1538:76: error: implicit declaration of function ‘errstr’; did you mean ‘strstr’? [-Werror=implicit-function-declaration]
 1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
      |                                                                            ^~~~~~
libbpf_internal.h:167:47: note: in definition of macro ‘__pr’
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                                               ^~~~~~~~~~~
libbpf.c:1538:25: note: in expansion of macro ‘pr_warn’
 1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
      |                         ^~~~~~~
libbpf.c:1538:76: error: nested extern declaration of ‘errstr’ [-Werror=nested-externs]
 1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
      |                                                                            ^~~~~~
libbpf_internal.h:167:47: note: in definition of macro ‘__pr’
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                                               ^~~~~~~~~~~
libbpf.c:1538:25: note: in expansion of macro ‘pr_warn’
 1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:1538:25: note: in expansion of macro ‘pr_warn’
 1538 |                         pr_warn("elf: failed to open %s: %s\n", obj->path, errstr(err));
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_object__init_internal_map’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:1938:17: note: in expansion of macro ‘pr_warn’
 1938 |                 pr_warn("failed to alloc map '%s' content buffer: %s\n", map->name, errstr(err));
      |                 ^~~~~~~
libbpf.c: In function ‘parse_u64’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:2102:17: note: in expansion of macro ‘pr_warn’
 2102 |                 pr_warn("failed to parse '%s': %s\n", value, errstr(err));
      |                 ^~~~~~~
libbpf.c: In function ‘bpf_object__read_kconfig_file’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:2268:25: note: in expansion of macro ‘pr_warn’
 2268 |                         pr_warn("error parsing system Kconfig line '%s': %s\n",
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_object__read_kconfig_mem’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:2289:17: note: in expansion of macro ‘pr_warn’
 2289 |                 pr_warn("failed to open in-memory Kconfig: %s\n", errstr(err));
      |                 ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:2296:25: note: in expansion of macro ‘pr_warn’
 2296 |                         pr_warn("error parsing in-memory Kconfig line '%s': %s\n",
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_object__init_btf’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3212:25: note: in expansion of macro ‘pr_warn’
 3212 |                         pr_warn("Error loading ELF section %s: %s.\n", BTF_ELF_SEC, errstr(err));
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3230:25: note: in expansion of macro ‘pr_warn’
 3230 |                         pr_warn("Error loading ELF section %s: %s. Ignored and continue.\n",
      |                         ^~~~~~~
libbpf.c: In function ‘btf_fixup_datasec’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 5 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:172:33: note: in expansion of macro ‘__pr’
  172 | #define pr_debug(fmt, ...)      __pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3323:25: note: in expansion of macro ‘pr_debug’
 3323 |                         pr_debug("sec '%s': failed to determine size from ELF: size %u, err %s\n",
      |                         ^~~~~~~~
libbpf.c: In function ‘bpf_object__load_vmlinux_btf’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3478:17: note: in expansion of macro ‘pr_warn’
 3478 |                 pr_warn("Error loading vmlinux BTF: %s\n", errstr(err));
      |                 ^~~~~~~
libbpf.c: In function ‘bpf_object__sanitize_and_load_btf’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3582:25: note: in expansion of macro ‘pr_warn’
 3582 |                         pr_warn("Error loading .BTF into kernel: %s. BTF is mandatory, can't proceed.\n",
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:171:33: note: in expansion of macro ‘__pr’
  171 | #define pr_info(fmt, ...)       __pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:3585:25: note: in expansion of macro ‘pr_info’
 3585 |                         pr_info("Error loading .BTF into kernel: %s. BTF is optional, ignoring.\n",
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_get_map_info_from_fdinfo’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:4798:17: note: in expansion of macro ‘pr_warn’
 4798 |                 pr_warn("failed to open %s: %s. No procfs support?\n", file,
      |                 ^~~~~~~
libbpf.c: In function ‘bpf_object_prepare_token’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf.c:4954:17: note: in expansion of macro ‘__pr’
 4954 |                 __pr(level, "object '%s': failed (%s) to open BPF FS mount at '%s'%s\n",
      |                 ^~~~
libbpf.c: In function ‘bpf_object__probe_loading’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5004:17: note: in expansion of macro ‘pr_warn’
 5004 |                 pr_warn("Failed to bump RLIMIT_MEMLOCK (err = %s), you might need to do it explicitly!\n",
      |                 ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5013:17: note: in expansion of macro ‘pr_warn’
 5013 |                 pr_warn("Error in %s(): %s. Couldn't load trivial BPF program. Make sure your kernel supports BPF (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough value.\n",
      |                 ^~~~~~~
libbpf.c: In function ‘map_is_reuse_compat’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5047:17: note: in expansion of macro ‘pr_warn’
 5047 |                 pr_warn("failed to get map info for map FD %d: %s\n", map_fd,
      |                 ^~~~~~~
libbpf.c: In function ‘bpf_object__reuse_map’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5084:17: note: in expansion of macro ‘pr_warn’
 5084 |                 pr_warn("couldn't retrieve pinned map '%s': %s\n",
      |                 ^~~~~~~
libbpf.c: In function ‘bpf_object__populate_internal_map’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5125:17: note: in expansion of macro ‘pr_warn’
 5125 |                 pr_warn("map '%s': failed to set initial contents: %s\n",
      |                 ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5135:25: note: in expansion of macro ‘pr_warn’
 5135 |                         pr_warn("map '%s': failed to freeze as read-only: %s\n",
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5162:25: note: in expansion of macro ‘pr_warn’
 5162 |                         pr_warn("map '%s': failed to re-mmap() contents: %s\n",
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_object__create_map’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5220:33: note: in expansion of macro ‘pr_warn’
 5220 |                                 pr_warn("map '%s': failed to create inner map: %s\n",
      |                                 ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5276:17: note: in expansion of macro ‘pr_warn’
 5276 |                 pr_warn("Error in bpf_create_map_xattr(%s): %s. Retrying without BTF.\n",
      |                 ^~~~~~~
libbpf.c: In function ‘init_map_in_map_slots’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 7 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5332:25: note: in expansion of macro ‘pr_warn’
 5332 |                         pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %s\n",
      |                         ^~~~~~~
libbpf.c: In function ‘init_prog_array_slots’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 7 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5365:25: note: in expansion of macro ‘pr_warn’
 5365 |                         pr_warn("map '%s': failed to initialize slot [%d] to prog '%s' fd=%d: %s\n",
      |                         ^~~~~~~
libbpf.c: In function ‘bpf_object__create_maps’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5492:41: note: in expansion of macro ‘pr_warn’
 5492 |                                         pr_warn("map '%s': failed to mmap arena: %s\n",
      |                                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 5 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5515:33: note: in expansion of macro ‘pr_warn’
 5515 |                                 pr_warn("map '%s': failed to auto-pin at '%s': %s\n",
      |                                 ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5525:9: note: in expansion of macro ‘pr_warn’
 5525 |         pr_warn("map '%s': failed to create: %s\n", map->name, errstr(err));
      |         ^~~~~~~
libbpf.c: In function ‘load_module_btfs’:
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5649:25: note: in expansion of macro ‘pr_warn’
 5649 |                         pr_warn("failed to iterate BTF objects: %s\n", errstr(err));
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                                 ^~~~
libbpf.c:5658:25: note: in expansion of macro ‘pr_warn’
 5658 |                         pr_warn("failed to get BTF object #%d FD: %s\n", id, errstr(err));
      |                         ^~~~~~~
libbpf_internal.h:167:29: error: format ‘%s’ expects argument of type ‘char *’, but argument 4 has type ‘int’ [-Werror=format=]
  167 |         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);     \
      |                             ^~~~~~~~~~
libbpf_internal.h:170:33: note: in expansion of macro ‘__pr’
  170 | #define pr_warn(fmt, ...)       __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
[...]
libbpf.c:13965:25: note: in expansion of macro ‘pr_warn’
13965 |                         pr_warn("map '%s': failed to auto-attach: %s\n",
      |                         ^~~~~~~
cc1: all warnings being treated as errors
make[8]: *** [/home/build/linux-stable-rc/tools/build/Makefile.build:105: /home/build/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o] Error 1
make[7]: *** [Makefile:165: /home/build/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o] Error 2
make[6]: *** [Makefile:63: /home/build/linux-stable-rc/tools/bpf/resolve_btfids//libbpf/libbpf.a] Error 2
make[5]: *** [Makefile:76: bpf/resolve_btfids] Error 2
make[4]: *** [Makefile:1391: tools/bpf/resolve_btfids] Error 2

Regards,
Salvatore
