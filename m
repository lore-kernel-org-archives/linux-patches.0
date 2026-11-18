Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061325;
	b=lRmvo02VI1zltjyfEhiRExMkFaz0QPS2yJBCP/UBKdN89OFzeHfZCIW2J1AhZJ0iD9Cn
	 Uq4LPWz4mrrKa3ikMQnTAj7eX+/IBLyllFwDb4W9OqCsAfCkcJ+6l5hSsFZRr9ehE2O1+
	 04quQSXmA/ZeBDkG0nhbmeuf6aGOawAYk5xRBN+FKXPtZGsCQQnSAumogIGpba7BhRpK7
	 J+HuS7F7vxF8WOjz0I5sxBxsh50f5TFeyA2lfZq3PxUM3DfHjcr28JkC6j4lr9oZ9/T4Q
	 GjwuccwPLFOmHkxatHJVirU760SsWw7HbYt7zHC0vQCjj2O/qkUYrfmvYNhduqZYKLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YWSNYQcqdZNu6rOVL4ty4+TlqzJ1+ZMFmOu79LS2pv0=;
	b=twfrvASux5tRJIfE0RMJRhq/3B5szq4Bjg6szkRpFBV5iwmz7Oh+USoFbQXFbF1bQP4h
	 +H0IJIuf8Dhko1Z9jDLlOCbN6V5Jukj1eZ92XfxZTVudITPdJplw+bKtuEqlPFI8LpTet
	 uEuJDvtoRQWdDMJenUW95AtUVqdGa6qA6QEFTFrp4yUnvLYkstLDwIfrMrN/RWhZDZeuG
	 H3ZzQ0/dL38KTnyMCAG52uu+1z0cf7/aiSOloV6quicXTqy9Cv7PxaRSRGct5iPPYFp67
	 Re7EWzPaABKuxmq7AXohMt4BR5S4K9n1TWSu5PDehvj0kQy8QXjM5dbrWsMRnntTpDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gp6C9I74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F51D606A320;
	Thu, 19 Nov 2026 04:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gp6C9I74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B14E1F000C4;
	Thu, 19 Nov 2026 04:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061325;
	bh=YWSNYQcqdZNu6rOVL4ty4+TlqzJ1+ZMFmOu79LS2pv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gp6C9I74Rv3cx56KrL5FCdX7NtybAryb3fu9RJg78oNjDvi3H/1uGokY3b//5UUcw
	 gPIeXSFVr8vn0iNImzbZm5x5LNm9TRs6XqoJ+3YnBGHy5x0vRPADacrVh98M8Or+2b
	 QvYIkml3oAEQZNF1s7R5L3Pf4RIjJicNt6/nkQ0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1470/1848] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:58:28 +0100
Message-ID: <20261118150020.851829477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit fdbe4cae71c8196cd7681ad47254b5b0560d3c1e ]

ddata.cpu is NULL-checked, then immediately passed to dev_err().
Replace with pr_err() to avoid dereferencing NULL.

Fixes: ab0ea257fc58 ("cpufreq: st: Provide runtime initialised driver for ST's platforms")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index c40d3d7d4ea43..f1f931d7b8361 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -265,7 +265,7 @@ static int sti_cpufreq_init(void)
 
 	ddata.cpu = get_cpu_device(0);
 	if (!ddata.cpu) {
-		dev_err(ddata.cpu, "Failed to get device for CPU0\n");
+		pr_err("Failed to get device for CPU0\n");
 		goto skip_voltage_scaling;
 	}
 
@@ -283,7 +283,7 @@ static int sti_cpufreq_init(void)
 		goto register_cpufreq_dt;
 
 skip_voltage_scaling:
-	dev_err(ddata.cpu, "Not doing voltage scaling\n");
+	pr_err("Not doing voltage scaling\n");
 
 register_cpufreq_dt:
 	platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



