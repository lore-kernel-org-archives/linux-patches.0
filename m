Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C184219CC22
	for <patches@lists.linux.dev>; Mon,  5 May 2025 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746473697; cv=none; b=d0BgGNsSnQjjUvmFXVFxjWL4lEsn3QFYMItjgg6/Ib6ZpcFIrd5oWHuzKA8sG6uJkhwEXjl3j9WYh0KVW46GrFAvzL2LmvMRtm8nbsu3GhSr1hL0bx+ohqSA0eZp2ROt7C9r4RS0Mb6GILCC4iWbGOBInFeFcGIQ59rZPYhPTBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746473697; c=relaxed/simple;
	bh=R4UOYAFLSdII7+XphTMNWPVBpYzJxCWHQxa8/SgBsFI=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwI6HjYu6PSZEbxMY9Oe2t5v6jAsphvlc5DzTKSk57xTKrgQZGUVEdU1eLmMEz8psBVfFVLl1zO767yhP792M+i+ugOIfTAju6W4uNjMq24XajhDVcSOAffzOJlDnpBtD2G1Bw//CcUeEc4hUvS7vUmSENwjWbK2yzLWSyLAztE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q15Pypew; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q15Pypew"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c5f720c717so685889885a.0
        for <patches@lists.linux.dev>; Mon, 05 May 2025 12:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746473694; x=1747078494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:feedback-id:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GkBn/ab9f6AA7W5UCEebQAelvR/PRTQoq/54e+igHhU=;
        b=Q15Pypew87lV3vJRVCU5LQv/7aO3JfTIiEg35AnZzx6l1WuYphBk+grrJXCTVzA485
         bJRgolEQzC28H9Ta27sDfNm0iEmpzCgFFPUIEGYBB4F20zwbzIrW8J+XAX9Pyhbw8aGo
         4y9y6igliQeDVUMF+BxaG+4ejmzva1g81ofBsIIF/EhklijAGDXLqFzNsSFp22PYemWw
         XlUHaz8X3OSFCFz2vfUmssRlCguBoqsJeM/VAFY2+VC4sbpDz2saBnlDJy4CKMfLE4GF
         bCXo2ZrBUks1ri683CJc+402zbEAbuMsyQeU+22BZBigN9aYAjY1M+yEv7QTN/UyHc3H
         RiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746473694; x=1747078494;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:feedback-id:message-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkBn/ab9f6AA7W5UCEebQAelvR/PRTQoq/54e+igHhU=;
        b=JwALWyU5V6Jf5VIPhjmqtXMIGGJeT9yKOfIkJuBjtTut2SOrm5+GcUo7s29+swEnoP
         A3wwqxwWju3YVXq6EvgjOYdLjrnwz1nsniXdpfujzoWNJjsdNJ2CEwgHwGnv2J1EvTbG
         hcqvFNFtmlDdYN0lmxqx/hM2SMlnSWFpd1w52Wj0jxjPdo/SVW9PxRejwbrMMBGaeJCS
         oKJl9cQIwXuSqDIiLez9QuONhRkcTzJunw0q64UY0SlnGMU9ci997naTpnwAYiQmCuwW
         9yK1Pwvam0wEws+JBpuzMiqoNJjL9+225ZdM8s0w4O3z9b+gF7VG4ud+7W0MtYDbXZEf
         deGA==
X-Forwarded-Encrypted: i=1; AJvYcCUM62hoCMXiesdxwEOqLhoA0tvktIaC7veHciRh67MmN0ED7bsI/09Qq4Ek7FkjGOP+l0/2Mi3+@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5iHb6X0W/tlFxohUl9LDHagS3JxAz8NyEcbji9qvp5H1AcO+d
	bXTe4JD+D1hgwVx/+rKL6pafC95m0Y2PWTNGxdNkVXXRPXwqt+M4
