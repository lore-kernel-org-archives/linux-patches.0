Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD771EEE6;
	Sun, 11 Jan 2026 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768134278; cv=none; b=Zrf7NKswgfQY/SZxoLwaIZ5H5jsDgergUCc75KqMbs6bAKgXvcvtSB5hUIxTS7JzX6HRaaSqWJXJarTzEe3NQrZMWOVjnG2SYK/mAOuFeisSkn7nmwSxt4KnPvRUEpaIKbBhFMUqclgs+NxzMzKfHlSoQiebdW5eTG4FRuj80oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768134278; c=relaxed/simple;
	bh=PcQZEqEKFa4VHxbvEoplIjPp7Qgs4VNTM9pTCnRw7U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5Xz4nG0PktwhHnhDkN0IGWQF2Mmbo6XFADPUGwIisRFlpXFB91HkJtcAD6u5zqshXMj/zcFVw59L750soml7HrBS5JURp5MXKqVMmgPPuFxZiMdMNOYhXT/jzGUwkhRtr1FS7GFiCjOQbQBsw8WIXXdDoZAcNKdNqmE5hYdPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKM57ZCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKM57ZCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDADC4CEF7;
	Sun, 11 Jan 2026 12:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768134278;
	bh=PcQZEqEKFa4VHxbvEoplIjPp7Qgs4VNTM9pTCnRw7U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKM57ZCNR2ax/pLoBnahumU1q9ZIWAw0TLLfOnBBnk+DsQKv6nEb+oXsLORIaSOfq
	 NVnpWPk9HygdFZshBNTxMpwt+3BbVTfdmV20k39qWyjMIr1meo2qOJ26AcQrmgGbF5
	 cuDEqhSpDIS5hXovom7aPcZDImgGq8M4pyrv0C2o=
Date: Sun, 11 Jan 2026 13:24:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com,
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com,
	bradynorander@gmail.com
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
Message-ID: <2026011119-stadium-trilogy-22ac@gregkh>
References: <20251215004145.2760442-1-sashal@kernel.org>
 <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
 <aV5Ap8TgMEDLucWR@laps>
 <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>

On Sun, Jan 11, 2026 at 03:04:47PM +0300, Askar Safin wrote:
> On Wed, Jan 7, 2026 at 2:16 PM Sasha Levin <sashal@kernel.org> wrote:
> > >Please, backport this to 82d9d54a6c0e .
> > >82d9d54a6c0e is commit, which introduced "intel-dsp-config.c".
> >
> > Looks like that commit is already in all trees.
> 
> You mean that 82d9d54a6c0e is in all trees? Okay, then,
> please, backport 161a0c617ab172bbcda7ce61803addeb2124dbff
> to all trees.

Why?  I see no context here :(
