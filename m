Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4C21C84C9
	for <patches@lists.linux.dev>; Sat, 19 Jul 2025 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752957414; cv=none; b=QfEtKHi5hkjnvxbwxUpW1scsxYrYdxiAZEWc1S6pxvxoj6veMCpHC72aNR+L4XW1iT0GqY7SkLx6gAUUdL/qjOFTgJal3JtXlfwJBOg12GwhsnTot4IqLvWpnhBUaG+ZqXfWb85Hgn8dcz0R8Ds2Qwba0I0NQJagkuIFWcRXnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752957414; c=relaxed/simple;
	bh=di+mcCvt0+UBtHhM8HRY9AByVNConNif7PwF2Wn94wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FRPL+F7keltRXEJnGqwwgEep1ms9MhMESHoC6Juf1Ecn9JQbWedUsj1l7Xq7BclNU+hSrvMoY4RBJuc0v5MA8C2k+a+LuLm7y5H/gmZCIz3sYzrHTbOzp+rebPPERjnOWIZf7QTiSh46B47dhz0YQFglg70GjSQ/0JsBCVKihG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvWQa3d4; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvWQa3d4"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6faf66905adso20285856d6.2
        for <patches@lists.linux.dev>; Sat, 19 Jul 2025 13:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752957410; x=1753562210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/28dPvNYfbE+FFDSr4PtOx6mzozUV3wLj3+bPK0eQsM=;
        b=hvWQa3d49LhLRvsadlLp1PAz8OMaPtaQhYvDh98yJybUCxZj/y6nJG1msBYkIZuB3K
         ETxcSSMJfe8AwJsVEaW2E/WHnYmFrbNjsZ0yaS6542+Yn5ae8hRF90SjCBX6GPPSfvFo
         /qIm7qe+6XzrdOZvLidLG7hIA4HuGg4coPHO27RyH740Hoc8kjfqq7ZtfT8YEztkJftW
         ezNNI2r+9oEtPuYDhF4R6RueWincll8iqr00NNi0X+S7p4TLYeW9LyqTBZfVDBruRK7o
         VRjeYGCQFxkBfeGwSjGDPqNUQUV5VDPXYvqmm15NR1M9DbsfQpQQjUSC4q8KM3p4UV0k
         GFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752957410; x=1753562210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/28dPvNYfbE+FFDSr4PtOx6mzozUV3wLj3+bPK0eQsM=;
        b=Gog1viM3ed0Imqlksu5NLxpkJCNBErjlWFK/sCS2DIi9r9wQFIgipD6mlvcoCg+zOW
         mM20iES/8paFyRnUBBgyDxu0DfoUwd1H5Sm9wsaeCJgTijSmGSeGRFCXCqsK3tXG3jfZ
         /tyKl44GNxBRCQ7rkXCqwBf04Fia8TR9+LNtpSgZP98th28V3v84ezHcNz+OQMKsIjYB
         hMk2X8Jmqp9yLvVBF1bH72c2/X7oqak3QP9bJK0wt2zItUqKGc+5999p4MVEofmjF9N1
         9FWSxARXhrzTjy8AsmSoU934euhKYFIwC6AS6GBRJJGsnvs4o05G751UM9i4RZZLK8WA
         6s8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDxvUga/dFJPmSJLL+w4VexKFO1ZoyrJ0nFCLZDVdVe2e3ZxMyFtGmMSvl361+UYoqTzHQW77G@lists.linux.dev
X-Gm-Message-State: AOJu0YyJFGNenED+bmlv3OWN4+Z5Jfey7BGFkmvSQWvGto1POqFAy/YZ
	/Wn3F0dbWMOfVSV/+aDj56x1uDIteDMZ561g3DqI0vZx2ADsFjdn/ue8
X-Gm-Gg: ASbGncu9vKNuRDt+2ejEEwgVscxy2gCI0L23b6TB9sox4q30pEDgNElGD1QRYNkecMg
	TDn9rmM72U3T+zpdA4hJ+LwYk8JSQZAuFq9ljaPoRlVrM0ZzbeMfSe15tafYv6zcMWJ8h5k/+7q
	A12a0LN031yJu4dSD73QLYF/SR5KIKXJPx8GB4nSUqVDbVoUE1AwNwb5c9Q4mtEmWf0/pSaH+E1
	cnkQdc3DJdjUXq5LxSjtw94Zm+9SURaIcNTiK57pisMgzLv1pgifI7jGoyZWtJfEMURMrsr7PCZ
	Obk2Aud9QB2LI4Du3Ua9CAqnEMANiQv3hpVyuL2EpuOUL2OztyPtEWR1W/KxeGDF69oYV+xfwYJ
	0yM1ebeAphc7wy14cSO1xn80VkGbgixfiErAzLSxOEnNf38qdXWmwmjxeeG3fqiSF1OaxuKVxc/
	jO4lK/7mTWPvXFEfC49/hAvWA=
