Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C3EA0;
	Wed, 26 Oct 2022 01:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9257C433D6;
	Wed, 26 Oct 2022 01:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1666748884;
	bh=DeNUe/+thSCrXVF482VVO4niwzLe1FwTzl3oKIQ+v/Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MOLScLugkE2Xjrku4vNwQQ2x+3ut851N45uuEkEn3TPLzBwaoNrRV1WlJZ31GRhOV
	 tnvPZ2EUF96cYEVKfXieBiQAcOiLArtryDwevpxqzdKIMFCN1A9sIZubhBoB3V237n
	 412KLgsmhKWF4KYtegvDx8hqWvWNsXQAywd6RbyI=
Date: Tue, 25 Oct 2022 18:48:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Gautam Menghani <gautammenghani201@gmail.com>, Nick Desaulniers
 <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/khugepaged: Initialize index and nr in
 collapse_file()
Message-Id: <20221025184802.7d4611caff603fecf98330b6@linux-foundation.org>
In-Reply-To: <20221025173407.3423241-1-nathan@kernel.org>
References: <20221025173407.3423241-1-nathan@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Oct 2022 10:34:07 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> Clang warns (trimmed for brevity):
> 
>   mm/khugepaged.c:1729:7: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>   mm/khugepaged.c:1716:6: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>   mm/khugepaged.c:1729:7: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>   mm/khugepaged.c:1716:6: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> 
> There are two goto statements that will use index and nr before they
> have been properly initialized. Zero initialize them so that they can be
> safely used by the tracepoint at the end of the function.

Thanks.  I've actually dropped the offending patch - I'd like a resend
which includes a fix such as this and a good reason for making the
change.
