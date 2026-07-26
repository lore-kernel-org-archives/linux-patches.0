Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A6131AA9B;
	Sun, 26 Jul 2026 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067504; cv=none; b=nq/a58aJ02VVJGGrCm0DhqBuUsO0WmLu93ALepAPZF45JGD2hSRuSAf9qd1QdVbkJRnpSLBcxS4RM8rPdhGKd8r3PIex4gRVo0fc1jVmye3U3DQhfQUYYGg4wgdtSKGAfrH+hgXKRSm6QsqdmwN5moWHmRxMnyg3veESCG4k8u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067504; c=relaxed/simple;
	bh=eHhF4E48U02y5ORgvdYnG25ZcDMa4Wz2xoswjv4C7H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWlNXPP6CKK+9Lx1iRZn0qzdZOoz+t5d+D4drHAznQBkmXYBKcblqQpiBa19XjT86tQp6rqSv6PdRVfZPJ/pMjK/LTxUTjy9CmhQEI7Vn96PldQebb0SNAwi3FHr5cRhhMdx8uI163qH7P7BuusXVjBt7lLphA+etkFgS9eLzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgzzZ+EF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgzzZ+EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBF41F00A3A;
	Sun, 26 Jul 2026 12:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067503;
	bh=5g0tEIEyUJIKpn3VeRdij5IgOWYnUqwSRJEhKflXIVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgzzZ+EFirIiSsw4MqNInKbOZNCeR75ChGPxpSW62NsZrTl8k7yOSeUiiQeY7bQZI
	 eXfE+Vuh2QUCDG0ssogJ2FCatGGBKwPrxuL5/JwZXKt2iJezjvS2kR9QIzbfV1zH4N
	 sSgggaNDt3tm25J2/0f2rEQqBgXcLocDMXFveqc2Kfvz6sT+t04/+Eb8oJULoGWeol
	 b4grdhGlCRTR9KAPRQ80ZW5CfNwIOUD6PdJsP05motpTE/PDw9woMT+caenV66fz0j
	 8QnhCATztQQPXR382230rebZz49aZiJww+gT6I4T+m+tS8SAF23DFKkSFX5chn+f4I
	 Km7MSphe0gRrQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0508/1276] xprtrdma: Document and assert reply-handler invariants
Date: Sun, 26 Jul 2026 08:04:45 -0400
Message-ID: <20260725192000.stable-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d2f4dd54-6741-416c-ac81-62f99833490a@oracle.com>
References: <d2f4dd54-6741-416c-ac81-62f99833490a@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The new WARN_ON_ONCE() checks seem to assume the cleanup in upstream
> commit: 2ae8e7afbc63 ("xprtrdma: Clear receive-side ownership pointers
> on release"), but that cleanup is not in 6.12.y.
[...]
> So my read is that 6.12.y should take 2ae8e7afbc63 first before
> backporting this.

Agreed, and the same broken chain was queued on 7.1, 6.18, 6.6 and 6.1
as well. Rather than dropping the assert patch I queued the missing
prerequisite 2ae8e7afbc63 ("xprtrdma: Clear receive-side ownership
pointers on release") ahead of it on all five trees, so the
WARN_ON_ONCE() probes no longer fire falsely, thanks.

-- 
Thanks,
Sasha
