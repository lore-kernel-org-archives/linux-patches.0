Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637DB242D9B;
	Mon, 31 Aug 2026 01:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140379; cv=none; b=D34FSTFgqMef+ox/1dx8qdJLkKjogxKO9ZJz0NRiSGJqozo5TEH4OykBZLjRxax/+pHQyXiBvTUxyvh9bPoxF/pDH7HMRq3fX6Pjjx8o6TH6l3pLaqrRyQw72lq/57xAz5327kBnqjXqp6Ea5cREsi/MN6wiskzKZKPvNjfsEE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140379; c=relaxed/simple;
	bh=MEXI+OmydpnUxwYeDV61fliBPocCjydpUam0heOI5+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXs+99hXosM22cHK09C5oZZ6La/lIN4jhZWIhsx0EAaC/QuZRPF0u7IENlhBZZOq0pkkSzmqHnvN3fgwIIpKVP7AFfYuq/CMb0ZlYTCD+h+43cQzY2VN6kA17CKVOc8Wdie+ZKjSnPWa7csXJpwVofJMiRNDOh/v7pFIPiQSLng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0mJVRC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0mJVRC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9041F00A3F;
	Mon, 31 Aug 2026 01:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140378;
	bh=Jo/K8BEpKfxTRf+rY37qmIL2asnFb0dlUgRZHHwynJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0mJVRC8+yMzgyhAcIGz/OQmPCUSJ9mrjdu7mAlLEZ3AP5CoC1k60efAjtg9zKHdt
	 OKnmKT6/tEjNjTz8S8xATZ11eBvQRVyG67sSZwzYaruwaQ8Rslm4owNUYFSfDvuwjx
	 ed8u/NsgUTJhuFhreR6VB0vPn5qmAcQm/xfwgg956yLYt00YDg59hsUW7Z1jcLAOt5
	 rYyPeLR3FRryYl8q4KSd84/kxfqkXbx8YRCEv9SHVhTMXB1oLKH6q6DCBbkNjevMLU
	 sZ3cJkqrg9RjaBdFs6VDS98kuSrYr/z+/F97i4HBvvYz/hFNirULi1kL0hmd0BGmrR
	 86EeXgrml7+mQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 050/456] sched/vtime: Get rid of generic vtime_task_switch() implementation
Date: Sun, 30 Aug 2026 21:39:19 -0400
Message-ID: <20260830195800.0014-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6e859ea9-468f-47d3-b462-86c1b629b6e0@oracle.com>
References: <6e859ea9-468f-47d3-b462-86c1b629b6e0@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Maybe we don't worry about IA-64 anymore? So nothing todo?

Right, but CONFIG_VIRT_CPU_ACCOUNTING_NATIVE isn't set by any ia64
defconfig, and ia64 was removed upstream in v6.7. Leaving 5.15.y and
6.6.y as they are.

-- 
Thanks,
Sasha
