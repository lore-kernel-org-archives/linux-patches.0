Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829751;
	b=U9dqoeiCm/Fslf7rWXZBcr/xiEFL22O1gWS4AKTxR4Qhzv3VNFnyQ/zjgU9iK9a+1LSB
	 EPHlry5/klQ0IOYQDzLk/LoFf7/KbB3Uat+5UzMCs9aUsQtFWCsuNRCifDFJ98mHaFuuB
	 MQozYX8D/y/dbPKckCPfHccvMg5MNTMYjCDfEBSAd5aSPKIC7USZ868F5LgKEmuHVyZLf
	 nUdP2aAPZiedkUIbMIEdhFkenRDU7myvkNETpTaBFoCRmW0RN7ESyMPz9sMiz3RkrjOsR
	 Zxhq3xiZP62ewpW+iC5OS9RY1uBv3rbzNal26/KiRMR9dlJ54gvKWjAbiHUxi+RnTFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=81+UKNWBJx9ebP+taKXIwtSIBonrE1+fbzchrdkRh6w=;
	b=bcKaAmujlcZjK9Dg1cVYxuSE2LM3Or5LHOUGvmnmlamLmZ2pwiVTzS3SZH6imoh4mtII
	 F8AJoi9sG9VPLocoxC8wrSTgvuDRgW4kjTc1zwoZLgRFLrvCxEVXkA2w5Xku+nxM1nwtO
	 xIzEb3n5C0cwcCJMh03VE/9tbnbvS/nFpLpClcMQLjH5GvI7r4DIht/HmBUcqHFfLIABe
	 Esr9p4ZdIsD6azN9D4BvM+Dl55E4p3wHt4IDd+LS7+oeVEuQCZfnt+d5Rl60H7FOW7sDD
	 dXz/TT9rHc5eqxwNMiDz3Qc3rurvhiVp5AP+wDgNniH6B6/wjADj8FafVXYF87BIe4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7RZXo+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A51606C5AD;
	Wed,  4 Nov 2026 22:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7RZXo+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C88B1F0093A;
	Wed,  4 Nov 2026 22:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829750;
	bh=81+UKNWBJx9ebP+taKXIwtSIBonrE1+fbzchrdkRh6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7RZXo+Srh6RI/Tsfj3N1BCrHGz86o6Edc5iUuQJAvYmNcoKcxxhMBzUFWaZ/sCMC
	 3TGjccI+hyprUEP+uBnBQvWFaf2MSqNrwnLKD2R7AZa/ZgRSD6YLywGz+D6Y29FjQ1
	 u1jXNSUMAqpHZUKlQzUMfuwhYw4Xno9IhW0D50Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0303/1005] perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove
Date: Wed,  4 Nov 2026 16:00:36 -0500
Message-ID: <20261104211052.408585126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 72ac17efd846a..9974b62541f0d 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -1088,6 +1088,12 @@ static void cn10k_ddr_perf_remove(struct platform_device *pdev)
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



