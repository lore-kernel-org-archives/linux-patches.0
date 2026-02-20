Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0903176EB
	for <patches@lists.linux.dev>; Fri, 20 Feb 2026 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771614720; cv=none; b=a1PPMCdEYuynu49auF2SCniN3uvp9LOrDFkxm6ekpWG2p74/hUIIgF8eW/GHt4xXhN2qy2OK1VMBGMySHbbyX17fFvOrwL4Ps90lD/nydwMjDIu9AJE1l+plF4RXOjDCVeIlr7Ssj82VuBEIuOIigknnw+0qC/y99uKXOewwI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771614720; c=relaxed/simple;
	bh=M8P+BbQ1YqZa4ng6H3k/8o1frpPX12XdeZj5ECuK2xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EonPwaibYzCA5pzfvFc4xPmDDvF4F86UJ7VU+Yyt5Y6YtKRUgNKL9+UATaJZ9v6IqS+g+jSL8QPeAnL05ht+uWlkwqZYtbACz6qlwvsUm5QjfsguMQwQvU0IyDizjmFG4o6OlHc3IBzhLYEqK+jlvJ90xWmTIErumJI68ZGRIMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Asd+fMzG; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Asd+fMzG"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48336a6e932so15678505e9.3
        for <patches@lists.linux.dev>; Fri, 20 Feb 2026 11:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771614718; x=1772219518; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zp4Hmr4tnrGJtnxnP1S6eBYh/Nilm6oZrfuoKYFMN2U=;
        b=Asd+fMzGgQy9qCF/OuY6sFS/Wn+zhQI58pyhjLph8ruIpk9C5kqIaS89yfYXKtRGcl
         XBKGVGjtmjUGPw4WEsQrYUo+pARRW6h8GA+HvU40AfSPUoR4/kCdY05A6WLEqoY1GMlF
         tEkbmvJrIMcq9UFuErjdU4x/Ev/bs5vO/5OI+6wVpwfMVUF8mbMTzi9nzLJqxpSZoXiI
         0mO9cPEbf6uWFwT7IG/yrewLyGcTxFGUUd6MFokGBf2qhkdNeLbQPT6a+5UyiuVPobIx
         yVFSILdnMXQnaRsZe5X4MxjKxv+BNyEUevOgNa7LW20U9pcAI8+NF1uckjJ0Hidw2jwj
         Skaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614718; x=1772219518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zp4Hmr4tnrGJtnxnP1S6eBYh/Nilm6oZrfuoKYFMN2U=;
        b=vU8Oq/dBz578xEuL9+GN8yaVxBhMybwc2O8/n2NdQn/oje1segLB3TWNqXtqBVyOLv
         JSrEAGa28YKfuae97TDltSiXAJixdfuaYl55EjUvK7f/V7CoJNbL3IZ2+CxDSKlLGmT9
         8qWL86Pho6DJcPUuE6I7Fcw0V7Dduqg2ZTz3Dg6xSr6D6vcyM5kYy2YRkoYEbnRPbsLO
         6sIw0WgYuEXgqsnqC6KVEwPjRk4xM6ulGqoNRfGyfWOGMgh78jSSKtrNpdQRUTE3hJ73
         qMqzGQqBHnS8yqkmpnJuA7h9a6rRRJEZmig3tQ89SXasTptjapm8rYKD3w0n3mU7eDBt
         L5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCU+pe3sVFXyN4hpbkwDurgLrzTMXhwQiT18eZDSuXTuATOHZnWZ0TlCYUrfd4IK1ilV0wP1i1fT@lists.linux.dev
X-Gm-Message-State: AOJu0YylxvnwVRdQNHW6wb6ndrhpQc7fPekBcydDaRjvYuGZJSAhcoCe
	aMzEwXcFoPxmJ/lyY2fo7ZLKgDNBXdMojhIUuW7fxuS9Dm6/9gBViuNP
X-Gm-Gg: AZuq6aIkXFhuSrT3EY3Ad7BYnxc27dwTFpEicCcRn/vNuxn71TatXHhllLylDRM0chs
	R5EzwZKLbg8vwyRVb3TkjQ/UGGn/HS/T0r2czzdqunfL8AQpomO1gqUBseT7ltqVkB9tHsm18Cd
	9nLAMZac10R+Yz2bHwNHcy70PIdKk+FmoaHO54EFi1CT5tYUV4CfmmCspUnggvcUW68D0X46JXB
	WARBQeedcanYNJAiVlRzc0iUXUm0R15t7f3i9lpsL8qIcr0v5CNpzmh2pR8tp2UkbvRH8k4TgAM
	l9Yk7qRW5nMt+8T3QGUi8MOLrN3tFAhlh6LQw87zVbvyYWKmuvq6ejhQFfPHSlmlGzYh3MViXxW
	oq57qyhVqtbICjZ+U4BToF8J04E+G1Dmq3TUUR3QOL9gNE+8+ub38RDdjvCTPfP2Y69qbNkLEHE
	+hBpsn4RBRVTkheIDtt302znV5NlEdHw==
X-Received: by 2002:a05:600c:3516:b0:483:a21:7744 with SMTP id 5b1f17b1804b1-483a9637590mr8799125e9.26.1771614717583;
        Fri, 20 Feb 2026 11:11:57 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a9b21ceasm3704985e9.0.2026.02.20.11.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 11:11:56 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: ddiss@suse.de
