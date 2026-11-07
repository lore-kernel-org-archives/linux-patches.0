Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062088;
	b=SU6hJvDJKWu+yT9wV+3TbcEeyzYIf2Vz6RZj0hbtxNY3EYMS6fKhMzcIoxDPKvC3HeJD
	 APPh8u1G8TnrBXeUgPyxVY9eXbFLqONnxhOfsO82Sxal0H/Q4amUecacNMhzeZLcUDw8T
	 ql9w3lI/UYr06rvyed4JRrrAHk1khTZsst9Q3FQIgo7QC2Vvk2kBi5cPjnCz8FO2EBKjI
	 GM9iRAGuBWLKEqCLfM4Wj9XzWlOdY+O8nWCX928Prdzcm4OlZuU/ByqWFnbjQzRL1eUkx
	 dCTTN+3YUlTYrJR8YEQsZkjo+NTtOOl3q6G6Y9oK1WFBDgg0KZFM5K+0/3II3f62SJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFTQ6OXZZeB3hp38cuS4N75K+jfFM2BPrI81bamS6RA=;
	b=kFDGTNM9NwqGOgr4o/6JuaQauuTcvoq/IWoADRHrdeQ9gL2KJRMXjeg81xcX0NBWcf02
	 RvuNqoGif5NqmLcqvNUC4/fFY+Fu2h6zBpS9AFv/F/GybkjzgCbXGrfg2a2YAFveag9p9
	 UNVaJc9np4cmlYWVBNQxnXecU7dABRjIBx91J6nJkZ5lbVgXMgBBPFM1zlzD54cYtotgR
	 N3APPXHRXGmoP6t/NUDU7R0wywUXj0VssdOhquDxepj9/FgqZHrC2tQp/7+4nEyBs1nm/
	 O/0YqM/QY3FxoqayoJ3FnGPqm3zFFLcUbQm5Z34gd0hI65gwUgec5+DrhH6UWFuRsqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzojGb7F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51C606D826;
	Sat,  7 Nov 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzojGb7F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE31A1F008AB;
	Sat,  7 Nov 2026 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062088;
	bh=xFTQ6OXZZeB3hp38cuS4N75K+jfFM2BPrI81bamS6RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzojGb7Fbpzm1r/Ztz/K4ZgPlrS5PwSgxblbI2nzy8FDupWSpMEetZIaY/OPjjC1L
	 pPy8VzAfunMvNrcEalDfVFtCFaZ8PyTPX+andIh5t0DO1+WJ5q3kCFPDyd+ZjfYz46
	 I7AueBlXsNElflRmcm5z7zfZqMFyjeYm1PJUM76Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1062/1536] clk: mvebu: ap-cpu-clk: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:51:18 -0500
Message-ID: <20261107135027.511564335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 677cc35148497..3cd9693d74cc6 100644
--- a/drivers/clk/mvebu/ap-cpu-clk.c
+++ b/drivers/clk/mvebu/ap-cpu-clk.c
@@ -282,6 +282,8 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 	if (!ap_cpu_data)
 		return -ENOMEM;
 
+	ap_cpu_data->num = nclusters;
+
 	for_each_of_cpu_node(dn) {
 		char *clk_name = "cpu-cluster-0";
 		struct clk_init_data init;
@@ -331,8 +333,6 @@ static int ap_cpu_clock_probe(struct platform_device *pdev)
 		ap_cpu_data->hws[cluster_index] = &ap_cpu_clk[cluster_index].hw;
 	}
 
-	ap_cpu_data->num = cluster_index + 1;
-
 	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, ap_cpu_data);
 	if (ret)
 		dev_err(dev, "failed to register OF clock provider\n");
-- 
2.53.0



