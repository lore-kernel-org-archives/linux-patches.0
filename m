Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A563F
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0001DC433C1;
	Tue, 27 Sep 2022 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664290278;
	bh=TUI2vY0GcI+g0Kd0i6XohCJSFPp7CBvJcwNd96s8s38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LlZiJ4qYXxC4ez7DpTkBYW516ZQnlJFjLSK4jfZUOByay98IA7t5xsmIynXGygXQe
	 AlFIUAjTy4NPR8v9uPPT/4tFjJqgWMJaCzhc94WfhdM74Kf7R+0ito1h6x/nTr/Etv
	 jONPSgpTPeXNWL6cT2llYg/fbzCtVNXCrZe2HTeg=
Date: Tue, 27 Sep 2022 16:51:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v10 01/27] kallsyms: use `ARRAY_SIZE` instead of
 hardcoded size
Message-ID: <YzMN48rlIHrl/c8Z@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-2-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:32PM +0200, Miguel Ojeda wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> 
> This removes one place where the `500` constant is hardcoded.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/kallsyms.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
