Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621913B27C2;
	Wed, 27 May 2026 19:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911363; cv=none; b=uc187ijm/H3R/UoXtZd0kyMv//a9p4VCehEB3J6HuoPXSAkeQ6QQt6IKFSPA7qZ+fqCrm4Xo8x5V2BFs0IuiQUJi22oN87opQ0j3Td3vnw503r3bfjX13YPWvvwc4Qq9i3fqPe4RvVzOYlEprJzlg0bxYzPO3xpz9jV30gEiRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911363; c=relaxed/simple;
	bh=1GFfPNR5K34gDyccJH/hSIhUrEjCFbGPHELgs2rqU44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmGVE4VKx239ltTGqsrpy7vQQaxeat2/n8wybfRPmhZt3EcHu10bE6vBhx7BpV2JEW5wsT9q2pk91Kv0287vPBwVyRv8SKmYPLHOMXYE1YR/vocDCJtVMafhWQUuTF4TSrSdZp65osGoXG6HJXWaIvoM/2c6e2mQ+LsR6lciYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ci8UlVH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ci8UlVH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1BE1F00A3D;
	Wed, 27 May 2026 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779911362;
	bh=1GFfPNR5K34gDyccJH/hSIhUrEjCFbGPHELgs2rqU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ci8UlVH0D8ctwOmqPf9iErVsJtcmpmp2+xkGub1np0wYMb1DvtNluZl3+XMNix82E
	 29FBzqixqwdpGleXJLfCNHnQREZUJSVtPTYRn1WmNBBOjXQ3LLTt4u/vpvdqOGeWCy
	 jJbuJMV7oBijpBXro2k9aEEmvrgJXmveTivEjuJEApht6nxP1WXD54IJS1X3wu80I/
	 I46tcEUqSbf8Z1UniY9LB0bJwpFdgW4++PwT7wNPmvfWIgVf+EcxVLntdlo9QcTh3w
	 bJabMt7Kieu2bLiGTsk2JcIXsXQ+1q8t4wLXbrR0tI2o3jU5BnTOf9JuRpo+GDkJoZ
	 Bhm1IDtKo2eGA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	Wentao Guan <guanwentao@uniontech.com>
Cc: Sasha Levin <sashal@kernel.org>,
	bird@lzu.edu.cn,
	kuba@kernel.org,
	kuniyu@google.com,
	n05ec@lzu.edu.cn,
	patches@lists.linux.dev,
	stable@kernel.org,
	stable@vger.kernel.org,
	tomapufckgml@gmail.com,
	wangjiexun2025@gmail.com,
	yifanwucs@gmail.com,
	yuantan098@gmail.com
Subject: Re: [PATCH 6.6 229/474] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Wed, 27 May 2026 15:49:00 -0400
Message-ID: <20260527-agent5-item007-afunix@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527094544.2344825-1-guanwentao@uniontech.com>
References: <20260515154719.961677988@linuxfoundation.org> <20260527094544.2344825-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On patch review, found this patch which backport to 6.6 context seems such
> different than orginal patch, I think this should be revert:
> commit 0d7e7235bc543c6ed7b873e3015db814d8e8c414
> ("af_unix: Reject SIOCATMARK on non-stream sockets").
> pls review.
>
> [DIFFERENT]:
> original patch patched in unix_ioctl(),
> this patch in 6.6 patched in unix_stream_read_generic().

Good catch, thanks. Reverted on pending-6.6.

No corrected backport is needed on 6.6: the upstream fix
d119775f2bad targets the SIOCATMARK path in unix_ioctl(), and the
prerequisite that introduces unix_ioctl()'s SIOCATMARK handling
(314001f0bf92 "af_unix: Add OOB support") is not present on 6.6.
With 0d7e7235bc54 reverted, 6.6 is back in the correct state.

--
Thanks,
Sasha
