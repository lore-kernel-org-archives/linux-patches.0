Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794076622;
	b=O2qaS19rn0Z1o6O209v7nARvibzeCYNj44/RR6R9YQ5K0rZ0KmRNOZfUSWA4fTuTi7ph
	 81BhVMzB4bTdj/tOaXZQG7hWDSYRc8ED570XnfVp1aoJUQI+ywCxbqQoZVhpOYyi5yWj2
	 VRbKbxI0tsF+ssjObnit9/2vXRFiuN3WbO6wGO736Y5G99OJCYNMY80NsxwLjPGJSjLHb
	 DgYvehSFOfm61Jhmc8zFmI1cUV1YQVrUq/PlX2MpsS2+FMwy2LxKa55eTZ+sMPk2/Js6N
	 7bUptj4/qQ6z6RIUBmn4HyeRzNtiReUfAY/IVvcYToIyfIW6f4u3SCdUW6XEF6muw0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794076622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ERuNgL3/8ubnIoEFYnufjQbxnvviKD87N6fwTkLdxrI=;
	b=ZGfjSXV3PkwzepjC5zdlIpcGQ5tTdkNLwpH3NcNwCST/hTOjq5NwD/k9NpJ5C0WdDnhY
	 DiGxhr5Puy+u33Mliq4Ds039k8BpmoEIkxeOT+sAouT6oVj2f3SfWxrD0bJW3pybqEgg5
	 Ykm8So2O3tt44Sig6w97+EnzU3s5ampk+e+tMYGtv6VQIPy9MzDdX+N1KVkvVgNXT3Kyh
	 PVR2K9tMypT4ZEWzrP9/9rE744gponOQ0aYAoMp1rTyXTBeduM82cEYDF8xz64ZPum5CD
	 Z1K0dpNl1Ck+ZhcXkIHc5dGe9QGjj5zLZrr+zvZSMmcPmpoj2fIlaZTGE7LkDWE+ABw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="axbka1s/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8580E606A326;
	Sat,  7 Nov 2026 18:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=axbka1s/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8051F0089F;
	Sat,  7 Nov 2026 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794076622;
	bh=ERuNgL3/8ubnIoEFYnufjQbxnvviKD87N6fwTkLdxrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axbka1s/19gUwcu/QXKm+mhOqmjccYmIKBleffEGvgIx8Cwl/MDFXNzPFTUVZieCc
	 QPht6WBEQo89ZR+KB1uvAOrUy4wpU9ZL/J/YUoGM0CpkO545NDcnzsHUoZEXuYWyPM
	 lRA2TMFaIDCehp3d4o7YmLulYSrMWIGShMbD3eAeF/sCOOqMfxOWfnl9X54h8ct80V
	 ZangmDWEA8OsKkud4r7T3UJyHHW6BvIr0eu/36eGXF2j7tXV7sKFE1QUtN3G9nFuzm
	 0cXQqgCAw91wiJZcx+Tt94dz5/lB+il+DS/VFZVkRegyYXH/gyms4YXRlQtYkSrAkI
	 uL1ahsyYUkJ3g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	damon@lists.linux.dev
Subject: Re: [PATCH 7.3 0655/1257] mm/damon/core-kunit: test invalid damos filter commits
Date: Sat,  7 Nov 2026 10:36:49 -0800
Message-ID: <20261107183650.177635-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107183202.177477-1-sj@kernel.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 07 Nov 2026 10:32:10 -0800 SJ Park <sj@kernel.org> wrote:

> Hi Greg,
> 
> On Sat, 7 Nov 2026 08:49:11 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> TL;DR: Please drop this.  It has wrong Cc: stable@ tag.
> 
> > 
> > ------------------
> > 
> > From: SJ Park <sj@kernel.org>
> > 
> > [ Upstream commit 409d2ab6d98209c30d45123920721710475a30b4 ]
> > 
> > Add test cases for testing the validation of damos filter arguments in
> > commit time.
> 
> This patch is for testing commit 1bfb9384ae0e ("mm/damon/core: disallow max <
> min damos filter range arguments commit"), which does not exist in 7.3.y.
> Hence this patch is making DAMON kunit fails.
> 
> > 
> > Link: https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org
> > Signed-off-by: SJ Park <sj@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > Cc: David Gow <davidgow@davidgow.net>
> > Cc: Usama Arif <usamaarif642@gmail.com>
> > Cc: <stable@vger.kernel.org>
> 
> I didn't intend this to be applied to stable@.  My original patch [1] hence
> doesn't have Cc: stable@.  But I show Cc: stable@ tag in the upstream commit.
> Seems Andrew added Cc: stable@ while applying it to mm.git and I missed it.
> Sorry for not catching this early.
> 
> So, this patch is not really meant to be picked into stable@, and only causing
> the kunit failure.  Could you please drop this?

FWIW, the patch was posted as a part of a series that have a few Cc: stable@
patches.  I did so because Cc: stable@ patches are only for minor bug fixes
that does not require the fast path of hotfixes.  Apparently it only confused
Andrew or his script.  Sorry about that.  I will not mix Cc: stable@ patches
with non-Cc: stable@ patches from the next time.

> 
> [1] https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]
> 


Thanks,
SJ
