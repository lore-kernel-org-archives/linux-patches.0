Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017723;
	b=1BuJzKpnPUggVM2DdS0UrjHcXBXTfpJG25tO0hzuZAtTlK47JYCJA8e2OiSTdwbRA3En
	 NQQKNZMH7zGP4wBUmng1fpsNud2jJPtiAcEIxVl5LejHINDnl4GtgE75z3xyY1Nh6NEKL
	 Luj08EBRIJztRqK6fuK+gfYgFHViyJUMU6uOhk/FZyS1vNW9yxLzer+e/BNplaw3ICnj3
	 9WD8o5366Bf9EFPs08OSogFN27zKayN8BqLSDxIKi3/A9BN/r1LdvbHlHLT+33Tq7dNgO
	 WaZioPRqghPwJocc1m72Wd1HUliAtwEXXlMdFpz80jfpNfRxkMEHJ1kfhKJhs8Xe0lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqqXKGHgC9X6/5TAuVTeCQiZhK+Y6EDSc50+6FnBSi4=;
	b=HfcQKomqhNAdB+PcFarhcO99pwoYHglH4GFZ7L4J0VUroewEn84ZZc4UDAdx/JNaEoD1
	 Fcp2/qkEADcJ5qR3OOwcMDCuP509hkcBOW64r35c5KlJolprr11QuXnUdEHDCq32Mw5/2
	 7LmTmGGHw5t1YycTFRqEwbjg1hPomGx5R2BdrhXFPP1uG+6ySjeov84zgOx544ibX1m5n
	 w5f6vCJwsPLEOeG49nyN8/NPhUg5uBgYUjh7qB0owU/tSAXb92Da8VnyLjivFRE02HjJ/
	 aGNUY+xaiuILKGQ88b8Hf0vmY2jvFMwVDRKmkh09Ss7rZGe+JXorqO6lLMxSKggUAKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qs0ewst9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21757606A32A;
	Wed, 18 Nov 2026 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qs0ewst9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1021F000C4;
	Wed, 18 Nov 2026 16:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017723;
	bh=iqqXKGHgC9X6/5TAuVTeCQiZhK+Y6EDSc50+6FnBSi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qs0ewst9wCwHKdz0e18SGlrpdmVbaOg1HlZFX9+PvvTkN1b+x5qD9ImjpSx9aG8Lw
	 7NJ3fWK7eXkvPA2uOiyuMB5Piy4A44yonP1J4ckPgIvpqo7YfTnrq0jK6c8OeVAMJ/
	 RStdkVcvzAHyooxGdRU37iGh84COlLEgkHon1fVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0985/2651] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:37:05 +0100
Message-ID: <20261118150323.363430575@linuxfoundation.org>
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

[ Upstream commit 6c4e6e8f5cf95f7e0d4f04928a9ae70e20c73d4b ]

The heading for k3_ringacc_init_data repeats struct, so kernel-doc
cannot match it to the declaration. Its three fields are also missing
descriptions.

Use the structure name and describe the firmware handle, device ID,
and total number of available rings used during DMA ring initialization.

Fixes: d782298c6f6b ("soc: ti: k3-ringacc: add AM64 DMA rings support.")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260923061658.20140-2-kmehltretter@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/ti/k3-ringacc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/soc/ti/k3-ringacc.h b/include/linux/soc/ti/k3-ringacc.h
index 2de6031b94241..7b7fc237c08f5 100644
--- a/include/linux/soc/ti/k3-ringacc.h
+++ b/include/linux/soc/ti/k3-ringacc.h
@@ -254,7 +254,10 @@ u32 k3_ringacc_get_tisci_dev_id(struct k3_ring *ring);
 struct ti_sci_handle;
 
 /**
- * struct struct k3_ringacc_init_data - Initialization data for DMA rings
+ * struct k3_ringacc_init_data - Initialization data for DMA rings
+ * @tisci: TI SCI firmware handle
+ * @tisci_dev_id: TI SCI device ID of the DMA controller
+ * @num_rings: Total number of available rings
  */
 struct k3_ringacc_init_data {
 	const struct ti_sci_handle *tisci;
-- 
2.53.0



