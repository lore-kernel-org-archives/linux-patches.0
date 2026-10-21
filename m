Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792613840;
	b=DtGt8KopHWmsl0wI24S3JP2GeodQ7+1/kOkAdkvW01QKhrKaMKfn35aGqSZJcJ7Ajxgn
	 ++kWUBlKR+jumXcygMbWorHLYE/VQa1I3yEAhTtv6cvFAM77UBztxiZ+Af/I5Zo1dZh1n
	 SMDJd2PaobltkEpMLDmBCm755IBR76QAkwJyTafI5wEMoZMrMzOOm2hVdoEVViyW2dK3V
	 N3bECVmHe5AH3q9m11cBx7oYLqpm6OEp7WdwxgOaK85NweroMZa+onGEYzR90BJX0WW6H
	 BfS/Fc6bRFuqUSfX6rTu/v4kb4wgCUv5gbZd3+y78CAqWKPbhQmpPmEvZUklkkVl4lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792613840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=y5zGwiWlY/+7u7tVy4Nz9l+XQayzXqtSRL/HPTqEiC4=;
	b=jeaQGj5IBFuO7SFxLimrCG8Az8lMQmJpKQwyslrV8XFds0rhGrUbV+gyk0liIueX3hgf
	 ACNwVU9UXYQAHgoTpOlDq1IPkD50OaZiEjRHpz4GoKiUo5XwRbfIt4n0eRyAbO2OfZWGk
	 cvsnszc3c3sJTxaQMR6V8sn2aP+4vf/F83qhttJeAt/f/1UxiH9447of/NxaJ5dXtogh+
	 J+BJq9beVK0g/TK1j/pzv/XKl5cQyTo0rWak+a9FB0LCJj/+cvWIgZMFdVpYGnP/FdhYt
	 OKR/hkzbvCwGzzCjwin9oZ3xYQ7Q1QdUSujAvnJhjNQOAat5wWEAMaxwI0FnFygaMsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rHa93X7a;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDB606A328
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 20:17:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7FDB606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rHa93X7a
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a03834d8ffso1329055b3a.3
        for <patches@lists.linux.dev>; Wed, 21 Oct 2026 13:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792613839; x=1793218639; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y5zGwiWlY/+7u7tVy4Nz9l+XQayzXqtSRL/HPTqEiC4=;
        b=rHa93X7aqJa7HiYwhVf7vtnPpMh8P83UtX/VUATtZ62ZuxkZ8gZ9NmFwZzKJN2yLUf
         K7+g1vfWfif8rCxhs24AogJZFUrmJGl/ojrt/Z8BqPtbB7T/0LUDFocytILkXO1Q/xUY
         YDb6hgc8o5Ym+kFiUqeHxfRDaEfmdpP5K8/cZpOz9W5Skrd6FuTLzr32nNCDDMwLf7bd
         ITzADPLwduBUUjfIWsas72KFdiiE6jJKzxtEBG8YhM/5nJ6wtOzkhrddY6B4/qyjpN51
         WWVuZ4wOYjN493hxW0MjSltth/Ma03DOHNifHE4fs9pQnr6YQdzmF5++1KiA77/kkCml
         W9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613839; x=1793218639;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y5zGwiWlY/+7u7tVy4Nz9l+XQayzXqtSRL/HPTqEiC4=;
        b=q5w9ME6JQZDjZHOiBJtZ70rMYuoo/OSeXdZthZ7n9RNNhKOHcz83CKdUZHCAcu7f++
         E9XZWKIEjr2butx6HZoUt47vy4aIqO8nUkVOKOHEuzy0spNwQIjtdRVT4HB8RSvMmaNy
         kTUOuFJjkkXhqQcVgdzZSlBEVcKqrFdFYrLYfzDL+UDDCqmMRDE3NTdJvw3FYaQUM5Cr
         ZPgUD0Z9QWUpdz4G73p5i58mLOh2C/w4pNXDG5BfSUn0XjJ4+vIVIihV0PQqym8/1pyU
         /AXNr059l6VYnxz4PKkqpyNvjhennjqMSnxPAzbLGyIqZ8kSge3PeFRcJOAGrlHKf7ms
         9HAw==
