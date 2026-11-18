Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048073;
	b=BJpViRDKV1mruQ6aw4C05Ye4TDN4g3IkqrMHZH8aOELA9cIZilVS6IyARMWraKu2sEr7
	 Zv/kwe4z3pq07qhVUwcV+6MpJug59HNgDgJ8BuKo0E2IgN9VJ3X7KFlYsfaY5FYokG6oJ
	 0ybbwt0X3YCOxWdvmbiSi2DpeYU4+Fc9+4NOStddtgcrKMTI8jVxOWdNdcIcmTHCZ3jng
	 zuLqpIFLy/ur+ncYaZbNUl45+BSegHSgZFVBB2puhZYla+Z081BSCG3JTK5WAS7HlYRX3
	 rrPpFvfCaMeqdH0+mpFW67LugIMxhXgKZEQQTqy0mDH7+s9jfV6T7I9jnP4WuhIzQJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90HrXvq11OV/R1fUBxGsLplnAFbewPUPmrJeQhdMTpM=;
	b=Gk1lSQ6AENzIYiP4/0Ij39YR6m3ZqBwRmsNdO3OXyHiyAzkhJS5JjMjf+rRXgiNwL8xl
	 mixrlNhaBXSwAAjXkzpvZQU2Ym66jB2tMk7X4AxTAZhd0OG1/8BQN6eM3PR6uRVs7/z1Q
	 RpDN03hBPjo7TZeAburD1NMsw44NM1bDdpjGCrEssMuUPoDfRWr+yk6QK3aNxaIBivx/6
	 CDUMvdCvABfpM46zKKR1YDoCUVBSCsWuc1ADRGUla1oyscKezbchFjh3zLOVYsebA/9YF
	 tGKGaLriJ2ns+gi0fYU5SrnLIb5iJ4sZ2b0ai6IrquEzcpB7kbm20SR1AuDYbXEbA+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6DwT+pI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A2D606A32A;
	Thu, 19 Nov 2026 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6DwT+pI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC01F000C4;
	Thu, 19 Nov 2026 00:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048073;
	bh=90HrXvq11OV/R1fUBxGsLplnAFbewPUPmrJeQhdMTpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6DwT+pIOecLHE3Ag0xAgG2NQAABGnmCYz44gw72xpSgGSGe/oBk+tUCXPAI/hl8n
	 99Irf2XiLeOM9pTU77Hiz4vymroMy4i3P+Vc2GB74/1A/HDLNf+Pw1qn6pZkaRr77r
	 ojGKufpk2a1eQsnuz40m99mgI4a3SCejnPTv2Jl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1866/2857] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150308.424797487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6741f3d900c5a..f9c76c71ba7d1 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -197,8 +197,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
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



