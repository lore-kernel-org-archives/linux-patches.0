Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ADB2DEA9B
	for <patches@lists.linux.dev>; Sat,  2 May 2026 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777712897; cv=none; b=J9vzOxw28Cycru1huqvC/3jkmSPvyRvcmHsf4hgxj2bBojBTY1lCXKaMJIg/da0QwlkPAejqsTETxxlLT4bpWH06hGZ0rHMXmpbVzQBEdv9duP+01NkVSz3sJkPPcs+4xxLXOmxMw1/yq2rsa4DPOwvcdJxZmPQBym59hADKyac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777712897; c=relaxed/simple;
	bh=7QbyI59Pdb9sb4X+UFRHx2zieFU5IvzFFR1nTLLWQz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8Uasuzunzpe+E+DnvFAGzqQO8Qvd8x6licDyv+Nw0mvSXJRT/z7T6fov7wYdqp0SUQ5A/VEscDryJFZy70O8/oRu2UAEsaunUHLv2vNViRTgM/6wVjshLORaS7Lnjazh/sTAYt1cnAAU8KijxlwnrGg4T0OR8AeXS30uVfOesk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=ntlPKz5u; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="ntlPKz5u"
Received: from localhost (unknown [95.24.28.48])
	by mail.ispras.ru (Postfix) with ESMTPSA id 9DCC445A1D1D;
	Sat,  2 May 2026 09:08:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 9DCC445A1D1D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1777712884;
	bh=UN/fGF5rtznIEbzrab6e8cF2yiO29rw8CfDIHrKPpiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ntlPKz5uRinzTGQ3s1+sbxR1rW5fxNC7iFgL908YwJ/kn1omowPI+WTiuz4kPHidn
	 az32c28/gMZykFwZVDJf7aVaX46CZunfjPse3lW/hBvn7n7BO1P4LhIBf5yzFiL7ru
	 Pa0nL3aDlWCXfedqovDHCaHHRJ1NZkQD6zJIA8Gs=
Date: Sat, 2 May 2026 12:08:04 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
Message-ID: <20260502120536-82f73a7f6431526a6d4ebcde-pchelkin@ispras>
References: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
 <20260502003658-e04f382bc8ed201a99b573e0-pchelkin@ispras>
 <20260502005417-671675fb5906578c85c3fb4f-pchelkin@ispras>
 <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>
 <20260502011444-849ff2d3f8fe48b07f48d496-pchelkin@ispras>
 <5794c5cd-ff76-428a-830b-6aaff9d36089@kernel.dk>
 <9b00a03b-ff87-4d09-be2a-5865e555bcd6@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b00a03b-ff87-4d09-be2a-5865e555bcd6@kernel.dk>

On Fri, 01. May 17:27, Jens Axboe wrote:
> OK, here's the new set for both 5.10-stable and 5.15-stable. Ran it through the
> usual testing.
> 
> Let's hope we can put this one to bed now :-)

Hope so as well.  Thank you for the updated patches!
