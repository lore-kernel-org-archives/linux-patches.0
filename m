Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773790;
	b=ancImosRpaHt/ZP591qDojK7rCm/i+zGrr0DKQTIIPTXgIf5Owjr1cuRvnyP3dn5usHi
	 U+xC/jT3qHhzbxE3R6OoKAzJAiLYisHwn82ob8pe05DGrglDfSVLw3LVDZwiCT3eHgaKD
	 AwrVupOKr8NnRwiXCVKTUzD8+ngf10zc7zdHMY4S0SPHjoFLkSPHm+sBNUW8nuIAf61z6
	 HG13S+5eUzBygpEbeWO1sqQFZc8ooNxFJFsBOArba/4bSgeXSLP9bK9A8Bpc75UZUO9n3
	 7aGf5ZwLyakT12yfDjFRM1l6c9nl7VVzwBWGD9beT79sN9NmlsNR9vzoo3uB2JDf8kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m/QEnO4EVXuuxXKqqPVjIHfWUBd7BfVBlBDbIb+0tyQ=;
	b=iWVYjjGNT+tvVH2wRR79clThhO9R0NxuHsRSs628wEZkI1OrNYOBySEqvwYne/6NBKdt
	 6PRSee8XsCTVnc9nJJq6rIobWYkLvESR7+tHKb2e1qSZab/u24QeIKusp875tejRThD5I
	 v286ZRabi6KEirTBkXogyfYKccGxyyixoC3xchiC7JN4cK1DjeoTPPbvWGblVTdOmEjWL
	 8obhCO2WC386WX7+PT5BSxauliv89u1AzwXR+xfuu3TC3+05PyOGYwcJKQ5gBVOksogU4
	 r2omXsMgEPYHNAHrGm2kkHJjAfhIz2T3QYvjwMsw3P/9un0yrML4uIipx0qBKJl7eXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDroHmg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11814606A31A;
	Fri, 23 Oct 2026 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDroHmg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF591F01825;
	Fri, 23 Oct 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773789;
	bh=m/QEnO4EVXuuxXKqqPVjIHfWUBd7BfVBlBDbIb+0tyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDroHmg6UcaxTp/UXCvLIw7j2o91iIl41aAzu/KVoh24vjQhxbY4KIxEh+QgObUQG
	 EfbzBHa424vp8u1or4SCd0TkoRTIX38XTbStfFGrYIA+paKGia9BRLB2yrvwmbz24y
	 2v+1rh920jzn7oXrNCIBWPyB2WPcPR1vsiE9VgaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/193] soc/tegra: fuse: Add missing newline to APBMISC error message
Date: Fri, 23 Oct 2026 18:34:46 +0200
Message-ID: <20261023163714.424840449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0ce94fdc536fb..1c25b36c2f3cd 100644
--- a/drivers/soc/tegra/fuse/tegra-apbmisc.c
+++ b/drivers/soc/tegra/fuse/tegra-apbmisc.c
@@ -278,7 +278,7 @@ void tegra_acpi_init_apbmisc(void)
 
 	ret = acpi_dev_get_memory_resources(adev, &resource_list);
 	if (ret < 0) {
-		pr_err("failed to get APBMISC memory resources");
+		pr_err("failed to get APBMISC memory resources\n");
 		goto out_put_acpi_dev;
 	}
 
-- 
2.53.0



