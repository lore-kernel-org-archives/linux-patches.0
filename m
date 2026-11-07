Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063843;
	b=qtWLhil3KCU6YsUZgFYNMKuui5hio/sE1kRzFV8NK8ir1rYKBOJ/nUJkjY3oanlp/N0H
	 kWO7yJSZLNsmzz7n5FdNLNfkEuq4dHegAVFD/MB+cWpy0Lt+3KKXn2GkAGbFPr5tnw0RT
	 IQiLzRXXxA/okAQU5mSllUfQXen0OhCwwMmmZvmpgCVIqPqbCTS3BLtEKscxwDPlTVX0r
	 lORjX6YA+WiQsdQpZi2i3zDbs5pjs4P5o/iGokVf51ecJKodiLX4jXTvWDxaEbRoIpor1
	 32DTc1Z49p3hRIoZN6vg51Om85U1cQXbILVKdZHLJmOO5d8B7+StpI6Ytp52FHQrCdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtJJKoSXqVzyH80zo8kZJLlI9CJWFbwjpNlgnkIlMVc=;
	b=t8xdAnzyslBFZ0dhusQOrxQsKYyWk/Y9wgibrwFHmcGfrRq+7bDN0KCdXyp7lYP2ekIJ
	 KQuTpcppJNn81zztHHwzMz/ghU2yFE6qDBDm9j4SEDASkloeHkcQZnfl2laoQLYefFYcP
	 0rK5+HKrVWcXUbWGPoit688HFlF5MIV9anmy+aTqNqn9X/J5k/tm3S3Sh5zlEZrrV2/AB
	 4WexUeZwqRh0bJwzeTzv9bz7Ds/JZA0hwEqJBHkkjPr8U1Xg6rHQCykBmUoOs/dZqQBQq
	 NvNoZ4Es98U683a39hqnXP6fRGvPssjeWfQPoes0OWF0Naq0hmqeq1zFST8U9UIaYyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKG8Jpj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A76606A9D4;
	Sat,  7 Nov 2026 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKG8Jpj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F701F008A5;
	Sat,  7 Nov 2026 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063843;
	bh=rtJJKoSXqVzyH80zo8kZJLlI9CJWFbwjpNlgnkIlMVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKG8Jpj9ooovV6qvpF5xQ2hNgroHYB7r/qnSPBligst4HeRiL202sLYXrmGp+9t88
	 D/Owj8qV78NWSrMELkK5S2Od/rDAlwwyFxKJXGDrpjBb5Ow0aMfXkSWyK0O2ZGjyRt
	 o6DqEI3990IfsIcQzp05nxXDQqMJHsLnpkbkIN6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0055/1257] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Sat,  7 Nov 2026 08:39:11 -0500
Message-ID: <20261107134940.923987705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 66343205f585b..7b02c36c7fca7 100644
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



