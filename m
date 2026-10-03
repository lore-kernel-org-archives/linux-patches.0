Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21336C0C8;
	Sat,  3 Oct 2026 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991030; cv=none; b=lON+yUu6EFnDvL8p+TfvwdxZJ88A+1N58coFHGHwHkEIONz8zbYSNN3xym5E1I89/zez80R/GJuN9rDgxvzv9NlcjePVlodtWrdKp4vCHNz3wcFEBz4AgJsmzYkaHVf68rhShONZwxv9HDYglsa8lR+XV6qNx4Ly1j5ztKeeS+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991030; c=relaxed/simple;
	bh=9neaJEqXLm78Lub6Cptf3c98xf1kvuLwiAn0r+/bi48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etfDYvPsFx4r/wIZ86E3+ZsecISwVOmjEHEaA32MOenR7pi18RmCnhNUFj7F5ACLtDii/+/bK3+GKy4kWVk+Sewk/JAzF/bEMDMkJseCVJPZBvhJKtoZyQ1zNdVb0LkR+TPcRhzIhh/m+ZKCo2JotIPc5UQUNr7ncGV2QvpZpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klHomOmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klHomOmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F0C1F000FF;
	Sat,  3 Oct 2026 01:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991029;
	bh=Xk+kCWiTfDSIfOY/Ms53i5aLtnjPXav8HPPGta528wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klHomOmKE9REbANo4ncYXS6JYcjEZueJN3x/qvwyKMWhpQop2fG6bipJZejwagxxu
	 MYpmUoUBc2B0I4uKoNLX3mqOJ3HWIMKCyHYynN/acQni6UmlTB8167+0MKA+6tc8wk
	 8yhs/gjlMUzXLv+f5Ituz4JpzeAraS7FCCTu2X/qrDRDwMrKsEssOzaABT/BaUT/kP
	 z5nbLfTJE3ot+PsQLQEPn7FOJmmNGwzNGrI+Ei6iiF5U7zE/8ejEvwt0amdrZmTmzc
	 K4JVQkhC4Cxg457uRfUBH73npR7/t/uGIh6txrFttwGw0vPgsZjNCjEh7Bc33lqeyN
	 HV5IVKfYZ5Nqw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 341/877] fs: avoid repeated scans in evict_inodes()
Date: Fri,  2 Oct 2026 21:30:21 -0400
Message-ID: <2026-10-02-rc-reply-0001-re-evict-inodes@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a10d4dae-c416-4ae1-8b63-4b7104c5dfe8@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152422.027976780@linuxfoundation.org> <0fee0444-1e42-4b1f-b7ac-234b5e19bb43@oracle.com> <2026100223-idealist-eatery-53bc@gregkh> <a10d4dae-c416-4ae1-8b63-4b7104c5dfe8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please drop this stable backport.

Dropped from the 6.12, 6.6, 6.1, 5.15 and 5.10 queues, thanks.

It stays in 7.2 and 6.18: their bases already have 3bc4e4410830
("vfs: Remove unnecessary list_for_each_entry_safe() from
evict_inodes()"), so evict_inodes() there already walks the list with
list_for_each_entry().

-- 
Thanks,
Sasha
