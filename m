Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110A01684AC;
	Tue, 11 Mar 2025 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706255; cv=none; b=UJUFao/86rNDr2uDBDTwWh6Wqk7Oey7OVqmo0Dw5vxvATQtLODNsPcUNW+sMIrTmE0pOVlrFDyuDkJOdJPcxs4qcPauCO5QpSMN5Ucwo06uzTUH8pS7ylrruxSnMGz6bKdByr6MeEllicAEOmf21FnTVYNrlau281CApUUh1iIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706255; c=relaxed/simple;
	bh=zG0wujAKIiITMjj2h7pTB9RcIll38Qvy+Hmz2m30l1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTwV33XTne+/r1Vp5Lg91hzHNElgLDi1nnNEw/EdlrRNQqBRkLlveTHYX48nfUuvr+2dP8fygC6G6yV1dzJHCu+iIgg5PPWVocEw1GuBOdgKTFVXYqMvP90wsdpMfjz+XZNNw5qSKV7FwmYgq/b3wagdsUYY8brI/I0ftGHiHYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBQo9YDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBQo9YDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAF7C4CEE9;
	Tue, 11 Mar 2025 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706254;
	bh=zG0wujAKIiITMjj2h7pTB9RcIll38Qvy+Hmz2m30l1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBQo9YDXOedxXG3MAQeJeCyb8i/PbaSotyG87sgRhLqZsAT2cZdcNtnDjPSPrfnan
	 Y8JAvls1eKKZelvBZ032+lwNUk/nG689msU+Iyqnm2bBUeN6lmica/4VryfLdaDY9U
	 CIXac+5ZpplIkN6yUHCbz5HjRyuCDRFGBozjqX4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 286/328] x86/cpu: Validate CPUID leaf 0x2 EDX output
Date: Tue, 11 Mar 2025 16:00:56 +0100
Message-ID: <20250311145726.276074156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed S. Darwish <darwi@linutronix.de>

commit 1881148215c67151b146450fb89ec22fd92337a7 upstream.

CPUID leaf 0x2 emits one-byte descriptors in its four output registers
EAX, EBX, ECX, and EDX.  For these descriptors to be valid, the most
significant bit (MSB) of each register must be clear.

Leaf 0x2 parsing at intel.c only validated the MSBs of EAX, EBX, and
ECX, but left EDX unchecked.

Validate EDX's most-significant bit as well.

Fixes: e0ba94f14f74 ("x86/tlb_info: get last level TLB entry number of CPU")
Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250304085152.51092-3-darwi@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -959,7 +959,7 @@ static void intel_detect_tlb(struct cpui
 		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
 
 		/* If bit 31 is set, this is an unknown format */
-		for (j = 0 ; j < 3 ; j++)
+		for (j = 0 ; j < 4 ; j++)
 			if (regs[j] & (1 << 31))
 				regs[j] = 0;
 


