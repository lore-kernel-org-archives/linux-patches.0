Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015325;
	b=5mcDLM8V0bKC7RJ2gV7H6SjEu4vbxt028gvHPaVjWCMBoifqdYAxI0eqzFxHPel7svda
	 9FZyI+CyazdLT9ruLpphBCRYF8n6nGwY1cW6QelCqJoIuVN6SzBkKFvwdOapbn6hRJhAP
	 59CBR6mkZ6d+81eVHVkXk6i8saTE7zhsuBqZmoLRjexYz8Y9A/iIXSM3G8KDiiy2OgMnp
	 5nHUvwhf2pz31pjsxfjmFvY9Eb6nZhP+ft1z8UkYrnfJS+L46NBGLxgJqWDwrZ2k4LUf+
	 WDA0PIIArxdXEu5GvkFFOyJ6lly0i9fxxV7iW+XwRJk7K054GLvP6ohfYx1sxKOP/Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWNn8wjS/GFQlxiRI6W8r1xzTy5n2NVhPlk20HliILA=;
	b=ESHS6Q/1a9bzT0PG8AqkfPtFktZwri7cBZhxK2c0Z8j50ZE4XDVb0U5rUB3yhZ3VWsmR
	 NZF0o5h1Fh3vRdDuQ0rsM3sOK+lOr24TFtTN3CbQAwy0yhEMapn6x5ADURR7Il6AbaXm6
	 7QaW+ZwTZxJz0QC51omLbYqobX3g4Z1JT/mez59Ws9h4MdyTCnWPgTCqOvN+Xb/N9Rz+p
	 RCXAq+oKXYpwgIxJEOEDATAONPE71j1jifLgjm5BN247scnhW6GPGtxRIGNoxQPB1CIDJ
	 qkQequFOcYioRfjJHFDcW4aSc4uz/0snR8P28+4NBIq42iALK8n2g3pVMe6YsoQW7wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OtgnA1rp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB62606A320;
	Wed, 18 Nov 2026 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OtgnA1rp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EF81F000C5;
	Wed, 18 Nov 2026 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015325;
	bh=HWNn8wjS/GFQlxiRI6W8r1xzTy5n2NVhPlk20HliILA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtgnA1rpZ/xWgW9oEGhW1tMG5qfoQ5/OKahIRdn0Bax7Cgm5PnialX5idLn1/BByA
	 5PeYbI9G8saLXORWh8zpfL7KtxWeQYiNMHdZRn/s7dKjrmOnCts1tJrvckQJke3sky
	 qzQHJmMG5LbCXEdDG7tieDu2bQZm+L7Rzc5V9gS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0134/2651] dt-bindings: clock: qcom: Add GCC video axi reset clocks for Nord
Date: Wed, 18 Nov 2026 15:22:54 +0100
Message-ID: <20261118150252.678169239@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 348a2ae162e5ec2dbab12c226b8240b8271ca444 ]

The NW_GCC video axi reset clocks are required by the video SW driver
to assert and deassert the clock resets during their power down
sequence. Hence add these clock resets.

Fixes: 06498d59bb4e ("dt-bindings: clock: qcom: Add Nord Global Clock Controller")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260801-nord_videocc_camcc-v2-1-674d7718e41f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,nord-nwgcc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,nord-nwgcc.h b/include/dt-bindings/clock/qcom,nord-nwgcc.h
index b6253dd2aa85a..8beaa129aa814 100644
--- a/include/dt-bindings/clock/qcom,nord-nwgcc.h
+++ b/include/dt-bindings/clock/qcom,nord-nwgcc.h
@@ -65,5 +65,8 @@
 #define NW_GCC_GPU_2_BCR					6
 #define NW_GCC_GPU_BCR						7
 #define NW_GCC_VIDEO_BCR					8
+#define NW_GCC_VIDEO_AXI0_CLK_ARES				9
+#define NW_GCC_VIDEO_AXI0C_CLK_ARES				10
+#define NW_GCC_VIDEO_AXI1_CLK_ARES				11
 
 #endif
-- 
2.53.0



