Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10006311592;
	Tue,  2 Sep 2025 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820216; cv=none; b=RWNgF+w7FOzMef8JdBhsR2KRyymWxNHaTHhfejshBByMID956dx5GTUNekw3WdpQdwH5yGO/JCmNnQyWCbmB0mFA6Di+k6MQCAnAPFOOLol5PDbGizxt0Zu2P7MUFjWyq68jBcbQUj1ySe7YkONT4+NtLPksxVFs8fPrrcTBHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820216; c=relaxed/simple;
	bh=eGqLdxRHdMfnATTVcXiihtAFcPCsn+uPLpkR6psEVTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN6uZhlYR06XzazBL42NdWw2Qv9+PKCVtev4pr5N0ddsXPdnVvybf6/3rsr/mDOCcOc32Q/EuTEGjTXsrq1KhgSo/V2D0zHvNuRGOTUSL8CaBN6iRE3I01fS3yTGEEXAM9hJxMwi7vBsKtRRki5Z60obh8V1rD3dQxqyhV/46sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DczUr6oE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DczUr6oE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8912FC4CEED;
	Tue,  2 Sep 2025 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820215;
	bh=eGqLdxRHdMfnATTVcXiihtAFcPCsn+uPLpkR6psEVTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DczUr6oE66exOhhmu+2vYo5BKEuPXfPAWK9xbFtopXYyDRFBBvF7U5OzKWtqRrayc
	 yl0pW8E7/DMWpjcRvqKR/bI/ceRt05sMTmwU+pPxZzi9B/DWrsfGjmdZsiWqd7qn+G
	 31EfPHZ8rzkAj7eTxIOg1Ooj/h7Bsz3SBgzzcVwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/75] dt-bindings: display/msm: qcom,mdp5: drop lut clock
Date: Tue,  2 Sep 2025 15:20:45 +0200
Message-ID: <20250902131936.422325327@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7ab3b7579a6d2660a3425b9ea93b9a140b07f49c ]

None of MDP5 platforms have a LUT clock on the display-controller, it
was added by the mistake. Drop it, fixing DT warnings on MSM8976 /
MSM8956 platforms. Technically it's an ABI break, but no other platforms
are affected.

Fixes: 385c8ac763b3 ("dt-bindings: display/msm: convert MDP5 schema to YAML format")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/667822/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml b/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
index 91c774f106ceb..ab1196d1ec2dd 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
@@ -59,7 +59,6 @@ properties:
           - const: bus
           - const: core
           - const: vsync
-          - const: lut
           - const: tbu
           - const: tbu_rt
         # MSM8996 has additional iommu clock
-- 
2.50.1



