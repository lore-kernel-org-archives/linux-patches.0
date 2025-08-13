Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FEF1369B4
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755048563; cv=none; b=bIxOFECVq1UlA+MOMsNZdacniTQZtSDI5HV+eMtBh4b8dE8THEhfeza9molO8MI2rpo3GeZIkBpGJ9WOD5uhdO7EH9S8VOIm/gtsEEfu4zMkz27HvClIPOIIfJiw3lUgV3JwXFxslpw2Q2x3cboZnnu33wgsxFaucYr/Zaqk+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755048563; c=relaxed/simple;
	bh=ZCTgfKqNa+LgytjlqH4lOd5R0jewhiOS/nlshZC7PQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjO+Wxqjew0q1SfzviSP45HpeJRae45b35iAI8wMs24cG+5bOv74uOLiUTNPeZjGgvgYAzzH0SuKHFD5wGkTdd53jygvKKsxtfv4foW8xISll/7mDJwZf3fMbVzve+U03sLgfTVTL/Ft3V/Yc1o2UJL/xcJ9XdcoTiZmQEASyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PmyK8HT5; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PmyK8HT5"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b914186705so665712f8f.0
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 18:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755048559; x=1755653359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rnD+xv18p/AxJUBrvHZm0xOy/Y25N8osSJ9mIdmrek=;
        b=PmyK8HT5QGFQsPq7D+kmgTDubbYSCUZhumLCR+GdhYYByEKIeNllMaL88v/wg+UfUX
         XgqY16eyvKzgKaUV/JfEFrCCCDWgPPM0O5xIF0xMNx7jbT3p5o+32sdSuX8PmgKHQSeS
         XZlb/3hbOxFgBrgFKslQRuFHs3QvUPp53hmYy93ULm1v+kMn6mjBYr8YCf2k3TqccY1h
         KYrt23xaDsCtnj8vZW0xC2fL6olhHowdVq//0WCanwiORccq45+RcJy6pef2KVlbFkmm
         ZjRAXcGKwrRBKOfFwAkVadErIxuCYZdCEsRDv4CM76AC1i5hp1OX3ef8l0nILjr2umsZ
         m37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755048559; x=1755653359;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rnD+xv18p/AxJUBrvHZm0xOy/Y25N8osSJ9mIdmrek=;
        b=njarr9qRC0V2wMytNWgEDC28/0mMayOMZ5dc3OUnp6RAVDa2aNsyBA4orEfZm5o51C
         wuTyQ8x2bqrVYqjKoC1pLh47h6sag6Zd3uufAymenU6Dli7ENn+4eI67AKRcvH1plDQp
         YXbPEwCHFMIDgHxHTAC4keTbyGWy5wpQ26V4wfXaeuMBbc87cCI4v0cvpaXNj4Wo974i
         +ujDqlt+t0MvyH52eZqzsgnfaYADXcdYhIud5ww+j3J7kfzcP1u636G72A+LhwJQ5XbZ
         JRcyX7f9yJuAM274X9hiYBDRxPr+/XUXCPZMQsx77xWDBQi7lBa2wkOyql5iVia1vVxg
         Y9bQ==
X-Gm-Message-State: AOJu0YyK1lrpF8Yo+GImTjLnsfKmWwJTNB2nYQxmDbpHyATwQHzoSwi7
	N4LU+deUWOkb+hwa2s5zg/QHd3AS7YbaFhAy8Qfk/xk7csfug801Mig=
X-Gm-Gg: ASbGncviYYLrppp6P2mEvDGibzuhzhf6zJJP4vzldG/IdTvleE0mthjEEyJc7WLR97T
	nlRJAaOPzYPwnv055lS9K8n81c9y4meJTdYsXEMdQ6EeFJoHKlOUJMD8upzjlJANY6wkys2Xx/i
	dF4dB05ktUugy3g8ZU3bCUALmtx/Xtfed/h2DhEFCGIR5BZAhalBcozGfhkt3Q7mDDHtB+c1PDC
	1s1YBXU1MgLpIP+cG/n8tGX6uNVu2S8TcsWbM5FXfOHFre2vFvdtQ1Y88mw3YUUxZigguxpchOm
	GtXmbYh1uaUUY4EJCoKM/daF5K8FYKw4xBNe5B8S9aykG+ZNsTsc7A827MF4mhAf65eIV9GUrIv
	oLIHiebUvcyVjl1exkw74PAZi0iKKWy1na97NWshIvdgwlZJTSWqf6WInknDCPvy80wod/0EE0A
	sKdNrWByLmXA==
