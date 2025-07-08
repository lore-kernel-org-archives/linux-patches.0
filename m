Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B203C01
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.172.96.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007599; cv=none; b=WQKhi2MlhU2eJeDRa4Yx59YllaoqkZc6Qf9eA538RVNnTAv3dTk3hiCun1s7uvF1Z8Kq1HAmEgafovIvBLcsuimsDmJDgm30WUCdy84FCKAwCtQ8zYYiY6H+2Ep1iZcm3tEdUdM6amLgrNJPEG7bupwUJOy60ZEqsY7U+t5fdAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007599; c=relaxed/simple;
	bh=OmBmPp7dnyJhHvmfusM1u8JnCW7ZfYNHJ8zqzo/YFdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRqlW7iTIdTyE97rd0aIs6zLBSFOxwIstkkxC11+8/MF/UgcPwD9HObiR5juzYLnfB4n+UlVJHts3DiPnJA4LMnoPH7Yj7iweyfZ0onFQaEld5hsyOB34K+ZGHZdQKigVXQAtEW7LUdwD2MHAGe7B/OJYvgg7CiVAp7+gTH8VMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; arc=none smtp.client-ip=163.172.96.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Received: (from willy@localhost)
	by pcw.home.local (8.15.2/8.15.2/Submit) id 568Kk7On005652;
	Tue, 8 Jul 2025 22:46:07 +0200
Date: Tue, 8 Jul 2025 22:46:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sasha Levin <sashal@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, patches@lists.linux.dev,
        stable@vger.kernel.org, Mario Limonciello <mario.limonciello@amd.com>,
        Nat Wittstock <nat@fardog.io>, Lucian Langa <lucilanga@7pot.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, rafael@kernel.org,
        len.brown@intel.com, linux-pm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.15 6/8] PM: Restrict swap use to later in the
 suspend sequence
Message-ID: <20250708204607.GA5648@1wt.eu>
References: <20250708000215.793090-1-sashal@kernel.org>
 <20250708000215.793090-6-sashal@kernel.org>
 <87ms9esclp.fsf@email.froward.int.ebiederm.org>
 <aG2AcbhWmFwaHT6C@lappy>
 <aG2BjYoCUYUaLGsJ@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG2BjYoCUYUaLGsJ@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 08, 2025 at 10:37:33PM +0200, Pavel Machek wrote:
> On Tue 2025-07-08 16:32:49, Sasha Levin wrote:
> > I've gone ahead and added you to the list of people who AUTOSEL will
> > skip, so no need to worry about wasting your time here.
> 
> Can you read?
> 
> Your stupid robot is sending junk to the list. And you simply
> blacklist people who complain? Resulting in more junk in autosel?

No, he said autosel will now skip patches from you, not ignore your
complaint. So eventually only those who are fine with autosel's job
will have their patches selected and the other ones not. This will
result in less patches there.

Willy