X-Gm-Gg: ASbGncs9KZ2DuTcCAjHcHH8y2ATfwFwZq9iy2mwDM0hgKafHL3K+xX6Pooz6AQGx2Xb
	xOdeU8f4LJLJrbbyrap0XZf3Xu22pA2pXgjbMjOwvuwL/oojRqWHFno7p8DOmGFGkTMgcNSDIkf
	oRYd0MxFaziukYbIbZXFC5PS86RKivUIe+PUb6yR3n1msVvlfIjDqKE3vIOtCdaZC539QYlZ/WR
	cNcWJzX2dlr2haOTHr5mwPjfvsGDOmhPWOH9T7FEXXRqcRUuSQecOXHdCGZ0HlK31PcpLKBlmN7
	trUznolv4swokjTVR6LJjv/j3rWZzGvvOwb8i/ZrgPDXVF3DQ7XPs3Ye5bbJtAlL+A4bbzWuXlK
	FpLua0wtteBRO/x6p7N2UM1A8XHR41Ew=
X-Google-Smtp-Source: AGHT+IFY12NsRRcgW0xx+lO9IySSe0Y4a8h3F+41ev4UQvcjKPFIvM2ToqA8JyqXddvLXXcDLCEXng==
X-Received: by 2002:a05:620a:6105:b0:7c7:c6e9:963c with SMTP id af79cd13be357-7caf04c142fmr87551785a.4.1746473694490;
        Mon, 05 May 2025 12:34:54 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cad23b5278sm606919985a.1.2025.05.05.12.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 12:34:54 -0700 (PDT)
Message-ID: <681912de.050a0220.383f17.18c4@mx.google.com>
X-Google-Original-Message-ID: <aBkS25IAZXiyXeXZ@winterfell.>
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8B8F3120007E;
	Mon,  5 May 2025 15:34:53 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 05 May 2025 15:34:53 -0400
X-ME-Sender: <xms:3RIZaENOKcV_V4pchMDIGpgqOT8XeYyK7jqMEa--H2Sfepw08f8ijg>
    <xme:3RIZaK-goJa0QuWpIgmKvY5jgUBAc87hW5au3mVlx9jIUH-AYw9c88C3LDlN6Ame6
    ChzIm-TziuNeJNc_Q>
X-ME-Received: <xmr:3RIZaLT8dU3hIUe4mBMvj7PC8hJ4ISIQfR0g0qsKehaR0zeBobQnmGEWsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvkeduleeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrih
    hlrdgtohhmqeenucggtffrrghtthgvrhhnpeehudfgudffffetuedtvdehueevledvhfel
    leeivedtgeeuhfegueevieduffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgr
    lhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppe
    hgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudekpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgughhofiesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    sghrvghnuggrnhdrhhhighhgihhnsheslhhinhhugidruggvvhdprhgtphhtthhopegrlh
    gvgidrghgrhihnohhrsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhmohgrrhesghho
    ohhglhgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhhsvghlfhhtvghsthesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkuhhnihhtqdguvghvsehgohhoghhl
    vghgrhhouhhpshdrtghomhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvth
    dprhgtphhtthhopegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomh
X-ME-Proxy: <xmx:3RIZaMu8GU9Ixwt_lnrfB4AOZGU4ehJiJajRp5xMVPmQiJJXIwMR5g>
    <xmx:3RIZaMeI-x4I7P7SZLXK0Dwz3XQnfvQVaJ_THw1O1SNzSzJBci_P5A>
    <xmx:3RIZaA2jVlhadXx5BUw9i9mSQsvMTHBgGYZ8_1YVGzakXFGH0f3tqA>
    <xmx:3RIZaA-s-nsYuLKNr6F4LFSWwXc7q5nZq_aELczlW1uCS0L1ELdSLw>
    <xmx:3RIZaD-J1ajwYTRjr-wt8yw2pWXopfcpzZwsO8yCWY4bEDWi68U8qru9>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 May 2025 15:34:53 -0400 (EDT)
Date: Mon, 5 May 2025 12:34:51 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/7] rust: kunit: support checked `-> Result`s in KUnit
 `#[test]`s
References: <20250502215133.1923676-1-ojeda@kernel.org>
 <20250502215133.1923676-3-ojeda@kernel.org>
 <CABVgOSm8T+_kXY78sioUHEcG7rYApfWK2Gfxkrvw94Dz57G0oQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVgOSm8T+_kXY78sioUHEcG7rYApfWK2Gfxkrvw94Dz57G0oQ@mail.gmail.com>

