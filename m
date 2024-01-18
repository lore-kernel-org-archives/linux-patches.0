Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6224A10;
	Thu, 18 Jan 2024 11:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705578627; cv=none; b=kLzB8GVMerk8X5/Ekfn0NRHgqbjF9axzjkPfl7F5J78KSogxdMTE66gixf0boB4YnlGJqBbCqkwpwlVXq5ro8RARIgewWme84tI98jvQD2Az7NBi1Tdf2VR2VtaaB6DY6Atc2vXb1vvBHmt655N3tvEEpaY6nlpoYZBz8Xx0Wag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705578627; c=relaxed/simple;
	bh=vLmB7wjmjpBIeGjkQ1MkxyXpQfMKXukMybLmX4qpWrQ=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To; b=YQ90ITxRgvQy4mcZiNCGZ8nJ6zIqgV/cmj71/V7FXfTf20NJhZWxrjTkf5W6gatQuM+Db4FlCihomG6CVecrRUEU/iZS7nS5b1mpGNM4NcdmIV0yvM7EQQImKFcoMb0tqtkwKICut9QgFSlAnSaTCwLTgiPhTy0S0mF96XtAJU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCmuR5lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCmuR5lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB16DC433F1;
	Thu, 18 Jan 2024 11:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705578627;
	bh=vLmB7wjmjpBIeGjkQ1MkxyXpQfMKXukMybLmX4qpWrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RCmuR5lDi5+h0BTLOyP1oqihIXMxUu6RGyoU+OKui2jQa82eL8904mz5ZaNXs2gc/
	 ry8R1sRhZAJBlU33I3dC8vk4gPjHR2dCSTbDtT0+Fsb6cUvuY83iD02b7bVHhWqCII
	 1Uuz0qV9Hej9NeQT9N0Xq8m0gyQ4gBGhuXe6J/Fc=
Date: Thu, 18 Jan 2024 12:50:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhuacai@loongson.cn>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 059/150] mips/smp: Call rcutree_report_cpu_starting()
 earlier
Message-ID: <2024011832-buddhist-vividness-b2d6@gregkh>
References: <20240118104320.029537060@linuxfoundation.org>
 <20240118104322.716905144@linuxfoundation.org>
 <6a59dd46.1988.18d1c47eea9.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a59dd46.1988.18d1c47eea9.Coremail.chenhuacai@loongson.cn>

On Thu, Jan 18, 2024 at 07:14:52PM +0800, 陈华才 wrote:
> Hi, Greg,
> 
> As I said before, this patch cannot be backported because rcutree_report_cpu_starting() only exist in 6.7+.

Sorry about that, now dropped from all branches.

Note, your email footer:

> 本邮件及其附件含有龙芯中科的商业秘密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制或散发）本邮件及其附件中的信息。如果您错收本邮件，请您立即电话或邮件通知发件人并删除本邮件。 
> This email and its attachments contain confidential information from Loongson Technology , which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it. 

makes me be forced to ignore and delete this
email, I don't think you want this :(


greg k-h
