Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BDB4C77
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 10:19:43 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id f13so21917193vsg.6
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 02:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mW7Qsc+LkNwU49jW8ZjK3kQHecamHHcZN3+W1tt/rQg=;
        b=JsKhM0TT7s7H2OljB5H9Nm0PFnlZuEsCXnmRTJs26tsebRJRNSAo25HE6/DzEsQYyw
         0dDBERm/heL+5CZZ6g6gSCak2GZN7RgF0VfezOUiMzcj1Cfl/RN2tw0CSXjAMaWV6LEe
         eCDkpPeYtp4rwVSxvCBjagzrfJ/sKF7CARUm2mw1BSipvUPk8zgXg6aP/LqG8ramibkn
         SGmy6r6T80UeUzLtH6zwXKThQr758t2/M9XNhYYrEGUjJjH4kx8hIHRMx9b357Fk275M
         m2RPFsC9i2XtolJsL2R2xsKzLJTJkDhByP+lmdKAoKIzy7RW5wnGp0z2g9at/SIGjwsN
         otjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mW7Qsc+LkNwU49jW8ZjK3kQHecamHHcZN3+W1tt/rQg=;
        b=Jh1NGx+mNYtmfIYLaCbwbap7j8R/oQZAXogLBiw7MNvR42bCt6QW8AT132kyTOsCYa
         XWTkVq1d1KvA9Cz84b1Gw+hXSzVLX41ElLRA9Brj/MlbXd5JfQJcMH14fiVy8pDX6RTx
         WWYLz8wWXYC0LjoO+pH9FywvG+68q+5fl0LO1hhoGcQJMPdhNqjWN7aiSuKfMNd3CpoO
         MJHF6fsJMCWdpQYDS+Y+Suhgl+yHbu9kNpbyBSEoQM6HNZ6AmkwzLoyzoCc9loT4+zSv
         r+tgKLViA7iOWLXLp9WtvVapFiwunxn3JwOtwHXMspzzzcgYBbnMPqheFffIkL2YArR8
         XDjg==
X-Gm-Message-State: AO0yUKUCZCZ9Cz3onAosCrzEFTcjE09u+P9Bu6ZDUZm6msblNccR/1fi
	pCsO9QT9XyxAEtXj8XgPaAUc4RCm0f7u9vsoxrN+Rg==
X-Google-Smtp-Source: AK7set92AkVKpvk5FqJ1Qjq+5W0UKJQNGj5d50Jv+hTSG3ohEWHYn7dbfUpzFKUsCFk6ttfjcXZ+GkYkYW8AP4abWYQ=
X-Received: by 2002:a05:6102:3202:b0:412:2f46:4073 with SMTP id
 r2-20020a056102320200b004122f464073mr6147566vsf.3.1677752381868; Thu, 02 Mar
 2023 02:19:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230301180657.003689969@linuxfoundation.org>
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 Mar 2023 15:49:31 +0530
Message-ID: <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev, 
	Florian Westphal <fw@strlen.de>, Mat Martineau <mathew.j.martineau@linux.intel.com>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Mar 2023 at 23:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on Linux version 6.1.15-rc1 on 32-bit arm x15 and i386.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: b6150251d4ddf8a80510c185d839631e252e6317
* git describe: v6.1.14-43-gb6150251d4dd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd

Regression test cases,
i386:
x15:
  * kselftest-net-mptcp/net_mptcp_mptcp_sockopt_sh

# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.

test log:
----------

# selftests: net/mptcp: mptcp_sockopt.sh
[  918.263983] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
[  918.398851] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
[  918.538987] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
[  918.678270] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
[  918.800671] audit: type=1325 audit(1677748585.128:33): table=filter
family=2 entries=0 op=xt_register pid=18489 subj=kernel
comm=\"iptables\"
[  918.813228] audit: type=1300 audit(1677748585.128:33):
arch=40000003 syscall=102 success=yes exit=0 a0=f a1=bf94ed3c a2=40
a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.842987] audit: type=1327 audit(1677748585.128:33):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
[  918.859285] audit: type=1325 audit(1677748585.128:34): table=filter
family=2 entries=4 op=xt_replace pid=18489 subj=kernel
comm=\"iptables\"
[  918.871788] audit: type=1300 audit(1677748585.128:34):
arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bf94ef64 a2=40
a3=b7edfe3c items=0 ppid=18412 pid=18489 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.901496] audit: type=1327 audit(1677748585.128:34):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D73796E002D6D006D61726B002D2D6D61726B0031002D6A00414343455054
[  918.934555] audit: type=1325 audit(1677748585.262:35): table=filter
family=2 entries=5 op=xt_replace pid=18490 subj=kernel
comm=\"iptables\"
[  918.947242] audit: type=1300 audit(1677748585.262:35):
arch=40000003 syscall=102 success=yes exit=0 a0=e a1=bfc21cd4 a2=40
a3=b7f27e3c items=0 ppid=18412 pid=18490 auid=4294967295 uid=0 gid=0
euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=4294967295
comm=\"iptables\" exe=\"/usr/sbin/xtables-legacy-multi\" subj=kernel
key=(null)
[  918.976905] audit: type=1327 audit(1677748585.262:35):
proctitle=69707461626C6573002D41004F5554505554002D7000746370002D2D7463702D666C6167730052535400525354002D6D006D61726B002D2D6D61726B0030002D6A00414343455054
[  919.013445] audit: type=1325 audit(1677748585.341:36): table=filter
family=2 entries=6 op=xt_replace pid=18491 subj=kernel
comm=\"iptables\"
# Created /tmp/tmp.CG4evZjYl7 (size 1 KB) containing data sent by client
# Created /tmp/tmp.urARJfNrFp (size 1 KB) containing data sent by server
# PASS: all packets had packet mark set
# mptcp_[  944.426054] kauditd_printk_skb: 50 callbacks suppressed
sockopt: mptcp_s[  944.426057] audit: type=1701
audit(1677748610.753:53): auid=4294967295 uid=0 gid=0 ses=4294967295
subj=kernel pid=18532 comm=\"mptcp_sockopt\"
exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
sig=6 res=1
[  944.452415] audit: type=1701 audit(1677748610.753:54):
auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=18533
comm=\"mptcp_sockopt\"
exe=\"/opt/kselftests/default-in-kernel/net/mptcp/mptcp_sockopt\"
sig=6 res=1
ockopt.c:353: do_getsockopt_tcp_info: Assertion `ti.d.size_user ==
sizeof(struct tcp_info)' failed.
# mptcp_sockopt: mptcp_sockopt.c:353: do_getsockopt_tcp_info:
Assertion `ti.d.size_user == sizeof(struct tcp_info)' failed.
# server killed by signal 6
#
# FAIL: SOL_MPTCP getsockopt
# PASS: TCP_INQ cmsg/ioctl -t tcp
# PASS: TCP_INQ cmsg/ioctl -6 -t tcp
# PASS: TCP_INQ cmsg/ioctl -r tcp
# PASS: TCP_INQ cmsg/ioctl -6 -r tcp
# PASS: TCP_INQ cmsg/ioctl -r tcp -t tcp
not ok 6 selftests: net/mptcp: mptcp_sockopt.sh # exit=1


Test results comparision link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd/testrun/15204254/suite/kselftest-net-mptcp/test/net_mptcp_mptcp_sockopt_sh/history/?page=1
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.14-43-gb6150251d4dd/testrun/15204254/suite/kselftest-net-mptcp/test/net_mptcp_mptcp_sockopt_sh/details/
https://lkft.validation.linaro.org/scheduler/job/6211923#L2664

--
Linaro LKFT
https://lkft.linaro.org
