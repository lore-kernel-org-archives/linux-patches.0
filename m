Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061952;
	b=S/OTSjF+ohRcS89bhu+UswNAujePd7IOM92jWh0hy99WKdKZqFactYklK/Gf9K6GsCBh
	 f7qWpjedkV8eH2qKrhYOTPdlDjDln7rqWmzGfu3pu7tGG1AVR7UfdtIqickoJL6XF9BL2
	 S5rUzd0r3G+W2dJl1CAwg89JoCLxNgi37SFJDkQt1Tdp/D0MirH4SDHLshqLGBJIzdNji
	 49/1ia5VIbvwSHvlDy7Y8K/ocRq5absasGXeptcQCkEB2sSl22absGXQ3lA9QIcU3DIXA
	 eRhSqB7ZoVdeAdW4khy0pN3FAejlfXtT2KTzLiqWv0+2vbiidg7idw5lBiA0R7uWLqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T24ffNEWL5/7GUJyMRZT2lesc1e9TpziL9QNdDavlaM=;
	b=jkj9AjcpbkNIO2jUiPNbO9RdpNYpsWhBLTKEXzxycPnnDIbjf1tkXuShYulPHNe+xg39
	 FGbANQMTUqOmrOLI2QWiw30PKWBSn1BND+uArh80ev/09eP1eIJcx0gkzySMXuqEDBBYX
	 2tp7xHY3XROfFLSNLZg6finrFlXqoqgxQ4YqoQZL8r2h/VP4D+vNBKWk63Dx51fZJOrc6
	 xemQQfX5wC6ynMEDosoVx248NL1CM8C7MCX7DpSn2uHJUzyban4sfZokvJGHGthUDjWNw
	 6d2Z0mLB1t1s7VZ9sy1k9CFY3096tV3A3MJDWM21+YGOvtrHWtyMEO+iynUT1EU5Oqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yzLlq193;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B110E606A32E;
	Sat,  7 Nov 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yzLlq193
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4251F0089F;
	Sat,  7 Nov 2026 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061951;
	bh=T24ffNEWL5/7GUJyMRZT2lesc1e9TpziL9QNdDavlaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzLlq193+gMwr25vSKT0GggQcxoj/jktMO2gc+HbELHFCHcr7AfMXPO+nP0rjI79j
	 /zTCgQ2fUHlMzyAWZdfqDldNRjWc7OlGzcHMIMQYUhGQJUe30l9XQAKzP9kI0rSDLa
	 ZY2FWSG9feJzoy8Q01HnRp/lxR9VprGgFs4P5T2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0911/1536] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Sat,  7 Nov 2026 08:48:47 -0500
Message-ID: <20261107135023.223540327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7543cea74564..0f8dac23ba288 100644
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



