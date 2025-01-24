Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138F71DB14B
	for <patches@lists.linux.dev>; Fri, 24 Jan 2025 22:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737756153; cv=none; b=i6vThNflSUuTcG6P7NwOezmrSodnEk2KGuckxLA7UeD69UUmujszNzSQvRj8OD6byBLE8BWteL4faetNt4pGYrqxoOtIbUjlQyVd65tFrP6wtTVlAaNhTNpYoJE70bXcRyo9HEtidqinXq9Osz4/tof8gfBrYvSE+jMeJGSTX2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737756153; c=relaxed/simple;
	bh=tnBZNQWOaVOKz/iP4SAHicFuq1EeGHKyWsQBBrY1FdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZvK/mfiU3zl/OKdjVD9z+rVlxgOFMNb26vQHsuxTKVFGjZoFl4hjaxHnVm0zW9WBZ/jYo4f5DubMf3mutA3Wnb+bLweO1pgc1XLjzAX0FkZSAPnmCpKYWDKPpU230UswgO8fjk2D8lD4rMdS9v/TFOfvuDwQlbrRhXMwqNe72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=muBMgFwo; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="muBMgFwo"
Received: from [192.168.192.85] (unknown [50.39.104.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 0338F3F925;
	Fri, 24 Jan 2025 22:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1737756150;
	bh=PtlQGxw99o3A1cTQfevkPdg/9d7CG5J/2wIyYL6ZAWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=muBMgFwoe6+LwF+LrVcK7nwPcGZKlTdb5fFm8+p8WRxWCaI/SMTDaYWzxOf8ryLeG
	 k8B7+CmtgNm+5YHZPVBLNsL8RLT1Y3jUoGrj7xNFPsY7/S89ODaQdyLNRYG2xgMbWC
	 RzY51sTmiSkVpF7TEh1l60bN0v8E67ZTN21wtU+xP/DuEv8KvvjmvJVSEuZRk73hXx
	 3Q7qUcynxWSwaubZxb4nQDE/nxkgn0Q9pTUWQJvT8T3t08hfRbn44npDp64gFeYjvY
	 36v+mHFljNVH+pFQO3BqxoMPo6vwDKrBkzWOkBw4Pwb63AcIRsCbpHE9qIy+yisR0p
	 SOqnogtTS6dnw==
Message-ID: <e66188a9-15d5-47af-9a85-6b8a6537701b@canonical.com>
Date: Fri, 24 Jan 2025 14:02:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] apparmor: Remove unused variable 'sock' in
 __file_sock_perm()
To: Nathan Chancellor <nathan@kernel.org>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20250120-apparmor-fix-unused-sock-__file_sock_perm-v1-1-8d17bd672c6a@kernel.org>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <20250120-apparmor-fix-unused-sock-__file_sock_perm-v1-1-8d17bd672c6a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/20/25 05:21, Nathan Chancellor wrote:
> When CONFIG_SECURITY_APPARMOR_DEBUG_ASSERTS is disabled, there is a
> warning that sock is unused:
> 
>    security/apparmor/file.c: In function '__file_sock_perm':
>    security/apparmor/file.c:544:24: warning: unused variable 'sock' [-Wunused-variable]
>      544 |         struct socket *sock = (struct socket *) file->private_data;
>          |                        ^~~~
> 
> sock was moved into aa_sock_file_perm(), where the same check is
> present, so remove sock and the assertion from __file_sock_perm() to fix
> the warning.
> 
> Fixes: c05e705812d1 ("apparmor: add fine grained af_unix mediation")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202501190757.myuLxLyL-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

yep, thanks
Acked-by: John Johansen <john.johansen@canonical.com>

I have pulled this into my tree


> ---
>   security/apparmor/file.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/security/apparmor/file.c b/security/apparmor/file.c
> index 85f89814af1e..e3a858649942 100644
> --- a/security/apparmor/file.c
> +++ b/security/apparmor/file.c
> @@ -541,11 +541,8 @@ static int __file_sock_perm(const char *op, const struct cred *subj_cred,
>   			    struct aa_label *flabel, struct file *file,
>   			    u32 request, u32 denied)
>   {
> -	struct socket *sock = (struct socket *) file->private_data;
>   	int error;
>   
> -	AA_BUG(!sock);
> -
>   	/* revalidation due to label out of date. No revocation at this time */
>   	if (!denied && aa_label_is_subset(flabel, label))
>   		return 0;
> 
> ---
> base-commit: e6b087676954e36a7b1ed51249362bb499f8c1c2
> change-id: 20250120-apparmor-fix-unused-sock-__file_sock_perm-0e4627bcefb7
> 
> Best regards,

