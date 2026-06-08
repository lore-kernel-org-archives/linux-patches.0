Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163582E11C7;
	Mon,  8 Jun 2026 00:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780878895; cv=none; b=DWLwlN3YPEQovHfQbtbTG5z8zf5vgDylR7ptTLIyAxqOl96j9brgparAalFLDBbitUZVmkqV6VP+pf+43Yx5dP5QgfpkA+P4iPLWc4eVtmnKbxGNd2GLT0QBjy8bXxbrE7w44RyN+San3TN0AziNcLQBjVKX4TJnpvYvzdU0VTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780878895; c=relaxed/simple;
	bh=eyS8IE4UX/rqahBlzU9wjQ8heie46agiTatI7322cPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV8qrmQu6v+PpIw7Y57oCDrh3YbtNX5sh0zCdo5P+TucPhG4x0m90FX75sKO98B66V9SgFN4DeYnc+uAe+m5yvmbqZbl356mV6trtpm/9tc+LDMToIGbumUER2MqCAf9rR3WKbAqjZ6lVu3y382wiSCu2t+cG0NCHQmrLJWany0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TG5/vlrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG5/vlrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BBE1F00893;
	Mon,  8 Jun 2026 00:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780878894;
	bh=eyS8IE4UX/rqahBlzU9wjQ8heie46agiTatI7322cPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TG5/vlrgUaRMDAt6rFlygpFpmKpQr/0Uc0p5i301blQ1PVkLNd2/Td1JSYSgES6Yx
	 JhqJxwzGY9l1nVPXNgakfsp4kmMiRbBJViu2b5ox+gg6vodLksCOZCPWGsTcwKfnnY
	 R4mlFU0+hX6+ZguNcteSmcyif7hRUY1LKnbBoJDIoVxvqNAk4NgOVqAx77/y3VbKLJ
	 EBROoGpg4YTYSnubKw0EnhokUyYd91y4owZAjxmC+890CpNMKPd5LBq+EMJQhp3YB4
	 iWsb3Ydv1rjn0ZQEwCTpcNIb2Bl1rroqoRZ3H33v4aA9en6xV5ejcOuze5r6gywI66
	 1XxpyUqI0zk1g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.0 243/332] gpib: cb7210: Fix region leak when request_irq fails
Date: Sun,  7 Jun 2026 20:34:48 -0400
Message-ID: <20260607202000.rc-0004-gpib@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <148e4311-5d45-4c89-b93d-898282282f7b@kernel.org>
References: <20260607095728.031258202@linuxfoundation.org> <20260607095736.972391850@linuxfoundation.org> <148e4311-5d45-4c89-b93d-898282282f7b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This was reverted by 05d5d79440c2cc0784f91b61f2012753e66be472.

Dropped from the 7.0 and 6.18 queues, thanks.

--
Thanks,
Sasha
