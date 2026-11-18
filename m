Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055745;
	b=G6yLjoGuJwpHRru/Fiu/5C7SdVkQuS7M7kdcGfctLXgmpkRnbE4QVrNNj4Gcugi/4a9x
	 vDQU1Ykns3OmR6E/5JENU/VNtgs0DIRVLa+pOqg8ZGThf+g/cTxFRPi+XUrfbTGoZJRnL
	 07bEpitjJtxVZYnlMfGbgwHCbz0h2uZ6R8lJchU+Vm+HvXqQmdX+2/XwZFjh8irEEg46E
	 IRildYGY7xm5ITO14/BSwtdgclTe1OwGG1UB0quGDkesILWzK+1KGHXhfZK+h4BC8JssT
	 NckGLNebhOQVFcz4wh/NTAD+k/U3dt6ZCCsI8gSVsJ2c5HYo3l10x3DETnRSOJQJJYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ELHh66z8ANUX3oG5n5CT+yxA3D/3UCJ9+9VIj9tekd0=;
	b=aV7CxD1N7xkI9DvS/5A/T67c+jxKLlZ2C8Ly3woB+BYZiOnbQsSodhQ2qeTx7FD/yLRd
	 q2k16eVJTcCB0AEoLoJtz+un8B2XC8P/HT5u90YAtJRx7TVz458dawBG/GsKbpZE4Ohe8
	 JmnYyTqRlYGkLHJvLmRv7YnMLLws/qCl8tHUC9q2VsQLh9CAgdl3z7c74sjlXGBlfUeRV
	 MzzTk03dOTqyHqAfqIm8dNYUv9zWzXcdC89GJ4cr6pWNcH7ntoh++AphJMjgdy6U0GXMg
	 o7wLiMTYbiCsCTAL85+3dokkz3ZSa1P5Bkyj9KJjBuMWjzCuhOazpBAOOxBPUkRc32Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UN8ptrWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67F0606A31C;
	Thu, 19 Nov 2026 02:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UN8ptrWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFFF1F000C4;
	Thu, 19 Nov 2026 02:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055745;
	bh=ELHh66z8ANUX3oG5n5CT+yxA3D/3UCJ9+9VIj9tekd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UN8ptrWS/yyC05DfiISSxJOwUlxKLx4j9XjDwwKmn1zUc8mcZMGRk07qvoIoG2+r4
	 GB9PJh9CnRM1LdI6RV116KaRU8emkvg7QC9+se+Zxm/4pYooSLg7kb0DRnM63v7RNm
	 nc3f39XkaUpw4UuwjyO12ej7C9EDgIhTzsJYQey0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1742/2214] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150121.323512676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1cde44670689..fa65cd018e12d 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -270,7 +270,7 @@ static int sti_cpufreq_init(void)
 
 	ddata.cpu = get_cpu_device(0);
 	if (!ddata.cpu) {
-		dev_err(ddata.cpu, "Failed to get device for CPU0\n");
+		pr_err("Failed to get device for CPU0\n");
 		goto skip_voltage_scaling;
 	}
 
@@ -288,7 +288,7 @@ static int sti_cpufreq_init(void)
 		goto register_cpufreq_dt;
 
 skip_voltage_scaling:
-	dev_err(ddata.cpu, "Not doing voltage scaling\n");
+	pr_err("Not doing voltage scaling\n");
 
 register_cpufreq_dt:
 	platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



