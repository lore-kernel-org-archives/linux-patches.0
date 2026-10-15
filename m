Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE833993;
	Thu, 15 Oct 2026 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022929; cv=none; b=WMQzVDZ2tkMNeYw0NUQFIPhNCQdaBYezVQHfErEfczpYr12abDg7r9GkveuKgZVFNBqjS+z3rHAKPhjK9N+3a9+nRxd/El5APMJHxIKdByacHxqpAdIy8qrdMnUphAwFdZbb8XZThXE057dDe4Bu9kxAOT9MYmExTfEk+F9Hc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022929; c=relaxed/simple;
	bh=TAozqHxSBkaONckPv8sYxH+ATozNAHYnMWUjnJvhE54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMpxJkX5i4WLOh5/WLbFlS7r/nGP5OTCmkNshvs3GQkrW1mAz5RF9QFa6xkgzHtyFXGrjwEtjlZUoy3M2rp5Nq0pyPBh/Qhzcs+J0FAV6a5jOBM0/uHItzjysrgZRJQ6UD4ttT/wRdR0RCyGiVbMLkctiGcgeGXRvggK752gjjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uavk5nzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uavk5nzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B641F000C4;
	Thu, 15 Oct 2026 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022928;
	bh=G1xROW0TRmBW6lJJpsJiPoRy9khRx28gvo8GrR0lZak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uavk5nzw4pEVxFq9qt6S5afM4IIiv5J0g5uE/3MsAjDZTjeh32g/1XQEUl2r99uG2
	 IQtlc7nzFUm7+SBQ3RPlDPSW0+nj6dx5iPrGUrGSHJTrB5UUuqBVrGZryAqaYiIaaG
	 6TTGArjLnV5KmmXcl0mT8DmhrhUQfo7aMY33FbdU2gwuePAFycz2125Wc3DzwlycTb
	 J5cL9Dpd0c5YQ6SZta4ErJDHux1l9ApwOs/T81noawlcLtlKc2GyPHIpshaey+87e8
	 yTHxMnHG3b2fxTj4GIF5WnIH9dXTZnjFMCzvhgAeLIj7knSRMPuCobqstMSxk34V8X
	 ukcHLQ0jm1uTQ==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.12 406/497] net: team: free skb when broadcast has no txable port
Date: Wed, 14 Oct 2026 20:08:36 -0400
Message-ID: <5db15abc582e493f833b2a2b@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0d7c5b89-87e5-4bcc-bb6f-ed44065956fe@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112917.527762800@linuxfoundation.org> <0d7c5b89-87e5-4bcc-bb6f-ed44065956fe@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> A lower-device drop consumes the skb regardless of its return value.
> Downstream then falls back to bc_transmit(); with no txable port,
> the new dev_kfree_skb_any(skb) releases the consumed skb again.

Dropped from the 6.12, 6.6, 6.1, 5.15 and 5.10 queues, since b7454f1940c5
("net: team: stop reusing skb after queue override") is not queued there.

-- 
Thanks,
Sasha
