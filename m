Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0C3E1682;
	Fri, 29 May 2026 12:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058654; cv=none; b=d8JSLxzUX7o+FZsQ4fpq65HJ6RGg4N0yvrKTEx12LMLSgziOo52bFkgZr0kmtgYSq8JfIDUDn33GVkmhij3etQrVchr5lK/P6HUKXVRORjNd4EBBhmTlnWfsIxRxnLMe4omki1mGDb/NN5AeFuwrF8wSaHxR7hqy0ND3vX4j5zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058654; c=relaxed/simple;
	bh=fydvVjAVH3DpTajNCPdBLazp9UBSP9CcGOVs/7y7MoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmbI8QZYxZRbcEtY3LvU1OZtYwsB/1OL8cNtfqOcVAqsdtyDNBzor2CBaYDP1YYNZ/2sqnp6dMqmTLafte9k6h5EhP6tlPZTy+lgDKYFkpgH16ATPSpTx73+PTPP3GA10Y8TZ12n6IMWVGjGHD2kSmwS9QI+PtbhNzu2Y6LNIhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8WWKG0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8WWKG0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89E11F0089A;
	Fri, 29 May 2026 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780058653;
	bh=fydvVjAVH3DpTajNCPdBLazp9UBSP9CcGOVs/7y7MoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8WWKG0jeIR6rUgaEri6hTUz3bR8Xk6PLCeTGm4auIhwl6sIQ7RKJovP25vLeLHbr
	 iDzce+EUF6qYXyxrk+6Pdq2lrl9YBLyBFN3MpXakauENvJz7Y7ZPMjLDMod3aaTsoC
	 PWl9279p44VBvXHEIwHvFF4O/BKpGNEAxoAH+CvgBpNrgOxtkYAeEGWC57YNkTsWi8
	 J62QNmT0AhRwls0wuWuTWLcQpDki8oxrJccdpLHQUwluLfnKILRU7UX8j4Vjvci6Ta
	 iOUYFkhjUyJ9eI8rsy20Xm4+T5He1lO6mH5U0CTmYly/boNikD0h5PhNXS6KMyrc0p
	 fVKpOxxs0N5FA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Daniel Vacek <neelx@suse.com>
Subject: Re: [PATCH 6.18 299/377] btrfs: dont search back for dir inode item in INO_LOOKUP_USER
Date: Fri, 29 May 2026 08:44:05 -0400
Message-ID: <20260529120000.btrfs-inolookup-keep@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAPjX3Ff-a8JHxeMr1Hk83BmQX9YLGNR+g+7waygn43ZD7pWMHg@mail.gmail.com>
References: <20260528194638.371537336@linuxfoundation.org> <20260528194647.015775177@linuxfoundation.org> <CAPjX3Ff-a8JHxeMr1Hk83BmQX9YLGNR+g+7waygn43ZD7pWMHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, May 29, 2026 at 08:39:10AM +0200, Daniel Vacek wrote:
> This is not a bugfix, rather, it is a cleanup.
> Even though it's kinda small and limited to a single function, I'm not
> sure it's worth the stable backport.
> Is there any specific reason you picked this patch?

You're right that it's a cleanup on its own. It wasn't selected as a
standalone backport - it was pulled in as a dependency (it carries
Stable-dep-of: 1e92637722ae "btrfs: check for subvolume before deleting
squota qgroup") so that the squota qgroup fix applies cleanly.

--
Thanks,
Sasha
