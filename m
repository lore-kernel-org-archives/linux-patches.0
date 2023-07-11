Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E501DDEE
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 22:17:55 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1b89114266dso46952435ad.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 15:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689113874; x=1691705874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUQ/8zCRZuDXl9Bj16DtG+5Txck+M49Fz3vYnY4FgQc=;
        b=ARXS4+iJF7czWLwSLs3uaant6Rd7iPZWrVB+mB2ZqjJuIlIygjiSudDipepnELI/3x
         JOhbeMt9Sd8sWzsK/vDruGsWToq1MCbP6+Hp/TboDopRI2RKtdOeg/rjGBmdSs0G5GRf
         HWq6EIzhbA39r6vmEXpBX+yBAbQKMICh2YQmi0kOqLHzR3AE/Rfpe58PUNNZ5YwfWoIr
         OldbsoCDG41DMYgsV2dueQGmjKmwClHsMNdKOE8LetFAQ2210Mqs+rGUoFRzhtdyh8+8
         DjpBv52aB4BV9qkMoAGMoSRt7oLRZ8RodheH1dNWLH5EOQzQYi/C3G9XxTyUC7Xm1afZ
         30qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689113874; x=1691705874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUQ/8zCRZuDXl9Bj16DtG+5Txck+M49Fz3vYnY4FgQc=;
        b=F4X1NpkNSrfUNGlJmZqQwYbTLooKSOsJD6SReRMNwr793J9cY7hP5Ma3yg4Dz7o+ot
         FvcyHAZgEwSq1hREcy/64RqmhmnpyPWSOef+Be0pvuEWqoLmuTTDc21OCZDEBvAjRpQJ
         EeoEvPVZMvUOnae6qBxxYsUHedqRPlcqlQ9Hj/p01cAvJuJO+IShu7T3KRPGCb72toyN
         s5I5AP+UY/PePeKwwvRw5IT7NKJoXPXx3mMFTpAYbojyARPNDNGPXaYr60/QNY/+JWMZ
         g3hyaZYT/rSdV3rabIvPFxfJE1s7D9KIJHu7jWviwiQXDggPQ67rpZBEWDCTKFWYP2wJ
         oVJw==
X-Gm-Message-State: ABy/qLY5i2EkpGXWcO0uCAdGLTRNWUbODpRRVWI7So6JqIEHkdGoeBVt
	hvSdQwIENDXJFF6rc1AohOo=
X-Google-Smtp-Source: APBJJlEeB9eQ9zhBAmdgyKXmkeARvRdkh7Lo22MREuuIBb+xm1J4qul+hzI5KiIy84cA5L72/MTDyw==
X-Received: by 2002:a17:902:a614:b0:1b8:9225:4367 with SMTP id u20-20020a170902a61400b001b892254367mr15708150plq.65.1689113874468;
        Tue, 11 Jul 2023 15:17:54 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:9374])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001ae3f73b9c1sm2427013pll.101.2023.07.11.15.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 15:17:54 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 11 Jul 2023 12:17:52 -1000
From: Tejun Heo <tj@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v3 0/9] rust: workqueue: add bindings for the workqueue
Message-ID: <ZK3VEPeBEyErmerR@slm.duckdns.org>
References: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>

Hello,

On Tue, Jul 11, 2023 at 09:32:54AM +0000, Alice Ryhl wrote:
> This patchset contains Rust bindings for the kernel workqueue.
> 
> One of the primary goals behind the design used in this patch is that we
> must support embedding the `work_struct` as a field in user-provided
> types, because this allows you to submit things to the workqueue without
> having to allocate, making the submission infallible. If we didn't have
> to support this, then the patch would be much simpler. One of the main
> things that make it complicated is that we must ensure that the function
> pointer in the `work_struct` is compatible with the struct it is
> contained within.
> 
> The original version of the workqueue bindings was written by Wedson,
> but I have rewritten much of it so that it uses the pin-init
> infrastructure and can be used with containers other than `Arc`.

I don't understand a lot but the part that I understand (Alice helped me a
lot, thanks) and the example usages look fine to me. While the interface
leaves some workqueue features uncovered (e.g. flushing, creating custom
workqueues, queueing on a specific CPU), there's nothing blocking adding
them later and this looks like a good place to start. So, from workqueue
POV:

 Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route the patches through the rust tree. If you want
them to go through the workqueue tree, please let me know.

Thanks.

-- 
tejun
