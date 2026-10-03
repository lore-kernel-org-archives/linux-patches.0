Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066522370A;
	Sat,  3 Oct 2026 22:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067003; cv=none; b=QaAuBMxqzQ0mFvqKUH563zR7KpZ4DAyPIiHlTTEYXX6HY3QaJT1iTbeNo4ahNkL5jCSblT1gLUvpbNEMlqGaakxGep81NRhA/ive4AGSFhP5yh1DPxtsnmilKjT+6WruamqEpFTeYjkK889Yzp9ztkHgGwHo5o6oC0N2NDxUmZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067003; c=relaxed/simple;
	bh=rsuWKUlJyONSdlSCMs0Xjta9LLNv0x+Ys/DDYDv53gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ+lx3NK3EUTAlgw4bvUNzTnWr9X9I4Gm7aR9+Pq8cEwHXnaopMzdTVX4vTMJb32B8xCiJG3xTCcOPbWwVMCawPxN0yiXD42bX+ioP+BTLJx4G7d+u876udXBbAfWfQ/VA7hd+fK6ixQKxbevxTP1o9bmxaSxMQ8jVdLAmgXdQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3R8NyGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3R8NyGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03F21F0089B;
	Sat,  3 Oct 2026 22:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791067002;
	bh=WSQ3pUY+9rt++lBY+79P0Gbp6ltFF37R09j8+KkXvIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3R8NyGbGb/CDKEgs4HXOGqxs9ivcGkZ1Z6MHUlJROXr7kCHpt8vIGnflDRnHi+ET
	 3eRSOx9KiQHlJjxR41HKNmUM8L4jE08GytIWrak346dsQmK/QluSVKIBZobw856Vm/
	 YCiE9md0uvIaOsf4U7AeT4U4yU37VpRA5vAyTabIVP2khvosJLPXFwsQ7lx1+TVMKo
	 0a5nTsFr+Z42owDFrATQNTMhzQxbHvsGMcPXbN6ROKv4lf2syRMYmDZl7AoLEuarAc
	 LAlEjB2PIFSPpNCXXR5TNSAnegxsWW3EIJc7oaKYMBdj7pwMT2/4dU+GfvI5T42slT
	 vw3dXGYeDJsOA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 474/752] wifi: cfg80211: dont filter by BSS type when removing stale entries
Date: Sat,  3 Oct 2026 18:32:55 -0400
Message-ID: <2026-10-03-1-daily-reply-0014-re-cfg80211-bss-double-free-followup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3da7c53c-7b2e-4aa6-80dc-2aa4fc5b60fd@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152408.530774330@linuxfoundation.org> <3da7c53c-7b2e-4aa6-80dc-2aa4fc5b60fd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 5.15.y needs acc44cbd7727115f9381c35c2898b1b5af665ec8 ("wifi:
> cfg80211: avoid double free if updating BSS fails") before this
> selection change, clearing both IE pointers regardless of the helper's
> return value, thoughts?

Agreed. The selection change already shipped in 5.15.222 (and in 6.6.158,
6.1.189 and 5.10.271), so this goes in as a follow-up. Queued for 6.6, 6.1,
5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
