Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD7A1C4EF9;
	Tue, 27 Aug 2024 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770063; cv=none; b=TYGFtIpKM9aV/vQs+ErBDNEr/9GlWy+/dPxGfeHDsoMgGzS40q9W5jWrdzwFJpldOsMGD0+n2FgCSoLaPb2jgc7+ksxZLkxrdzNwhxiomr0MJOgptfx9ElcJRBspkEbfJSIZP4gWeiOTXQPu3l/SO5WTvDP0s9UBLOtn+iViGv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770063; c=relaxed/simple;
	bh=Tz+9PWVguUx9sXKc3LHUtbgPNKKcO6SD73exaz3w2Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq7nDHuAeA8fAygfMTvWXLg57gGOWxxaTO7KlLhvRjAASho9EWGUqvnz7ljDA0W8bE+YOG0puMBYBGKxfVRVc59MdwB6sc3Ljqx8QUUkzBzFpmu7djzwT7Ey7al5GTov6lUYuu/8EH7d8AieRmOOgPs+tGELm+pCr3jKq/XjGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA7IPGe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA7IPGe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C0DC61040;
	Tue, 27 Aug 2024 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770063;
	bh=Tz+9PWVguUx9sXKc3LHUtbgPNKKcO6SD73exaz3w2Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wA7IPGe9gYcMKsyngFFLY1NowOTWDWbXbmEPZQ6gmrAs/l3u7aej24Z0tPY7l3mB8
	 s/9HvyneicEpDif20bA/bMTpUbvGIW5M2b9emSRUFVFU959NH1p4wmmDujLxpbFoqI
	 mnmX0MnJK0g+RHmF06nagJuBjR+JRBtlhjAc5ovQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ofir Bitton <obitton@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/341] accel/habanalabs/gaudi2: unsecure tpc count registers
Date: Tue, 27 Aug 2024 16:35:46 +0200
Message-ID: <20240827143847.789065628@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit 1e3a78270b4ec1c8c177eb310c08128d52137a69 ]

As TPC kernels now must use those registers we unsecure them.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2_security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2_security.c b/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
index 2742b1f801eb2..908710524dc9e 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
@@ -1601,6 +1601,7 @@ static const u32 gaudi2_pb_dcr0_tpc0_unsecured_regs[] = {
 	mmDCORE0_TPC0_CFG_KERNEL_SRF_30,
 	mmDCORE0_TPC0_CFG_KERNEL_SRF_31,
 	mmDCORE0_TPC0_CFG_TPC_SB_L0CD,
+	mmDCORE0_TPC0_CFG_TPC_COUNT,
 	mmDCORE0_TPC0_CFG_TPC_ID,
 	mmDCORE0_TPC0_CFG_QM_KERNEL_ID_INC,
 	mmDCORE0_TPC0_CFG_QM_TID_BASE_SIZE_HIGH_DIM_0,
-- 
2.43.0



