Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC2D40B38D
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 07:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616178; cv=none; b=ByvhOf2tQBzDxkC9Xiyn9ScWPgaMXKKWq609tOULUwbMLggt+Y9P3vFDKAmDdnqb7rHy7vq+5Xm79dj+KWyIIKnouURvjfq2xLRkUL0dJLO0hJHXyc5fW0IELeHLBKjMVopvV5WaFN8MUwqyLwdhn/X1Zg+ZHKcZLtD+RsSCG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616178; c=relaxed/simple;
	bh=S9G+sBSYSmMXBhisqHbLvHHceupQGvHLcCB8+wA13sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aEbnHh42jzFBNcpyHaKgYCD7PqFGu38Wjbjyfyn0sKjW5YH5KMD+Z0YAfmSJPmH46hWnRdHxQVwq+kKnnqBHYIwCRPlzfn7RHUOFAToMMdpdJufxKcXFkDqdZs7szhQNbZ6JWDNQF2pWdmJ0IhzRZdVD/3flpILZZ3QLS1bWfiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hn0rH+CW; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hn0rH+CW"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so223450f8f.0
        for <patches@lists.linux.dev>; Sat, 10 Oct 2026 00:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791616174; x=1792220974; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TMxjq59OBAtUnM2DtD0UmWpPdwh4PH6N1GUz99zOIpQ=;
        b=hn0rH+CWTaQQT9fOcLu9/9oErOlSeLia6AbBJyMyq4kXW3tBYeGfis8vOBEZopb9WU
         FmaScdnAbzVJbsUA9FvS3TbaPTr+HuGnsv2eRKL8hp/RVC28iN5fYcVXfFMx0VdL3k47
         WxF/w3oPHKfTBlEyrpyMKzl6JLshyGU6K79DwAivAGsUBw971OQq9I5OpfnRBXqEbe3R
         YcYdfUeDiaKgKrl3Ztghu/Co+F0e3/FSYItIFxjxOX/WnhlLlWHPzOfhWtbT6o3J2gDS
         1+3XvZ+/Kc/q7oEp9eTB90pMDqVjrIoANVJACsqgsohvoiOttBPQsP4m7JKp/qXDXx3y
         k5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791616174; x=1792220974;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TMxjq59OBAtUnM2DtD0UmWpPdwh4PH6N1GUz99zOIpQ=;
        b=tg4ie2q9alPRFR0iv/t/yUEQxgXI0XDOq3qeKsip7eipskzjp0dJeci1bzpBFdPjh0
         Pl7vAHS1wUMfPBF8TOKm3MeGCtIo/EsS6VjUjqtzdz08USMw/83KSIrtbg0cttVuWaIv
         tirFCE2p+ytyO86YGg342616SIf7se4vIuS/K2I0c+oH84LJ136wwmuh/D1XmYyQYCzL
         EKTTfpcUPCcrGxhJXN4vgmjY8CQfvtmoPopTnBe8bTQYKOQNLQdPoZT2V/8pW2fo9dvB
         wBV00LwfqBoBNdjW8Y4RNuKOI6FMzfAXKse1JkRqXkp5nV2X0vxCMNkm5x7HiRA/Tpla
         RDWg==
X-Forwarded-Encrypted: i=1; AKwUvBwcuSxOH+EgtyQC0B7/ffZWOAsQdjQFTU32Wf6fmES0ZFCgds8p9ic9bIz4yxqFGTdFCs3Vf38t@lists.linux.dev
X-Gm-Message-State: AFq9FYIVjR/TX+JNWKwEkccn76TUUintkyOmVZlWpNIkZDIpR0jVtSeW
	VK7b2CgWk3GF4YHl2f8+LPpJQiia1EXwPGO97zgkOBpW72yxToPSU2JS
