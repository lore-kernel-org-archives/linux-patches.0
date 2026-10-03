Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF863081A2;
	Sat,  3 Oct 2026 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067027; cv=none; b=guvLmT4xB3Myaa88pfV7jJLdoPBZSqk+5PaEGC9/Y9BHzQLM1i1HQuqpkmP2dKRSj4rZrWsNi7qqc/4BrKDmNu2zfedNp8JA0aUdMQoc++V3mSe63efxiwhgEqlE7eIL8vZETLqXcQKi/+pRdi2VEZuxbYsYm+19uS0I/egJo7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067027; c=relaxed/simple;
	bh=+Bsw/pSuySfH0a+2Qrk1zNpWmzZl77mGThBCGcbA+eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SApcdXine9uSXvBjtVg1M7WTGjS6HRWEx8qB/mJHrTX7HmFzjD4b50MXoTLmWEnZ6RGPRPrtF9qSZYC0a/DcJbgM7jIrP8NaiaYm1jqVwfnHxnXXcCM7cgnIDx53du7n6d0g1a8nG4OEEowlWt4kptvDCu6s8Q9HCB3QPK5yNo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+2CoGTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+2CoGTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA541F0089B;
	Sat,  3 Oct 2026 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791067026;
	bh=4KmYCpcctXqXFx58nYQ8a8lPlmkoekZEaIJgK9XPUWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+2CoGTbdm4ao47zfq0SeiSpzJvOu+DxF/yt8aqeKWTM75f7eU2ZbBYEdg8xtECnv
	 6Alr/+Fq7xC5I+E9qHVk/UglBCGhjgDW18XminzCkoQfbWSfSi+UftYqi95nSbe8+q
	 MPIIortPfz3XPR8KGRFaFY5pikfugLb1YzfxgT7CCdcfhrJl5zakPdudy4+fa0rqCx
	 iQ2Rq+GLVRRoTJITNk7z0VY4fU8JcJ5p/b5ZBTnd2nDo9Ki5svkcK4VErDVBsCf7Ly
	 KjGjbSg6zab3PzCFT34tVXJib1YgtPEtAt1Z8OzYu3PyUg8mvqAdKLnFjGN8fvx5G5
	 gQfm7t4z+Ox7A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 721/752] net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry
Date: Sat,  3 Oct 2026 18:32:57 -0400
Message-ID: <2026-10-03-1-daily-reply-0016-re-ovs-nf-ct-is-confirmed-followup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e618db5b-53ed-45cf-babd-2b88227ca3c5@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152413.824545792@linuxfoundation.org> <e618db5b-53ed-45cf-babd-2b88227ca3c5@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 5.15.y needs 3c1860543fccc1d0cfe3fd6b190e414a418fe60e
> ("openvswitch: add nf_ct_is_confirmed check before assigning the
> helper") before the shared-object relookup fix, thoughts?

Agreed. The relookup fix already shipped in 5.15.222 and 5.10.271, so this goes
in as a follow-up. Queued for 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
