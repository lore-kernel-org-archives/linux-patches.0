Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE25481FBD
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777418731; cv=none; b=VTQaKKDOMRk/FT8ePuCbMiQaEC975cgb+NteMNSBxZ7QnqiUUpqPFqDrIWtMTMa8e2bd2zU5gRDNCQw+JA4aGQxbK+ei7/QTpYd2fkx+tJrKK5sACTXRPqtEgIDON5FHFBAh7EZk9GJhlvBFME3ZdN321l82Ww24mrmJ4zwnS3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777418731; c=relaxed/simple;
	bh=R6cQfvSjsIKmI/Y08xsoDpxCht3Jq53qKnqck3FE+rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBno4BMjXHt0TyIYIQ02NK4KOAkd61z8osuql1oXMNRfS9RFQ+UPiEsg8Qt76tRIZ7bduaQRkf99h09RNAuyBIt0b9M8636WLePbiBDkyEhhSEfOGLLvqtIH86acrwFy6wtkFh/1QnpXOfTZfRFasHcYyv2+QU2ZSzwA82bQrd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZAgA6eY/; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZAgA6eY/"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35691a231a7so7976805a91.3
        for <patches@lists.linux.dev>; Tue, 28 Apr 2026 16:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777418729; x=1778023529; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOJluPxYzNGos+SwkCBaicu5SwImO2KTCLCxq5NtkQk=;
        b=ZAgA6eY/4LRPVx8QupDaUkM8VpvD4KHmtxBLxPZu8Fpaur/xJXvjhxUAOIYaLvuLtO
         JasKO1Hn8/zwGfn/WmA2bzYnibwdhrP6TGntlgiKne+fiazPx0VSRIwuESg2u3nZQX09
         nIHRI+DG/hz6gh41V5DJKVN3P42dZJn9SN8y7CuUIUdCo239RmjEyWY0NwqKQ9tL02Ql
         vGuTAQgqk0D6qEUb1+CsGUzx8XPDjMkUkmfPy4lmqlnRPPCkVr5RMk8by140+CXTi6Pb
         q55ST8CQk7m3J17UDPeSb07xydGFdt8LfViWYx8RF1zZthc8p2J2iCF1JT1EqV5smBlh
         ZUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777418729; x=1778023529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOJluPxYzNGos+SwkCBaicu5SwImO2KTCLCxq5NtkQk=;
        b=X+l+RssaCib/JMS2TcApgWMkMV3lo9cTsgp0U0Ut1hxG08SAywEoO6mynx04j7fIOI
         ryeazO7DUAL6iDSuCkBXb+69JINbjBRPCDpFUXpQehjP8xF0TsXgUX6ZaQJ4iCLJ35RL
         8ISx1NOX9eY/G0uN0S2m3zIWGQLvRxm4oa1R9EBWuolmoq2/UFZPskVbKF1kNEdyk+jo
         GrB7O6RIFh6BHs0iS3q1LDJtCPBYVsfAUPkS6ZymxDq9jmRCW7ptn0IFgLgzTU1ZwpW6
         ocJb68sqlwoKCsallBhRyeAaeSDM2cJO/N3y1c528SI3jK1L7mOPB8MkY8ADNYTmAQ1z
         AogQ==
X-Forwarded-Encrypted: i=1; AFNElJ/qTMOISvb4txNjeQWD3mk1d4fVX0pmYVUUbywVFbR1sQLLahpsUzp9YiTaM9080L/RHzk1kmC6@lists.linux.dev
X-Gm-Message-State: AOJu0Yym78ciVSOmBII1yvEg/opg06oaO3wJKzBeT6CmMSMJuKW4ltx9
	JkPxQVod+sTOWKVzldz0E9GGBr/W98kd/d8YWnCVEnk+j3sI6ZrckbNk
X-Gm-Gg: AeBDievS8DIqH8jNcepiHk8WidnEG8ezQoR/K+g1AhZXSuakshCLZlPCdqd89JfSmD4
	4LZIjBYTNrZUoHTJEoN1PtRFtCuinX1p2pmpg7DAHJt1aofJ+IlAfNf0MNDBq4bpC3LQPitpwrY
	MpLyE2XZ0ucu3q/4SS1oTpiqayzX+r479lHSZcS1mD2ikinVeRhZUOz7H/AEJbBLGNE7fG/+Ozb
	aLhy5V/YE5EAc2kCHelEz0HWI+6WCjkC51148HH8GOK+y8FHVVHhblIR5D1dGs7BncBuQSeS2q0
	EamDMBTA3/tuKq92s595gWpHDMuOsS7mn4jvIc/N/n0ehgQKqSBzP7DVJU60brwwY0k/9Yy9HmC
	PwvdL6Ot2LrXEc2rA0vewb7urKaG49qzePDLZTzGLtVzPPNj06wNMlk8llRd2eKpwfapvWmfalH
	j4K6nUXb67dAmj9fW2YbSszAOH
X-Received: by 2002:a17:90b:264c:b0:35b:a418:698c with SMTP id 98e67ed59e1d1-364a0b82c88mr1309297a91.12.1777418729293;
        Tue, 28 Apr 2026 16:25:29 -0700 (PDT)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a0115274sm803468a91.2.2026.04.28.16.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 16:25:28 -0700 (PDT)
Date: Wed, 29 Apr 2026 08:25:26 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	linux-fsdevel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] ntfs: Use return instead of goto in
 ntfs_mapping_pairs_decompress()
Message-ID: <afFB5jP8Wer3MYRp@hyunchul-PC02>
References: <20260428-ntfs-fix-sometimes-uninit-rl-v1-1-31e0c8025430@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260428-ntfs-fix-sometimes-uninit-rl-v1-1-31e0c8025430@kernel.org>

On Tue, Apr 28, 2026 at 03:21:38PM -0400, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   fs/ntfs/runlist.c:755:6: error: variable 'rl' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>     755 |         if (overflows_type(lowest_vcn, vcn)) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   ...
>   fs/ntfs/runlist.c:971:9: note: uninitialized use occurs here
>     971 |         kvfree(rl);
>         |                ^~
>   ...
> 
> rl has not been allocated at this point so the 'goto err_out' should
> really just be a return of the error pointer -EIO.
> 
> Fixes: cad7c6f0a514 ("ntfs: fix VCN overflow in ntfs_mapping_pairs_decompress()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thank you for this patch.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ntfs/runlist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
> index be6ca3d374bb..da21dbeaaf66 100644
> --- a/fs/ntfs/runlist.c
> +++ b/fs/ntfs/runlist.c
> @@ -754,7 +754,7 @@ struct runlist_element *ntfs_mapping_pairs_decompress(const struct ntfs_volume *
>  	/* Validate lowest_vcn from on-disk metadata to ensure it is sane. */
>  	if (overflows_type(lowest_vcn, vcn)) {
>  		ntfs_error(vol->sb, "Invalid lowest_vcn in mapping pairs.");
> -		goto err_out;
> +		return ERR_PTR(-EIO);
>  	}
>  	/* Start at vcn = lowest_vcn and lcn 0. */
>  	vcn = lowest_vcn;
> 
> ---
> base-commit: d986ba0329dcca102e227995371135c9bbcefb6b
> change-id: 20260428-ntfs-fix-sometimes-uninit-rl-cfe3c6a9c34e
> 
> Best regards,
> --  
> Nathan Chancellor <nathan@kernel.org>
> 

-- 
Thanks,
Hyunchul