X-Google-Smtp-Source: AGHT+IGeKABTFHfN9W6A3yT2jAFSY2KexZG1xm5flv3gh7T0aNpDMjDu7i8oSpr1PQh701WQXLZoPw==
X-Received: by 2002:a05:6214:cc8:b0:702:d655:f4e9 with SMTP id 6a1803df08f44-704f6a19c56mr233430946d6.18.1752957409906;
        Sat, 19 Jul 2025 13:36:49 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051ba6b0e4sm21863886d6.68.2025.07.19.13.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 13:36:49 -0700 (PDT)
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id BAB4EF40066;
	Sat, 19 Jul 2025 16:36:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sat, 19 Jul 2025 16:36:48 -0400
X-ME-Sender: <xms:4AF8aKoCiqhLIc-d40SEhuiBP1zRqgP3VBYQQUEAh5R_nS9i6GqPlw>
    <xme:4AF8aHnjCjYScWhQcTKBgd_nLeH0F3zjrD9ZQF4O3Zb9fkJawt63Y2a3fKZw6-2xj
    cx7wK-GjMm2WJ4ugw>
X-ME-Received: <xmr:4AF8aLQDOKCfFGUPJ2ihvaKQ9JwVlvRJnuW04mTdJkuApcle6dOrEl71-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdeijeefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhepgffhffevhffhvdfgjefgkedvlefgkeegveeuheelhfeivdegffejgfetuefgheei
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohep
    udehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehojhgvuggrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopegrlhgvgidrghgrhihnohhrsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepgh
    grrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesphhr
    ohhtohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepthhmgh
    hrohhsshesuhhmihgthhdrvgguuh
X-ME-Proxy: <xmx:4AF8aNa7AG7q6qFr78s3XEt4AwRn3Ix4m1K6r8yEWh0R6KE38r5DdA>
    <xmx:4AF8aL8N7JIvbmsnBa63R9pCJ52SUIdCVjKNIvGdhW0T0vxTgm98Rg>
    <xmx:4AF8aPl-mgumOgmQubcbV4iG18QEuly0ldctV1HpS0NgXod1-7fJUg>
    <xmx:4AF8aIYlG24qGS3p4NyQgKBEw2Dxkji_HN1RXx2Mb41T5xw0t7aGFQ>
    <xmx:4AF8aPPlHiWshwO0mGLlC2JdpS47gf0t2ivHw6fChvEByGGisWzzuItV>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 19 Jul 2025 16:36:48 -0400 (EDT)
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	I Hsin Cheng <richard120310@gmail.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: list: Add an example for `ListLinksSelfPtr` usage
Date: Sat, 19 Jul 2025 13:36:46 -0700
Message-Id: <20250719203646.84350-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250719183649.596051-1-ojeda@kernel.org>
References: <20250719183649.596051-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It appears that the support for `ListLinksSelfPtr` is dead code at the
moment [1]. Hence add an example similar to `ListLinks` usage to help
catching bugs and demonstrating the usage.

The example is mostly based on Alice's usage in binder driver[2].

Link: https://lore.kernel.org/rust-for-linux/20250719183649.596051-1-ojeda@kernel.org/ [1]
Link: https://lore.kernel.org/rust-for-linux/20231101-rust-binder-v1-4-08ba9197f637@google.com/ [2]
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/list.rs | 125 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/rust/kernel/list.rs b/rust/kernel/list.rs
index 7ebb81b2a3d4..f66898738b31 100644
--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -38,6 +38,8 @@
 ///
 /// # Examples
 ///
+/// Use [`ListLinks`] as the type of the intrusive field.
+///
 /// ```
 /// use kernel::list::*;
 ///
@@ -143,6 +145,129 @@
 /// }
 /// # Result::<(), Error>::Ok(())
 /// ```
