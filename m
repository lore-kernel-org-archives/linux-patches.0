Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0332224F6;
	Tue,  8 Apr 2025 11:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111280; cv=none; b=GNbPp5Xcf5nJZkdl2ZwQAorOe0OaK2JMGXgrAxyMtjTvXtN2iUEgfH9UzzulPx40NL8niN3McTRVOSV074jH1mg/TeOL0qNYK+iRx5+q+5FJgmueRY8DkAQSlVslM3QjxCvLD2x10pqabxwoN588+ks2RYWTnhAFOXkzTISK2ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111280; c=relaxed/simple;
	bh=gMuS2giU5Zv3pgjvI/vUzc2GZ5QwmVqLKnArB42eRzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4hTWhJ3Yno8MOVkTaFxmioDUXiRpbV/XZObVqIgTjg8xM7fnAS74quWvwnGdkeG58kp7lg0A04vH3X9gPvrFNuIdcFNiYccXdR3SNQmAtpkrbDaB8zpP3hvfntuYKrhv+INIOWgM0B8EgX9I8mpPKuHQjwvgLDzAz5m0MNBt0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1p2Evwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1p2Evwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821EFC4CEE5;
	Tue,  8 Apr 2025 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111279;
	bh=gMuS2giU5Zv3pgjvI/vUzc2GZ5QwmVqLKnArB42eRzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1p2EvwkxMgMI2QVbjlWkiZVtLZNgTZYBCKcE7NCCjPio+9Jf7A0Heyo2GYJLFZB7
	 LLAn3LSkUND8hfwCua7a/5JqpuUAWPycF59X62jVTRw7f4Qlewg9NyxXlubPf0hgSo
	 PJXbmhqEqEV2jdCplizEFWW9St4gBJjOzgGkK3IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 373/731] remoteproc: qcom: pas: add minidump_id to SC7280 WPSS
Date: Tue,  8 Apr 2025 12:44:30 +0200
Message-ID: <20250408104922.953333947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit d2909538bff0189d4d038f4e903c70be5f5c2bfc ]

Add the minidump ID to the wpss resources, based on msm-5.4 devicetree.

Fixes: 300ed425dfa9 ("remoteproc: qcom_q6v5_pas: Add SC7280 ADSP, CDSP & WPSS")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20250314-sc7280-wpss-minidump-v1-1-d869d53fd432@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 78484ed9b6c85..9f2d9b4be2790 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1348,6 +1348,7 @@ static const struct adsp_data sc7280_wpss_resource = {
 	.crash_reason_smem = 626,
 	.firmware_name = "wpss.mdt",
 	.pas_id = 6,
+	.minidump_id = 4,
 	.auto_boot = false,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.39.5