X-Gm-Message-State: AFq9FYK+FnqYpwYskkLC6CHJUtM0sz/fG4p9B2ulv2bEqpM8mFUdGZ/D
	h6sSMAw/ut0mJmZuw2+hK5y2p6GWeb46jgsbhcyv0pWzVBaKF7hT8p5A2Or0okQReVqSpb0brc6
	CmBZfEg==
X-Received: from pgbda1.prod.google.com ([2002:a05:6a02:2381:b0:cd6:9aa1:6906])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e8d:b0:3db:4e0a:df51
 with SMTP id adf61e73a8af0-3e287dd6182mr2176941637.22.1792613838826; Wed, 21
 Oct 2026 13:17:18 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:17:18 -0700
In-Reply-To: <20261019135441.1420968-127-sashal@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-127-sashal@kernel.org>
Message-ID: <atkdzsPJgcu123DO@google.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.6] KVM: x86/xen: Prevent runstate times
 from becoming negative
From: Sean Christopherson <seanjc@google.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	David Woodhouse <dwmw@amazon.co.uk>, Paul Durrant <paul@xen.org>, dwmw2@infradead.org, 
	pbonzini@redhat.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026, Sasha Levin wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> [ Upstream commit 36a85200643e62d20a91f0bc1a811187b59f7762 ]
>=20
> When kvm_xen_update_runstate() is invoked to set a vCPU's runstate, the
> time spent in the previous runstate is accounted. This is based on the
> delta between the current KVM clock time, and the previous value stored
> in vcpu->arch.xen.runstate_entry_time.
>=20
> If the KVM clock goes backwards, that delta will be negative. Or, since
> it's an unsigned 64-bit integer, very *large*. Linux guests deal with
> that particularly badly, reporting 100% steal time for ever more (well,
> for *centuries* at least, until the delta has been consumed).
>=20
> So when a negative delta is detected, just refrain from updating the
> runstate times until the KVM clock catches up with runstate_entry_time
> again.
>=20
> Also clamp steal_ns to delta_ns to prevent steal time from exceeding
> the total elapsed time, and handle negative steal_ns (which can happen
> if run_delay goes backwards across a scheduler update).
>=20
> The userspace APIs for setting the runstate times do not allow them to
> be set past the current KVM clock, but userspace can still adjust the
> KVM clock *after* setting the runstate times, which would cause this
> situation to occur.
>=20
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> Link: https://patch.msgid.link/20260728144954.355376-21-dwmw2@infradead.o=
rg
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

...

> **Step 8.1: DETERMINE WHO IS AFFECTED**
> Xen-ABI KVM guests with runstate/steal enabled (`CONFIG_KVM_XEN` + VMM
> setup). Not all KVM users.
>=20
> Record: [config/driver-specific: KVM Xen guests]
>=20
> **Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
> 1. `KVM_SET_CLOCK` (live migration/snapshot) after runstate SET_ATTR =E2=
=80=94
>    documented, exists in this tree
> 2. kvmclock discontinuities from masterclock re-snapshot =E2=80=94 still =
present
>    here; the rest of the series is **not**
> 3. `run_delay < last_steal` unsigned wrap (ioctl uses VMM `current`;
>    vCPU path uses the vCPU task)
>=20
> Unprivileged guest cannot call `KVM_SET_CLOCK`; the VMM can. Guest then
> sees broken steal forever.
>=20
> Record: [migration/SET_CLOCK and steal wrap] [realistic in production
> Xen-on-KVM] [VMM-triggered, guest-visible]
>=20
> **Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
> Not a host oops. Guest scheduler steal accounting becomes permanently
> wrong (100% steal for ~centuries). That breaks guest CPU accounting,
> load, and can stall workloads/watchdogs. **HIGH** for those guests (not
> host CRITICAL).
>=20
> Record: [guest steal corruption / apparent 100% steal] [HIGH]
>=20
> **Step 8.4: CALCULATE RISK-BENEFIT RATIO**
> Benefit: stops a permanent guest-visible accounting failure on a path
> used in migration. Risk: ~20 lines, no locking/API change, skip-
> accounting is conservative.
>=20
> Record: [high benefit for Xen-on-KVM] [very low risk] [favorable]

Two questions: do we care abou this specific flaw, and does anyone run Xen =
guests
with KVM using an LTS kernel?  I agree with AI's assessment that this is lo=
w risk,
but unless this will actually benefit someone, I don't see the point.
