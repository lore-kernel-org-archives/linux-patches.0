Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D013D23B1
	for <patches@lists.linux.dev>; Thu, 19 May 2022 05:09:19 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id a9so2035386pgv.12
        for <patches@lists.linux.dev>; Wed, 18 May 2022 22:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98eExJmW4CvEKtY59mnP3Y/Ym1dtBxRsqatQZZ+JrsE=;
        b=a7sYXQjPMfQzah39v1TrKWM74noSYC4U93pdcytKPTSAPZHaSMFeh6MO5a70qhYq7J
         vqeUfanwMjC+3Ofp4OsgTCyE+RH/Iat9mOHdTv03SR7xzpISwaAtOTYTvrBplRD9KBcF
         NfhUgAUMWXSQLvG+qW0Jm7GBkNP5JYKAcsC1AR1t1ASDWGIuyZhzldB2m5jjIUYusoXk
         TWvXj4RcxegBTqT9127WByzDKE9n2x7lRClXNvQqbhL9/YRaDemt6RtmPa2aXa621W2Y
         R+QDM0ZfMdRY7bPve3ZWfEfChBIgOFfJ+F0vYOrdavxpvEyCK/0L0oimLsH7PyHUkR8n
         fo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98eExJmW4CvEKtY59mnP3Y/Ym1dtBxRsqatQZZ+JrsE=;
        b=p2bjpEAMnk8ELLdC+zPYXD8rmRtozk6MbDP28Cepb0nRg569B5qe6YREcTL6hmVIsa
         OOyeBXqJmUsUvfJHvnGbE6yRLsN5ZisP2P1kYVJaKVzMpE190a2qWEAL9wvRFzG0Tc1m
         NoFNoiOuxH8NF+aKHzJ8FLrL+x/7sH2xr+oh2ceeKUFb7hMCI3NFRXtv6SqafxMTaGeJ
         COc0zNEHFpgM32mfXFvMVJ69VquTYcsMomUPcbxZx3KeZ6iO/oDseOKtPNfbo7SmLiuB
         bwfs5LOqIvhZY20djt3qYIGJ5sF3u5VsJsT/j+vDonV1ovnM1A+2r/rYuKM9lR0dLYbD
         7K1g==
X-Gm-Message-State: AOAM531f+hxD/bPLkdxGEibJoww7TB6HK/xVr9f+oz6g5bUm17Asy+k2
	iU6x+h+otSBVSitFfZ5AZUU6pchr2ZNUnqmcjNI+7Q==
X-Google-Smtp-Source: ABdhPJygLxvh9MesiDEmxvUfVw0qVDPGMgmrGCvuMSGdvcf6MoDuUElKbtA2K4vJ7FB0j2ydMFCKHE2bqi5xa10MlCI=
X-Received: by 2002:a63:5610:0:b0:3f2:7e19:1697 with SMTP id
 k16-20020a635610000000b003f27e191697mr2465804pgb.74.1652936959213; Wed, 18
 May 2022 22:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-3-ben.widawsky@intel.com> <CAPcyv4hKGEy_0dMQWfJAVVsGu364NjfNeup7URb7ORUYLSZncw@mail.gmail.com>
 <CGME20220418163713uscas1p17b3b1b45c7d27e54e3ecb62eb8af2469@uscas1p1.samsung.com>
 <20220418163702.GA85141@bgt-140510-bm01> <20220512155014.bbyqvxqbqnm3pk2p@intel.com>
 <Yn1DiuqjYpklcEIT@bombadil.infradead.org> <20220513130909.0000595e@Huawei.com>
 <Yn51WhjsC1FDKNfS@bombadil.infradead.org> <CAPcyv4gwi1gr-_XTV9z5aZ-HJ=J5gDonQk0_M-_U9yYDqqi3PQ@mail.gmail.com>
 <Yn6yGKmMZES0IQbw@bombadil.infradead.org>
In-Reply-To: <Yn6yGKmMZES0IQbw@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2022 22:09:13 -0700
Message-ID: <CAPcyv4hFHxc9wV1R_v70WdtZAyxD7oAV2HxxySF0nZx+vunM0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 02/15] cxl/core/hdm: Bail on endpoint init fail
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ben Widawsky <ben.widawsky@intel.com>, 
	Klaus Jensen <its@irrelevant.dk>, Josef Bacik <jbacik@fb.com>, 
	Adam Manzanares <a.manzanares@samsung.com>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, May 13, 2022 at 12:32 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, May 13, 2022 at 12:14:51PM -0700, Dan Williams wrote:
> > On Fri, May 13, 2022 at 8:12 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > But with CONFIG_FAIL_FUNCTION this means you don't have to open code
> > > should_fail() calls, but instead for each routine you want to add a failure
> > > injection support you'd just use ALLOW_ERROR_INJECTION() per call.
> >
> > So cxl_test takes the opposite approach and tries not to pollute the
> > production code with test instrumentation. All of the infrastructure
> > to replace calls and inject mocked values is self contained in
> > tools/testing/cxl/ where it builds replacement modules with test
> > instrumentation. Otherwise its a maintenance burden, in my view, to
> > read the error injection macros in the nominal code paths.
>
> Is relying on just ALLOW_ERROR_INJECTION() per routine you'd want
> to enable error injection for really too much to swallow?

Inline? To me, yes. However, it seems the perfect thing to hide
out-of-line in a mocked call injected from tools/testing/.
