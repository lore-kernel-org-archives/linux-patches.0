Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036083;
	b=RQYcIa0D9qPGxY1kKND0qDZZmkh/M7Tc0Wg8AcpFqdOw7pGdE4f2P3Dpp9/eoeb8Atmu
	 ezhWeMyX7r/bbN20h5MUj75T3Tq6kywJqUZxlyalC9mIJ8PaVuOusmdBDuQJq4qeOlgJd
	 C9xUKHUXJrWeb7q5jKiG9fNhZB4HoOsfOoCw3+zMF33VY+deUt7wS4PqqmdtJAtcyYBZ1
	 gHl9w5RIV5IjLloHrwbD41AivO4xxBXybVYF4QT9T3tAUpS6gcKTuQ/Lfaxt7jhwOM9e5
	 TYjhGyakT8vYlyJYgX0KKYzvLvPNIly3AkfWr8zZaUY9JeAa0bvBefOpol4/Llrr7Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMp+wEKJrJNWj+fxHchoFjuimM8f2LiG+TyIKxm5hgA=;
	b=EHZenOS38F1OaLG3PoK0s2AHYdmXxKVPavuZYFI7txVGnkXmp2D4e8dzaBVYobJAGEwV
	 xOBJWnmYzd9Ff6Ge8Teg+GIaTAy8ZPXru9H3sxThomkWcVLxMiWPkPXW4j4RVSnwpc8nk
	 ilewt1qAoLSdPunL1gy+LlpJyV1ZFwRHWbWjj5eddb3667QgQwub6tD5qcm4uXCEhGMQr
	 cu4tUCf2rNMWjFBVNTuODSYh99ueVOPh0+CW3DyJ0eqbGki5Oy9PzjHWo7B1EMBnx9+sb
	 XDzWoVV2KUB4XSNHSljS3pEzruFeHYhoYLG8gvtLJpO6lOKAday9k3iwZas3NxIhMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wq5UAPgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D689D606A31C;
	Wed, 18 Nov 2026 21:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wq5UAPgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F561F000C4;
	Wed, 18 Nov 2026 21:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036083;
	bh=lMp+wEKJrJNWj+fxHchoFjuimM8f2LiG+TyIKxm5hgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wq5UAPgTf0cOMKxkWRCoRhhMh0YO+wiD9Xkg9s4TLxTy12OVVcQOhKdje8TmU/w43
	 KDFLOQDni3ocmKf4YNFu8Be5VxWeBEXiB0oGedMR8YuuftLq2fI/mXsArtAAZyR8AK
	 ygjf8FersPZeAtb1BlbMlVgFn1wYTAMgptBhV4xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0934/3318] clk: mvebu: ap-cpu-clk: Assign .num before accessing .hws
Date: Wed, 18 Nov 2026 15:25:56 +0100
Message-ID: <20261118150347.578170025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



