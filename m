Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064151;
	b=iXSKPYWntHu+e8BKIWnCyQndnQq64CDqo5RXXBJLBgcSKS01ye0gb1PszIyA2ohLcbF3
	 ndS089Tff1cv7EL/7avMhoIItVSDKIgYsj0KjHhR2SJUhQfCx55Gm/4cF7xoq+JdUzBEv
	 6TJFGf95GHOvu/xCy7C3MrVIFpB1CTBijFz+fUy7fKnSeAmK5n4oe7BAEajwpM+6xm8fw
	 IkwR0k3Q8YjJRdf/Z2inA2oa7FFFHXmAY6hykZtqZlnpnrT8MJyE7Tsrwms9nEZ7/IYB5
	 Ktudor8ASeaBXAxYy16pE/OmM/n0ey/gH2QcJU3gQTsoMqjJQXJmoxOPHG4eo26IHwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uClGxA4enwha9GYvwO77X/bfHuzgTvfVvKekhyzLnM=;
	b=K1NrFNdFDuocPKeQZTrHO48lWw2D/h6jQzja20aV1IZhVeJZIj4lMDUM3eA+SwFobnOB
	 7MkZpC0icVD611WYGOESSGSyTfQS5RPPH7M0F6qT6tfSSQ4VqCtwvyPbJtHkpZkYNvV2R
	 2QNH/H97DGgKIUcRFy4ZboCPmjruuOPMv75j8fRCK2HIU0GUP26Riq+RMqC8SzkWyPHt2
	 3Lmz+gVJy68O3wxQKVpJeISAmd+j9A3TJs2rCSGsb+P879+rYFFJtW2yAcER2UkDaG9rH
	 WAohM7KbY7qjEF0xsqAgPmlAwbKajZIDHgni/S4PVzirqXxfR4sb/3tv7Bc1/ZJN/2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i983gpgQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98089606B8BE;
	Sat,  7 Nov 2026 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i983gpgQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E311F008A5;
	Sat,  7 Nov 2026 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064151;
	bh=0uClGxA4enwha9GYvwO77X/bfHuzgTvfVvKekhyzLnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i983gpgQHl+V+s/m96mXa1eHW2a5r1g9gEEyt4/7EFOTGJGz/S7RIQZbLv6L0dn19
	 r8lLjvYzlBCeaTUyDXRX9Hl+Ss5IYHauxhwyCiWtg4pQevhCqkv1ZV88oQ+CNb+L9h
	 QF/+h1QsbDptlJO6cbW/b+/HnWpkJ+6alqGkTOnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0293/1257] clk: mvebu: ap-cpu-clk: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:43:09 -0500
Message-ID: <20261107134947.557947751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



