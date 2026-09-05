Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A52475F7;
	Sat,  5 Sep 2026 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608485; cv=none; b=LvKnowHPK96jhq7RVl7+AebbjDhRfaurz+6J/RqBLrmfljIN3B7vODdqteDBqOmfDhLMaS5RLhRmKIVhGczSoENWYJXYB6TQVgc7EafXj7P9ZT86gFh1Nuao85prkmTYuvPRyU6x00mArD8qnARkNZnYfRqbif1xz1dSZ5AWNso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608485; c=relaxed/simple;
	bh=UV53DRsOGI+3DZr1F6Byao7TGY82v4luBE60dp6ks30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2IKvF7dosIOZBE6eZH9nRXggonhv9RuyuaIUpR0byIrTTezxGgAEvLXfhpvqqbHKaiDOwjykdjM6CEDnl3/Piz5k2mTyLI5CKTUI4G3xtizOwCo9YeSXaPbfidMEA0TwNgU1NdNDZgj/IQZYn61gBwpkF4g76WnseN1U0F7MNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SP9btzWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SP9btzWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF51F00A3D;
	Sat,  5 Sep 2026 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788608483;
	bh=gifpKp+5IUGA4WQodiCfcIPD/2OT99dXfSnF8EVtxEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP9btzWReG/xJYvsSXWsDIu1nOJVPRa3uwEDuoAxydkW8CMPwLdmwTBMWJTIVEiki
	 lLptHyBO9lBdRVmXHCu2yz/ycY1PGpJyvh1iyv+GgAtajrPZGY+G5taeqTj+wvtog6
	 r36Ecu/sRvqiOyhSYWJ39M+i81Ke2+07gMZPUCLmOKfsIB+NT/si45b2A2rWo0/Ltn
	 jKvDNqg3hoxZgvJbTkMYSRooma8H5PFu2LD2pQH9vskfq8qR7ffN7lObU+Hm8SR69K
	 7d9eEBRkBhGdmvn2XXHA0TtDtRpYyvuNThreJ9ixlXtx91pzkxrqOo9HERGIbmtzCl
	 0oBuHK3prhxug==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Date: Sat,  5 Sep 2026 13:41:11 +0200
Message-ID: <20260905114111.124795-1-ojeda@kernel.org>
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 04 Sep 2026 06:52:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 552 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I see the same arm32 build issue:

    mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
          |                         ^

In addition, in UML (x86_64) there is also nearby:

    mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
      110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
          |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      111 |                                       pvmw->pte);
          |                                       ~~~~~~~~~~

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org

Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

Thanks!

Cheers,
Miguel
