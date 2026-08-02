Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342A28688C;
	Sun,  2 Aug 2026 03:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785640562; cv=none; b=AiRcXi3xStB2io2Ks2/XKhBeWiOwM327ALnu/DMbXXEzvMJlUbXsCBjclOZ7t0Ipn4rNP63+2X8eTCOXA/hcnogTQ6bsk5ZttBP+qMYiQV4Dg361I7FLgS0qV0m1YXAa80SlUEJEst12K1SLUhdcDCmhY/SLTYueiLwRqiqqx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785640562; c=relaxed/simple;
	bh=WBowxO9f7Fong14dM5OMVx667BoJJMGpy8xOUgUpw8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjGl/Tbsif6TACfNduvvYystPknL6g5ts1b2ijoimwKYpA5tfK18KlTQPkxYQgAF97BBd9kn435+GswQNsMoHqSPSFVkbD0SG9kcikC/INs038zpfORsFhMlMumpxj777AvI7BsWC9aOXPa4wY7RdTZSe3bNTZxiJ3tmX4QG538=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUI9MXK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUI9MXK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BCB1F00ACF;
	Sun,  2 Aug 2026 03:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785640559;
	bh=b3voyMfOmDAm8y/i82HUiBmXOAEl8a5WhzA/yD6LJB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUI9MXK3pDHLu/SfB4cxvpv08S+5VdLTaAsEM2ak4rZaqNYBQFSthdgdeoij8lSSW
	 DAjnU9WzDrPyYIPtQnYB/Cox/Mt8LJyUaYezocQXRgwG9/CYhPfH0F1ZXVSfrJI+ax
	 purYZww6/+jYuGcRaezJe/MAi7XZ6TSNIp0C28Qbk5hflucRttCusBdemPK65/rDlQ
	 xagGX5Zo83Ovsz+HyNkdY80L+nAZjctVUpOeKkcMYhv7dJMDGdJNqGQHZMTJmqrTDT
	 G+agcccjcpwBs16XD89paxCtfLRM5Kt2bcnhqnkVO16ThHknx40391GvGba00Qbhml
	 hgrKe840uORKQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 541/602] bpf: Refactor {acquire,release}_reference_state
Date: Sat,  1 Aug 2026 23:15:52 -0400
Message-ID: <20260802030151.769b0f1c8214@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <129ad991-e9fa-4f6b-bc1a-a1d78eff6145@oracle.com>
References: <20260730141435.976815864@linuxfoundation.org> <20260730141447.394161782@linuxfoundation.org> <129ad991-e9fa-4f6b-bc1a-a1d78eff6145@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Aug 01, 2026 at 11:34:53PM +0530, Harshit Mogalapalli wrote:
>So 769b0f1c8214 is recorded as present although its semantics are
>absent, while 201b62ccc831 is split across two differently attributed
>commits.

Confirmed, and thanks for chasing this down - your reading of it is
correct.

>Maybe we could be replacing 76344b7301ce plus 4ee2d0ce3e82 with one
>correctly attributed adapted backport of 201b62ccc831 before
>6261a33d665b.

For now I've dropped all three from the 6.12 queue:

  - bpf: Refactor {acquire,release}_reference_state (769b0f1c8214)
  - bpf: Refactor check_ctx_access() (201b62ccc831)
  - bpf: Reset register bounds before narrowing retval range in
    check_mem_access() (5e0b273e0a62)

I'll requeue the fix next cycle with a corrected dependency set.

-- 
Thanks,
Sasha