X-Gm-Gg: AYBFou0lsSJtL1s20Siel+TJNbsTQBJjuR4gTpqqQvYupnRrJmOvm6sIMO8nTQjqx+F
	9tV1+iVbuT9UXZJZSs+od2Pta+qF5NLXB2NWdavb9E9VZWYvYcuMAeIAMl8PrHigGjfX9JYn87O
	nmhw3sxrzacr+TLCMXlzD8rjkZJjJ5wmOK6OhtuRU/gBYcpUJkwPI1Xxhwtch66XeZyM4S/bhWP
	tHzvrWTqhy1qlOfZ1DhshU9fCdPAfsxe6etcRfcolM+10KJekS5xK5ia1QluzrQa9RGjzxmfj/t
	6Rk2fPigidSl/LDLDkywEciQR08wwEuLz+15UyzEpgAig9aIcfQleitntyBXF5keQ2aXypMnxCX
	v/38xpAIjWXF7j2zAazR0Y4P4J0DOj2uYg2Q30QuUTd55oaiEmL9bpTdK8/lPiUZVywdNqMgcQo
	yAisAR64TtzLfuutWFqrV0pPm/Dgnd3nkeTY0jgvmQonh3eWAbvVkjlCbF7knGE8m3mot7ZP4Hj
	sDMPFg0TjkT+YKrBvgFyTEJNBlKRG+YYAVk+Bs8wiVGEBDGG+1rP+ETK6i7knN6ayVZrYbnpQwk
	CvdsIGLWeVJZB/06f5pX6zdcaWnmt2dvn2yBfH7lEn6VJpEo4DIFl+PL5XcZYHfj8uEqjhhTuPI
	=
X-Received: by 2002:a05:600c:19cf:b0:4a0:1c43:3c04 with SMTP id 5b1f17b1804b1-4a18e4a988dmr71338785e9.13.1791616173605;
        Sat, 10 Oct 2026 00:09:33 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9d3f-0d01-48c7-5d76-0ec6-9dac.310.pool.telefonica.de. [2a02:3100:9d3f:d01:48c7:5d76:ec6:9dac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bc6a484sm117254135e9.2.2026.10.10.00.09.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:09:32 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 6.18 158/403] rust_binder: reschedule node refcount update on thread exit
Date: Sat, 10 Oct 2026 09:09:28 +0200
Message-Id: <20261010070928.87491-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261009140955.775132646@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org> <20261009140955.775132646@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[...]
> Cc: stable <stable@kernel.org>
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://patch.msgid.link/20260903-binder-thread-exit-node-v1-1-be09ff14f6a4@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
[...]
> --- a/drivers/android/binder/node.rs
> +++ b/drivers/android/binder/node.rs
[...]
> @@ -725,7 +725,21 @@ impl DeliverToRead for Node {
[...]
> +    fn cancel(self: DArc<Self>) {
> +        let _drop_outside_lock;
> +        let mut owner_inner = self.owner.inner.lock();
[...]
> +        if let Some(node) = ListArc::try_from_arc_borrow(self.as_arc_borrow()) {
> +            _drop_outside_lock = owner_inner.push_work(&self.owner, node);
> +        }
> +    }
[...]
> --- a/drivers/android/binder/node/wrapper.rs
> +++ b/drivers/android/binder/node/wrapper.rs
> @@ -57,7 +57,39 @@ impl DeliverToRead for NodeWrapper {
[...]
> +    fn cancel(self: DArc<Self>) {
> +        let _drop_outside_lock;
> +        let node = &self.node;
> +        let mut owner_inner = node.owner.inner.lock();
[...]
> +            if let Some(node2) = ListArc::try_from_arc_borrow(node.as_arc_borrow()) {
> +                ds.has_pushed_node = true;
> +                _drop_outside_lock = owner_inner.push_work(&node.owner, node2);

I object to this patch as queued: it causes compile errors with
CONFIG_ANDROID_BINDER_IPC_RUST=y.

The upstream commit was written on top of dbb17c9ea756 ("rust_binder:
move (e)poll wait queue to Process"), which added the Process argument
to ProcessInner::push_work(). That commit is not in 6.18, where
push_work() still takes only the work item, so the two new calls do not
compile. dbb17c9ea756 is a performance change with no Fixes: or stable
tag, so I am not suggesting to add it.

An LLM agent assisted with the review and the build test.

With CONFIG_RUST=y and CONFIG_ANDROID_BINDER_IPC_RUST=y (x86_64
defconfig otherwise, LLVM=1, rustc 1.98.0), "make drivers/android/" on
the review tip da42e30e9b04 fails:

  error[E0061]: this method takes 1 argument but 2 arguments were supplied
    --> drivers/android/binder/node/wrapper.rs:86:50
  note: method defined here
    --> drivers/android/binder/process.rs:172:19

  error[E0061]: this method takes 1 argument but 2 arguments were supplied
    --> drivers/android/binder/node.rs:740:46

ANDROID_BINDER_IPC_RUST depends on !ANDROID_BINDER_IPC, so a build with
the C binder enabled does not compile this code.

With this patch reverted the same build passes. It also passes with both
calls changed to the one-argument form, push_work(node) and
push_work(node2), but that is only compile-tested.

Thanks,
Karl
