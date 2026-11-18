Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034099;
	b=WEOCD+Co04X0Cn1E/W4borV5wIUr1HYwN6n4R+46isV5dx7IO4x/+feUSoEEUIXjEIHV
	 nfkpWVrxh8G+ZUI3I2YnDrlN5kHf2qT96b6w8jiVV7zPGw1ehOaeK8Id/kObHAlNe9hqZ
	 qv4Z0ewvJbpdLQ4JTNtl+AS1/USVKj+EUX8vdTZbiZ4tJuW+HE7ewFnYhFBOdR2npZ+yC
	 4O1rozRoYa7i7vEyhlRUBm80ORLQdtL1Y/BQvqmud9GP8p/AOo2KpNwn0saF3SQjWRaNG
	 U+6gd/8ezXt3bvRzic/+dMQ6axjWLuvPGKEgyT8ujFc4/TXCZB5M+7lWxwkmp/n+BUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=js0aE0SagAUBz+0lBDOiV0277UUljF8/JHJm3oMUliA=;
	b=PEDI+8UUA2Hl4olin21mBYQCEiZRpMrj+rmjUaMiG1TPXcur5vJlHVFqg//QztdZLiEh
	 3R86AjpFDf4IrKX4Tx7rWpRQP2GhloflC6XcVrKuD1XVhjF6q+OkqDviMcpQ8hl+8qWU6
	 am+w6YrOHJc998fIOTc4tK2kL/wI1o17K5T3vzQVkDQHvjNdNDCuoEgpcuNwmaut3gT2U
	 ASQuYoHP6P31huANM1PlatvwLIMDHYo6QYU9wRfH2PY5HNUJCB+RumLxawRiSC8mDqlUt
	 Cihr/IrBx8Dgv+RtQ5bWuBFIrojf5c7f364vTlJS7hANOfbcB4favramMyyxOtgSPfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBxylyml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29E5606A31C;
	Wed, 18 Nov 2026 20:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBxylyml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455031F000C4;
	Wed, 18 Nov 2026 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034098;
	bh=js0aE0SagAUBz+0lBDOiV0277UUljF8/JHJm3oMUliA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBxylymltz0V9yKBgVlSRQ3JTXlZ9vi013IcFqxNy4F2zuNJQAXCebVHY13jkfqcl
	 9a6Zfxz3Dgg0ObhlwM6oFdZydlt5K7VbV6rXkuZNxH6h/Ow8ZE1IkvtFCXs1C8z0ii
	 6nlK42w3sIejyLQAnIYYNaAT4rj754a1STzJ50u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0209/3318] perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove
Date: Wed, 18 Nov 2026 15:13:51 +0100
Message-ID: <20261118150321.189416541@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 7dbcb0268d1e2a1d3badb0c6e77ee70e550b1787 ]

cn10k_ddr_perf_remove() did not cancel the poll hrtimer before returning.
If the device was unbound while perf events were still active the timer
callback could run post-free.

To fix the issue by adding hrtimer_cancel() in remove().

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_ddr_pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
index 524ba82bfce2c..d8fa0a6634578 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -701,6 +701,12 @@ static int cn10k_ddr_perf_remove(struct platform_device *pdev)
 {
 	struct cn10k_ddr_pmu *ddr_pmu = platform_get_drvdata(pdev);
 
+	/*
+	 * Cancel the poll timer before further teardown so the handler
+	 * cannot run after this function returns.
+	 */
+	hrtimer_cancel(&ddr_pmu->hrtimer);
+
 	cpuhp_state_remove_instance_nocalls(
 				CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE,
 				&ddr_pmu->node);
-- 
2.53.0



