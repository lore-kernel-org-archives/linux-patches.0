Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62550380FD7;
	Sun,  5 Jul 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783259524; cv=none; b=Sm1hBhFLW35hryPuzwGD+hyYeguYiqYjVPbPN7JjsDMtaXkMmm5yUHCsN15WpQ3S0uOc4dFHSG+fJfcUEgSUL/lh5GUg5yVTXiZYHbb6UZbQNT6cIhej3fb7KK0Fe65NHV/iCjIRkIsCoURFJDZztOUlQ7anFP0SaPB95m8LMYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783259524; c=relaxed/simple;
	bh=e7qsdR6RLX28wY6F8j6XHLck42eNjftjSVndAG1rxmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYP4QzO27yw6Ib5cHV0ebnVUTe0OGQMj6xvf1te8a7k4JtAdO7csw96S82SC/wMHZhrOHKXfr4QX4xUo1ukwbBHKZ8UCZIDKDyY6S+HDZBPFYryENzMhk2oFEXBi+1mtkk+HVuforTVX+cQhez8JeznojizB/LWS/Q+HVhKqtVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EY7McWhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EY7McWhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A5E1F000E9;
	Sun,  5 Jul 2026 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783259521;
	bh=ccbtHIIbFEYwquLQXpwo/HS5VUnsG2JeIqciVKxFvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EY7McWhEoKR2PLVQjueptAkt5YPKfVPWBO7dVIo46tbwxRXXfJuDPjDRGjUjZtrrj
	 659DJ5YydIgdwIxqSdMwdcx30qLSKnytAweO4ERQJAE65FC1mgZK3y3vRy7xQOYKIT
	 oGakJQaDXRbhYwAlqME5K+yJJXj2ohwES3r3v/+xuvPEzs4Jm/JOfEJzq6aHjfWlDF
	 bj81JDpX8JuDXxnuPP0ZN4J+wG8JGqkeK2w51nIaCpaTW4bMDt5pa+l5DGvPBXN9Wf
	 51yiqnZPv6+HoL9LSL/EuYhWhPk6FiHBT0JsSxmZ3NfgrOEkrhBvn3PC+lCBM4z8BH
	 gzdGp3bk1nWxQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wentao Guan <guanwentao@uniontech.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 01/96] net/sched: act_pedit: use NLA_POLICY for parsing ex keys
Date: Sun,  5 Jul 2026 09:51:56 -0400
Message-ID: <2026070416-stable-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <418ca29bbbb1190853136331c572470dca803800.camel@decadent.org.uk>
References: <418ca29bbbb1190853136331c572470dca803800.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2026-07-03 at 22:16 +0200, Ben Hutchings wrote:
> No objection, but this should also be applied to 5.15 and 6.1.

Queued for 5.15 and 6.1, thanks.

-- 
Thanks,
Sasha
