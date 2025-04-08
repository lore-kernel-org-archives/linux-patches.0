Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A996426A1D7;
	Tue,  8 Apr 2025 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116369; cv=none; b=tuRAa1WflDcrGTfSQ47DtE1aRnQrbbaA02YXU8Sy7rSAhvbd08oAv/l6I23qeUrBNsUV5rhKHOFSy7+jlt3U0cOgtWyBGwMjXLpXevxcN8uFhd1GW/6jEmVdLBpbJ9o5FETOe7m8zhnuFwQiaMihTCET2jGzJnKKpOcqqNk+awA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116369; c=relaxed/simple;
	bh=EECFcvkclJAZlxv7m2RZCPCMN9vSZ3d12Qf7yXfgf7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOqxHWOviWP6uBIRJgegsN7SkSU5S5JG9M8LXiHx6SK0M8W3WfN34rbm/ANJ34pgDzZFtxfi478XiSjA9GVrc6FsIPD42nPWDcWTfV9FWXNR8oAZt+jdYJHkRGzMmTgxXuRkjSi1sMI3eRJOfJX14Hsrx7fsTrOTRbUzhDjzYS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwLJMh1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwLJMh1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D017C4CEE5;
	Tue,  8 Apr 2025 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116369;
	bh=EECFcvkclJAZlxv7m2RZCPCMN9vSZ3d12Qf7yXfgf7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwLJMh1TUZ7jemulKPwXg/MjN7d8Ol9rfspnNDW5WEydVWmjZVZ4eRAoiD3/NVPS4
	 sUgnWg6Dq5UhfNTacOjuFveMIG/ljf/OryiLsZ4qmAycK8Ywezov4tQeTCxEolSaJ/
	 H1j3Ks51ASHZBSL/PiKQOWisnhuokul4SRw2hJwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/423] remoteproc: qcom: pas: add minidump_id to SC7280 WPSS
Date: Tue,  8 Apr 2025 12:47:21 +0200
Message-ID: <20250408104848.409031173@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 179a0afd5fe6f..a1636bbf36118 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1356,6 +1356,7 @@ static const struct adsp_data sc7280_wpss_resource = {
 	.crash_reason_smem = 626,
 	.firmware_name = "wpss.mdt",
 	.pas_id = 6,
+	.minidump_id = 4,
 	.auto_boot = false,
 	.proxy_pd_names = (char*[]){
 		"cx",
-- 
2.39.5



