Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5C81724;
	Thu, 15 Oct 2026 00:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022930; cv=none; b=F7/QgnI5FcVSGx5Ig9mvzy2qorHlxBlBxRHVPffWRi3jZMSvRlgAWA+j6yCz31+UsZWJ/+maCTZLrHJRxVcJRuTCxfSq6mW9eMw2+Dgq8qGgKmFoA1jMbRpHrCdJkm5FbPVsJuyaxdmV5HKH3dTfQQS7HFOJR6czRsIXMCLS6ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022930; c=relaxed/simple;
	bh=Z+OtbtESs8YwW50X+ZlgWjS97aMrxHir71rTNo0xUSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPrCOPF+02WfU711gezh9r5hkIzTCcviVmKt097ZlpzdJ14Lt4Py39xC33Py7xD0CekPEWhvaiAe1Txr4taSiKGP3LoBJ81VH1RGeq3bvXuwmlM15kg5Qomb1WjKSFmBnCeHIap7Ki3ShA0rmoPDGGkUaDLL516tI3kqtNY5B/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqMNOfBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqMNOfBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383901F000C6;
	Thu, 15 Oct 2026 00:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022929;
	bh=uRkloQgEKcTq/ULTcUVGtiIkRBkAiq4y+wSJP8BqPws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqMNOfBeUwkesEpbzPwN41aXbaCc14JznEfXj+gFLYf/osGVPLrKBIc5agJvfnOyg
	 nQb2KCo0ltjrJbnIEL2iJ3oIWoT9iwhOL/LuIQYrwM+fB5RKe1ZTy1EDAOWyQZppIA
	 /0EGnY8GuYQ2PsYh1x+Axj4y5tnPvt8EZ6PPkQW4VpnnKPkH3afrAsLyM1bnURvjdq
	 VvIse8VRhc3atmIk6Z7ucxVi0R61S1yM2OaHSYMkTCxM2mMUqZQaNmt0VWrneUDqNn
	 mOfqK9WD+lCOzwydOoWt8dQeEYLBqhsniYJZCnmL9HWPlyhWjA4qEyuNNb81o0iW4N
	 lslnBmAw6V7ig==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.12 464/497] btrfs: fix lost error return value in btrfs_listxattr()
Date: Wed, 14 Oct 2026 20:08:37 -0400
Message-ID: <afb38804dd034ee2a3912fb2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3bca6bdf-2620-4f4c-878e-6a3cf0ac673c@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112918.894044198@linuxfoundation.org> <3bca6bdf-2620-4f4c-878e-6a3cf0ac673c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Should we fix this inplace or drop this for now?

Dropped from the 6.12, 6.6 and 6.1 queues. Those trees free the path
explicitly, so the early return would skip btrfs_free_path(). Nothing is lost
by dropping it there, since the older trees' iterator already propagates
-ERANGE.

-- 
Thanks,
Sasha
