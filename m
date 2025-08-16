Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF314E2E2;
	Sat, 16 Aug 2025 23:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755387470; cv=none; b=QBAXaMiCkBxdiIhnf/m9ZxYmI+y0/Ke3+bTF0NAqS9SVlWd6rxYsB09fC2Uj9NpL2QiHaWPPvF68BWCFUSe9qehGq1JgWhVA1RDurBTYti9YZXw4UWqlGp2XATt092ddE+aySACD1KtDqolaLsND9Q2rF0Jv/IyCDXbIIjOw+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755387470; c=relaxed/simple;
	bh=n0Ug3xm97yHJIp9hnivwulo49/WkJhxthMq+zEpRlDU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=geKRg4zQk+6i27I33CM6utbwFs//oLvxhMYBDnv63jfprkF9R7EU5MJlH7Je3dBaL7Df0PppXZUWP6n96TeiEbVsNuUv32DWNiUS5c0imK8PJvsFCm7OJ0WKGZoK7AqRhFzV42jM4+uvCKJtRpXD0VQmsxWzhLYALAFWQuQR+/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjOTL/Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjOTL/Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F72BC4CEEF;
	Sat, 16 Aug 2025 23:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755387470;
	bh=n0Ug3xm97yHJIp9hnivwulo49/WkJhxthMq+zEpRlDU=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=RjOTL/CgXh7QEa1CPQmdNA/AiakjbtR6aWhcRkgaaQzVSUnXZz50KwC4Pzxd1Z5XO
	 wK5dacrWZGYi4ZtT5vxh1E/JeYxpAOmFohF2EZFtMsC1aSh99JT0JsEj/T46+JkHv5
	 YqZc64DjrvIGBIlh4MupDoBC6upfUDjA522/e8wiZ7i+6rZapv0f8s0WX+X6nLTXPP
	 +W0eZcUShOYnccB32zZ4fqV6CUF10GDk/bG1vP8Zr+FcxXpk4ITw1hP9edMtUH/kOH
	 W6vVHgAJHuTK05j9ew3vZIvD/m4vA0QW37v8Yqs4FHVHKGkm8ITPu8Zt82pEL/5z1I
	 hpJUho5enQAPw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 17 Aug 2025 01:37:44 +0200
Message-Id: <DC48X8GV4JAW.1S68E9ZZHD9ZY@kernel.org>
Subject: Re: [PATCH] rust: alloc: fix `rusttest` by providing
 `Cmalloc::aligned_layout` too
Cc: "Alex Gaynor" <alex.gaynor@gmail.com>, "David Airlie"
 <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <rust-for-linux@vger.kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <dri-devel@lists.freedesktop.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
To: "Miguel Ojeda" <ojeda@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250816204215.2719559-1-ojeda@kernel.org>
In-Reply-To: <20250816204215.2719559-1-ojeda@kernel.org>

On Sat Aug 16, 2025 at 10:42 PM CEST, Miguel Ojeda wrote:
> Commit fde578c86281 ("rust: alloc: replace aligned_size() with
> Kmalloc::aligned_layout()") provides a public `aligned_layout` function
> in `Kamlloc`, but not in `Cmalloc`, and thus uses of it will trigger an
> error in `rusttest`.

Good catch, thanks! -- Applied to drm-misc-fixes.
