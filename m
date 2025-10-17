Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E94A30C37D
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681410; cv=none; b=iLt23dCdlwySsdLBKPnwUi3bRRcVccE7E3jbEvatnwweafG8Q3qEQeDs3003/1lnavdOBRBJUjF+5DTupBWAd0ZBMKeC5QKacVBEQPHPYBjHnhC4PJehrKTK9Ak1Zf7DCo5OJSxYi3ihzfE+pZHiTJk2LdRO1ZnU62wCWpZ/GLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681410; c=relaxed/simple;
	bh=PTeCjpmyIduQtL+k+FvKXkT5QKPZ5hJEEZjKkNV8bTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GcgKU5K3Xjvnsip9yHuS/cvRplf46F99OBtZk180snFOYVj9X/TPhIttUl6PUyHaJohE7Ve5l6m0tLCdTU4zOkkZ5GpPIsw6QnVfMzYgFd6g4VHHtv++y2Gd0X3jMFdw33RlccgBiBXIFvAL1/QKuS2QChmccWX6nz5YFgFEk48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V2xF+oPS; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2xF+oPS"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-471191ac79dso5548245e9.3
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 23:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760681405; x=1761286205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YKOBkkWD4hkodywyrqPuA/TDPu23QJtZxY6LZ9yXiLM=;
        b=V2xF+oPSfEuAT9msjiXGyJOoLGbIqlvRSAjnzFq18oxXBTIwbunoIY6xs+68m3fujw
         CBbrVcGdJymEZ1vntYpr8mNLMO9bcV0QMbjCVywtZp2xjEwurv+d15Xo5RLF4QlXWDKW
         EB5aKgHy0qY2KlfSNPIXaQ2MLUDqqcU9ymEAvE7C5JwVIm/8N4/+dtkbiJSY79Kgtzrp
         /cKX0cHDMOrP7WF0HDunviUI1PNu42+lSnjsWBP+Vz9XAQZ2QfRI1ikvEroXzugEwJc6
         DcZ96jsRaoZbpVz0jqW/L8SOvB8EFKegjO24GbcUklgBKcrZmEC8amOkLIkbMsOnCUv5
         35pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760681405; x=1761286205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKOBkkWD4hkodywyrqPuA/TDPu23QJtZxY6LZ9yXiLM=;
        b=HJkt117OUNkbKOTrVjx6RcHPWcAUzHiWNgGwp5Uri3MMUBazc50mNFWfbHEstyU0ax
         A5Qf+0BSsV0xJ5VNPQOzEO6WUrkAzK55mG3bHUR0apip946Cj0hGSa88Vy2C8HPP0L7V
         k/wSnndZE4YhSeeHcGvrC5rfc4BgSUqkKfOfPkwHBPUG5zp2PlU5TgqSEXwnK6fllaiw
         aDxcgLrQmMvZOSvwLTKNUD/1QF0prAOT59eUFaFtDczGIpn8Ba7qI+fF5FuEOe630ckR
         7wW/3+y612Z2o0EslwWZxmkWFUCaO940pzCjPxYMZoprPkn+2t/PcR4hQiMuZsucC768
         wRpA==
X-Forwarded-Encrypted: i=1; AJvYcCUafLYzybiOnkjfAlU1Pr8vIyaCbIISjNUl272worP5QGxOLKWtLhUJBMcapP43DBgyouKq4Orh@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8dAoiuNtFfN36F1OjnyXtFPf9nOyqPNeWBE/80FSGXuXR1sAV
	GacNFBqPv+g1kle8OOeHAZ8H7W2jyRiWDiNu5YYHJis7CLmKO9K8c1ZN
