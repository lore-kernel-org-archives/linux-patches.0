Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071631352B;
	Fri, 18 Sep 2026 00:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692771; cv=none; b=Df00ZR9PMv1MJdpfLD5F2YGPrq93nICcOF/+9U34uqPIQ1AHwsYkify1CMJzpssnIMxrSWuMyUDW0uzEGH39ISYDuj6xjdzoIdQl+2mlbMYhg4iA1ADIzeQJgAjOkSKqVWkXiPLsI19rFxg8/BtjoasmvBz19drd6ff+B+JV7G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692771; c=relaxed/simple;
	bh=SroFQVMmqUU2n+gt1KMKRBsuVPuMLZqY/vfgkHyCO88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeNplYO2yKsl/hLnqidl2OTaXeVyBL42dOvkAwFiqrXuerdv007hcBjbB/zS90Wd2BhqAapr5jxXDdDO3KCPEiFySMvUlIU78kjGFqq6yLTXT7j8k2uQcxNy4EVs7uSfxojaAXWfWC63b9s+flMjKUvCUqorlMRrTFsWHlyMB+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtlT1Ja3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtlT1Ja3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FBB1F000FF;
	Fri, 18 Sep 2026 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692770;
	bh=KgjDBX0U4EFf/DojCPBQLSfjWOIgve9X5vdwNkyakrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtlT1Ja3VPNOlA1ymkqyFrvSuBpTM0j8D/cqWfRkBtL2noEQdFRJK7N+p2n9QgzoO
	 baMFx4BzFoJWZIGhq8ojcbzZ1QTz+lwCgsqww9iVaIvuxhqb/k2uM//z9bgozrQBEz
	 OUSDpUtB9WUaCzpHCH7sfpbWfj5osNZrvNXuykuMiwWajRj3Xk5s6A+oYyCjXFXQKc
	 gWiTvaGb3Iqq8Z/ks5z5wdRtGUcQ10+FgtpX2ILZpwDiwqPOrOjwhIomORBivU/oMB
	 BEaNw4lzYh4LmRUxNoFruhFebiXUMcC6vx1xCy1WSNaDRSNzJJXi4VkEpOFml99QsM
	 P1/R+cRzuEq+g==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.12 1160/1376] hwmon: (emc1403) Rely on subsystem locking
Date: Thu, 17 Sep 2026 20:52:28 -0400
Message-ID: <2026-09-17-daily-reply-0001-hwmon-emc1403-revert@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
References: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Guess I didn't pay close enough attention. Neither this patch nor similar patches
> nor 3ad2a7b9b15d507 were bug fixes and should not be / have been backported,
> not even as prerequisites of other patches.

Both are reverted now, on 6.12 and on 6.6: the locking change and the
hysteresis fix that was stacked on top of it. 6.6 carried the identical
pair, so it got the same treatment.

Reverting the hysteresis change also re-adds the temp*_min_hyst
attributes on those two trees.

-- 
Thanks,
Sasha
