Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B0FEA4;
	Thu,  2 Feb 2023 06:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F054AC433EF;
	Thu,  2 Feb 2023 06:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675318525;
	bh=ezi/tsRwvbIGmfLvyvnkgMf52A4ZxQwliiJ7g6rQbHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d2kFqZXqLdNq3C9BL4FdBB4OSoW+nGNQjlVY/Awdx2cs3s2n+856r+ioKjht5q/oQ
	 E3TKCm2qiJreclhOcBosZMv1BVKV+aK7h0xh6JBm7CO5/if7tX6QVzFDlZGpFZAEe6
	 YWF/Xp/hGv36xvwv4aKpaEZOD0U4j6vkBfwz4azT50KSQTJoetesDYSQR5E8yPW9f7
	 8oG+3/jUur6+Yf1nCQI6Ht9yxvML7qh8UDV/EXF0j4U79GetPPbsZ7i+9SRD8N4wzG
	 S7+UPY6Vt/shIuExluBGeIpm+l9q/+3yJIX/rSsNWJSPyiIbFFmnDoTgv48qmY44dD
	 9QakSYXdyLsEw==
Date: Wed, 1 Feb 2023 23:15:23 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: jaegeuk@kernel.org, ndesaulniers@google.com, trix@redhat.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] f2fs: Fix type of single bit bitfield in f2fs_io_info
Message-ID: <Y9tU+woHY23zHpmv@dev-arch.thelio-3990X>
References: <20230201-f2fs-fix-single-length-bitfields-v1-1-e386f7916b94@kernel.org>
 <64d1f9d3-12d8-cc7a-501e-5c0286b0cfa1@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64d1f9d3-12d8-cc7a-501e-5c0286b0cfa1@kernel.org>

On Thu, Feb 02, 2023 at 02:13:18PM +0800, Chao Yu wrote:
> On 2023/2/2 0:40, Nathan Chancellor wrote:
> > Clang warns:
> > 
> >    ../fs/f2fs/data.c:995:17: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
> >            fio->submitted = 1;
> >                           ^ ~
> >    ../fs/f2fs/data.c:1011:15: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
> >                            fio->retry = 1;
> >                                       ^ ~
> > 
> >    ../fs/f2fs/segment.c:3320:16: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
> >                    fio->in_list = 1;
> >                                 ^ ~
> > 
> > There is not a bug here because the value of these fields is never
> > explicitly compared against (just whether it is zero or non-zero) but
> > it is easy to silence the warning by using an unsigned type to allow
> > an assignment of 0 or 1 without implicit conversion.
> 
> Nathan, thanks a lot for catching this, do you mind letting I merge this fix
> into original patch? as the original patch has not been upstreamed yet.

No worries, do whatever you need to! I just care that the problem gets
resolved one way or another :)

Cheers,
Nathan
