Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72F344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301698; cv=none; b=COJ9T17JxZTp8ljUouIr+BQpKo3pg1C9noOPoMaQDe7A51yQRt3BMZa+gZOVRMXyVbviIjmGShbv0ESC+vljcpiUuH+hVZNeml6qcXdJvvQ1GHa3EhvixPHiBKqJOwT8Utazfot2y7xzh1p9w+kcw+6VKxbDZorAAo3wXfhESJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301698; c=relaxed/simple;
	bh=qjnaR7bSYY7K4Ij8tTONdCZjgXAvSowkI6az04epq5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZXVDnkhUruON/EwgloPOkDdGgguClUGQ1BSYQYzo+BYUMJETXdRlJoyx3tIbN9R0T5KjjfwjespT6FYad3Jp97zEKXr1qGBjTzJB0mVR6q3LqMQNBbkngHi7ki7Res07cWOhDF1EDVVLzN34ObKd9yTLkBTtrWcMc+0x/2IWHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBb19Xkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBb19Xkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3963DC19423;
	Sat, 28 Feb 2026 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301698;
	bh=qjnaR7bSYY7K4Ij8tTONdCZjgXAvSowkI6az04epq5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBb19Xkl+shPez4RpNpWi575V/2q8c0lFBvQnw9INN0APumLVDwcBXNeNA7tcT71h
	 6rNdOr5cueJwcLQQz43N7nIoV+SeIGqDAp11RAtHKIquzAbI/pQvNZzKHwqCdk7tXw
	 n3B/IljIJz5Tj9lP8OXPl/coBs08PG5rglhP0oOmE3wxcW4xwqGlf9w56Fjh3jvCag
	 JWVHt0tOP0BeYk5Z2Ief7uk19lYbtEv3HKcIdqaTZG1ynL9hewJLrov6ntz0XLx4uZ
	 LM9KLvYh0ScYBJ/rHnpp7yI36sOO37cn0205kliuGM5dhVChxjV3PreYYXtCRE7PXb
	 lqnmxPhPbmxIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/385] soc: qcom: smem: handle ENOMEM error during probe
Date: Sat, 28 Feb 2026 12:55:13 -0500
Message-ID: <20260228180011.1568201-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

[ Upstream commit 0fe01a7955f4fef97e7cc6d14bfc5931c660402b ]

Fail the driver probe if the region can't be mapped

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251209074610.3751781-1-jorge.ramirez@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 170f88ce0e50e..493e218c5fd4e 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -1211,7 +1211,9 @@ static int qcom_smem_probe(struct platform_device *pdev)
 		smem->item_count = qcom_smem_get_item_count(smem);
 		break;
 	case SMEM_GLOBAL_HEAP_VERSION:
-		qcom_smem_map_global(smem, size);
+		ret = qcom_smem_map_global(smem, size);
+		if (ret < 0)
+			return ret;
 		smem->item_count = SMEM_ITEM_COUNT;
 		break;
 	default:
-- 
2.51.0