Cc: brauner@kernel.org,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nathan@kernel.org,
	nsc@kernel.org,
	patches@lists.linux.dev,
	rdunlap@infradead.org,
	rob@landley.net,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/2] init: ensure that /dev/console is (nearly) always available in initramfs
Date: Fri, 20 Feb 2026 22:11:50 +0300
Message-ID: <20260220191150.244006-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260220105913.4b62e124.ddiss@suse.de>
References: <20260220105913.4b62e124.ddiss@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

David Disseldorp <ddiss@suse.de>:
> I'd prefer not to go down this path:
> - I think it's reasonable to expect that users who override the default
>   internal initramfs know what they're doing WRT /dev/console creation.
> - initramfs can be made up of concatenated cpio archives, so tools which
>   insist on using GNU cpio and run into mknod EPERM issues could append
>   the nodes via gen_init_cpio, while continuing to use GNU cpio for
>   everything else.

This cannot be done in proper way.

Let's assume we want to build *builtin* initramfs using GNU cpio and
then concatenate to it an archive made by gen_init_cpio.

Then we want CONFIG_INITRAMFS_SOURCE to accept already existing cpio
archive AND file in gen_init_cpio format. But, according to
CONFIG_INITRAMFS_SOURCE docs in usr/Kconfig, this is not possible
(I didn't check whether this is true, I just have read the docs.)

This means that we should do this:

1. Generate an archive by invoking gen_init_cpio and concatenate it to
our preexisting archive
2. Create kernel config, while specifying resulting archive in
CONFIG_INITRAMFS_SOURCE
3. Build the kernel

Unfortunately, this will not work, because to invoke gen_init_cpio you
should build it first. And you cannot build it if there is no config
(I checked this).

So, we should do this:

1. Create kernel config, while specifying an archive in
CONFIG_INITRAMFS_SOURCE, which *DOES NOT EXISTS YET*
2. Build gen_init_cpio by invoking "make usr/gen_init_cpio"
3. Create an archive by invoking gen_init_cpio and concatenate it to
our preexisting archive. Put resulting archive to the path specified in
CONFIG_INITRAMFS_SOURCE
4. Build the kernel

Unfortunately, this will not work, either, because command
"make usr/gen_init_cpio" doesn't work in clean kernel tree even if
config exists (I checked this).

This means that the only remaining way is this:

1. Create *fake* kernel config
2. Build whole kernel (!!!)
3. Create an archive by invoking gen_init_cpio and concatenate it to
our preexisting archive
4. Create config, this time for real. Specify archive created in previous
step as CONFIG_INITRAMFS_SOURCE
5. Build the kernel, this time for real

I hope you agree that this is totally insane.

So, there is no proper way to create builtin initramfs by concatenating
archives created by GNU cpio and gen_init_cpio.

I think this is a bug in kbuild, and it probably needs to be fixed.

But I think that my patchset is a better approach. My patchset simply
ensures that /dev/console and /dev/null are always available, no matter
what. And thus my patchset side steps the whole issue.

Here are additional arguments in favor of my patchset.

* The kernel itself relies on presence of /dev/console in console_on_rootfs.
There is even comment there that currently says that opening of /dev/console
should never fail. (The comment is wrong, and this patchset fixes it.) So, if you
happen to supply builtin initramfs without /dev/console, then you will
build kernel, which violates its own assumptions. This will not be
detected until we actually try to boot the kernel. And even then it will
be hard to understand what exactly went wrong.

Why should we allow this failure mode? Let's instead ensure that this will
never happen. I. e. let's make sure that the kernel's asssumptions are always
true!

* My patchset makes the kernel not more complex, but more simple!
(28 insertions(+), 33 deletions(-).) Moreover, my patchset makes it
simpler not only in LoC sense, but in conceptual sense, too!
Currently codes in usr/default_cpio_list and init/noinitramfs.c are
very similar. It is possible that they will be out of sync in
some point of future.

By the way, noticing that they are out of sync is *very* hard. Consider
this scenario: usr/default_cpio_list contains this line:

nod /dev/null 0666 0 0 c 1 3

and init/noinitramfs.c contains this line:

init_mknod("/dev/null", S_IFCHR | 0666,
                        new_encode_dev(MKDEV(1, 3)));

Are these lines equivalent? You may think they are, but they are not.

init_mknod function above in fact creates node with different rights
due to umask of kernel thread. (And thus unprivileged users will be unable
to write to /dev/null...)

My patchset merges both codes into a single helper, thus making sure they
will never be out of sync. And thus my patchset reduces complexity of
the kernel.

* Currently it is okay not to put /dev/console to external initramfs.
But it is not okay not to put it to builtin initramfs. Why creating
builtin initramfs is harder than creating external initramfs? Why we make
lifes of developers in one of these cases harder without any reason?

Consider this scenario: somebody built kernel and external initramfs.
Everything works. Now they make this initramfs to be builtin.
Of course, they expect that everything will continue to work as before.
But it doesn't work. PID 1 doesn't print anything to console,
and you cannot even debug this, because it doesn't print anything to
console and you cannot see your debug printfs!

This clearly violates principle of least surprise.

-- 
Askar Safin
