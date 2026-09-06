Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D128A353A98;
	Sun,  6 Sep 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706959; cv=none; b=ArbTuHUaY+bAsLfEwUrVRl4hQZBFlF4yAlwChnxv/oE5aE/XjM4cCECIwVA4wxNsxq31YZUbqaxiuVLvVMqUi/ezmC/dFBeN1xDiAgh0kgMH9xniMRX29GtaMPE19MCDTuG7C+GvEowMubcfyncbBLBS6IJtbxNFFCb98+6RrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706959; c=relaxed/simple;
	bh=D1LMb8GJasf0UMiiOhoGQ12tDf7gfuZyJzrdQ8LIfxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvLohcinMQmsLw4XYz1h6bi6zLJ4Ukp+W4tB3Zle32dqGq+SMziAeXZdtRplVGBgIH3qAQiyFePJVjDTc9CUgFBPjtv68A1Tn1VDHNdAdyVr5LcrFIvJTpHDUat0Bocbm6ElbPgPsOtzeaHnOTWrtIoWElJlT2u2ojwBNQvQc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jphYLjQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jphYLjQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53F91F00A3A;
	Sun,  6 Sep 2026 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706958;
	bh=eDJDazhi51A9OYXyQLhSbYNrg/f1I4ny2ea9ZbAjnmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jphYLjQEHuhHE2nBAZ0Al450aHLwqHky+2iM+FpAoDI/PlRlg2JfBYNCJqlmOHMGP
	 q3BF45RXS9a1nfLEPwT+WzZJvUUFxYfECrvfKwmQ/ppQNemhxov7Ho7d5YA+zBTE6V
	 kjgp1GVzSlZbphOhexf+F5qJtoNCrNp0iGQVgj5ALfkyuXG2JWF3D4r/8oGeRVMDb3
	 8jpWMieAngdq2lHJ/jnX4CyFuSklXwiaQuodI1QltNx/0bf8BJcwiDmRZETxmiCPyv
	 +zceSHI+1h5Ye/Y5GrHxdtRM8P8HBAZGZDy5/0zUHFIdLlrsnWwVOd9H3qa73uzYDH
	 b1YZRRI2UljIA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 381/403] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Sun,  6 Sep 2026 11:02:29 -0400
Message-ID: <20260906181000.reply6-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1a4a92b4-b87a-4654-8d73-05344415069f@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045743.458413377@linuxfoundation.org> <1a4a92b4-b87a-4654-8d73-05344415069f@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream avoids this with prerequisite commit: 456f832e5fc2. Maybe we
> should drop this patch without prerequisites.

Dropped from all seven queues. Upstream's own commit carries "Cc:
stable@vger.kernel.org # requires \"i3c: master: Fix recursive locking
during device registration\"" (456f832e5fc2), and that prerequisite
isn't queued anywhere - so it needs to go until both land together.
Thanks for catching it.

-- 
Thanks,
Sasha
