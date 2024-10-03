Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419CC1AB500
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 21:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989562; cv=none; b=L4ALEnjWqR8tmUvE2xUMnh+F6drBQtrrRAYqaiAbjl57bSaOgB+2dgE/QeZiW7nLB5xFrAeNa5RYRpxubmRRk+qD7gHdTkAe+zWXVAfB2P/fDBPPOHDRYky4Vgrv1pxS5g7amOQRweFydadat3ueCJdY/CGlygFjxxBtRVlRwg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989562; c=relaxed/simple;
	bh=DjjcLb0zldRjw3VlI1nsDssX0csRwTyctgRrUyMIskE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=klRSh/DXzzuAN1Dfu3R1Hsdq05YFhLnhTvkLl7fOS9Sq3DeCBN94nW2wxy9xC2fda2fqj45kedmT64NJhv9KMUWg+dMyHRK1maZ2xs6oDV0Ev2PbkTt1h8C65KmN+/vDgLc8/q30P8WRX/VbHj212S3KMuPV1Htg2hoVDTSHgCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XD3CoUHA; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XD3CoUHA"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a8d51a7d6f5so204238766b.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 14:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727989560; x=1728594360; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8syhsHxRK4yyfAod4n4jN48GcJ5d5jKRHHTAes7XE6k=;
        b=XD3CoUHANgcYYHXEbb9bVLdHEDxFY0R+YdCuWUJRQ0UUIkYr9xL8OGxrqIFI4jHeXr
         Ohi5jaIA0uE+Wl9u2MFDkm7pTT4+ie+SINIDxMY1WCSL5EbcysQpbkwiD12C211jDvk9
         /X70wb7x+8+LBfDvGQ49U5WuIMCRJ5ZcnRM14tJ1/+mTu8x6nMkr6sz0+rPVPRCn+qvz
         lz4S7V+xNArfcq73e46OuJpwfzjmc9d6OAN1e9tCLzwrjc0My/Xrz5Rw7H7Tka63/OEZ
         RqOVCno3TP7MtY17d8rlr2PN+gxIp76ZQhm/3zMW77671URZqM+j5BO36keku97BkVeu
         voaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727989560; x=1728594360;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8syhsHxRK4yyfAod4n4jN48GcJ5d5jKRHHTAes7XE6k=;
        b=lZiJnLKWjTSLYfRzr7s1v+LQeDqoqiU+tJ83G51DuhT24ZUdMgv6mvV6V0PfyWsjr8
         p0UendPusK4U6Ymp5tJUasTu37cZJOFOP9hQStS9E6tnJ2wSFgneljyOi6T6EBqvWKvA
         GmVMv8pyrRCy/atJBPES2rYfgCh+HeHsFmsKxf+Mnh5rxr1iKw96ZyyUuQcn7xPrwslW
         aediX2xe8sXZfut2p8L+5oJGC/mBxLJHsp5TGstSh6IpJwhCdpLczc34uSI7oeoi7Yjm
         dW81n9S03iVswQ0PnBZ5F8OiHz5kPxuVcii077Vb86I14tdaR9Gdu+xjZ+nny8QDqy28
         KQ7w==
X-Forwarded-Encrypted: i=1; AJvYcCWNQP74OviJ3DRUM3O7sQRyM3JIEYZMJxPHwfn2fA9lpFzvhjEZOT6vSCxbsfE+RVdFltBo5Dy0@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8Kw7miMDbVRevnr/4SZCMwAuMoiG6k1edzk3PUCaDrPupczA8
	ajXRRaWD4uKd+d9wqX3Lg2ddJ++/j4Ri5pBhFLFDsMuNO7um/X48BWzP7l3fBFc=
X-Google-Smtp-Source: AGHT+IF8SP7YMciB5jdn3uzWyp2F/BxhL0ga8DmoKHlGXXKrPUpcT1e/351YeAk6qB4g2x0fbw1hMg==
X-Received: by 2002:a17:907:e61d:b0:a8d:510b:4f48 with SMTP id a640c23a62f3a-a991bd0d019mr57152166b.22.1727989559652;
        Thu, 03 Oct 2024 14:05:59 -0700 (PDT)
Received: from [127.0.0.1] ([85.106.96.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102a625asm131713066b.87.2024.10.03.14.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 14:05:58 -0700 (PDT)
Date: Fri, 04 Oct 2024 00:05:55 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, patches@lists.linux.dev,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_6=2E1_033/440=5D_arm64=3A_dts=3A_qcom=3A_sm82?=
 =?US-ASCII?Q?50=3A_switch_UFS_QMP_PHY_to_new_style_of_bindings?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAO_48GE-bQ2ZcdXNKsRS6U+4+opkXi0osSEodMUdW+fo0jNACw@mail.gmail.com>
References: <20240730151615.753688326@linuxfoundation.org> <20240730151617.057892121@linuxfoundation.org> <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com> <F1136AC5-0860-4070-B4FA-86BAEFC070FB@linaro.org> <2024100238-margarine-strongbox-d096@gregkh> <CAO_48GE-bQ2ZcdXNKsRS6U+4+opkXi0osSEodMUdW+fo0jNACw@mail.gmail.com>
Message-ID: <C7E275C7-77D7-492D-9699-FC5B9D32C339@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On October 3, 2024 5:51:07 PM GMT+03:00, Sumit Semwal <sumit=2Esemwal@linar=
o=2Eorg> wrote:
>On Wed, 2 Oct 2024 at 15:21, Greg Kroah-Hartman
><gregkh@linuxfoundation=2Eorg> wrote:
>>
>> On Tue, Oct 01, 2024 at 09:01:09PM +0300, Dmitry Baryshkov wrote:
>> > On October 1, 2024 8:27:55 PM GMT+03:00, Sumit Semwal <sumit=2Esemwal=
@linaro=2Eorg> wrote:
>> > >Hello Greg,
>> > >
>> > >On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
>> > ><gregkh@linuxfoundation=2Eorg> wrote:
>> > >>
>> > >> 6=2E1-stable review patch=2E  If anyone has any objections, please=
 let me know=2E
>> > >>
>> > >> ------------------
>> > >>
>> > >> From: Dmitry Baryshkov <dmitry=2Ebaryshkov@linaro=2Eorg>
>> > >>
>> > >> [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
>> > >>
>> > >> Change the UFS QMP PHY to use newer style of QMP PHY bindings (sin=
gle
>> > >> resource region, no per-PHY subnodes)=2E
>> > >
>> > >This patch breaks UFS on RB5 - it got caught on the merge with
>> > >android14-6=2E1-lts=2E
>> > >
>> > >Could we please revert it? [Also on 5=2E15=2E165+ kernels]=2E
>> >
>> > Not just this one=2E All "UFS newer style is bindings" must be revert=
ed from these kernels=2E
>>
>> How many got backported?
>So far, only this one=2E

Just to note, [1] also needs to be reverted=2E=20
I'm currently OoO, could you please also handle it?

[1] https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/stable/linux=2Egit=
/commit/arch/arm64/boot/dts/qcom?h=3Dlinux-6=2E1=2Ey&id=3D86225a63467a07047=
487f37c877277af20a9bf85

> I've sent a revert patch - if you could please
>apply it to both 6=2E1 and 5=2E15 LTS branches!
>>
>> thanks,
>>
>> greg k-h
>
>Best,
>Sumit=2E


--=20
With best wishes
Dmitry
