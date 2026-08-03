Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FC543744A;
	Mon,  3 Aug 2026 20:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785790031; cv=none; b=Kc3fsHxega4/+dkiqVGaUZw8AEsX9knLaSnQWyY3Kp0muzXuFXHM8PuEp8No0S+oLCbIb6GHIy0GUMHccgwonCumHLU/M3Fo5Ywl1TLx/QyJPDHaQIh9EniFioZsgVtjFAkQHpanbnsYHd+6bhx7Q9HNhy/EgHdpAy8cYb3BBaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785790031; c=relaxed/simple;
	bh=NtRI4G++zgdofnVphFzmDP/P6d0GStgoozM2/pxzgdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEtnpcUf7MrABfZjvxCW87BdNwuA0+kN75cGi8QaY4FF0/A9pUSxLyr/nyrgATofOL+aRgYsmRoOL8245nLQHz7IMMZeiRxrSAcygi8GH3MHX1KGFRlD4mSeKZqYsvCm1JZIDx81DDrXsfQXeMxVLlB13yvHlUONdHIoDZX3SFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjrmWomv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjrmWomv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199311F00A3D;
	Mon,  3 Aug 2026 20:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785790030;
	bh=9znsjw4t6667kLfYMDFGAgCoXeHgQcpi30lJtlf9JjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjrmWomv7kBGgiA+V6dSZ2ToyLu9t2sL7rBtjaF/jcoCEdcLbv+I0WI0E8mxH+1yJ
	 X1XQbpaUucI0zOUKQCr21KtQn+OE2YEZpJ0Zhqc76IDXNW7zwfstal2L0VagBpbT1Z
	 P0zv/Q9jpA/zqjJTWc99XW26xsZEyPxoBBfz5FaBmQ8ngb8qiWjxgUgBeC7OrMqX65
	 P3Y0u7R3OczC1yrXnIz3uSVgh1PPHe7IEgZRXA1ipIOwj4puEUb+iMNC8i01MS0q5C
	 uWJRhwZEYAu0X0OiL8OhDbn5C7hLTZAV/3fiJ/DsMwsZeDGW7GacnwN3hKIUf/nSCJ
	 CC9bAUQpx6hWg==
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
Date: Mon,  3 Aug 2026 16:46:58 -0400
Message-ID: <20260803203506.stable-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f793d6a0-d734-4e4e-8b9e-24a633b18554@oracle.com>
References: <f793d6a0-d734-4e4e-8b9e-24a633b18554@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 03, 2026 at 10:39:01AM +0530, Harshit Mogalapalli wrote:
> Thanks again, that plan looks good to me.

Re-queued for 6.12 now.

-- 
Thanks,
Sasha
