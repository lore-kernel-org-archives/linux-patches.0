Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06961B5ED8;
	Wed, 20 Nov 2024 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732138148; cv=none; b=GaFruorIPZtKLJx9rIq6jELtL7IRLzoilEpY9KchZB33cQHIKBOodkk8bBoSBxySCcnm0UXoQhif0VHykMmgURvhTvf0lARsjMBrEm44zeDHH9yVMBA6w57nyNeyF7iE/dwmy8I+/FyqNLncqm3lQGn4ZtQk9lRzsyFg5XIzwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732138148; c=relaxed/simple;
	bh=AH7jBkvW3vmQevUwT1qZe6oh5eRiuiDeIP9puuoH2g0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFK12/igTO7kgt0d7Xt/CCJWf9BfJzsIdFLU5+h41P6y9Gy//9/9PkHVs0mcqww37vmMBeMpddTes5mwBnPTbVYAeFuBT9TunP3I218Qg4dRzW9m4tsHGdftTR13N0in5qWXHIyjHTtgOMDNOgt74CJDAORxILfth74jb3TG53s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=umgXeC4i; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="umgXeC4i"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id B81CA14C1E1;
	Wed, 20 Nov 2024 22:29:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1732138143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QpBeDvQksNg01sH+Wzi0SHUbla6WiWqM9PQqY8u5gPQ=;
	b=umgXeC4iOmTTUmV1dgALJ1ehGtwZMRzyy5BnORN5sMRzYtGwm0HMdNSsHwch/tGMCaku8n
	sk6Bwb2/zSPUaQ5/U6NNehRKMmp9dWKn5hbo3LvjhlYfxZXdkHXhAul2fdzNj+05/dFS44
	5hmrIOxY3+0Bm34ctJce1niJIgeLSpuFgu4joCEPNRcbp3m84zpCTZp3+G8geKnmNmsbkG
	CgbXDmhWbkM9XMUt2dyIS127mzFn7RxOCAEvnNvuUEKJ6awgs71bzLtUGF1TD4KmPDH7+z
	Nx1uxUwPV/PMaqo5+mBo5DXhnDhqFYrD05ydOxbG2tJ0gSr6kQ+yWvIhsm81cQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 4cec0879;
	Wed, 20 Nov 2024 21:28:58 +0000 (UTC)
Date: Thu, 21 Nov 2024 06:28:43 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Kees Cook <kees@kernel.org>
Cc: Ulrich Teichert <ulrich.teichert@kumkeo.de>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"y0un9n132@gmail.com" <y0un9n132@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Message-ID: <Zz5Ui1lf3cu0bBlN@codewreck.org>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
 <Zz0_-iJH1WaR3BUZ@codewreck.org>
 <Zz2JQzi-5pTP_WPx@eldamar.lan>
 <Zz2YrA740TRgl_13@codewreck.org>
 <eaf6cfe58733416c928a8ff0d1d1b1ec@kumkeo.de>
 <202411201000.F3313C02@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202411201000.F3313C02@keescook>

Thank you for the replies,

Kees Cook wrote on Wed, Nov 20, 2024 at 10:08:04AM -0800:
> It seems like the correct first step is to revert the brk change. It's
> still not clear to me why the change is causing a problem -- I assume it
> is colliding with some other program area.
> 
> Is the problem strictly with qemu-user-static? (i.e. it was GCC running
> in qemu-user-static so the crash is qemu, not GCC) That should help me
> narrow down the issue. There must be some built-in assumption. And it's
> aarch64 within x86_64 where it happens (is the program within qemu also
> aarch64 or is it arm32)?

As far as I'm aware I've only seen qemu-user-static fail for aarch64
(e.g. the arm32 variant works fine, didn't try other arches) in this
particular configuration (the debian bookworm package has been built
with --static-pie which is known to cause problems)

It's also fixed in newer versions of qemu, even with --static-pie,
because they reworked the way they detect program mapppins in qemu
commit dd55885516 ("linux-user: Rewrite non-fixed probe_guest_base")
and that also fixed the issue (in qemu 8.1.0)

So, in short there are many fixes available; it's a qemu bug that
assumed something about the memory layout and broke with this kaslr
patch (and for some reason only happened on non-pie static build)


mjt will at the very least rebuild the package with pie enabled, because
it's known to cause other issues with aarch64 and that was an oversight
in the first place, so this issue will go away for debian without any
further work.

This is the background behind me saying that this probably should be
reverted in stable branches (to avoid other surprises with old
userspace), but master can probably keep this commit if it brings
tangible security benefits (and I think it does)

See the debian qemu-side of the bug for details:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1087822


> Is there an simple reproducer?

Unfortunately I couldn't get it to reproduce easily, but I think it's
just a matter of finding the right binary that does problematic mappings
(e.g. running true in a loop didn't work but running gcc in a loop did)

The most reliable reproducer I've been using is building a reasonably
large program, we were working on modemmanager at the time so that's
what I used; if usually fails between 100-300/500 of the build:
----
$ docker run -ti --rm --platform linux/arm64/v8 docker.io/arm64v8/alpine:3.20 sh
/ # apk add bash-completion-dev dbus-dev elogind-dev gobject-introspection-dev gtk-doc libgudev-dev libmbim-dev libqmi-dev linux-headers meson vala clang abuild alpine-sdk curl
/ # curl -O https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/archive/1.22.0/ModemManager-1.22.0.tar.gz
/ # tar xf ModemManager-1.22.0.tar.gz
/ # cd ModemManager-1.22.0/
/ # abuild-meson \
        -Db_lto=true \
        -Dsystemdsystemunitdir=no \
        -Ddbus_policy_dir=/usr/share/dbus-1/system.d \
        -Dgtk_doc=true \
        -Dsystemd_journal=false \
        -Dsystemd_suspend_resume=true \
        -Dvapi=true \
        -Dpolkit=no \
        . output
/ # meson compile -C output
----

If you take any of the command that failed from this build and run it in
a loop, it'll also eventually fail after a couple hundred of
invocations, but if your loop doesn't involve any parallelism that'll be
slower to reproduce.

Note it requires qemu to be broken as well, so you'll have best chances
with a debian bookworm (VM is fine; a chroot or podman instead of docker
is also fine; in the chroot case ninja requires at least /dev (and
possibly /proc) mounted)


Thanks,
-- 
Dominique Martinet | Asmadeus
