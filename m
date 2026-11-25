Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620387;
	b=ZsTCND6Pubt4Ey873vIRggj+xwa+LoaGlX7O3ANaK2yTGp4lmUItSeSo3CN9+6NKuBBq
	 dBB3Hd6poaZ5b3abZgNL013Dr4Ppo/l5j3eRQedN9yxnfeOBL0g+RNQD/IHhqqsHb6pE4
	 3CAkXOvU73xN/JJogr4awML+jvhgspOzug2AArEsLuLOlPJgN/SQqVShBnxWdjhjyMC+C
	 hpZL4Wg6BNkQbzKkNIEY0kfHJl2lyuHTzICY616S+3qLx5ApUfxO9iiJQAwYRvVrjvaDn
	 DX5wX/FmL9bwBAhD5o0eoYoA4N3EEVuvjZnRcG57qTfyvTPCnZufYxhYLFyvQwzWqZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hvaen/WgY8vuebIcUsQEEw6iXZKWmTJDJKRthKfqb2U=;
	b=SGRBA+thCJSdDgJ8ty3eBMUp9AvGhxvtWpegX4HZSN3iUh0iT/pw6hfozQ2KeZOE2Oeu
	 31t4yEvye8TcKoEKjv/JbxSdvuqBn8W9jpTg9BNLCasLhAhpBUfQENGQRKBdL1rmwAO1Y
	 uUDN/Mozsc7ery2AZyFJ9SGS1xKVfkk6e82x+pcDlNQ89wt6pZrsa9bT/Sipt2tL/j5wR
	 gYb77/2+KM7DGcrEievflRgQkbdYSfplSNRE+KlpH3ldbYg6aBiYxfXA5XXf9ygSFQT4U
	 cCQxtyStIVdPdSeUoySRCAHLFnF31lbFKrQMYUssdKWLaRXS7nDJkWy6g0hfhcZWrcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZEuxnsU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44239606A321;
	Wed, 25 Nov 2026 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZEuxnsU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B2E1F000CF;
	Wed, 25 Nov 2026 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620386;
	bh=Hvaen/WgY8vuebIcUsQEEw6iXZKWmTJDJKRthKfqb2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZEuxnsU0kfsbXD9zFI1FeXhtaYG5M2qoKIk/tvYnP3pjdOmsCX5j6qQx/nbLee0Q
	 R0hnYPbh6Mq+Wtp5b4ba6PzrtzYtrJIG7kpaKSlXn3ts2FL4DBXAlPUy/LUaNGzbAm
	 LE1d1kxSl5S2PsiitTiTX35PMTqzv3JLKZ43pnPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 7.3 0901/1005] misc: ibmvmc: initialize HMC state before device registration
Date: Wed, 25 Nov 2026 15:37:19 +0100
Message-ID: <20261125143842.798878557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 2022f170e5655c40b93ed98629f7d0adb98cea49 upstream.

misc_register() exposes the IBM VMC device before the HMC state and
spinlocks are initialized. A userspace operation racing module
initialization can therefore access an HMC through an uninitialized
spinlock.

Initialize all HMC state before registering the misc device.

Fixes: 0eca353e7ae7 ("misc: IBM Virtual Management Channel Driver (VMC)")
Cc: stable <stable@kernel.org>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261028044828.96177-5-yaojiale02@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmvmc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2365,14 +2365,6 @@ static int __init ibmvmc_module_init(voi
 	ibmvmc.state = ibmvmc_state_initial;
 	pr_info("ibmvmc: version %s\n", IBMVMC_DRIVER_VERSION);
 
-	rc = misc_register(&ibmvmc_miscdev);
-	if (rc) {
-		pr_err("ibmvmc: misc registration failed\n");
-		goto misc_register_failed;
-	}
-	pr_info("ibmvmc: node %d:%d\n", MISC_MAJOR,
-		ibmvmc_miscdev.minor);
-
 	/* Initialize data structures */
 	memset(hmcs, 0, sizeof(struct ibmvmc_hmc) * MAX_HMCS);
 	for (i = 0; i < MAX_HMCS; i++) {
@@ -2382,6 +2374,14 @@ static int __init ibmvmc_module_init(voi
 			hmcs[i].queue_outbound_msgs[j] = VMC_INVALID_BUFFER_ID;
 	}
 
+	rc = misc_register(&ibmvmc_miscdev);
+	if (rc) {
+		pr_err("ibmvmc: misc registration failed\n");
+		goto misc_register_failed;
+	}
+	pr_info("ibmvmc: node %d:%d\n", MISC_MAJOR,
+		ibmvmc_miscdev.minor);
+
 	/* Sanity check module parms */
 	ibmvmc_scrub_module_parms();
 


