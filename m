Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223611A0714
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727967081; cv=none; b=YQXWJcHS2EXFlZMGBBBdDUMRfWyWJU+nHBS4Hp3e2AkxbfRms8lSCQd4m/KrJJ8l7+0DY1wBkbgELV6uKYdhld+sA3FbC8UrQ4gIBXM4DdH95oJhZAItRO5lLi69GSCbXesvMId5fUhrIeY7mh1f8glrS5DQr4swGta48mYMBRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727967081; c=relaxed/simple;
	bh=NeXhRRZE7DT3g8kJ48kuyLUXxM6zfLePzejvee7tD2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQYTD3wZg8ENnvdGboH2nNtKGeYLav0Ob6MFrxK0V/JCyQ5Nz3NwFKoDvUFeCk2oAmMXLziYM29eqHJ3IScWI69e/9VJ9NsJmzhUEMGnHdOPm0UQXOqRmi+Lr+PCOSKomMv6zn8iowGxoOKT355O7xi9tIik7ZAqEj9gb63ygJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HMULzXLa; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HMULzXLa"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8a706236bfso72035766b.0
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 07:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727967078; x=1728571878; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TeU1LyZudadV3KNmAo2vsrTm1POifx06+ONtSSucOhs=;
        b=HMULzXLa4O3BdwlmYkjDfSHDT2/TcXmlTYN3Gr/7O44Q/v25d9egdo/3TXbFO/YrEw
         9BsvYGTpFq2Tg+pzUn1tLlv1wx+aBpUqktXbbTpySZF6CGLCj/Eie5xwzH0byDiwj+zK
         GvFigxXd+RdFfHpI1PEjI04fMG9qYYMXeiVDu4a1HCmv5+bb1jutJvGUd19CxlotvpgD
         PNa66v25FE41vutDRO3NGv+3Ke2tK0/MClOp6RDBRNEVoE46KBvAdcHjdN7CuF9gjTTE
         3uYGMyh1UzoB3P7tJy21yUBczRB3Hlnxu4TkP/z/lZsUia+/TYyReU1O2W37Bx6FeQL3
         d/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727967078; x=1728571878;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TeU1LyZudadV3KNmAo2vsrTm1POifx06+ONtSSucOhs=;
        b=JikWCjTUvTy96Tw7Z8JVOXsSagbIqEjkTPo50DKzIf6v/jrPnVqFHf6GBvWXNAy9fI
         8YqbfpedI0TIboTRCB2tPKb9bhn55wX+4Cr9WNe+oJA3sogLC8Ygh/6kyBeZIAzuOQbV
         TgmzEGiNYmhE//N7CCWPh36Wlde3MKf7b9YAf5AUk9/oGJ1jmTciPSnQN2iKtsILsSkP
         TaxWepoDblhGrQPizgm3gZMQPtpZpBzZ0aI+0iB2h8nSYxEOzOiu1SJoAsWr4pc8Bi6E
         p+bR42XlJmULZYj4ZNe6/QDsHRJv0cl0D1fRfcnIrinCNAe1STkMJs02jSy0QhzwC/v1
         l5jw==
X-Forwarded-Encrypted: i=1; AJvYcCX+Ed4IqgxtVMdKKbyoi1QiNc7yhPGeBlwiKMXZ9nCLeunh8GI5Rm/mx9EN6f9jtL/BzVQfmLYj@lists.linux.dev
X-Gm-Message-State: AOJu0YwMMt54apFNCaoWPm0Mc1yii7sXr643pK6GZd+i8VeZbmGkGuIX
	46a5lCtw1uZPAUHmzzFNzoQs3A0j30JUoXM+Z8GrD6L2nPNytcvU3QBxW4b9+jBdW/xrRhrib+a
	jlsYnzsmrOuz3G9OuMyJy1wemNRx5730uXpJAn1HOQ9q84H9+sHU=
X-Google-Smtp-Source: AGHT+IFEqCnDPH06RQJ/I2XQsbGBvms4zMBZy4jpAuETf/Gswg5YWu1pgYUlj1PNIxAz+BBi1CXryf/d/1si9ybMXmw=
X-Received: by 2002:a05:6402:280f:b0:5c8:9434:7e94 with SMTP id
 4fb4d7f45d1cf-5c8b190d765mr7338035a12.11.1727967078214; Thu, 03 Oct 2024
 07:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730151615.753688326@linuxfoundation.org> <20240730151617.057892121@linuxfoundation.org>
 <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
 <F1136AC5-0860-4070-B4FA-86BAEFC070FB@linaro.org> <2024100238-margarine-strongbox-d096@gregkh>
In-Reply-To: <2024100238-margarine-strongbox-d096@gregkh>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 3 Oct 2024 20:21:07 +0530
Message-ID: <CAO_48GE-bQ2ZcdXNKsRS6U+4+opkXi0osSEodMUdW+fo0jNACw@mail.gmail.com>
Subject: Re: [PATCH 6.1 033/440] arm64: dts: qcom: sm8250: switch UFS QMP PHY
 to new style of bindings
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Oct 2024 at 15:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 01, 2024 at 09:01:09PM +0300, Dmitry Baryshkov wrote:
> > On October 1, 2024 8:27:55 PM GMT+03:00, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> > >Hello Greg,
> > >
> > >On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
> > ><gregkh@linuxfoundation.org> wrote:
> > >>
> > >> 6.1-stable review patch.  If anyone has any objections, please let me know.
> > >>
> > >> ------------------
> > >>
> > >> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > >>
> > >> [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
> > >>
> > >> Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
> > >> resource region, no per-PHY subnodes).
> > >
> > >This patch breaks UFS on RB5 - it got caught on the merge with
> > >android14-6.1-lts.
> > >
> > >Could we please revert it? [Also on 5.15.165+ kernels].
> >
> > Not just this one. All "UFS newer style is bindings" must be reverted from these kernels.
>
> How many got backported?
So far, only this one. I've sent a revert patch - if you could please
apply it to both 6.1 and 5.15 LTS branches!
>
> thanks,
>
> greg k-h

Best,
Sumit.
