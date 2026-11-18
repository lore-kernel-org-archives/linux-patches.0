Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023487;
	b=2aoI09feiAllbFqK4AibaBg86IrkOod057Pkljk82FkeZ+scP+WBLyt6OHBoYaLQVB7O
	 4pEvhdHwbQudQFxVeCgCchFImCVxFXRaL819/U+wp3dAKPA6H/jx5TuhRLbP7wXHdeIGa
	 NptZ6hjG7VacYbiUUXuUuzXTCCJ6M3faKM74r2dscaeCMJJIIE2ZDZclnMBjmkQLgGr0d
	 Gex5cYdDP11mXykwcT+XoNUHlLxWP3zRN55JOI2m4eogMsUQjGUHrmtpscO8Xoqrv1kRc
	 B4yDPyVS591He6OzgwgsnJgg1xjYUXm4rRhkRe/FXs+ldYte7qz/WYaLCnSa1+ugWHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ae7e/RG0t7fBKyjhzRepNLjzL8wxPWXgLN/q2N6Oqdk=;
	b=znhRGCKAbVj1nCrC8Hv/mtlsU7XRZjMexWaZTEp9rMl9BHB+DbinyW2OBP1dgbMBzQpG
	 M1SsxZ1u6B0w4oyChRuxvUQHzH9OaH4ymI+jkp/B1u4P5IIJJOJzkH0lFjoovcuwUjGPG
	 Vrh3NO2XFFzlfs5aCEJUO1HCK3WR1lMM69B2UN4GhrXeA6kFwyM4fAc8r4Ln43M2bO+G5
	 AJ4V/3Fp2xHlDrVDWVHCavvFhzN6iU/Rl8OVjrdAyqRD+jCiM7Wla6VvXrUHUMBxYtn7s
	 CxEhkGEALzWUHeoY09SJ83AUzay5hBpNh4cJaLBfvSjMlT6GEePGlrul3D1mJzLBP+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En2DhZmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83139606A336;
	Wed, 18 Nov 2026 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En2DhZmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D266C1F000C9;
	Wed, 18 Nov 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023487;
	bh=Ae7e/RG0t7fBKyjhzRepNLjzL8wxPWXgLN/q2N6Oqdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En2DhZmQ6cV+4FhndZgycHyBNVXEBvkBnaPyYez56QQq2pSRtxselb+BhXFqLb6cY
	 0jEiEMYdYAxZgfqYVVU+Ox6R7Ij2nCZeGyzz1cgx86e1i9jXgJmfssUef8nnf7xGAT
	 sV65m47XkS83tjYUjGonUfSzZzHJ2i1f/yrT499U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0346/2151] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:34:41 +0100
Message-ID: <20261118150134.705759510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c12a3a4b35e47fd511fbd550d3637318be41c4eb ]

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f5ba032863a9c..3e21ff6acb9a2 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -220,8 +220,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.
-- 
2.53.0



