Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774347;
	b=zInlW4P1A5iCkPlPMhoqO6uvEAQNef2CTQ0v9cmFAy7eSkugvSxSsO6elH8dijvq161t
	 BzeaVRDzLlrZ0j6gJCneHLlwz2nxsbdNKkWwWAWVHlAEIh4NO20LPsQzEvxTi87/eKYr7
	 2kgrbdyuz9YxYARQNQBw/UjZfwc5yZz2dyjfIcerAUvM3EtYiVTJkmICJxOVtVmt2G0/b
	 TeS5EI9A1E+YRvXdvD2wq3ktmyYYbz4VN4tUgo/pB3ziuK9nDtN8l9yFZKHKKgJ5+vzmj
	 4Kp1rSyJHJH4k2tjfrsqvumOFfxvOjgH5d+eBACCFoZVHoJ8sI8FAcLViGIpIwD20Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hOlSGyEmorn9312XCoGyoLWhE00eNKNLwoFXPLAOp84=;
	b=p8/wWl9VnOn9LfCnUrPfZ1jCNAgptHxzMA+PBGMofDwkCm0h7bSlxwSwo6K8S8xy7X2a
	 7nlKinsU2Tm/O6VTW5mNUfUBtBfyKJtiBwDUb5LRPDoyXOjrSNOwG/qUVRbCQEH72ChVG
	 M0Sdh8/GssyAqWX62gxwNUwTlWW5RRFbypvNfPzDSKLab7OG0R5DTAu/21CSf9oW1SN4p
	 Jp7HeLUMYc0K+suIlS/jJ2mfXt20jsxMpcw57a5RjZalMB1O8I8TwVF/+3jp+LFVQI+hW
	 d7Yeb+3C0aeCrQoFN6KUqtc2bh2eRSyAlr+U6ufUznNtBinxsbn3V1nehSb8IdbPTRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SY+vO0aI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85F606A31A;
	Fri, 23 Oct 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SY+vO0aI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5D51F01825;
	Fri, 23 Oct 2026 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774347;
	bh=hOlSGyEmorn9312XCoGyoLWhE00eNKNLwoFXPLAOp84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SY+vO0aIDmpQDfBBZEHELU8WQYAX+PWrkAY5n+GaQAPG+87VVL94UmpS0SnCLIsfC
	 UH7M7oawMgybROtA9Bfyp2xwLWcLhj6MX0CJArlFbPl9CKQ1Y3eZ/nkG56W+cF911z
	 yGE2IZxJ1h0GOqgMBuzUUvtuA0br0ZV1trBOUkRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/242] soc/tegra: fuse: Add missing newline to APBMISC error message
Date: Fri, 23 Oct 2026 18:37:25 +0200
Message-ID: <20261023163713.891250593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 2f4a0fb66d313f03832f061bc3ec25b33c8198c9 ]

The error message printed by tegra_acpi_init_apbmisc() when failing to
get APBMISC memory resources is missing a trailing newline. This can
cause the message to be merged with the following kernel log line, making
the log harder to read.

Add the missing newline to keep the error output properly formatted.

Fixes: 7b0c505eb341 ("soc/tegra: fuse: Add tegra_acpi_init_apbmisc()")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/tegra-apbmisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/fuse/tegra-apbmisc.c b/drivers/soc/tegra/fuse/tegra-apbmisc.c
index 6af69ccaa295c..f86c88fab1686 100644
--- a/drivers/soc/tegra/fuse/tegra-apbmisc.c
+++ b/drivers/soc/tegra/fuse/tegra-apbmisc.c
@@ -309,7 +309,7 @@ void tegra_acpi_init_apbmisc(void)
 
 	ret = acpi_dev_get_memory_resources(adev, &resource_list);
 	if (ret < 0) {
-		pr_err("failed to get APBMISC memory resources");
+		pr_err("failed to get APBMISC memory resources\n");
 		goto out_put_acpi_dev;
 	}
 
-- 
2.53.0



