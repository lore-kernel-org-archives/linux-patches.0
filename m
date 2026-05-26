Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7823ABD9F
	for <patches@lists.linux.dev>; Tue, 26 May 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779811289; cv=pass; b=Uq1IbCp0d/qERIYQhp7meDLmcupHslG4V9nhy3LXpZqyNSqcQcg6rC0XU/y7Fa0lpy1KazUOv/QDbGI25v7sMgQGhIBDUUy0MkV1RrQmpyHIuuilMrqe1aM9hiIDg30zwVSEjcGV8zQFtdu7SLgFarsIUtozf+opYRYReZMyvjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779811289; c=relaxed/simple;
	bh=pVzqx11hjh7N1pH2gCRYfQFcHOCbS36d82t/QEbOWBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FulsR/SP11O97DJsTmSGYlNhZFsatqIyriQ9y9wvLH/DqXgzZWCqVA2TlIEIrxu/gYokZLuKFywYY8EVqNQ96sk0nuvnNrHdhlUXh2fDxv+UJEHxyE4ZhDo3G2aIO0RInj8PXSL2ggdFG2JPU2qPFyfyHaMqKkkOmXap38CacHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=isovalent.com; spf=pass smtp.mailfrom=isovalent.com; dkim=pass (2048-bit key) header.d=isovalent.com header.i=@isovalent.com header.b=I8lIt01h; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=isovalent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=isovalent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isovalent.com header.i=@isovalent.com header.b="I8lIt01h"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1329fc4bf77so9961082c88.1
        for <patches@lists.linux.dev>; Tue, 26 May 2026 09:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779811287; cv=none;
        d=google.com; s=arc-20240605;
        b=MJRgqFvt7x8JQ1m3UgVLDJ1zacYKPyKG8Kzw6zzlh+x7tCJdBeMaDsXHPhFVn8l3IG
         euVFbUH/rw91+h90OnAj3oPaZNk8tkP1ZJveqSJztI8eSB4FJ2ks0CF6+kXRssb7hd5p
         XnH4uRoJdDkYgMDysDJBwrDxFkvN5j6rzxJxSa7o1lzj8iYFCBYbezVbMnMjp9CNJiPW
         MEl9iaSolBVfKYJ2U4u7MnX82FSvlgIQhmnuMMZYpSygEf7IOON1ypQhm5MY3TflUCxf
         5wYK9XcQXkQvLdIr4LS9keqtA3jhL9dM9TeVW+mF9GLikttUsRjLGETnJeoULsAP8O5P
         veLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JuWcfKbEhiOQ+qzwtoWjTZXdsQUx+LDCmslbk+9iAr4=;
        fh=W2+pFp+pLN1AUUUanYWQ3NLAxNZ5Q/4MBs/HxWcnuD4=;
        b=iLGVR1U+qQzBv0uwvJW/3k0rC89S4qiUR9aVdtMxQaEZwc9rGIB56Ao62Xpb4ojgEH
         XaXwpsuF1r9YtTJqcoRhS8r5/NHUwOdxdq51F75Fd2z5qUvBJnEN0GG2YVuScnuMnUJz
         NOH6F6BEICyKMm7rKdNwnkFm0uH+uLWekO2MJgC6ICITZ0M/ZTjNtxiwvIHKMNL7b5sp
         64v10UrZ7Bhw+FJrX+frFkmXGByk0NIbzjdsR5byrh7epvSVVhBk7khKSY0EEaV/+FrI
         ChL2LEPFdPzqAYbRqIjBO/k8wqpTjuaQdFlxdrE0XxUuY8Ju1envLNG8hjm3gIyW+Di0
         UAxQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1779811287; x=1780416087; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JuWcfKbEhiOQ+qzwtoWjTZXdsQUx+LDCmslbk+9iAr4=;
        b=I8lIt01h3bIrntFEhiDDeEALLFG37mTiklhohmkLavrkqYtNQ0jjb8V60mNzbFGl8L
         3i28kVl8+1uUh6S+ES84R05c3JpOsqeHWdimOwDFQJMgRGYwg+XgfX4Nd4aZ6Z9SAdcR
         WwweZ1GzZyNlvk7Ln6Szi7IM1Hc8/a0CESedB6K6ArOyntTEreScPCDsljWv5M4m2VgU
         jlZb3x0ju8G7Q3qcsiKG2w0XrUxFXWa7xMw/auf6h9r2a27V/gC3emlS8MUDli4zQ44f
         oHyYRINCdHTR4pGGnqUa6OsIFO3ZZT89sOsM7vNm8+7IxzjNL9Fb4Liu7O+JC1DGCc1X
         irVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779811287; x=1780416087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuWcfKbEhiOQ+qzwtoWjTZXdsQUx+LDCmslbk+9iAr4=;
        b=F0noyjrn8wTFtI8yEE/4s7BZOVgvKKnl9vUwsBVuVmL3G8QcRBgAhTc3r569trGjSK
         rhBa3lmwScFObvwW0/0NoNoxAOp6Mi9MZaFGZqU189KQyxAf7bEXYfuZlCgrNHDODpxc
         vWzzRQV2bDKA5I4GDGV+rpqBz/bWZtM7vhTL+vTLir5HbwjXSyUE12xR3mVGBwD5padA
         lbyGQXTLXSkxeBwJJG9/VwOiqgkd8vEcY90gxeY910kj2ksa13RQ6Dfu0xsgtXQPBAgG
         VHJn/j7U3thq6Isg+hTCZ2F/cXIHef/exg1bgqNcbElwwuwiB3M4ggYVgWlRnvpgHkG7
         TCQg==