+///
+/// Use [`ListLinksSelfPtr`] as the type of the intrusive field. This allows a list of trait object
+/// type.
+///
+/// ```
+/// use kernel::list::*;
+///
+/// trait Trait {
+///     fn foo(&self) -> (&'static str, i32);
+/// }
+///
+/// #[pin_data]
+/// struct DTWrap<T: ?Sized> {
+///     #[pin]
+///     links: ListLinksSelfPtr<DTWrap<dyn Trait>>,
+///     value: T,
+/// }
+///
+/// impl<T> DTWrap<T> {
+///     fn new(value: T) -> Result<ListArc<Self>> {
+///         ListArc::pin_init(try_pin_init!(Self {
+///             value,
+///             links <- ListLinksSelfPtr::new(),
+///         }), GFP_KERNEL)
+///     }
+/// }
+///
+/// impl_has_list_links_self_ptr! {
+///     impl HasSelfPtr<DTWrap<dyn Trait>> for DTWrap<dyn Trait> { self.links }
+/// }
+/// impl_list_arc_safe! {
+///     impl{T: ?Sized} ListArcSafe<0> for DTWrap<T> { untracked; }
+/// }
+/// impl_list_item! {
+///     impl ListItem<0> for DTWrap<dyn Trait> { using ListLinksSelfPtr; }
+/// }
+///
+/// // Create a new empty list.
+/// let mut list = List::<DTWrap<dyn Trait>>::new();
+/// {
+///     assert!(list.is_empty());
+/// }
+///
+/// struct A(i32);
+///
+/// // `A` returns the inner value for `foo`.
+/// impl Trait for A { fn foo(&self) -> (&'static str, i32) { ("a", self.0) } }
+///
+/// struct B;
+/// // `B` always returns 42.
+/// impl Trait for B { fn foo(&self) -> (&'static str, i32) { ("b", 42) } }
+///
+/// // Insert 3 element using `push_back()`.
+/// list.push_back(DTWrap::new(A(15))?);
+/// list.push_back(DTWrap::new(A(32))?);
+/// list.push_back(DTWrap::new(B)?);
+///
+/// // Iterate over the list to verify the nodes were inserted correctly.
+/// // [A(15), A(32), B]
+/// {
+///     let mut iter = list.iter();
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("a", 15));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("a", 32));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("b", 42));
+///     assert!(iter.next().is_none());
+///
+///     // Verify the length of the list.
+///     assert_eq!(list.iter().count(), 3);
+/// }
+///
+/// // Pop the items from the list using `pop_back()` and verify the content.
+/// {
+///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("b", 42));
+///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 32));
+///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 15));
+/// }
+///
+/// // Insert 3 elements using `push_front()`.
+/// list.push_front(DTWrap::new(A(15))?);
+/// list.push_front(DTWrap::new(A(32))?);
+/// list.push_front(DTWrap::new(B)?);
+///
+/// // Iterate over the list to verify the nodes were inserted correctly.
+/// // [B, A(32), A(15)]
+/// {
+///     let mut iter = list.iter();
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("b", 42));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("a", 32));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("a", 15));
+///     assert!(iter.next().is_none());
+///
+///     // Verify the length of the list.
+///     assert_eq!(list.iter().count(), 3);
+/// }
+///
+/// // Pop the items from the list using `pop_front()` and verify the content.
+/// {
+///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 15));
+///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 32));
+/// }
+///
+/// // Push `list2` to `list` through `push_all_back()`.
+/// // list: [B]
+/// // list2: [B, A(25)]
+/// {
+///     let mut list2 = List::<DTWrap<dyn Trait>>::new();
+///     list2.push_back(DTWrap::new(B)?);
+///     list2.push_back(DTWrap::new(A(25))?);
+///
+///     list.push_all_back(&mut list2);
+///
+///     // list: [B, B, A(25)]
+///     // list2: []
+///     let mut iter = list.iter();
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("b", 42));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("b", 42));
+///     assert_eq!(iter.next().ok_or(EINVAL)?.value.foo(), ("a", 25));
+///     assert!(iter.next().is_none());
+///     assert!(list2.is_empty());
+/// }
+/// # Result::<(), Error>::Ok(())
+/// ```
+///
 pub struct List<T: ?Sized + ListItem<ID>, const ID: u64 = 0> {
     first: *mut ListLinksFields,
     _ty: PhantomData<ListArc<T, ID>>,
-- 
2.39.5 (Apple Git-154)

