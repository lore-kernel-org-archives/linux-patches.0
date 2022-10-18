Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AB35386;
	Tue, 18 Oct 2022 20:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CE9C433D6;
	Tue, 18 Oct 2022 20:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1666126509;
	bh=/wjPaj4hMDgvB9PGYzwx7w23XxCmDgS1FeMxQ9Lnm/8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t6A6TUsmq2JbEbJPF9njM4iC/QgtcTd8Ie8guuS+lxgJow8hHqyHDECrTFzFOEIND
	 TYh5EUoTvOkUT3id59yExMEevKehALV6PEULymcHTv+fiCRZCCe4/R+39vX/9x9hBB
	 imwUJ1ccCDJ1WzY7UQOKdLp99XWaWAsSZzUk4d44=
Date: Tue, 18 Oct 2022 13:55:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH] mm/memremap: Mark folio_span_valid() as __maybe_unused
Message-Id: <20221018135508.d1844e583974b03eaa9aa354@linux-foundation.org>
In-Reply-To: <634ee87229a37_6be129430@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221018152645.3195108-1-nathan@kernel.org>
	<634ee87229a37_6be129430@dwillia2-xfh.jf.intel.com.notmuch>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Oct 2022 10:54:58 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> > ---
> > 
> > I am aware the Fixes SHA is probably not stable but I figured I would
> > include it anyways.
> 
> This fix looks good to me, but I assume commit-ids are not stable until
> the patch moves from mm-unstable to mm-stable. Andrew, do I have that
> right?

Yes, mm-unstable hashes change daily.  But knowing the title of the
patch which needs the fix is quite helpful.

