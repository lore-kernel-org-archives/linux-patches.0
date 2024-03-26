Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9571C6BB;
	Tue, 26 Mar 2024 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473827; cv=none; b=d/fvT1QgAsjFyfszSRqnUYkvSWtQBh0AMrxL2+FhL0yNZP1bx7jqzW2UKZmZkj8naZ9oQTD0aR/Mwr69c3C6f2g/skd9Pm1OOa4abnE0BogDUll3K+NNZLCqJjuslqYsaT9Q3XjsdjX0xd8KAkW8R2iPx2ZnNEOBL/yZJYl+O88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473827; c=relaxed/simple;
	bh=QJQbY7ol0tz5vhAdueXo6pMJWaVuwhL4mLpoErSBJME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKCTmuVryrJEIu7ZdhX8Yd3j4+UTKIdrjTf0BbOF+xNdvSFZu2qAMUsroYdkyO8QJs1LE/vuAWZ5gNMPFIUPjph0wt45AFrFb+tJi0PIuPfX4ZL/0+d6abNmMfQPDuOfW28iDneqSiYmGL4Smf/y1t5iAO4KJXBvzz6lRU5QDc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZlc+H+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZlc+H+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19050C433F1;
	Tue, 26 Mar 2024 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711473826;
	bh=QJQbY7ol0tz5vhAdueXo6pMJWaVuwhL4mLpoErSBJME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZlc+H+z8VXyJUkFxan7PI2uZ45FlY5VxlBTIVdWE1b9xP9zoTo+w1VsoGk7nh+73
	 eZxF7B8s9m8aZyEBUg8ixmC4MXsaoFF+eAbeAh8aFtHFy1rmSsj1kRF8l+/Z5o5RDE
	 h/7FkJDpVQskZ21y7RiFytr0sIecpnxEKn+tZFq/QS8a1ZON5wEWoC4cNqtxZq06va
	 ZU+tSlGkf5iDo8rCT1QRdWNVuiAw/S2j+GNFUeEmYXdHTpYuB3Itx8YHvvd6Bytr+f
	 xwFFw3udS5oq1J6ftB9mBi0QPxa1iqxU/RbpntPVhB0j3GrSz8/+IN7brJj2OxALKQ
	 FOFAs4VGvhT6Q==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Michael Shavit <mshavit@google.com>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: Add cpu_to_le64() around STRTAB_STE_0_V
Date: Tue, 26 Mar 2024 17:23:17 +0000
Message-Id: <171144985938.34712.7805099046790657214.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v1-98b23ebb0c84+9f-smmu_cputole_jgg@nvidia.com>
References: <0-v1-98b23ebb0c84+9f-smmu_cputole_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 04 Mar 2024 15:50:08 -0400, Jason Gunthorpe wrote:
> STRTAB_STE_0_V is a CPU value, it needs conversion for sparse to be clean.
> 
> The missing annotation was a mistake introduced by splitting the ops out
> from the STE writer.
> 
> 

Applied to will (for-joerg/arm-smmu/fixes), thanks!

[1/1] iommu/arm-smmu-v3: Add cpu_to_le64() around STRTAB_STE_0_V
      https://git.kernel.org/will/c/0493e739ccc6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
