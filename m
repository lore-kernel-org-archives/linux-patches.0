Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019296;
	b=zYUs+rrjxfz485wbEW9HWCEBIsTqkb3RZs2WYP69BIJuNBiIs+MwVNlBmYd7QmQhkhHY
	 8kLEHJ4UOA5awMM0t5oca+/Ys05RNjYGWwojKNcQE15kqhaQ9Fw2Og2XVE++uQF77m0u5
	 g7ntunTfKQeWQdwNPdGNZAXk9znU5iHVBiA1BtZE3YNNgiYLlqT/X6MrayxV/tFSSWdUU
	 BQ15C/dMwO/hz9ftLC1OxqKhp1/WEiLZejf3E6P490yEP/NMfU++adtpK5qImdxaOwJwH
	 Jxo3EvT7RRxW8hVqu5RipSYR4ty/5RDUiPPk2GL4FPsUxQjmtOdrbTbwIdARqN+pL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGO7G7I7n1G4DC1dyUTIGKIG8nNfL/aqFWvfbw1fGUg=;
	b=gHwsCub56YE5Y8Eb0pECh+Sv+4LhcSLcpCVnPwJWSFbRExGUFCJGEuejI+/zBV3DdLyE
	 J9Nqjmy01GWzYTlrywJ0U4H0APw01A0nDoKB1wNwYV7JmOoTDRfum96+/u/3axBcHbXDY
	 3XQncZcCoETl2tJyr63QPptMWilqufegU06V8GbW5mqWiaJlWZbkV/2ax8dl67v33ZeaQ
	 qSWt9gTeAven1O1XmiiO1VZ64AvbsvkvPyFvGLYdzJ6jYTREdn4kQS9qhHi3e0gEkjCEc
	 yNH+ZW7Z9q806kFp9yYa+Laug0TXhj5X2RnBCTp+W3SMGPuZGfB65CAWId9qfHfEJLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLSwYRrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FB7606A32F;
	Wed, 18 Nov 2026 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLSwYRrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6AA1F000C6;
	Wed, 18 Nov 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019296;
	bh=gGO7G7I7n1G4DC1dyUTIGKIG8nNfL/aqFWvfbw1fGUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLSwYRrf+Epf9At/RD/B4x80Pv2bY8ExT+Z7lsQGW1K9bd0evtdkNi7IPZ9zdD4WB
	 w836oWJy+c74GOh9Hq0tvPcvsq/e/QUyCb3IhEf4gS1sWnYJuzdReaTry1mD/biDle
	 VmpjAFfysl8FzKbirB8Yz2DQpPNe4IxkDzc0M3W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1545/2651] gpu: buddy: Drop the stale @p line from the gpu_buddy_print() kernel-doc
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118150343.584785826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit b7027ff72c2fd4f7697a00b854c882445e9150b5 ]

gpu_buddy_print() takes only the allocator since commit ba110db8e1bc
("gpu: Move DRM buddy allocator one level up (part two)"), but the
kernel-doc still describes a printer argument and kernel-doc warns about
the excess parameter on every docs build.

Drop the line.

Fixes: ba110db8e1bc ("gpu: Move DRM buddy allocator one level up (part two)")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20260907012125.21209-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/buddy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/buddy.c b/drivers/gpu/buddy.c
index 26e7a48b55f33..d728ddfc4f0b7 100644
--- a/drivers/gpu/buddy.c
+++ b/drivers/gpu/buddy.c
@@ -1586,7 +1586,6 @@ EXPORT_SYMBOL(gpu_buddy_block_print);
  * gpu_buddy_print - print allocator state
  *
  * @mm: GPU buddy manager
- * @p: GPU printer to use
  */
 void gpu_buddy_print(struct gpu_buddy *mm)
 {
-- 
2.53.0



