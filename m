Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062977;
	b=rMP8j0ygnyGrdTRKS3cZIwxszxWE9kDBmw2c7+8+qK2pbp420Qo524lwh5ePPbhJRQMY
	 wQa0VyziDmlRtTJ9xH0K6BHxVKkWBH7Q+MHLVnQoL9UQAT5sT+ZhWpG+/btxWB41Yeuhg
	 M9I2eXuwOlzX6z68nlIECr5sf7yBFhH38Rw5gyJjLURH0DTgo+zRfoVPs5REKfc0BjwTV
	 t/qRVESVPkCZHw4J3FY9gKEWjj9eIgTng+7I1P/b8W4WgBuhWq/DlgDZesJjvzv/SmGE0
	 Lgnzk7LbUyQ4tu3PaiLxewMGRjoWT96mktGCQo89Gl9DN02iLci4QQ3bT2gwymK/29w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBqZ4YTdkwTE4m7ab0+IQ03kPMeavOIfvQlFfxXXDsg=;
	b=NZgoFq5TJlAyKOCV8K+BUFQN9czg4RiM2vkvj2iKTC70S0iywB5JtJR/zoK1C19sZoq6
	 2oKXwvcEUKbiN1Al218Ht/p0FdkHMYJ58yXgfaUwEsJXPYL5TVnnlU4FhVCsVRBLqCodu
	 8fsv4VkyndTDFaZfCGR7TFLSTk6SBOHsGh0KDstqB2JrWzMOodv/MwaIK42KNtjWQDo7Q
	 ovufN0r4hu/Tf5RB96f5ipWsJ3WXVbFKbsOFuRNF74PaeyzYBqwgbC55fK4/2plo8M7lh
	 J1TfAQhNimCiXhSDsz36KN2zVfskkeH7RvDK1dc9XREs5LymOgFa7cj7p8f4X9hnlqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZYCFDyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F460606A33B;
	Sat,  7 Nov 2026 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZYCFDyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03A71F0089F;
	Sat,  7 Nov 2026 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062976;
	bh=HBqZ4YTdkwTE4m7ab0+IQ03kPMeavOIfvQlFfxXXDsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZYCFDyM6afp7g6qAOgX48scHD4YgNnvDCuyFsJ18/q471j8a7Bh3xlgTI/lZ7nps
	 N+wMSinAWI62qvTbuvbiezTj6vcHFgxshqdaCaDMgSOfjFk+25jhd4McuJuwHfwF8x
	 FIz/wg/t9aXzgMWiw2Mz9kPeAtrwC1ndFbjVQNoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/869] clk: mvebu: ap-cpu-clk: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:48:40 -0500
Message-ID: <20261107134859.909350401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit b4243850393f2f24e21b9f4b2c56233e60c904b4 ]

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer (UBSAN_BOUNDS)
about the number of elements in .hws[], so that it can warn when .hws[]
is accessed out of bounds. As noted in that change, the __counted_by
member must be initialized with the number of elements before the first
array access happens, otherwise there will be a warning from each access
prior to the initialization because the number of elements is zero.
This occurs in ap_cpu_clock_probe(), which reads .hws[] to skip clusters
that have already been set up and writes it inside the CPU node loop,
but only assigns .num after the loop. With CONFIG_UBSAN_BOUNDS and a
compiler that implements __counted_by (GCC 15.1+ or Clang 20.1+), this
triggers an array-index-out-of-bounds report during probe of the AP806
and AP807 CPU clocks, and with CONFIG_UBSAN_TRAP the first access traps.

Initialize .num with nclusters, the number of elements .hws[] was
allocated with, right after the allocation. For the in-tree AP806 and
AP807 device trees, which list the CPU nodes in ascending order, this is
exactly the value the old assignment produced. It is also the correct
value for any other node order, since of_clk_hw_onecell_get() rejects
indices at or beyond .num.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mvebu/ap-cpu-clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mvebu/ap-cpu-clk.c b/drivers/clk/mvebu/ap-cpu-clk.c
index 1e44ace7d9519..ed3ca59e0ee97 100644
--- a/drivers/clk/mvebu/ap-cpu-clk.c
+++ b/drivers/clk/mvebu/ap-cpu-clk.c
@@ -284,6 +284,8 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 	if (!ap_cpu_data)
 		return -ENOMEM;
 
+	ap_cpu_data->num = nclusters;
+
 	for_each_of_cpu_node(dn) {
 		char *clk_name = "cpu-cluster-0";
 		struct clk_init_data init;
@@ -333,8 +335,6 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		ap_cpu_data->hws[cluster_index] = &ap_cpu_clk[cluster_index].hw;
 	}
 
-	ap_cpu_data->num = cluster_index + 1;
-
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, ap_cpu_data);
 	if (ret)
 		dev_err(dev, "failed to register OF clock provider\n");
-- 
2.53.0



