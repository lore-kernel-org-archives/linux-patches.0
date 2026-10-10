Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617D3932E8
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 07:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615915; cv=none; b=qYNHdcVOUIa/GsfK27S3bMYHyQGFMqZjoz8FAh1fxDv+OrepQa/JLwJ4bKV6PiTWl9MxE6ZP/mxpzoKH8HNGJJDucNYlZ4G1+x6EIHF2WJ3L8IV7li3ZhFPBKXrfWdzKx85VfwXr0VCe4sy7qvscLR3/HTMKUwGUazXWlSQW4N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615915; c=relaxed/simple;
	bh=t8DVFcwVouByAULESlvSnWi9+KEBgxDGmG+Hr+IMQQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyweKRnXFspSZGWl9gqxW25Gdw1tJiguCBae3euskKQdm3ZRfEGW0CEB+D88L93q2IjdMV8VbsNktoBPuJa12EWW1cPhoZBMMiGK/hpPARR/amChhvdamLmWH8MTLfsNacV+g/Mm7wuOC/6rE8w4un5n/z60yHLHc8YNIwhB0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hqqjnhm3; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hqqjnhm3"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4be28b82so378235f8f.2
        for <patches@lists.linux.dev>; Sat, 10 Oct 2026 00:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791615912; x=1792220712; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DweFzcI4gHZFLSxIvwyVvNqAgdk6GYFvRotJCZPm6FQ=;
        b=Hqqjnhm3NUekZkl3zElXRFwN+1iVNatkKUreAmWTjAyZyGAk5mYfpcAmiWAcJUHl81
         cL98zlxvnyvg7nvWtvJPK0bkNpQVhc9vzPl4ttLyqYrjWWCXV0RKF//fxktl1WWlQsXU
         6myoLSj6q8zd9FH305hfEyTYKHJTXeP0i47BSPGMYt/mj63ymAPto9MlP0rNBar3WmRj
         5Tx4s4DiNQA2Hfd2EeRrMRJ+v/5BBO9MZ9txuYLENFbXYJd7X1dfhF8vt3X+xmi01+Mt
         4pTYYsj4/tvzxaQ3a/sEh9S7jUmButgIpMwoCLqt3UbuYvBkXvgw0OhgTt2a9ieMqwld
         EmKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791615912; x=1792220712;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DweFzcI4gHZFLSxIvwyVvNqAgdk6GYFvRotJCZPm6FQ=;
        b=i/8q34MFruXbIN6X8sPCNKyUSdUa21plWmlJ3KA8fUAb7LkKvel/4UKTI9+xzD8dwv
         BOaAgJeTnFn6oySuJ7FDoGvqk16dUU2MzQSCbDnKzyXt7Ya+qrMe4JBVuoC4qYndXyQ7
         +JTn/IPw9zm2mwu81hGn6zDs2oxcN4QCi/yUWeNLfX9NsGBPVRTggs0KfbKb513XMm1R
         OxZkeayeQB4Xrf6IhTSZDWUcSkoUK/XWRq2zxsHKGWXvuUMoSkpbaXzoDBxYNNHOwfv2
         g9Bp0vzJDme2JE7r9GiCYZwJWi4+SNhDIRZ4teCBxnKmN70xfPrq4i3hV7IDW5OO53xa
         djUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJcdtLyPbWECrwFYpgpwWDveUj3hpCYjrT12rtowVDKjMhzdMDlRxSMDUbK8sh/OnkVL4znteP@lists.linux.dev
X-Gm-Message-State: AFq9FYJtAXp9cH/rcArtrccADLz7QiG1uXd2C7944hX33liO7axA0EA4
	VPP+nUlmknA1sWzEG9WkexkCkrD65kQFKFJFJ2khRVXSVvxXIoc7o3Zf
X-Gm-Gg: AYBFou25/CxVINYkZu/6G7G46tVC2wp2eHopJhCJ8fG/l2E9DJAZ+F68353xCFx5Q6p
	R9oDD8EnipsVY0L6W5hJNNZ410P8uLsOsKcuaMM4Fl4W2qeyKnVb6rKf16Tt0gOpir8aeStJABi
	Dj3CVEoo1Xtylc0l+kfzfDJaFSoCR3iv4H29UGXc056cH70UuZdtAzI1JydM7qCI3LduiFAs0sX
	ybutS9qSjOnwofXqRs62IzkxPOSb1Pwl7nuau4rXQR1JvX9n5dKF1AvqOATQrSXe6sFAEo0/fQt
	FKNw/8WQunyfN0qR3jILzTY0oubCLk1LT3qpb/4YT5lDUU/Uk0mYgsaQP7CtYuOkvlE/MriarWW
	wTk9jyPhg+CKeo55SI/OnClb97pVBJIleuoB6YUvK0rk3OVxxB8uIci2Gf9C5Z+yJxMA0WNy6R6
	vOElUtFl3JH8pnKSULOXYwN/7GePUjxFkgu6vI6VpoujNtALKTXjLalyQqKyllWra99t2GjPUHR
	JEoroyXiGYFkm6KmqullyfZ00KZLLTuhxcjKXkEFqv3ET5j0gFfv5DdPhC7EEssVZJ+3ylinRL4
	XA8gUGWmtyE+ubXqjrGM/NCfgrlgoJ/HRssLnOH1FkdhfeCMnOAki2BxIh7JRdQsSLhv9lDCKEq
	B
X-Received: by 2002:a05:600c:3e0a:b0:4a0:1c10:1372 with SMTP id 5b1f17b1804b1-4a18e4aa206mr81147435e9.27.1791615912019;
        Sat, 10 Oct 2026 00:05:12 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9d3f-0d01-48c7-5d76-0ec6-9dac.310.pool.telefonica.de. [2a02:3100:9d3f:d01:48c7:5d76:ec6:9dac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18dcd7dd3sm68365155e9.2.2026.10.10.00.05.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:05:11 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 7.2 203/428] rust_binder: reschedule node refcount update on thread exit
Date: Sat, 10 Oct 2026 09:05:04 +0200
Message-Id: <20261010070504.73698-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261009140950.590490061@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org> <20261009140950.590490061@linuxfoundation.org>
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
> @@ -733,7 +733,21 @@ impl DeliverToRead for Node {
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
to ProcessInner::push_work(). That commit is not in 7.2, where
push_work() still takes only the work item, so the two new calls do not
compile. dbb17c9ea756 is a performance change with no Fixes: or stable
tag, so I am not suggesting to add it.

An LLM agent assisted with the review and the build test.

With CONFIG_RUST=y and CONFIG_ANDROID_BINDER_IPC_RUST=y (x86_64
defconfig otherwise, LLVM=1, rustc 1.98.0), "make drivers/android/" on
the review tip 77b730c57839 fails:

  error[E0061]: this method takes 1 argument but 2 arguments were supplied
    --> drivers/android/binder/node/wrapper.rs:86:50
  note: method defined here
    --> drivers/android/binder/process.rs:173:19

  error[E0061]: this method takes 1 argument but 2 arguments were supplied
    --> drivers/android/binder/node.rs:748:46

ANDROID_BINDER_IPC_RUST depends on !ANDROID_BINDER_IPC, so a build with
the C binder enabled does not compile this code.

With this patch reverted the same build passes. It also passes with both
calls changed to the one-argument form, push_work(node) and
push_work(node2), but that is only compile-tested.

Thanks,
Karl
