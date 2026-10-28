Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217346;
	b=cT9PC/Cfpe4xwYwME15lnzPGgLpOsTlDIvTZospMm9cnIf03oi0TE/CFA82JZv/ZKRis
	 yUu+0bJ3lIBYMSG+NltuVHwbylDxjng3nF5wnnZbqDm5SNGKhEIVfAJwQD/Ah5AsSasXz
	 xhz+3ExwHAgPmX0KMDCdClxEy4vq5d5lwYKYaaabZoylg5JvwPXT2ntKkznTzDs4FMrXm
	 F8wNw5cclvp8LmBRsSDPPJG6OKsNDMG+jx3fLGYyeVjiZ5DjzJAj6Yw2171zTIk9d+nsQ
	 lqMzn/q7Yi2/Z2JiQLtzNqPBkQM/gva73mDazAHWLDXclfBzC5lmX/VT2ug0UX+9nzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3rFOGGjHinSqfpf0poMiqPbuj2VfAWUO2MZWlpVcIv0=;
	b=GGTemfPrLrpY9lFOEPK7THIrvMXzy9OhTtCo28Ig9nTJpc+PVOwDPx8qqa0SsGVy69jE
	 H97sdxo7KLlMYNXoHsyO4gnomfKdtRT7sMkYqqP5NTsi0vf7RUX2Jw1ggiKK1tKX2TFBh
	 NgeUyBNL6X3kSpDTZ5Qm+Ohuw7gPYtLM5UoNiRD3HkmUOeTCIoRiMjwZRgN9dETa/IVdK
	 qQr0hAtUsnIN4YLJGL7mlH+RLjhqOtj5fn1yIPal0mENtcXFXGlgfOhqjrP4UncKCMlK0
	 r4GRTpIbdQRUU7UJH2+aA7GyVpo2zqYdflP4gjAgD8Kkx1vdxBfROjeG+dWUMuiJxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMT1BA3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0A606A31A;
	Wed, 28 Oct 2026 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMT1BA3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C931F01825;
	Wed, 28 Oct 2026 19:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217346;
	bh=3rFOGGjHinSqfpf0poMiqPbuj2VfAWUO2MZWlpVcIv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMT1BA3KLMXRrYxgajccBU4i2+2Tqv2hebjML3jml6ez/13z8vascYkqr6wnUwMga
	 KMpFdosuBlIYik1ZqjcZXjt+Gn6Ardho41aN2NUVZvHtaokmWIdhq943Mfm4DfEbNw
	 SFh0hHIgYzP4J9oAp859Z6Wupwcqf1oHOdHa8S/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1835/1887] firmware: arm_scmi: Reject out of range DT protocol IDs
Date: Wed, 28 Oct 2026 18:05:31 +0100
Message-ID: <20261028170541.205173741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 59407ccb52130f2c81f4b3cbe4f14114afceb54f ]

SCMI protocol IDs carried in message headers are limited by
MSG_PROTOCOL_ID_MASK. The DT parsing paths noticed protocol IDs
outside that range, but only logged an error and then kept processing
the invalid value.

That lets a malformed 32-bit DT reg value reach helpers which take a u8
protocol ID, where it can be truncated and/or treated as a different
protocol.

For channel setup, two different out-of-range values can also be used as
distinct IDR keys while aliasing the generated SCMI protocol identity.

Skip DT protocol nodes whose reg value does not fit the SCMI protocol ID
field before setting up channels or creating protocol devices.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-7-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 2f959a3183273..ed32f48c8fe3b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2194,9 +2194,11 @@ static int scmi_channels_setup(struct scmi_info *info)
 		if (of_property_read_u32(child, "reg", &prot_id))
 			continue;
 
-		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id))
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id)) {
 			dev_err(info->dev,
 				"Out of range protocol %d\n", prot_id);
+			continue;
+		}
 
 		ret = scmi_txrx_setup(info, child, prot_id);
 		if (ret) {
@@ -2403,8 +2405,10 @@ static int scmi_probe(struct platform_device *pdev)
 		if (of_property_read_u32(child, "reg", &prot_id))
 			continue;
 
-		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id))
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id)) {
 			dev_err(dev, "Out of range protocol %d\n", prot_id);
+			continue;
+		}
 
 		if (!scmi_is_protocol_implemented(handle, prot_id)) {
 			dev_err(dev, "SCMI protocol %d not implemented\n",
-- 
2.53.0



