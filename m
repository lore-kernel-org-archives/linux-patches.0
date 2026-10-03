Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9562E3B0583;
	Sat,  3 Oct 2026 22:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067217; cv=none; b=dnyWW84ZWCAUhITAb1yXHJrvFucET9rn8eFT1sGjuio5JLYg3CdSEIboGXDdtUT5v3hZCvzhKgini00tbBEiOYehqpJis3bZKiWmGL7KKQUe/IvxGYy/2UvS5jbjF+Dt32N+MeB0HXnqlFXP6KGkKyftAB2v6hV+zuiMRrKTUvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067217; c=relaxed/simple;
	bh=ym6JHc6oYk6Hs9ATwSHnMDKHqHEJMlY8Y4Wc2OoOhjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpB/FO9dsV+/EYe9hF5gP8jwQOoSXl5Z7Z5RRnpJxRtGxOhwzAxGV7s9GTuyRcZOfCS8g2HssnoAMVEkfp+TqvAx7OHWQKOYXQ6JlIGatlZcsT+O2ImhwqZlPaJSAE0C+AROpAGJwaTMkmli0UUsAsu4nL2CObkzRegvXxI4XaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4AXoGx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4AXoGx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F01F0089C;
	Sat,  3 Oct 2026 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791067216;
	bh=YLn69eS/CQianwmmN6z5s54JKd/AomPAJvFD5C8JUdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4AXoGx+8OWtio2iYBGqV8JctbAlFO7sL4HL0Y8akg7i+d74O0op1hjfSb3y9FAI3
	 Mut4rCX5MsFJf31B1TKAVVo2Q1vhriK/vPrSU+m42L4iMPLZ9860qhaoDX61PbkPe2
	 gQMfxU//ILz+HRDeTbj3h0PFURSy87x9AF2JTQC3e4H0MeRGq48K85YPhDrLraCwKV
	 nfyV4HpYJkYqI7i4o+RNlNollNvn2dQbUMbjGyNKH5oE4d0Weu6PaDVP+Sc1kVpY4x
	 VZQ2wYQ9EemjpjVbTXR1wpRtGXrEfVqC6zPpasx5+Zl4Doe53TFMf3aUyRjrxxdvq3
	 fXI0SWW5+5kGA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 118/752] ipmi: si: Use platform_get_irq_optional() to retrieve interrupt
Date: Sat,  3 Oct 2026 18:33:08 -0400
Message-ID: <2026-10-03-1-daily-reply-0027-re-of-irq-of-node-put-followup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d2ea9d9c-d581-491e-bd33-072ac019d977@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152400.732402342@linuxfoundation.org> <d2ea9d9c-d581-491e-bd33-072ac019d977@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 5.15.y should take eb2b4ecf7299ee39ee9cecc4d3f2633aeb10cefb
> ("of/irq: add missing of_node_put() for interrupt parent node") before
> accepting this API conversion; thoughts?

Agreed. The ipmi conversion already shipped in 5.15.222, 6.1.189 and 5.10.271,
so this goes in as a follow-up. Queued for 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
