Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793888686;
	b=px6aAI+GBx0rBAKmzdwsTeteiro8JNfGPdQm93kDQOOHXpG5M+HsXlFFoEU17xMqOpKm
	 Ml41Cq6StR7D7LvOe4zkeHlQ8qG5MyMx8V/xOs3Y9BCd00LnBM/BAuqcS0HcbfueCMkF4
	 ZeUcHcUzjjFPGQiUK8KobHr761YwkvbtpX/53/itdGk7Zvf1T+Invk9oWIAMkWFKLDgWt
	 ecHmBz3cAOpnquqign9fieGe8dVDgKGjRhv3hkTc1dEpsBUSd0HzIrB+YW5zmxwDo/YIJ
	 4mVFMfFciimegekChQ/PwiKdvXK5pT6DQqH31z2KPay/kMRqF2jru7kqd+k6ctJtmQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793888686;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Whq/GeK8lJYp6vWQcR6l4+gWrLqDlX5gpLbTFWIZllg=;
	b=AFxGQTzFx4KiCN7UjLHr4xNMkymtfBgcyZ6NhGM8xjNYpKtx79VajgABBAqINpxSDejp
	 wVgq+6rQtSdhdwUhmQsUE+qOWPvzIortznmCQqFCKgilRyFjHkk8WCbMZRoeX3vCya4JU
	 NF2ka87J0lhv4F4qq6E8j5iLka1M+DeuNQKh8Ag3F8xURCH+zrVgd8KB261B18hn/Xz1f
	 t1BOEiPk4bf1Ylife2U/pm2xhWTrvWVEn4EKfcult87V/kXHhNNHqg8/W2zQxRh+bDO3k
	 VrXNRNF/AX8fWPkYXFch8leA6bNSJL4S51XUiMhZmlT+LzpqJYvysTMO5t4iDoV/pwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mvrVLI7z;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D3606A328
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 14:24:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 028D3606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mvrVLI7z
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdae1584747so1158903a12.0
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 06:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793888685; x=1794493485; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Whq/GeK8lJYp6vWQcR6l4+gWrLqDlX5gpLbTFWIZllg=;
        b=mvrVLI7zTIHk7e6cO9rGAbcpSxZEdpwdbDat7Feabc84wChczkyuPlFBryMhTWFLci
         mNrQ5KXZQwyXca1YJlpJNmAe7/aWlhTvjImHd3tm2LEH+4F0BfEywdXJwdAQcBch1N1b
         l7v7T95ZBC+KALNOxmoTiKix0MEVQr4fFvYXqoQGthzY+bmnfa17OJ/WJ3Rt31+pSPP2
         Hb7vQn5FoayzjzYkJsLriWm/o1eUbg9I4o927SfbcYCQ0VC09xrtMTyvk76QBdRnfrUQ
         /YoB5nMnL8HMYQvaVBqZ3mvj74CWPbcjvsjCZH6+r9QvFxOE7Oha9YRzglDFq4FylgDz
         mNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793888685; x=1794493485;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Whq/GeK8lJYp6vWQcR6l4+gWrLqDlX5gpLbTFWIZllg=;
        b=OzUzFAckSrtguo/6c7d0TpdLFsHG/o7TI84Y5U18Ky5oJLD7Ad/iUvSQh1WXfh2Dzf
         LdP/x7qDSqSAYRkfWD7oZQXBIIpkomuwOO4DXBRrKPb6TWz/oI4+pMrCB4VdflWizlwE
         c9k9WpeSaVwChXH7kaaiKFRvlKXFuMwiVXDZ+y/lVVdwRgt7hG92L2YcGvmFlyLOpvOQ
         OrGkqT4mZWKcCtxoLvWCDeu5KnXba2nrmPwnNldq0WSOK9herI8LRWo/BjC71KWvIeSL
         ++IK9EENjvgsEO5pzR4YLa3lqWf7optQeVbckDR69iD5Qea4PBdAe/NhcQu39ckscpMr
         jNAQ==
X-Forwarded-Encrypted: i=1; AKwUvBwPUKJMycr+UL3LcBq5E3KW5jTiG6l/TwAJMvTY+HhcAPTWQZXHMmKK7yxNrM0y7vjzJpSZFTr8@lists.linux.dev
X-Gm-Message-State: APuU4Z8f7SqZxentKUfCsJtdbBEnvsuYvav4IRV8YfyZ8IlRJP3GsPGN
	7HAwtdzzSIFyPZKgCeH4jGPpPlAhvjnocZ1ml29T4ttL1jRfbi/ztBQu1UrCIaaDmZMETset2F9
	b9h4olA==
X-Received: from pgly25.prod.google.com ([2002:a63:1819:0:b0:cd8:2b49:af45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6372:a745:b0:3d4:52bd:b89d
 with SMTP id adf61e73a8af0-3e928d46807mr12909269637.23.1793888685125; Thu, 05
 Nov 2026 06:24:45 -0800 (PST)
Date: Thu, 5 Nov 2026 06:24:43 -0800
In-Reply-To: <2026110539-lived-blast-ef64@gregkh>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104211043.516122098@linuxfoundation.org> <20261104211109.504581890@linuxfoundation.org>
 <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com> <2026110539-lived-blast-ef64@gregkh>
Message-ID: <auyRq2HXJIfMXgBh@google.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Nikolay Borisov <nik.borisov@suse.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 05, 2026, Greg Kroah-Hartman wrote:
> On Thu, Nov 05, 2026 at 03:04:56PM +0800, Xiaoyao Li wrote:
> > On 11/5/2026 5:11 AM, Greg Kroah-Hartman wrote:
> > > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > There are some dependency patches failed to be backported [1][2][3]. What is the
> > preferred way to handle it? prepare a separate series for 6.18-stable with all
> > the necessary patches?
> 
> Yes please.
> 
> Do you want me to drop this one for now?

Yes, please drop it.  Thanks!