X-Gm-Gg: ASbGncuJJqrgNYmkJRDTrv9L+hZ+6m/ZjlFHCet1nW9xjsE6KNm0hofa6W0Cfk1eBHY
	+B4Jf8y0zrK7w3+FxEvDfd/tsMRYw6pisEcCxVnt3Cvlv4uM31/ZHPI5OJVJJFv0JHQT4Xz7BIe
	69QPgYVuQgGS0sGtgvOB+/Yx+xqHK+dLt/xJ92B5CZ0ibH6pOAIH1n8wd933Z2aC7ANKDPGy/iN
	Ywhr9Bs9g4mC0o6iBjMlFwPRRPUpDVTYGd6Vnn8m8EZzxLaFn62fnis9d8fuEpRHY3w9CkHcyWu
	kSBKrR6m6Ap+U9PvOC/MIYzgsG4B1IF6cQ4AquD1gA2rwhV3026G1IdCnyVZWP8b3sghfXOC6VW
	h+sJLW5wI4TL6AqRo7XfS2sCsamqwLKvibmnoxkBOPUvnSkHcQoSuB0ux3qJeyRmXfKV6hIv28F
	R3aXhkjlmDBnY=
X-Google-Smtp-Source: AGHT+IGZ4ambk8T3o48xvPm40t3Ay+iXThL+hr7h4NpNwxZaAMKHno3K1osHDhvr/3GCz1pzwYtqQQ==
X-Received: by 2002:a05:6000:178f:b0:3ee:1521:95fc with SMTP id ffacd0b85a97d-42704d8812bmr1885897f8f.14.1760681405257;
        Thu, 16 Oct 2025 23:10:05 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426ce5e1284sm38327970f8f.45.2025.10.16.23.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 23:10:04 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Art Nikpal <email2tema@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Rob Landley <rob@landley.net>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-arch@vger.kernel.org,
	linux-block@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Young <dyoung@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Jessica Clarke <jrtc27@jrtc27.com>,
	Nicolas Schichan <nschichan@freebox.fr>,
	David Disseldorp <ddiss@suse.de>,
	patches@lists.linux.dev
Subject: [PATCH v3 0/3] initrd: remove half of classic initrd support
Date: Fri, 17 Oct 2025 06:09:53 +0000
Message-ID: <20251017060956.1151347-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intro
====
This patchset removes half of classic initrd (initial RAM disk) support,
i. e. linuxrc code path, which was deprecated in 2020.
Initramfs still stays, RAM disk itself (brd) still stays.
And other half of initrd stays, too.
init/do_mounts* are listed in VFS entry in
MAINTAINERS, so I think this patchset should go through VFS tree.
I tested the patchset on 8 (!!!) archs in Qemu (see details below).
If you still use initrd, see below for workaround.

In 2020 deprecation notice was put to linuxrc initrd code path.
In v1 I tried to remove initrd
fully, but Nicolas Schichan reported that he still uses
other code path (root=/dev/ram0 one) on million devices [4].
root=/dev/ram0 code path did not contain deprecation notice.

So, in this version of patchset I remove deprecated code path,
i. e. linuxrc one, while keeping other, i. e. root=/dev/ram0 one.

Also I put deprecation notice to remaining code path, i. e. to
root=/dev/ram0 one. I plan to send patches for full removal
of initrd after one year, i. e. in September 2026 (of course,
initramfs will still work).

Also, I tried to make this patchset small to make sure it
can be reverted easily. I plan to send cleanups later.

Details
====
Other user-visible changes:

- Removed kernel command line parameters "load_ramdisk" and
"prompt_ramdisk", which did nothing and were deprecated
- Removed /proc/sys/kernel/real-root-dev . It was used
for initrd only
- Command line parameters "noinitrd" and "ramdisk_start=" are deprecated

This patchset is based on v6.18-rc1.

Testing
====
I tested my patchset on many architectures in Qemu using my Rust
program, heavily based on mkroot [1].

I used the following cross-compilers:

