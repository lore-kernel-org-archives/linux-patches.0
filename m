Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9619E7D1;
	Wed, 18 Dec 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520919; cv=none; b=MUPy8nzZ2eHDoGC8u2h6NnkFD513BC26UbM+8UuAjH8OXIqrd7WsWjkCRA/+zqMjyEwWUxu0fDNipd3fqaRgvRC9e6FAW9pJa1Qf5RmUn3kRXA2mwTM1OOJKsBhqwEDxlEoDWT5jgdWrRtxA/KFPzMSWSpQxQq8koYaxXX4ag8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520919; c=relaxed/simple;
	bh=egWM0/6ayZVJQYeGHWdPTf9/ptqp50bI4KAUchlYdQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MKi3HGOoQfC3YTun2bkNVczZNDcYg2negMr/wFOSPXnPjXqsjIrPLDhSlxgDbNWdRBEoLBLlfPFQlvTZRQxwa2ZwL31WXSaWBvDIVj73c7t7ZpTMnPPZmE4SE0lzvWGdc/WvskpFk6/vpHagzna+CjoLyvNdxAileaG6OpiczEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AeOsUIMh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AeOsUIMh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PdD0fWSeks28ckGXeO0kIngmU2Xjq54R0xAD2Pt/q7c=; b=AeOsUIMhdOL5R2FOgXCjv+JYeB
	2Lhi/MUAJOrmI/7US0Zu2CJCX7h2CB94HM9JPegSoc42dWAKpiMs1nBs6tOo5ICMfbi5JI7ad0HRp
	qK9n/3uRZRYDYVnJKnD0U0/544h8mUijj0z8GeF1K9bmbXWcf2LwmGSEXJu5q0qkuYTKBWbknTE7S
	LNx9o2EQ2xiVm0QBdzbaxdE1xtPotxe6Q9g/Sxtdw6/AIZWlQDsS4OvwJpFSBIaMwr5LEHv93C3FR
	yHNoXW4AKvqMhLgquiBCf8ycqCJKeXRnL1Asuy/CLony9gbkkhQpqoNgAsFqFjZdLPKBdRHtm1ppb
	H8CbJzfg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNs7o-0000000GR7y-3jJx;
	Wed, 18 Dec 2024 11:21:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests 0/4] enable bs > ps device testing
Date: Wed, 18 Dec 2024 03:21:49 -0800
Message-ID: <20241218112153.3917518-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

As we move forward with bs > ps block device support, add blktests support
for these devices. This leverages min-io so to also ensure we make the IOs
optimal and make a uniform way to get this min-io from a file or block device.

Luis Chamberlain (4):
  common: add and use min io for fio
  common/xfs: use min io for fs blocksize
  tests: use test device min io to support bs > ps
  nvme/053: provide time extension alternative

 common/fio      |  6 ++++--
 common/rc       | 10 ++++++++++
 common/xfs      |  8 +++++++-
 tests/block/003 |  4 +++-
 tests/block/007 |  3 ++-
 tests/nvme/049  |  5 +++--
 tests/nvme/053  | 11 ++++++-----
 7 files changed, 35 insertions(+), 12 deletions(-)

-- 
2.43.0

