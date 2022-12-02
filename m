Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D14C64;
	Fri,  2 Dec 2022 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669992365; x=1701528365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YeOXBTpcKW54/I4KLp5hnE2yhE4BreCqf9VS8FQha6M=;
  b=bXkssP0DnsL4NWiPPJ5oAHpS1nKCsgjmJmkc/wvfq3kLP/swJWEWpEbG
   F2S8KTFXjD5CZ1OuP61GLsUOww8IvKKBZcMI6zxcfIVlENbvNfdTD1Sov
   nh51XpYKQxc5XhpJ9tem4PNXWp+NeAO9A9vDbWXhAj9EPKfHPXCK9qFVK
   oE4LUSv1LNvJlvI6fbL6CcYyZoe81IP3TCD/CJij0m87JbR9IUTTzFSY/
   vOufm7XsiBGace+WNpGljlTqFjQefe7bcBBOOFangC561QCDAlvpiDpQh
   dMGdmim5RvLJh2fpkxcscSfPsezGGKH1nhzHRwtPqaFH3uy7apRVqLDab
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="303568475"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="303568475"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 06:46:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675849501"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="675849501"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 06:46:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
	by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2B2Ek1m3018822;
	Fri, 2 Dec 2022 14:46:01 GMT
From: Alexander Lobakin <alexandr.lobakin@intel.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] modpost: Include '.text.*' in TEXT_SECTIONS
Date: Fri,  2 Dec 2022 15:44:46 +0100
Message-Id: <20221202144446.3395140-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129190123.872394-3-nathan@kernel.org>
References: <20221129190123.872394-1-nathan@kernel.org> <20221129190123.872394-3-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 29 Nov 2022 12:01:23 -0700

> Commit 6c730bfc894f ("modpost: handle -ffunction-sections") added
> ".text.*" to the OTHER_TEXT_SECTIONS macro to fix certain section
> mismatch warnings. Unfortunately, this makes it impossible for modpost
> to warn about section mismatchs with LTO, which implies
> '-ffunction-sections', as all functions are put in their own
> '.text.<func_name>' sections, which may still reference functions in
> sections they are not supposed to, such as __init.
> 
> Fix this by moving ".text.*" into TEXT_SECTIONS, so that configurations
> with '-ffunction-sections' will see warnings about mismatched sections.
> 
> Link: https://lore.kernel.org/Y39kI3MOtVI5BAnV@google.com/
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

This revealed a couple issues in the FG-KASLR kernel. None of them
are false-positive although FG-KASLR doesn't merge text.* into one
section in the final vmlinux. Nice!

Reviewed-and-tested-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> ---
>  scripts/mod/modpost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

[...]

> -- 
> 2.38.1

Thanks,
Olek
