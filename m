Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035751;
	b=flGpSqyw3lXq5K+xBd1l1xB7UTf76Hu+duklkG71bHybsUrOC9pXtnsJiVeYmgIlfpwa
	 zSx09Z6WL5qH87Zy8YqOFFhnvjq3xvk7fSJmiaQPQr0pgEWx8C3ROl5VNsK5vkJWVOkwL
	 KojHD2qOp9IlWx+kPRQuf/C6CDPQKFyodMJNnKO/X5bqejc4mwvUIzpChwA8pIclJXgcF
	 rsjjGEokHpv8HW5PFLoCTR7ZapHAjgmRBADC5wYbDbF9npKha/zS/KZuQTTxV2EUiVpaM
	 lLSojcqV79+o43lV7RMxV7rXJZ6AuRApryhO1pchnh1T/lx8/8d7oPxAHfj+RFeM9Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xgz50340V9DTYJAdkYZBWNm6OBzxgyKxWe6AmxrtN5w=;
	b=DHMYuqyWDpsE7id08oeXVSMLPRMJiBn1DPILMksnjszU83ndHITmZ+a1UcrdcnlR6Bat
	 xGBU7bt+JAplckJ5Aab5PTMqLMZ0hiMGElhddLsPGKHLBc6IsORS98vPZ4xAKE8eykIUr
	 mr+Eo31wSEbut25tlYPnfGsamLOALe52uiP1x+/9xYYEoVsuSOtb6s4RDmCy2w1UOxUDm
	 F7zhc135IBSJIS4cnXzlyQLXyRzmQGTRncSGSy9r9fjh4OintWjpT1jtu/olN0RfD2OHe
	 A4MD0XL3nsPW7KDSYGw101p2U1jSmYLzJofnL2k/EykTegTHDYFYA/jOOl8oPRE6Xgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hrr73uF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B682606A320;
	Wed, 18 Nov 2026 21:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hrr73uF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F031F000C4;
	Wed, 18 Nov 2026 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035751;
	bh=Xgz50340V9DTYJAdkYZBWNm6OBzxgyKxWe6AmxrtN5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hrr73uF+pRyilrXI13VqUAuXdkcxTWBD5SoD69bsCtO+jN6z0V5NBPaqG5pKW73zH
	 c1duLLuyNRwPsPjFz2LjcY4Pw9E7hd1tOcCUT9fhliatQh4ZvLhYDZLSgghptiteQH
	 1YFGP+RxlImFZOIhyFDUJFTdxYZvuR6dNdkwFeRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0814/3318] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Wed, 18 Nov 2026 15:23:56 +0100
Message-ID: <20261118150343.443592427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6b07f8c06caca015a0db69e3f323b5186469bc66 ]

A compromised or buggy DCPU coprocessor can make any user who reads
world-readable /sys/devices/.../dpfe_info|dpfe_dram trigger a kernel
stack out-of-bounds read of arbitrary extent. This bounds checks
chksum_idx against MSG_FIELD_MAX after reading the response from DCPU
message RAM.

Fixes: 5d06f53d9509 ("memory: brcmstb: dpfe: Compute checksum at __send_command() time")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Assisted-by: Gemini:gemini-3.1-pro-preview cursor
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260826201500.3000125-3-danesh.petigara@broadcom.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 482edebbc8ade..9ac5fefa89f94 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -503,6 +503,8 @@ static int __send_command(struct brcmstb_dpfe_priv *priv, unsigned int cmd,
 		for (i = 0; i < MSG_FIELD_MAX; i++)
 			result[i] = readl_relaxed(regs + DCPU_MSG_RAM(i));
 		chksum_idx = result[MSG_ARG_COUNT] + MSG_ARG_COUNT + 1;
+		if (chksum_idx >= MSG_FIELD_MAX)
+			ret = -EINVAL;
 	}
 
 	/* Tell DCPU we are done */
-- 
2.53.0



