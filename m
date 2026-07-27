Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF43D6477;
	Mon, 27 Jul 2026 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785190800; cv=none; b=K/RTpO9O9O80KD4ShbGgBOfRG9+dasjhLwtJ1mbrEhhgXDK/9Fattb7j0bObCKGf3epfib14ZaUVciA7tXQw/I9TikEXbxof3RxmBspiRjbmJd7LZsCIyXYQ7ryQa6n5awnis+foMH0Z/j0zWcx+DdtzZeIi6ss7DPTw++5GGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785190800; c=relaxed/simple;
	bh=AvO4vstQDJDo+pj6UvD5emt07oDLy034uBFecG6FlJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipatXVdwP4VfrFiZvcbTUARWkeIQQX7RC9NgDUOE+Q6LCvBxc8E9rljHnp/oTFrKZ1YjaSKMTj9qB1lL06uPwaSntYWcmzEc362dcRBjy98va0WrYooWuIqUQZaJsZVrEm9fk9NyiqeW+59oI9J0Lwi/wCMQoPUZ68Qr/6eDDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2jUGEU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2jUGEU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5661F000E9;
	Mon, 27 Jul 2026 22:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785190795;
	bh=DMYpqrh66kHFPew/+HTM9w2lz32UEwCjJx0aqTQCH60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2jUGEU7HUP4axLRBijs/ink+6MLSpqKUNbF7ehZ6Rbw+MF3HAMF/0X6hOmUwntuc
	 4Gx22OASvx71iZ/WuUy/FpCB5iB3G840iLbGOD22xrprDzyTE2MepYOt3aEpgzM320
	 8Hw2EfccigGFxOqdP3e1kSrEeFoUDCxeEP9G18xBFrLdyV8vSfilEE+Qk7lvYVR0N1
	 2hpUf84pkaJgHARfQw0gr9H82nvYBP85UlXlfLOiXFgw+HkK3HM/e8AFBdHV0qEzaa
	 B4emi9oZOaiZCzaJwuC/9NG2I1UJ1DThElUaKikPod+sXju1++cPTblwZqzcmw2dax
	 7k0bczFbeT8nA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0588/1276] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Mon, 27 Jul 2026 18:19:41 -0400
Message-ID: <20260727202413.stable-0008@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <302daaf1-f83a-41fa-8306-f90769c687cd@oracle.com>
References: <302daaf1-f83a-41fa-8306-f90769c687cd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Jul 26, 2026 at 08:55:05PM +0530, Harshit Mogalapalli wrote:
>So are we considering backporting the prereq in future releases ?
>
>Asking this because panic_on_warn() is set in few systems probably.

I had another look, and I don't want to open-code it myself.

Miquel, Ivan: could you send an adapted [PATCH 5.10/5.15/6.1/6.6/6.12] of
the a2e06b4bef20 + 0569f67ed6a7 pair? That would restore parity with 7.1
and 6.18, where both went in cleanly, and I'd rather take that from you
than guess at the adaptation here.

-- 
Thanks,
Sasha