On Mon, May 05, 2025 at 02:02:09PM +0800, David Gow wrote:
> On Sat, 3 May 2025 at 05:51, Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Currently, return values of KUnit `#[test]` functions are ignored.
> >
> > Thus introduce support for `-> Result` functions by checking their
> > returned values.
> >
> > At the same time, require that test functions return `()` or `Result<T,
> > E>`, which should avoid mistakes, especially with non-`#[must_use]`
> > types. Other types can be supported in the future if needed.
> >
> > With this, a failing test like:
> >
> >     #[test]
> >     fn my_test() -> Result {
> >         f()?;
> >         Ok(())
> >     }
> >
> > will output:
> >
> >     [    3.744214]     KTAP version 1
> >     [    3.744287]     # Subtest: my_test_suite
> >     [    3.744378]     # speed: normal
> >     [    3.744399]     1..1
> >     [    3.745817]     # my_test: ASSERTION FAILED at rust/kernel/lib.rs:321
> >     [    3.745817]     Expected is_test_result_ok(my_test()) to be true, but is false
> >     [    3.747152]     # my_test.speed: normal
> >     [    3.747199]     not ok 1 my_test
> >     [    3.747345] not ok 4 my_test_suite
> >
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> 
> This is a neat idea. I think a lot of tests will still want to go with
> the () return value, but having both as an option seems like a good
> idea to me.
> 

Handling the return value of a test is definitely a good thing, but I'm
not sure returning `Err` should be treated as assertion failure
though. Considering:

    #[test]
    fn foo() -> Result {
        let b = KBox::new(...)?; // need to allocate memory for the test
	use_box(b);
	assert!(...);
    }

if the test runs without enough memory, then KBox::new() would return a
Err(ENOMEM), and technically, it's not a test failure rather the test
has been skipped because of no enough resource.

I would suggest we handle the `Err` returns specially (mark as "SKIPPED"
maybe?).

Thoughts?

Regards,
Boqun

> Reviewed-by: David Gow <davidgow@google.com>
> 
> Cheers,
> -- David
> 
> 
> >  rust/kernel/kunit.rs | 25 +++++++++++++++++++++++++
> >  rust/macros/kunit.rs |  3 ++-
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
> > index 2659895d4c5d..f43e3ed460c2 100644
> > --- a/rust/kernel/kunit.rs
> > +++ b/rust/kernel/kunit.rs
> > @@ -164,6 +164,31 @@ macro_rules! kunit_assert_eq {
> >      }};
> >  }
> >
> > +trait TestResult {
> > +    fn is_test_result_ok(&self) -> bool;
> > +}
> > +
> > +impl TestResult for () {
> > +    fn is_test_result_ok(&self) -> bool {
> > +        true
> > +    }
> > +}
> > +
> > +impl<T, E> TestResult for Result<T, E> {
> > +    fn is_test_result_ok(&self) -> bool {
> > +        self.is_ok()
> > +    }
> > +}
> > +
> > +/// Returns whether a test result is to be considered OK.
> > +///
> > +/// This will be `assert!`ed from the generated tests.
> > +#[doc(hidden)]
> > +#[expect(private_bounds)]
> > +pub fn is_test_result_ok(t: impl TestResult) -> bool {
> > +    t.is_test_result_ok()
> > +}
> > +
> >  /// Represents an individual test case.
> >  ///
> >  /// The [`kunit_unsafe_test_suite!`] macro expects a NULL-terminated list of valid test cases.
> > diff --git a/rust/macros/kunit.rs b/rust/macros/kunit.rs
> > index eb4f2afdbe43..9681775d160a 100644
> > --- a/rust/macros/kunit.rs
> > +++ b/rust/macros/kunit.rs
> > @@ -105,8 +105,9 @@ pub(crate) fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
> >      let path = crate::helpers::file();
> >      for test in &tests {
> >          let kunit_wrapper_fn_name = format!("kunit_rust_wrapper_{}", test);
> > +        // An extra `use` is used here to reduce the length of the message.
> >          let kunit_wrapper = format!(
> > -            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kunit) {{ {}(); }}",
> > +            "unsafe extern \"C\" fn {}(_test: *mut kernel::bindings::kunit) {{ use kernel::kunit::is_test_result_ok; assert!(is_test_result_ok({}())); }}",
> >              kunit_wrapper_fn_name, test
> >          );
> >          writeln!(kunit_macros, "{kunit_wrapper}").unwrap();
> > --
> > 2.49.0
> >


