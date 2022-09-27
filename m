Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E982596
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF60C433B5;
	Tue, 27 Sep 2022 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664290337;
	bh=ptfmmYZp+x1Y9NE6TMn3iivjW3xBjzaMOwgTv/XmtFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edkIUBbHSu3HEoKHpm5KykZITI19g2qPLhglCgZ0+YAYCy5hw29hcYxukE36re0m6
	 eWx+sZA49h/yHf9FWkL8UfiwMgePdB3Zn13WWC291q3sL5LEQs4jvBhsxhzCsQ6Sgb
	 pHARfRmPSLbVRaiFuSCKED8EI5pkglghqnUoDvy4=
Date: Tue, 27 Sep 2022 16:52:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v10 02/27] kallsyms: avoid hardcoding buffer size
Message-ID: <YzMOHkNNDI7mss02@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-3-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:33PM +0200, Miguel Ojeda wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
> 
> This introduces `KSYM_NAME_LEN_BUFFER` in place of the previously
> hardcoded size of the input buffer.
> 
> It will also make it easier to update the size in a single place
> in a later patch.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/kallsyms.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
