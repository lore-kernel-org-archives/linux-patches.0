Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DAB3E2749
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.215.233.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246017; cv=none; b=rjaZ/gwUe0tfK11W/wMK3UcZ45+3oh/Yqy8s1Wcfe5WBZKJvZjPqocnXDPxNyqIp4dGUjTPkU8Z0j8oOELfPdlDLmFnqUht7TU9flSZASgsnxqOGkH/sluEB9K6TNC9Q3PDw2rBm2q1PIu/vFPe3zLflVkvJ9Ih2jwtoXfjEpQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246017; c=relaxed/simple;
	bh=yfmmkwAeJvWfGL49tAgU1v5Tud7TSPPe/MHUoUFfoV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxdFhxTJyh5EWdFSzbVDVNyeZOuXAQGeFEMOZONduqIOlpWR531EQgmO0pc0bVEj7c4/nlf5kn0/JRadEnPpBjuW+rnSmDOoUgolq0Ux2bT45exWtI84BmRR2NctzYBgBsQRrxbkOt4B6Jj2hgkQIFjYUxU8rVVR+PtDI0iq0L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=ROiWVa14; arc=none smtp.client-ip=64.215.233.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="ROiWVa14"
From: Eric Hagberg <ehagberg@janestreet.com>
To: sashal@kernel.org
Cc: patches@lists.linux.dev,
 	stable@vger.kernel.org,
 	peterz@infradead.org,
 	kprateek.nayak@amd.com,
 	shubhang@os.amperecomputing.com,
 	Eric Hagberg <ehagberg@janestreet.com>
Subject: Re: [PATCH 6.18 022/314] sched/fair: Fix zero_vruntime tracking
Date: Wed, 11 Mar 2026 12:14:00 -0400
Message-ID: <20260311161400.1003322-1-ehagberg@janestreet.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <05467440d95c78161254bab895be5692e4f0a3f3.1773141555.git.sashal@kernel.org>
References: <05467440d95c78161254bab895be5692e4f0a3f3.1773141555.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1773245700;
  bh=yfmmkwAeJvWfGL49tAgU1v5Tud7TSPPe/MHUoUFfoV4=;
  h=From:To:Cc:Subject:Date:In-Reply-To:References;
  b=ROiWVa14wvindocmtMe/Scfo1SCMTDmkdOJIe0Gi3eRDcwVy9Cv9bNQCah/X2ya5a
  ELyP5Rylg/hvvy3T3gz55+MdM4MAfbt+VxjlPfkTK1ecSHvKGBuvCWKMCdKKLWnyDT
  u8r19WVDg18J3TsbUNVRhiW+i2UYcovNNzUzwd+WgXRGZK+ncDPX98fa0q3jbq54va
  3M5Je31/TtEBgB0G4DoSAJPJBLUyVV/Q6v9nUwjkhPhgtXmUKY6BT0Z8EOyKBLZSDc
  4ORcBW0F43cI6BkL3QIAhdJrOmtXBOilNRxl1rY62yKC2c7WDTECTRJOpJYs4XAKcn
  fTGvWc2b7rNhg==

Shouldn't this also be applied to the 6.12 stable kernel as well, since it has the patch
mentioned in the Fixes: line?

The broken tracking mentioned in the test case is seen in 6.12 kernels as well.
