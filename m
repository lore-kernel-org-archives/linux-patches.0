Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39151D278E;
	Fri,  6 Sep 2024 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725633326; cv=none; b=K+1QPuW1l77CnzTeH7Af0PZvaNKU4Q6IuJV2KTH/6Jfoj3Y5UI+5KzEbV6xW+U/JVfU5v9NAkAoTHWZSqKZN3u7uUUG9uUehZU/Ci/xGlh0dA1eNU31/Fr1GzShRmKzYrE1ycM1+wE6BSYjcPNpZdE5srpBh5W4/Dmoy3RsujhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725633326; c=relaxed/simple;
	bh=j9DGI9QJ1v/pRS53VlEA60o8aePK4CIqnJTb7NfSxvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KerKIgcwJIk+7HKX9H0Hf2S9faoPuGoUcP8W1yI2neAVOa1zT8AynJmqdDhavIIVky3qJCfwPcWhI7lcAoNkYXBmhxw0qw8EwWC9Vn5VcWKeY3PsnXTNFUY3riSPSO7aVuMRqRo8Li0236G5uIC7oRC+hSp2mg3gkvSAYR9dedA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWEHntdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWEHntdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71F2C4CEC4;
	Fri,  6 Sep 2024 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725633326;
	bh=j9DGI9QJ1v/pRS53VlEA60o8aePK4CIqnJTb7NfSxvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWEHntdXWyToe3C3vUEaNwXdb7680FcOLSzcojsdp1uNpfqK2Z0RATbGcr9U8ZDSG
	 V4HHXZoXE8bAbWZaonBAXID7SSMnr78805yPZczgIP9gxyHGeARG/QIZJZhRlt2Svb
	 WBd0slKmXU3pN/y3fpE2qujWsbrktOmC6SN77HYDuQ7bufu35QgGau5E7mIl27gTvd
	 5uOoFHxhKDTfx+ZY5goUymhDwLcK8zCxIrwW8WaWX6DSeoRqvw760JdC9mBR6ghyp3
	 18PWQSvfjYAbVYBzPPJLogG9yU6ypuhdBBTx5A12Yxr3F+ZZ1le1Zv75+rJvkVO25+
	 up/MYh476nAmg==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 0/9] Tidy some minor things in the stream table/cd table area
Date: Fri,  6 Sep 2024 15:35:17 +0100
Message-Id: <172562904958.411706.13455091898578049664.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 06 Aug 2024 20:31:14 -0300, Jason Gunthorpe wrote:
> Will pointed out that two places referring to the CD/STE struct did not
> get the new types. While auditing this code a few more oddities were
> noticed. Based on a feedback from Mostafa and Nicolin a few more things
> were fixed up too
> 
> - Use types for all the HW structures everywhere even for the L1
>   descriptors that are just a single 8 bytes. This helps with clarity of
>   what everthing is pointing at
> - Use indexing helpers for the STE/CD two level calculations
> - Use sizeof(struct X) instead of open coded math on constants. The sizeof
>   naturally follows the type of the related variable in almost all cases
> - Remove redundant dma_addr_t's and save some memory
> - Remove redundant devm usage
> - Use the modern rbtree API
> 
> [...]

Applied first change to will (for-joerg/arm-smmu/updates), thanks!

[1/9] iommu/arm-smmu-v3: Use the new rb tree helpers
      https://git.kernel.org/will/c/a2bb820e862d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
