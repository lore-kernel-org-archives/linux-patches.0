Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167B01FC8;
	Fri, 28 Nov 2025 05:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764309304; cv=none; b=lRRp6vwBxpoEMLjmBr4uExI+5N9SkT2QuSdmq5a3BQiZJiAgMRKLpfoQvhZVcycmj6YIsTKDS6vPlp4u5B9/qCbY7ZlhHmRV1JQLAbW94mYfG+CO70cTm4wONR3p272PFjWF/cE28uQy5rU5w5EyqFrTY5qzY/gdL3VOEhwf8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764309304; c=relaxed/simple;
	bh=YuGOiUhAAEVcesrwCXxu9qmyQXGRUIMxQreWPlnESP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJ6aX58AnBI+FFur2ag+OCGZS5jYsd0qzAE3TohqofYRl2dny3eNdGflD6R1ZBxJ1uMovUwGcAi6r7JrLwrlw2wsPwCNz/M1/z205sUJ5yBjZNGCXzZm4cgfrlPwF7QZCYi1URcv3q6Q98Pgup/uFXrPij6St+HAbqVjyh97Mxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S21GwaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S21GwaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379DC4CEF1;
	Fri, 28 Nov 2025 05:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764309301;
	bh=YuGOiUhAAEVcesrwCXxu9qmyQXGRUIMxQreWPlnESP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2S21GwaHQTsk+Hd8zm0CF7SnenxeiOttOzLNNQOLcesGl9r1TSb0+RA+OZZtE6eU0
	 esgn2u2MkdEN/W0o5aC0ipwvLLQ7gk3E92nUPqs4KQGkQqtBP28Cy4R2pHmX3un8AS
	 +1In2RuBTHYmEMWEGKxO91MJ+q+Hf2M3hDQ6bByM=
Date: Fri, 28 Nov 2025 06:54:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhuacai@loongson.cn>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 6.17 051/175] LoongArch: Dont panic if no valid cache
 info for PCI
Message-ID: <2025112837-cardiac-moonlit-beee@gregkh>
References: <20251127144042.945669935@linuxfoundation.org>
 <20251127144044.829793395@linuxfoundation.org>
 <7d60571e.2cac5.19ac84bf531.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d60571e.2cac5.19ac84bf531.Coremail.chenhuacai@loongson.cn>

On Fri, Nov 28, 2025 at 10:30:12AM +0800, 陈华才 wrote:
> Hi,Greg,
> 
> 
> > -----原始邮件-----
> > 发件人: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > 发送时间:2025-11-27 22:45:04 (星期四)
> > 收件人: stable@vger.kernel.org
> > 抄送: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, patches@lists.linux.dev, "Jiaxun Yang" <jiaxun.yang@flygoat.com>, "Huacai Chen" <chenhuacai@loongson.cn>
> > 主题: [PATCH 6.17 051/175] LoongArch: Dont panic if no valid cache info for PCI
> Why Don't became Dont when backport this patch to stable branchs?

Odd, I do not know.

> 本邮件及其附件含有龙芯中科的商业秘密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制或散发）本邮件及其附件中的信息。如果您错收本邮件，请您立即电话或邮件通知发件人并删除本邮件。 
> This email and its attachments contain confidential information from Loongson Technology , which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it. 

Oops, now deleted!

greg k-h
