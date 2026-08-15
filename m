Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E06F2DECD3;
	Sat, 15 Aug 2026 02:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786761220; cv=none; b=e8CrggVz1xZCw8ipSy1LWOt+CUP2XPo0I3c8ZQgSVc6N/LQjsFur2agntKgfpyGqYkH7UD09GGxxiT6GUzrie5RZLL/S0XxqgxrTmTZpFdLexiAG4FQnXXCAU7lfn7ZrCI9xogDujx72VSqVWalknPxSmX5q1cOPmoTvxdl5dX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786761220; c=relaxed/simple;
	bh=YbBxYYnWfqioZPCwazB4l/A1qwTGZbCd1lDuhhiXGig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzFAtxIQcQ27PYiBr67w9gyArQ4cfR7u7DYEUusc5uvEZJb4jRoa9RFwusrv1lY8N5si08s1AumwB9a5VmLxDy7NqYEJtvsiDjvvgaVxLCjckFKeqyB0RmmXDmRH0i3sZCN1WW8hqg372bX8sUjvzWNO6aJXZMWJAR+QBH0zW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozFGK9UB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozFGK9UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C951F00A3E;
	Sat, 15 Aug 2026 02:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786761219;
	bh=WS7GRsZZb8IXylI14yT8TKSJh/Bw4M+QS7aj5jDzG04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozFGK9UBwenOtss9ukSxW6l7mhViV3WfNicnUWsU8MkQ8x94s42CLEEbIf28xIf7b
	 FWWZX4l/q3cuHvDvncl76Sqg1tUasKOs2eyLkC6RLkOMjsfNHW1WBqcQtTAhQCyMzy
	 iREEy5CmNiSWRpZgJy+Uj/2QE/x2OoJ3pNf0LNfXPXmgVw9AKj8BhxMy9XFL0Qtv4U
	 76mJJqzNDHk2z2+X/l7Y1Rjj0mc5IcXGrDuuzQZSmgCi00JD8Ud+ahqtjSf4c0oGQt
	 dkj2oErLiwLUKnpplnp8kPVR4exGYEPFue3G6IP1kKRS2H3enQu5Cnxsv+QNSqIgVa
	 x6mjnKkws0iTg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	samuelcrossley@gmail.com
Subject: Re: [PATCH 6.18 0019/1611] iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Family 0x19
Date: Fri, 14 Aug 2026 22:33:12 -0400
Message-ID: <20260814193000.12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260813132447.3396830-1-usama.arif@linux.dev>
References: <20260813132447.3396830-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I have raised this in [1] but also raising it here, this series seems to break
> kexec on Milan hosts.
>
> kexec starts working on SNP hosts once we do:
> Revert "iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Family 0x19"
> Revert "iommu/amd: Use maximum Event log buffer size when SNP is enabled on Family 0x19"
>
> on top 6.18.43 release.

Does the kexec hang also reproduce on v7.1.y, or on mainline? That would tell
us whether this is the code itself rather than anything specific to the 6.18
backport, and it decides whether a stable-side revert is the right remedy at
all.

-- 
Thanks,
Sasha
