Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929B1341047;
	Tue, 16 Dec 2025 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885418; cv=none; b=iNOaD3SCrmA0yP2tWUTYaI1Tbl6t22CO3fu1ZmGQsY01c3jF1mxsiIrvuNSGNxaoh7l1797zFbo+xlMdZoBUGKMbAijY7psRZEaz2IaBRWMDs2akIKvmdlOE+6a+aR6FudQMzhkO/2SWt9pKmZqlqCyCVDxUGxB0FCsmBFuG3k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885418; c=relaxed/simple;
	bh=Ys6yYXhOuvawoVuvgeSJHRp+0kMI6l+QI4gGOe7HmyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SElRpZY0RG6xoJl77fDxeYQBS9uKa/v6M3xJk76q4Eu6QwFJtPjE3+8uX1maUrKX5dAkToopEPLy6a7wINt3LDfJabdVoZft6oKJtWX5K18akUe11WffdEmYCH8Mg8pDFtHbctLp3HkcpN2iW/fC9wm76x+RZ72ITO6ZWUKNhsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtLew5ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtLew5ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88615C16AAE;
	Tue, 16 Dec 2025 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885418;
	bh=Ys6yYXhOuvawoVuvgeSJHRp+0kMI6l+QI4gGOe7HmyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtLew5otFbFNzmu0N1Wrdkn4VniMGr1F9bXDhxeSMxDWkruL/W/qbDpQLmXyax2Ks
	 +Euha2NOWe+QmldmT8xdVAc0irYXYhpPVMmqE6MYuwWkBC+I/Eyyx+OZ2UrO3nDcY9
	 dOr5fjeuz7Aee6hpQeYEBDUqM0mlFZxHmBqf1Kjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Martinz <amartinz@shiftphones.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 100/507] arm64: dts: qcom: qcm6490-shift-otter: Add missing reserved-memory
Date: Tue, 16 Dec 2025 12:09:01 +0100
Message-ID: <20251216111349.162766513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Martinz <amartinz@shiftphones.com>

[ Upstream commit f404fdcb50021fdad6bc734d69468cc777901a80 ]

It seems we also need to reserve a region of 81 MiB called "removed_mem"
otherwise we can easily hit memory errors with higher RAM usage.

Fixes: 249666e34c24 ("arm64: dts: qcom: add QCM6490 SHIFTphone 8")
Signed-off-by: Alexander Martinz <amartinz@shiftphones.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251009-otter-further-bringup-v2-3-5bb2f4a02cea@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
index b9a0f7ac4d9c9..3fe4e8b763343 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
@@ -118,6 +118,11 @@ cdsp_mem: cdsp@88f00000 {
 			no-map;
 		};
 
+		removed_mem: removed@c0000000 {
+			reg = <0x0 0xc0000000 0x0 0x5100000>;
+			no-map;
+		};
+
 		rmtfs_mem: rmtfs@f8500000 {
 			compatible = "qcom,rmtfs-mem";
 			reg = <0x0 0xf8500000 0x0 0x600000>;
-- 
2.51.0



