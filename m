Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75735A952;
	Fri,  9 Jan 2026 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767966048; cv=none; b=qjFU/nCsYC/5l6Qo0Rg6dFkFzjZu3365WYmKx8BGLuVdIipSkmbVlGlQxw/bK5KXnbopfI2OSVH26KXOUv1H2PV+5toaluPj5bepnrH+kmGlZkvle5/DJyD4QUz3ReAAYE4+NYjrtNwcVdh8lR5k5FEoh9pde9lw/+88Bkp26aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767966048; c=relaxed/simple;
	bh=G/p1x2YBAJeOLuNkk8WAicrllcn4KYPv9RqNynVAaYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u82JUzgzQX3Ap8VMACbCDHFupkt6jrZn8na4QaSsqeOKeQQqMGOU+47OL4QvNBW03ncEGf/WwkWwZJcIgKcMPktWC+b1hcdzkEomwy0cgPL49sNr854Rml9xKqPUKP0yTpk/Szak3U3/lXxxt5vmn1gCZmFeXJpmC23gTZaQZ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=IMKAVE+W; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="IMKAVE+W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mHMWYBgydm9Inr+rqCvfzF3QaGT77USiVccdvrYveKQ=; b=IMKAVE+WHBbsesk0CBNBlDP5op
	aE6CrnkPMQwGU3ldknG/tscquJk+jYN/RJ/zwKBAO3ybAE8f0QJIQ8KBq7WArxjPsnOT45J6IrvJA
	wjHdPt78XDQFZxlZ3iBhzcabMD2Amo4wv9i8/xeV/loSbmKbjWmIND4i5bOU3zfCETN4rgCUFo5ju
	F3qr4o4mangv0akYDvrQ+xEtRbzQ08q17cKn1y80tchFxsc+YJ6OCBh0fpfXXeOBipGqQ1ZLMiZgz
	1eeJ5l83u0PT6doNFkrHGkZ3/lLIDkCcLMK9IP/94IN8BxaA0eAh7tvR4pXwn4ncUhDJ8De6V9dte
	WTfNEZpg==;
Received: from 179-125-75-246-dinamico.pombonet.net.br ([179.125.75.246] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1veCjH-003Qq7-Od; Fri, 09 Jan 2026 14:40:40 +0100
Date: Fri, 9 Jan 2026 10:40:34 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 6.6 731/737] ext4: filesystems without casefold feature
 cannot be mounted with siphash
Message-ID: <aWEFUlM6PsTMMXxr@quatroqueijos.cascardo.eti.br>
References: <20260109112133.973195406@linuxfoundation.org>
 <20260109112201.603806562@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109112201.603806562@linuxfoundation.org>

Hi, Greg.

The followup to 985b67cd86392310d9e9326de941c22fc9340eec, that I submitted
in the same thread, has not been picked up.

20260108150350.3354622-2-cascardo@igalia.com
https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
a2187431c395 ("ext4: fix error message when rejecting the default hash")

You picked it up for 6.1 and 5.15 though.

Regards.
Cascardo.

On Fri, Jan 09, 2026 at 12:44:30PM +0100, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Lizhi Xu <lizhi.xu@windriver.com>
> 
> commit 985b67cd86392310d9e9326de941c22fc9340eec upstream.
> 
> When mounting the ext4 filesystem, if the default hash version is set to
> DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.
> 
> Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> Link: https://patch.msgid.link/20240605012335.44086-1-lizhi.xu@windriver.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> [cascardo: small conflict fixup]
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ext4/super.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3632,6 +3632,14 @@ int ext4_feature_set_ok(struct super_blo
>  	}
>  #endif
>  
> +	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
> +	    !ext4_has_feature_casefold(sb)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Filesystem without casefold feature cannot be "
> +			 "mounted with siphash");
> +		return 0;
> +	}
> +
>  	if (readonly)
>  		return 1;
>  
> 
> 
