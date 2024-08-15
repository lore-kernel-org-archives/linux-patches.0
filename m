Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAC71AC422;
	Thu, 15 Aug 2024 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733076; cv=none; b=fzP7NFm56i7UGp/7MYg7sWzvbPgUwFp2aPo9z/8E0vDBZgX1dqMhw3VOVNFvgV2qLD4EPrhDicERD88rEr4Wprbc995fBN1p1hLG+FV8pSpaXcWVkAWIEqVCM4DBFZiWxHvKTkcdkYAWBEMPC2K6oGikXNPh1T/AHsdWChOIFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733076; c=relaxed/simple;
	bh=g7GghDCTRuhCyj93BpE5UAZolJlguwwEmFGoEOpfQ9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvuwJjbQX0vFXKV1+9R2XdACJEDveQq1EvsPcG8AJCVK34qKOQ+nfOBvIKMGPXosfrXZ7SGG3qLEx3gtAGq2Fv/CHBfKzXXFPhuWjv6cCV4EWEIB1DyKk+ulxHpQJ/EgtNrT31uKjPS6qlGN6jdwZuf9D6rLgyI2RahyexBlFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAYDY+gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAYDY+gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0CEC32786;
	Thu, 15 Aug 2024 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733076;
	bh=g7GghDCTRuhCyj93BpE5UAZolJlguwwEmFGoEOpfQ9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAYDY+gNtCxWOhoTxM4RHtu9WUIK/R8ks7AfVurEakiUA21cSCQvd483wNz5wwguU
	 FA2FmtORBti2XlPJXF3JgUXWrJFTxLXoQLiLRCiNrDpKERkeaTATCQl4bBXN161coh
	 H1+93fGyWmJM4Cr+lz35vk1qD0ix+NpePJqdEP2c=
Date: Thu, 15 Aug 2024 16:19:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+411debe54d318eaed386@syzkaller.appspotmail.com,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 29/67] jfs: fix shift-out-of-bounds in dbJoin
Message-ID: <2024081547-defrost-basin-8be3@gregkh>
References: <20240815131838.311442229@linuxfoundation.org>
 <20240815131839.446390501@linuxfoundation.org>
 <36b8c214-3039-4fce-b27e-3558a78cfda2@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36b8c214-3039-4fce-b27e-3558a78cfda2@oracle.com>

On Thu, Aug 15, 2024 at 09:13:42AM -0500, Dave Kleikamp wrote:
> On 8/15/24 8:25AM, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Please do not include this patch and its revert (62/67). This was not a good
> fix.

I added both as our scripts keep picking this up and it's best to have a
"patch and then revert" in the stable tree so that people don't keep
trying to apply it over time.

thanks,

greg k-h