aarch64-linux-musleabi
armv4l-linux-musleabihf
armv5l-linux-musleabihf
armv7l-linux-musleabihf
i486-linux-musl
i686-linux-musl
mips-linux-musl
mips64-linux-musl
mipsel-linux-musl
powerpc-linux-musl
powerpc64-linux-musl
powerpc64le-linux-musl
riscv32-linux-musl
riscv64-linux-musl
s390x-linux-musl
sh4-linux-musl
sh4eb-linux-musl
x86_64-linux-musl

taken from this directory [2].

So, as you can see, there are 18 triplets, which correspond to 8 subdirs in arch/.

For every triplet I tested that:
- Initramfs still works (both builtin and external)
- Direct boot from disk still works
- Remaining initrd code path (root=/dev/ram0) still works

Workaround
====
If "retain_initrd" is passed to kernel, then initramfs/initrd,
passed by bootloader, is retained and becomes available after boot
as read-only magic file /sys/firmware/initrd [3].

No copies are involved. I. e. /sys/firmware/initrd is simply
a reference to original blob passed by bootloader.

This works even if initrd/initramfs is not recognized by kernel
in any way, i. e. even if it is not valid cpio archive, nor
a fs image supported by classic initrd.

This works both with my patchset and without it.

This means that you can emulate classic initrd so:
link builtin initramfs to kernel; in /init in this initramfs
copy /sys/firmware/initrd to some file in / and loop-mount it.

This is even better than classic initrd, because:
- You can use fs not supported by classic initrd, for example erofs
- One copy is involved (from /sys/firmware/initrd to some file in /)
as opposed to two when using classic initrd

Still, I don't recommend using this workaround, because
I want everyone to migrate to proper modern initramfs.
But still you can use this workaround if you want.

Also: it is not possible to directly loop-mount
/sys/firmware/initrd . Theoretically kernel can be changed
to allow this (and/or to make it writable), but I think nobody needs this.
And I don't want to implement this.

On Qemu's -initrd and GRUB's initrd
====
Don't panic, this patchset doesn't remove initramfs
(which is used by nearly all Linux distros). And I don't
have plans to remove it.

Qemu's -initrd option and GRUB's initrd command refer
to initrd bootloader mechanism, which is used to
load both initrd and (external) initramfs.

So, if you use Qemu's -initrd or GRUB's initrd,
then you likely use them to pass initramfs, and thus
you are safe.

v1: https://lore.kernel.org/lkml/20250913003842.41944-1-safinaskar@gmail.com/

v1 -> v2 changes:
- A lot. I removed most patches, see cover letter for details

v2: https://lore.kernel.org/lkml/20251010094047.3111495-1-safinaskar@gmail.com/

v2 -> v3 changes:
- Commit messages
- Expanded docs for "noinitrd"
- Added link to /sys/firmware/initrd workaround to pr_warn

[1] https://github.com/landley/toybox/tree/master/mkroot
[2] https://landley.net/toybox/downloads/binaries/toolchains/latest
[3] https://lore.kernel.org/all/20231207235654.16622-1-graf@amazon.com/
[4] https://lore.kernel.org/lkml/20250918152830.438554-1-nschichan@freebox.fr/

Askar Safin (3):
  init: remove deprecated "load_ramdisk" and "prompt_ramdisk" command
    line parameters
  initrd: remove deprecated code path (linuxrc)
  init: remove /proc/sys/kernel/real-root-dev

 .../admin-guide/kernel-parameters.txt         |  12 +-
 Documentation/admin-guide/sysctl/kernel.rst   |   6 -
 arch/arm/configs/neponset_defconfig           |   2 +-
 fs/init.c                                     |  14 ---
 include/linux/init_syscalls.h                 |   1 -
 include/linux/initrd.h                        |   2 -
 include/uapi/linux/sysctl.h                   |   1 -
 init/do_mounts.c                              |  11 +-
 init/do_mounts.h                              |  18 +--
 init/do_mounts_initrd.c                       | 107 ++----------------
 init/do_mounts_rd.c                           |  24 +---
 11 files changed, 23 insertions(+), 175 deletions(-)


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.47.3

