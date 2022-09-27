Received: from hop.stappers.nl (hop.stappers.nl [141.105.120.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4D23BE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:05:43 +0000 (UTC)
Received: from gpm.stappers.nl (gpm.stappers.nl [IPv6:2a02:a46d:659e:1::696e:626f])
	by hop.stappers.nl (Postfix) with ESMTP id 088DA2000F;
	Tue, 27 Sep 2022 14:05:42 +0000 (UTC)
Received: by gpm.stappers.nl (Postfix, from userid 1000)
	id AD319304049; Tue, 27 Sep 2022 16:05:41 +0200 (CEST)
Date: Tue, 27 Sep 2022 16:05:41 +0200
From: Geert Stappers <stappers@stappers.nl>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v10 01/27] kallsyms: use `ARRAY_SIZE` instead of
 hardcoded size
Message-ID: <20220927140541.zpb2effrshaxndqi@gpm.stappers.nl>
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
User-Agent: NeoMutt/20170113 (1.7.2)

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
> 
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index f18e6dfc68c5..8551513f9311 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
>  
>  	rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
>  	if (rc != 3) {
> -		if (rc != EOF && fgets(name, 500, in) == NULL)
> +		if (rc != EOF && fgets(name, ARRAY_SIZE(name), in) == NULL)
>  			fprintf(stderr, "Read error or end of file.\n");
>  		return NULL;
>  	}
> -- 
> 2.37.3
> 

Reviewed-by: Geert Stappers <stappers@stappers.nl>
 

Regards
Geert Stappers
Hopes to see the kallsyms patches getting accepted,
that they don't show up in v11 of the Rust patch serie.
-- 
Silence is hard to parse