X-Google-Smtp-Source: AGHT+IF6ANTBUGWn6c/+tjvpGwdQGKJylAO1qgBQXq77hqzcQ4nArUWu0jEtObWqZRhmA+oj9jsv8A==
X-Received: by 2002:a05:6000:250a:b0:3b6:cf8:64b3 with SMTP id ffacd0b85a97d-3b917ead5c6mr549289f8f.34.1755048559206;
        Tue, 12 Aug 2025 18:29:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570d7.dip0.t-ipconnect.de. [91.5.112.215])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac51asm46964655f8f.1.2025.08.12.18.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 18:29:17 -0700 (PDT)
Message-ID: <cd616763-06c7-4f40-a1e0-7fe46002db68@googlemail.com>
Date: Wed, 13 Aug 2025 03:29:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812172948.675299901@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2025 um 19:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

When I was starting the build, I did get a lot of strange warning messages from a Python script which I have never seen 
before in a kernel build. I upgraded this machine some days ago from Proxmox VE 8.4 (based on Debian 12 Bookworm) to 
Proxmox VE 9.0 (bases on Debian 13 Trixie), so I now have Python 3.13.5. Before the upgrade it was Python 3.11. It now 
also has GCC 14.2 instead of GCC 12 before.

The messages I'm seeing are these (with some context), and I'm unfortunately not knowledgeable enough to understand 
their significance:


   UPD     include/generated/uapi/linux/version.h
   HOSTLD  arch/x86/tools/relocs
   UPD     include/generated/utsrelease.h
   UPD     include/generated/compile.h
   HOSTCC  scripts/bin2c
   HOSTCC  scripts/kallsyms
   HOSTCC  scripts/sorttable
   HOSTCC  scripts/asn1_compiler
   HOSTCC  scripts/genksyms/genksyms.o
   YACC    scripts/genksyms/parse.tab.[ch]
   LEX     scripts/genksyms/lex.lex.c
   HOSTCC  scripts/sign-file
   HOSTCC  scripts/selinux/genheaders/genheaders
   HOSTCC  scripts/insert-sys-cert
   HOSTCC  scripts/selinux/mdp/mdp
   DESCEND objtool
   DESCEND bpf/resolve_btfids
   HOSTCC  scripts/genksyms/parse.tab.o
   HOSTCC  scripts/genksyms/lex.lex.o
/usr/src/linux-stable-rc/scripts/bpf_doc.py --header \
         --file /usr/src/linux-stable-rc/tools/include/uapi/linux/bpf.h > 
