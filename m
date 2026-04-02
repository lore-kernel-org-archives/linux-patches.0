Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B5E39D6E8;
	Thu,  2 Apr 2026 12:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775131636; cv=none; b=BZ9UCaJOD14+VoqZD/PBlkfIExSaRUUpaPVuc5i4v4Ulyb7eMhu6w1BQbGGQYfL1DyEH9gq7/9xb7NX71lecF+hmYH8qU6+cYmBWQ5Fp4c7n7wGLIOkbavAXwsvxkLtk7+VVlHIxGZ9BHY0BLLvbGodvzcsNIQY7Bre3mN2iEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775131636; c=relaxed/simple;
	bh=EWnmxLQmqRlCZ8CAZ8QFKkobjO3CVb7rGcpVWxRQqqc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=iEMmThbMROhtjXs/Sttw/JmkGMpGAjjQ6Y4Ej0HdjJAp7iXJpAZ0GelXCHrC496QWKgT1sQ+u7guS58YIY1/MzVaKFMdBT2vNtfLb761Yo9JLZ+Fgthb5V3orcaejfHLA0KtXj07ifulsqvZSROPNqJjWULkkwA0TatMXc/LO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUcolV0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUcolV0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94913C116C6;
	Thu,  2 Apr 2026 12:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775131635;
	bh=EWnmxLQmqRlCZ8CAZ8QFKkobjO3CVb7rGcpVWxRQqqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NUcolV0MVu5yQo0LxuoiC5EPVoctbJWANW7LB40tn/OwN0GvDgSgryn76Gxwa51fV
	 tHBt97JyphLNChg0qn1GLuZRNcaPqrRLJOpdNrBbN3Qy/pxdek7f8oKK/fXwOdeP+O
	 YOBcJ6tSVYbOye8iqWGvvoDUiIDj/uc/Jfhf+BJaQcrj5zq6YVcEB8s3nmqPlfp2u7
	 VZgX4mhdcr/ESCKrQr5Mh5WBlFbxVo0o2SwGnW9oZyOVc8eanBEltHWdKygknzw8Up
	 qzaiE9BYwUr7iUmD8PjZXELGloVCvfpWTAiS53gCwyMu915M/NaxZzQQI18+jVI7PF
	 bqHNX7TbrTwuQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Apr 2026 14:07:09 +0200
Message-Id: <DHINN8SUUZSW.2LM7XEUJ2M2B0@kernel.org>
From: "Benno Lossin" <lossin@kernel.org>
To: "Gary Guo" <gary@garyguo.net>, "Greg KH" <gregkh@linuxfoundation.org>,
 "Miguel Ojeda" <ojeda@kernel.org>
Cc: <achill@achill.org>, <akpm@linux-foundation.org>, <broonie@kernel.org>,
 <conor@kernel.org>, <f.fainelli@gmail.com>, <hargar@microsoft.com>,
 <jonathanh@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux@roeck-us.net>, <lkft-triage@lists.linaro.org>,
 <patches@kernelci.org>, <patches@lists.linux.dev>, <pavel@nabladev.com>,
 <rwarsow@gmx.de>, <shuah@kernel.org>, <sr@sladewatkins.com>,
 <stable@vger.kernel.org>, <sudipm.mukherjee@gmail.com>,
 <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
X-Mailer: aerc 0.21.0
References: <20260331161729.779738837@linuxfoundation.org>
 <20260402112712.110869-1-ojeda@kernel.org>
 <2026040247-stimuli-surreal-edf1@gregkh>
 <DHINJ6CUHNLM.3RD5BA5313NKK@garyguo.net>
In-Reply-To: <DHINJ6CUHNLM.3RD5BA5313NKK@garyguo.net>

On Thu Apr 2, 2026 at 2:01 PM CEST, Gary Guo wrote:
> On Thu Apr 2, 2026 at 12:52 PM BST, Greg KH wrote:
>> On Thu, Apr 02, 2026 at 01:27:12PM +0200, Miguel Ojeda wrote:
>>> On Tue, 31 Mar 2026 18:19:44 +0200 Greg Kroah-Hartman <gregkh@linuxfoun=
dation.org> wrote:
>>> >
>>> > This is the start of the stable review cycle for the 6.6.131 release.
>>> > There are 175 patches in this series, all will be posted as a respons=
e
>>> > to this one.  If anyone has any issues with these being applied, plea=
se
>>> > let me know.
>>> >
>>> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
>>> > Anything received after that time might be too late.
>>>=20
>>> The pin-init change does not build:
>>>=20
>>>     error[E0425]: cannot find value `__refcount_guard` in this scope
>>>         --> rust/kernel/init/macros.rs:1320:25
>>>          |
>>>     1320 |                   @guards([< __ $field _guard >], $($guards,=
)*),
>>>          |                           ^^^^^^^^^^^^^^^^^^^^^^ not found i=
n this scope
>>>          |
>>>         ::: rust/kernel/sync/arc.rs:529:49
>>>          |
>>>     529  |           let inner =3D Box::try_init::<AllocError>(try_init=
!(ArcInner {
>>>          |  _________________________________________________-
>>>     530  | |             // SAFETY: There are no safety requirements fo=
r this FFI call.
>>>     531  | |             refcount: Opaque::new(unsafe { bindings::REFCO=
UNT_INIT(1) }),
>>>     532  | |             data <- init::uninit::<T, AllocError>(),
>>>     533  | |         }? AllocError))?;
>>>          | |______________________- in this macro invocation
>>>          |
>>>          =3D note: this error originates in the macro `$crate::__init_i=
nternal` which comes from the expansion of the macro `try_init` (in Nightly=
 builds, run with -Z macro-backtrace for more info)
>>>=20
>>> (among other errors)
>>>=20
>>> I would suggest dropping these for now:
>>>=20
>>>     0565326613fa ("rust: pin-init: internal: init: document load-bearin=
g fact of field accessors")
>>>     66655aacfa42 ("rust: pin-init: add references to previously initial=
ized fields")
>>>=20
>>> Cc: Benno Lossin <lossin@kernel.org>
>>> Cc: Gary Guo <gary@garyguo.net>
>>
>> Crap, I just did a realease.  Let me go revert these and do a new
>> release with that fixed, sorry about that, I guess my builds weren't
>> testing rust on older kernels, my fault :(

I don't know what happened with this series :( Sorry for the extra work.

> It is probably missing a dependency patch. I could take a look next week,=
 but
> perhaps not backporting to 6.6 is an easier solution :)

Yeah let's do that.


Cheers,
Benno
