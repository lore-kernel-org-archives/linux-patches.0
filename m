Received: from mail.codeweavers.com (mail.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389DD214222
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744228319; cv=none; b=GbRoDBAHOBqP66jgsdbFG7daniQOc8zLcy41aHH4UB1RXkshnxUa3symUHATVDQDgoUIdxx9KpIcW9KZ1OCOJoTyhd8sG1HyOLpWcikj8p2KiQV6wdExSCu+gtB+95DTuPNZOwfvApXDqI2YSN69DOVzQfWwEItRyFgwh7MifPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744228319; c=relaxed/simple;
	bh=srZdtUbsj25zJcg+sv4ihyOmvUqVsx4nLRDCCO0jmGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAjFTc0BlRf6y6p3F30v/nJgnBUAFiQV+kNy59jFxPWGS3r9GfrPH7yaD3k0yFEoGVRzhVyiiuzLsCKh+aue2lsSN96YldM1aIUxxnK9UCeLQQyePkH9zoZBn0uBBLhvZfXWYtyzvA8RiDSelgKIvXgm8x7m04mTUQuvnX4nsNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=codeweavers.com header.i=@codeweavers.com header.b=q95V2898; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeweavers.com header.i=@codeweavers.com header.b="q95V2898"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codeweavers.com; s=s1; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ax8ThMEhAIWuIpvRx/5WF5Oe5jPEwk5qG3N0T3I0ZUQ=; b=q95V2898MEstaW/8b5K7u6466b
	8NiXDrqRRlLZkeS4sEoPZau+QiS7Vhu0SdgiEsqR4ALVyQH53Iizg0sHA2HkwfTWxqW6v5OQq375c
	xjp9qrwxYJXiMx1KVggPNtAKnc5CFI2HNwi8AEKWUFqQ7yzA7B6obVKSiJk2wRHGUwq2rQRwrjHYx
	o5qrpjpAebwfvp8VM7FMNGp6ffwJ1AG0228/zmaoMt66rEEmlcjudPj6TzGufPgGICx6xRQbZGo68
	dbRgacWv8STAdmoOVlvqsijR/C1xqMboDwPSNLUJMvDh9UM5fpiwdtsKmZd653jnfKH1tzUOnWh88
	g4i1Jf8Q==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.localnet)
	by mail.codeweavers.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1u2bDO-00F8QV-1d;
	Wed, 09 Apr 2025 14:36:02 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev,
 Mike Lothian <mike@fireburn.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 257/423] ntsync: Set the permissions to be 0666
Date: Wed, 09 Apr 2025 14:36:02 -0500
Message-ID: <13024143.O9o76ZdvQC@camazotz>
In-Reply-To: <20250408104851.729914678@linuxfoundation.org>
References:
 <20250408104845.675475678@linuxfoundation.org>
 <20250408104851.729914678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Tuesday, 8 April 2025 05:49:43 CDT Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mike Lothian <mike@fireburn.co.uk>
> 
> [ Upstream commit fa2e55811ae25020a5e9b23a8932e67e6d6261a4 ]
> 
> This allows ntsync to be usuable by non-root processes out of the box

I would be inclined to drop this from 6.12 and 6.13, since ntsync isn't actually functional in those versions. Leaving the file unaccessible by default means that userspace doesn't have to perform extra checks to make sure that things actually work.


