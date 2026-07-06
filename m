Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E27378D76;
	Mon,  6 Jul 2026 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346910; cv=none; b=WvvQFlKdaafSBziXqbeCSU7DSziUnyFIjpRgRcMy+BW9rjoC9F3zW/NK1+S7QDiz7EnE/BdIbEJCC6pG2oOjJv5gQa7sY2ywBsX09ntHStRHqhT7Bzvg6LMSpPb2d2PJ4w79YuyMOGMHoRbqMrynMIzEcZwNWN8aliYHFb6poOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346910; c=relaxed/simple;
	bh=lxlqGKfABMfZDI+W0HNaq6D8+ZvBD+cRtYxi58m1R2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH7+nGdoSmxQiJIAOSmwjYoTuzWzS4WIJFhkkGcaJE2OoqWmebOi2jU6RqHgsMSskKWIVwj4a3rBCzsqSuGZ7BFPtVcdXp6ouJp5TyveD/FSzVoBqD0TwB+BPwAFJx8ntgngmf7aFUTv/qoTZVjWjA3BVnVccKTLU1B0KsP54wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImE01U9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImE01U9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876441F00A3D;
	Mon,  6 Jul 2026 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346909;
	bh=9wA9W72obBOInK7f+81GO6Aw1p0fg+9MBar9MjsxaW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImE01U9kBSCZQ5nGTUfUp+o4YIk+uJf7VQQk9uXJqlCSHqvfM98lVziYbL4HRzkog
	 /BCezasfMSd9v7x/6ZZZMvtoMsrcdLNSnxDs9yPDta0OWL7iZVEpg5102FonWO2pK9
	 9C5ymdfzkciTKg9jS1RgheKK9CZ3KVNov8XHHSN+I6OPVYuFHytpTW5k4gwBcvWOq/
	 am7byl4K+dZ2eyjuT/+hNVeNwLBfNbWmR6WJBcnzla3JHIHzmBB1N5Mm1jtoj72DMX
	 l/mmCO9rAfLmW2o7SaFyVboFV04jQqg50q1NKvBkP4A6r5rf3QjrkB122ZnOdaB1yB
	 syJIOby18F1Ig==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dominik=20Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading princhashlen
Date: Mon,  6 Jul 2026 10:08:20 -0400
Message-ID: <20260706135124.draft-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
References: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think this depends on commit 4552f4e3f2c9 "nfsd: change
> nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
> older stable branches this failure path appears to leak name.data.

You're right - the new early return leaks name.data on every branch
lacking 4552f4e3f2c9, and the patch shipped in this round of releases
on all six branches.

Could someone please send a tested backport of 4552f4e3f2c9 to all relevant
trees?

-- 
Thanks,
Sasha
