Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6813D446C9;
	Tue, 20 Feb 2024 21:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464743; cv=none; b=OQ82dDntYS301u88uzYWq0foDVpijoV7jDfU1PcN2+NM0ioKpHwdHB0FPS2Sgkr/atsd2VTsfsKEto075p3RBKrg5EFQ6WUgWo3H0ScGpa+fsbc03jmEsD6lhT1ZWMbtXOGru9lMOMmhdtuBAujDCiVZj1sMc3R5T7zmqgWrzlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464743; c=relaxed/simple;
	bh=MZJ9pBLm1pnFXQWXpvBJxmvpM/Ie7yATLlQhaZ0KQsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOGEdYTk1z1sZboYmmXnk4gv6IUNqMaAsB1fk6Q6ug+vkUdsCHWwZAj6L0kl8BmMbfP0ZosJDXMp0wsQSZ6TLeo8/R2ix+DlXVFb0IvO0sDgGihu4lMzjhYDXqqR73zAyUAs15ohfXzhBKhUwGqIjafBhSReFKxl+xi26NxBDL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf4Earz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf4Earz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA382C433F1;
	Tue, 20 Feb 2024 21:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464743;
	bh=MZJ9pBLm1pnFXQWXpvBJxmvpM/Ie7yATLlQhaZ0KQsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf4Earz2HD3IH1bGBDe0is7m7rI7q/PPaiVSecrNCu4AAkAlcBWo9LIcxfNUKq086
	 pw2u6YUSnbSln+Y0j2eSeKmnBwRvhjBAr+dO7WUY/fL0AuzaPnzZIpihu2zuYMkl8r
	 Pwll79p+zkAMvVa5fZKTob7nf4AB7tD+P27Zyqns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 095/309] interconnect: qcom: sc8180x: Mark CO0 BCM keepalive
Date: Tue, 20 Feb 2024 21:54:14 +0100
Message-ID: <20240220205636.165420146@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 85e985a4f46e462a37f1875cb74ed380e7c0c2e0 ]

The CO0 BCM needs to be up at all times, otherwise some hardware (like
the UFS controller) loses its connection to the rest of the SoC,
resulting in a hang of the platform, accompanied by a spectacular
logspam.

Mark it as keepalive to prevent such cases.

Fixes: 9c8c6bac1ae8 ("interconnect: qcom: Add SC8180x providers")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231214-topic-sc8180_fixes-v1-1-421904863006@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8180x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8180x.c b/drivers/interconnect/qcom/sc8180x.c
index 20331e119beb..03d626776ba1 100644
--- a/drivers/interconnect/qcom/sc8180x.c
+++ b/drivers/interconnect/qcom/sc8180x.c
@@ -1372,6 +1372,7 @@ static struct qcom_icc_bcm bcm_mm0 = {
 
 static struct qcom_icc_bcm bcm_co0 = {
 	.name = "CO0",
+	.keepalive = true,
 	.num_nodes = 1,
 	.nodes = { &slv_qns_cdsp_mem_noc }
 };
-- 
2.43.0



