Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946A3F9D2;
	Tue, 12 Aug 2025 18:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022131; cv=none; b=VzGX6Yn2bN/pWE02TLIwGjDmNCkMJB6qDP7wfcTu73BnM5cZLtAV9ulhvfmXeO/WJd01Uw1bTs/nHTZ5CoPuMLjOfxoV2SxxuWtiQUD8jRjRLNxfBj5YCE8ADdKZe76pB63l++YRthXo1kLwC1uQuZuBdAPPfA4hRQJwzjB/PqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022131; c=relaxed/simple;
	bh=+bu2skLHOLIbCKRpaUZFw+RBN+w4NfoNxdXnh46yMgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD6SIuIRy51zdBtN1dLAvqnUutvJ7KgnA69NSkksk5cGM0yBHW1ARbegjXabC+G7sS19wxaYqqFnFdf+gQnIKGzvrKtiGtHSslmhLh/cUkhzsgXDtzGzExTL5dqNzUhGzlmaOLp0w+K1VGfyFIy+Ugz5mc7wH964zripNCRRrXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWHV+6US; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWHV+6US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF81EC4CEF6;
	Tue, 12 Aug 2025 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022131;
	bh=+bu2skLHOLIbCKRpaUZFw+RBN+w4NfoNxdXnh46yMgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWHV+6USv/tvPG3/cmK9o8x1967TLnI8nJgS4eq//nUpJo3uedtaCwSRxD3Jezsjr
	 46ZxcOUl8LfvmK6iiSPjkZi3sBHW9KAUx7w+WDWm2v/72p2u8CcSQ8SZNlxwmdEjoS
	 di1O/W9gIpHXxLX6Jobg7KUr5bQmMbKmYy3nb+Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/369] interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg
Date: Tue, 12 Aug 2025 19:26:00 +0200
Message-ID: <20250812173017.135761236@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 02ee375506dceb7d32007821a2bff31504d64b99 ]

The qnm_a1noc_cfg declaration didn't include .num_links definition, fix
it.

Fixes: f29dabda7917 ("interconnect: qcom: Add SC8280XP interconnect provider")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-1-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8280xp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8280xp.c b/drivers/interconnect/qcom/sc8280xp.c
index 7acd152bf0dd..fab5978ed9d3 100644
--- a/drivers/interconnect/qcom/sc8280xp.c
+++ b/drivers/interconnect/qcom/sc8280xp.c
@@ -48,6 +48,7 @@ static struct qcom_icc_node qnm_a1noc_cfg = {
 	.id = SC8280XP_MASTER_A1NOC_CFG,
 	.channels = 1,
 	.buswidth = 4,
+	.num_links = 1,
 	.links = { SC8280XP_SLAVE_SERVICE_A1NOC },
 };
 
-- 
2.39.5



