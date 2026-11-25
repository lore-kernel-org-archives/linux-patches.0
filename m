Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618385;
	b=xS8RGaa/qfWClf5J0l/TW+fK0SGqwEujYdR1v1qALFKDiBtA3SIbEASjFDGCN/tqebmy
	 lyVIw1LDLSqHhiSY+z8diRdlCG1ZoeXWv6JzTSZoJeC42xSoNr9ZuJu73HzgIHTbMdPwY
	 4bpgNv2Sml64iKYWjZfr/KMqXjFSzgR0/HEUQ/32BGk9jYEh0N8WEW7P2upCjs48LoBlg
	 6zGY1EFHuKHFZAv1VKjeuPetwXwxTJcnNLLbp6e13e1VU6XCF/IlTsO3p8ro8Tc7asZcD
	 JeHbp97sDNkQKhqvzj74PlDeI9F5WhFrwIwf82zWLZsI+YK8+251gUrZpQV5quGsYLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YFh3APmYI2gJUsI87F9zce0qagq47IYF2IAXuncGaxs=;
	b=VyoS1QU6cEF+nCrot5BARP+YSuVGFQJeM8WaCeW3RDI/69VV+1nhX1fSsm2VeaHCh0Yb
	 OHVhgA5wMnBdlzDeUmug0Y4A+ndb18F7wEa9Ktd/wwW5nc5CUVo4XBtCDXibDxh1uK+lF
	 104tXHZFICGTrSNXB11/u965hMOd7xmvRoQYfaIq3U8L53fOlXJ5kQHg/NdmbGmvaAsNt
	 +0zisZca3jpFGwPG7fQrQh+h7wZO7tRIljrWnxlaK6d4gvsw1cChrl1AKtO8Eaid/9AQm
	 t3wobDWTKINPu8WWC/FiW8rGcMuhJ5ma9KX26ZjmyWwxMf/uKE9FbZxZI5dgTy7tfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RUwLAPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79CA606A330;
	Wed, 25 Nov 2026 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1RUwLAPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36CE1F000E0;
	Wed, 25 Nov 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618384;
	bh=YFh3APmYI2gJUsI87F9zce0qagq47IYF2IAXuncGaxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RUwLAPElcAfv4thhmA3t12RFs68fpbvOcOpsearrFgonO/jdpkEDZoNGBNhF4Qzy
	 5E0h3gEKMPzj9zh9Y8uSWPCyWp+S/3fsfKzPfJNjQVkov0YJDFa340ONxqy6zyas2e
	 MjMVWGYP/YPOrTcJOpNCjf8L4mGPXmOWH4UQ2gE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0219/1005] wifi: nxpwifi: guard the 11ax response handlers against a detached command buffer
Date: Wed, 25 Nov 2026 15:25:57 +0100
Message-ID: <20261125143826.872861598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 6a5cf549f4dcbd502db8cd00c5f49d20a2b9648f ]

nxpwifi_wait_queue_complete() clears curr_cmd->data_buf when a
synchronous command is interrupted, but nxpwifi_process_cmdresp() still
hands that field to the response handler. The three handlers in 11ax.c
store through it without checking, so a late response oopses.

Check the buffer first and return 0 when it is NULL, as the sta_cmd.c
handlers that commit 068986fd6f2a5 ("wifi: nxpwifi: detach sync command
buffer on interrupted wait") covers already do.

This is a local denial of service: it needs an interrupted synchronous
command and a late response, both on the local host.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Stable-dep-of: f17e2eda1630 ("wifi: nxpwifi: bound the TLV lengths in the 11AX_CFG response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index dc1e747383eca..7e9127ae2f421 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -205,9 +205,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 	struct host_cmd_11ax_cfg *he_cfg = &resp->params.ax_cfg;
 	struct nxpwifi_ie_types_header *header;
 	u16 left_len, tlv_type, tlv_len;
+	struct nxpwifi_11ax_he_cap_cfg *he_cap;
 	u8 ext_id;
-	struct nxpwifi_11ax_he_cap_cfg *he_cap = &ax_cfg->he_cap_cfg;
 
+	if (!ax_cfg)
+		return 0;
+
+	he_cap = &ax_cfg->he_cap_cfg;
 	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
 	header = (struct nxpwifi_ie_types_header *)he_cfg->tlv;
 
@@ -346,6 +350,9 @@ int nxpwifi_ret_11ax_cmd(struct nxpwifi_private *priv,
 	struct host_cmd_11ax_cmd *he_cmd = &resp->params.ax_cmd;
 	struct nxpwifi_ie_types_data *tlv;
 
+	if (!ax_cmd)
+		return 0;
+
 	ax_cmd->sub_id = le16_to_cpu(he_cmd->sub_id);
 
 	switch (ax_cmd->sub_command) {
@@ -584,6 +591,9 @@ int nxpwifi_ret_twt_cfg(struct nxpwifi_private *priv,
 	struct host_cmd_twt_cfg *twt_cfg_cmd = &resp->params.twt_cfg;
 	u16 action;
 
+	if (!twt_cfg)
+		return 0;
+
 	action = le16_to_cpu(twt_cfg_cmd->action);
 	twt_cfg->sub_id = le16_to_cpu(twt_cfg_cmd->sub_id);
 
-- 
2.53.0



