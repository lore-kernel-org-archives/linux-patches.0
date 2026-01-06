Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88093559E1;
	Tue,  6 Jan 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722558; cv=none; b=VT2EFP7gKvgSok2h0C4cs2h2igQSP4nSXtOenILyPnmyowa9Xd8OBX7VBHeljpws1MsqVkIa+UTMUnDkWGOcCjPU8DlgrWO6MrT3Ia/CZFRQ/Zrrj0wvlZknpHpIi4IGA2B2v0N0DAvCxQaq/7Wkj2MZt2VRfZxcJthE9yT5Q9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722558; c=relaxed/simple;
	bh=n+nJl0qP9/8B8WiDw5m8fVx+TdPqHZJUuNukTIxVY+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOH7BCDxBsNB5ZmYJFDfruh4Hep744ZkL1uUse5EyGESgH/4tk49ciFcSQOGEUQx809Obobmzg8NVbOmIz8mIrptu+ViX2Wee7TZWJ2XCxdo+9LzO2YiJcunTdqBYKtt1t9NMnIfZLHVgs1Xv0ypQWbQpTbEDH6C9PsD6Xd2wxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6oKUy3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6oKUy3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CDEC116C6;
	Tue,  6 Jan 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722558;
	bh=n+nJl0qP9/8B8WiDw5m8fVx+TdPqHZJUuNukTIxVY+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6oKUy3HMeFN6SAKuYK/LNLT4CsiQdeG22jtq7kR1kBH66EXqPyMV8IokoOikUeEE
	 zwF4qfCNPDNXLOOh8PtWA3eDb3n3JprH7zxNu32ilfHRowIIqoNxq5GXiVywXISbF0
	 MrPcCHsACUwXAg8DmBZCVU/cLv+sP2sCE1j+RZVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 299/312] drm/msm: add PERFCTR_CNTL to ifpc_reglist
Date: Tue,  6 Jan 2026 18:06:13 +0100
Message-ID: <20260106170558.672965367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

commit 6c6915bfea212d32844b2b7f22bc1aa3669eabc4 upstream.

Previously this register would become 0 after IFPC took place which
broke all usages of counters.

Fixes: a6a0157cc68e ("drm/msm/a6xx: Enable IFPC on Adreno X1-85")
Cc: stable@vger.kernel.org
Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/690960/
Message-ID: <20251127-ifpc_counters-v3-1-fac0a126bc88@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1360,6 +1360,7 @@ static const u32 a750_ifpc_reglist_regs[
 	REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE(2),
 	REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE(3),
 	REG_A6XX_TPL1_BICUBIC_WEIGHTS_TABLE(4),
+	REG_A6XX_RBBM_PERFCTR_CNTL,
 	REG_A6XX_TPL1_NC_MODE_CNTL,
 	REG_A6XX_SP_NC_MODE_CNTL,
 	REG_A6XX_CP_DBG_ECO_CNTL,


