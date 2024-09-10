Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F452190499;
	Tue, 10 Sep 2024 10:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964100; cv=none; b=rqh1wwp4QztLyXQBZaBbLZ5wKtlbcdgavxq3Zok1ynUqJ1vsCeyp69pJqusF+sO0TpdsBb6IRB63kN5sueBGYhCgJgtu+5V+gaRXhSXJriokL2/vnYA4l510SQKT/PlPYn4vDqrksYfXXJ5YFVq0ikOzC0aTxseQjtga1WoyvLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964100; c=relaxed/simple;
	bh=lzoGLK6rybLUCl0AWEPbdoBXMORpDIhHfTci+AZKils=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek/fjIfTZbBxpiJJaNwbJXEb+S3Rlfstb16AExJP+oHOOo/Ors+OKdj4j8nL9X+plluGiyae7hk2YyW2TJpP26FmzW2w4A8kmQByNoUiz1L/6TFzexMwbxzo+65ENOYzORudwyRNfaEIHiz/3aF9Ij3ZCSSVvLw8bj2Z+tMSdZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/lt3YdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/lt3YdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955BEC4CEC3;
	Tue, 10 Sep 2024 10:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964100;
	bh=lzoGLK6rybLUCl0AWEPbdoBXMORpDIhHfTci+AZKils=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/lt3YdIQO0ZrinjCYCI6sqWUIP+w8MVXBvqDRQS6cg9xIYI7nIsnK5MiHSCKgq+Y
	 QSswCmj9anLurVZ6FkiIYvBJ1BckOAxx6rJLtMd9jjrJx9lQJ0DqjTbkIBKEWoqYpX
	 EirRA9jeAvvCVGjj2MUIbJUX6dDRUZPd0yMQZQww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Ughreja <rughreja@habana.ai>,
	Ofir Bitton <obitton@habana.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/269] accel/habanalabs/gaudi2: unsecure edma max outstanding register
Date: Tue, 10 Sep 2024 11:30:55 +0200
Message-ID: <20240910092610.621961244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Rakesh Ughreja <rughreja@habana.ai>

[ Upstream commit 3309887c6ff8ca2ac05a74e1ee5d1c44829f63f2 ]

Netowrk EDMAs uses more outstanding transfers so this needs to be
programmed by EDMA firmware.

Signed-off-by: Rakesh Ughreja <rughreja@habana.ai>
Reviewed-by: Ofir Bitton <obitton@habana.ai>
Signed-off-by: Ofir Bitton <obitton@habana.ai>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2_security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2_security.c b/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
index 908710524dc9..493e556cd31b 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2_security.c
@@ -479,6 +479,7 @@ static const u32 gaudi2_pb_dcr0_edma0_unsecured_regs[] = {
 	mmDCORE0_EDMA0_CORE_CTX_TE_NUMROWS,
 	mmDCORE0_EDMA0_CORE_CTX_IDX,
 	mmDCORE0_EDMA0_CORE_CTX_IDX_INC,
+	mmDCORE0_EDMA0_CORE_WR_COMP_MAX_OUTSTAND,
 	mmDCORE0_EDMA0_CORE_RD_LBW_RATE_LIM_CFG,
 	mmDCORE0_EDMA0_QM_CQ_CFG0_0,
 	mmDCORE0_EDMA0_QM_CQ_CFG0_1,
-- 
2.43.0



