Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506533016E1;
	Sat, 30 May 2026 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161284; cv=none; b=ZTKg3ExncXrpptrpnoQcHJO8YWROym0gI1Z4rPCskjC73ACAcjsTSWNqowW7w9O0iHqUWelLNYSYXQ21d6YZmciLayajz9m+bubzYAeQYarf0AAzow1nvL3D2Ldun9sK/0Yaeo71iOL48l6uXRo3ByzAEHv4IRqtiCei+91DDJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161284; c=relaxed/simple;
	bh=YEsSm5riBhu509Hoe0Owyx/1tVT86HpkU8qSS5vTFVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXMF7jFYFk3cmHrgHBzkNWAHT6RlXz9L2Fvfy+/KmqKSzbZzC4FB0WS0wWBkPF6JSJCKQhjbDA2g6Z5cSHqEb/zdjzzZgTs6UUGqG2A8Iehr0AstoF66qkY9h87TJeidLcSJB/afDjMrILuqiTqa7JWEdSFybZz2PpfeA9BDPUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRYmF6iB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRYmF6iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C0D1F00893;
	Sat, 30 May 2026 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161283;
	bh=kI3v/U6isZXARt6IsBoK7rdKtPEsb/jb/K8gSRCkCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRYmF6iBDbYc+coLhv5wo69xBbBhe7M4y+U+rDZl/kGE+nJXaJFMs+GC141RkQd+v
	 R9FIqXiGzt78RouA60K8x1ghCJd+FHfJA2h4Trghd6Tv1nnDVGF+nyhXtuS9KaWh0g
	 zaKVS+38bd4/KhBWa2LjWc6aj7NHuMHWoVoSHnC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 579/969] soc: qcom: ocmem: register reasons for probe deferrals
Date: Sat, 30 May 2026 18:01:43 +0200
Message-ID: <20260530160316.395992600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 9dfd69cd89cd6afa4723be9098979abeef3bb8c6 ]

Instead of printing messages to the dmesg, let the message be recorded
as a reason for the OCMEM client deferral.

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-2-ad9bcae44763@oss.qualcomm.com
[bjorn: s/ERR_PTR(dev_err_probe)/dev_err_ptr_probe/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index a8a0d89ab01b9..087271120ce3e 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -202,10 +202,10 @@ struct ocmem *of_get_ocmem(struct device *dev)
 	}
 
 	pdev = of_find_device_by_node(devnode->parent);
-	if (!pdev) {
-		dev_err(dev, "Cannot find device node %s\n", devnode->name);
-		return ERR_PTR(-EPROBE_DEFER);
-	}
+	if (!pdev)
+		return dev_err_ptr_probe(dev, -EPROBE_DEFER,
+					 "Cannot find device node %s\n",
+					 devnode->name);
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-- 
2.53.0