X-Forwarded-Encrypted: i=1; AFNElJ8XPKi8Vqqd2CadUnwrV7kWVRNYiz1d/sWzyQ7ic7XaGr6ieqQJqdB3PU5YjB4u4nrqzq1Oe5F/@lists.linux.dev
X-Gm-Message-State: AOJu0YwfwJXvlk7Fyx93Z/TDc3p+jMS8Yn+C5Mcf4t+SnmJdv9c71E6F
	dH7tPXpeKl2SlZI7qIrJ/PP9WnxmH6x0WowWlCuIXdvEHRQK1A+SbfjySG+SEPUllqn/Q/z7U7U
	Yg51lNLP9zKWWYIb+6cZxxu9QfhG+O0NZoC4hZ7DLtg==
X-Gm-Gg: Acq92OEhZ9vDrMQPqMKkwNNpJoD/uv9K0Vvu1UvD5csHTamMXztkZpXj/TkwQ17i7Wc
	8JTO8sshcn+TesszOppQZdBKRPKamOow7SmZlY0TGkGqY30UboPWr0yyBF3a4d0vSwXuNWzoKNg
	EgtR18z4Ss42ajljIMSyOqycygYdBvOWFA9ijzuVpaPzWhqNy/AgaoQDPLiTMaTvw6QnFinMZcv
	+Rh1zQre7IO0FmiIU6Mf+jLGzP+bGzNll2gbggPunn9yiNIZlW5qdvOM3PIgnzBh/Pkdo7D1Dy5
	CYW5m2zzatswhSs9B/J3wo1QL7g0xkoOICyO11MQiweSx35aL/PD3PX3PCpyMhD+exn4iwTgl48
	WRw==
X-Received: by 2002:a05:701b:240f:b0:134:fc38:4e5f with SMTP id
 a92af1059eb24-1365fb534b4mr4742656c88.22.1779811285149; Tue, 26 May 2026
 09:01:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162134.554764788@linuxfoundation.org> <20260520162148.582539866@linuxfoundation.org>
In-Reply-To: <20260520162148.582539866@linuxfoundation.org>
From: Alice Mikityanska <alice@isovalent.com>
Date: Tue, 26 May 2026 18:01:06 +0200
X-Gm-Features: AVHnY4IJl_dvx3UZ0ZSVEcvY4jymeZHCGABK9TTIX9K4r8NdaAFfM045Bta1oQg
Message-ID: <CAD0BsJXt3QurRvFmOGNzh1juYYcQEst=3aYJmHiCCf-4DCZCVw@mail.gmail.com>
Subject: Re: [PATCH 6.18 648/957] ice: Remove jumbo_remove step from TX path
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 20 May 2026 at 19:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me know.

Sorry for the late reply, I see it's already applied. This commit
depends on "net/ipv6: Drop HBH for BIG TCP on TX side" (part of the
same series [1]). As far as I see, this dependency was not applied to
stable trees, so removing this step from the drivers is not correct.
Either this commit should not be backported (reverted), or the entire
series can be backported, if eligible. This consideration applies to
all stable trees.

Thanks!

[1]: https://lore.kernel.org/netdev/20260205133925.526371-3-alice.kernel@fastmail.im/

> ------------------
>
> From: Alice Mikityanska <alice@isovalent.com>
>
> [ Upstream commit 8b76102c5e00d1f090e0c31d17b060c76d8fa859 ]
>
> Now that the kernel doesn't insert HBH for BIG TCP IPv6 packets, remove
> unnecessary steps from the ice TX path, that used to check and remove
> HBH.
>
> Signed-off-by: Alice Mikityanska <alice@isovalent.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://patch.msgid.link/20260205133925.526371-8-alice.kernel@fastmail.im
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 1a303baa715e ("ice: fix double-free of tx_buf skb")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 73f08d02f9c76..90dbe5266ce78 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -2594,9 +2594,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
>
>         ice_trace(xmit_frame_ring, tx_ring, skb);
>
> -       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> -               goto out_drop;
> -
>         count = ice_xmit_desc_count(skb);
>         if (ice_chk_linearize(skb, count)) {
>                 if (__skb_linearize(skb))
> --
> 2.53.0
>
>
>