/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/bpf_helper_defs.h
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 bpf.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 libbpf.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 btf.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 libbpf_common.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 libbpf_legacy.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 bpf_helpers.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 bpf_tracing.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 bpf_endian.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
gcc   -o /usr/src/linux-stable-rc/tools/objtool/fixdep /usr/src/linux-stable-rc/tools/objtool/fixdep-in.o
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 bpf_core_read.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 skel_internal.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 libbpf_version.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 usdt.bpf.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
gcc   -o /usr/src/linux-stable-rc/tools/bpf/resolve_btfids/fixdep 
/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/fixdep-in.o
/usr/src/linux-stable-rc/scripts/bpf_doc.py:62: SyntaxWarning: invalid escape sequence '\w'
   arg_re = re.compile('((\w+ )*?(\w+|...))( (\**)(\w+))?$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:64: SyntaxWarning: invalid escape sequence '\*'
   proto_re = re.compile('(.+) (\**)(\w+)\(((([^,]+)(, )?){1,5})\)$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:116: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?(BPF\w+)$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:120: SyntaxWarning: invalid escape sequence '\*'
   end_re = re.compile(' \* ?NOTES$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:135: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?((.+) \**\w+\((((const )?(struct )?(\w+|\.\.\.)( \**\w+)?)(, )?){1,5}\))$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:143: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?(?:\t| {5,8})Description$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:156: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?(?:\t| {5,8})(?:\t| {8})(.*)')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:169: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?(?:\t| {5,8})Return$')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:182: SyntaxWarning: invalid escape sequence '\*'
   p = re.compile(' \* ?(?:\t| {5,8})(?:\t| {8})(.*)')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:221: SyntaxWarning: invalid escape sequence '\s'
   bpf_p = re.compile('\s*(BPF\w+)+')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:226: SyntaxWarning: invalid escape sequence '\s'
   assign_p = re.compile('\s*(BPF\w+)\s*=\s*(BPF\w+)')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:241: SyntaxWarning: invalid escape sequence '\w'
   self.enum_syscalls = re.findall('(BPF\w+)+', bpf_cmd_str)
/usr/src/linux-stable-rc/scripts/bpf_doc.py:264: SyntaxWarning: invalid escape sequence '\s'
   p = re.compile('\s*FN\((\w+)\)|\\\\')
/usr/src/linux-stable-rc/scripts/bpf_doc.py:277: SyntaxWarning: invalid escape sequence '\('
   self.define_unique_helpers = re.findall('FN\(\w+\)', fn_defines_str)
/usr/src/linux-stable-rc/scripts/bpf_doc.py:410: SyntaxWarning: invalid escape sequence '\*'
   '/{}/,/\*\//:include/uapi/linux/bpf.h'.format(delimiter)]
/usr/src/linux-stable-rc/scripts/bpf_doc.py:501: SyntaxWarning: invalid escape sequence '\ '
   license string passed (via **attr**) to the **bpf**\ () system call, and this
/usr/src/linux-stable-rc/scripts/bpf_doc.py:583: SyntaxWarning: invalid escape sequence '\ '
   one_arg += ' {}**\ '.format(a['star'].replace('*', '\\*'))
\
                 if [ ! -d '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/' ]; then 
install -d -m 755 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'; fi; install exec-cmd.h 
-m 644 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'
\
                 if [ ! -d '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/' ]; then 
install -d -m 755 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'; fi; install help.h -m 
644 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'
\
                 if [ ! -d '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/' ]; then 
install -d -m 755 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'; fi; install pager.h -m 
644 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'
\
                 if [ ! -d '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/' ]; then 
install -d -m 755 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'; fi; install 
parse-options.h -m 644 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'
\
                 if [ ! -d '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/' ]; then 
install -d -m 755 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'; fi; install 
run-command.h -m 644 '/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd//include/subcmd/'
\
                 if [ ! -d ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf' ]; then install -d 
-m 755 ''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'; fi; install -m 644 
/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/bpf_helper_defs.h 
''/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/'/include/bpf'
   HOSTLD  scripts/genksyms/genksyms
   CC      scripts/mod/empty.o
   HOSTCC  scripts/mod/mk_elfconfig
   CC      scripts/mod/devicetable-offsets.s
   MKELF   scripts/mod/elfconfig.h
   HOSTCC  scripts/mod/modpost.o
   UPD     scripts/mod/devicetable-offsets.h
   HOSTCC  scripts/mod/sumversion.o
   HOSTCC  scripts/mod/file2alias.o
rm -f /usr/src/linux-stable-rc/tools/objtool/libsubcmd.a && ar rcs /usr/src/linux-stable-rc/tools/objtool/libsubcmd.a 
/usr/src/linux-stable-rc/tools/objtool/libsubcmd-in.o
rm -f /usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd/libsubcmd.a && ar rcs 
/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd/libsubcmd.a 
/usr/src/linux-stable-rc/tools/bpf/resolve_btfids/libsubcmd/libsubcmd-in.o
   HOSTLD  scripts/mod/modpost
   CC      kernel/bounds.s
   CHKSHA1 include/linux/atomic/atomic-arch-fallback.h
   CHKSHA1 include/linux/atomic/atomic-instrumented.h
   UPD     include/generated/timeconst.h
   CHKSHA1 include/linux/atomic/atomic-long.h
   UPD     include/generated/bounds.h



I will start over with trying to build the other 6.y stable RCs and see whether this is specific to 6.1.148-rc1 or 
whether it occurs there, too.


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
