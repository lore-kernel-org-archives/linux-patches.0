Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019848;
	b=GMZy/nV3AfmSowpPOt4BQHNTQPl3bair1vRYdpV32W5Otr2eNVz3939gFgeDPseBrW6+
	 2XXbGpEHRAGsKY6O/BOB6//8qaZjo77lDZWA07DTw4QJg5sNmaflhMda7zPgVLCNZSM/o
	 HviKNrLBe5kY0OwTU29A8nuxJmWdB3tJlnmdSdKOcOz4vRQLsD1LBoYWBgPGVM7XAqr1C
	 4pTBM+1J981xXr5i+tQylP/wy2AomTrtZYQFZWJZocFaPSMqqjglotLznCJjK2Sjs8ufx
	 9eJLS8H3IvN8PMa/z84ZS+I5xqYKlVShVzrtdwx15xGZItqJPAQPcirLlUA0e9atKXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=31UL5+otG43VBZXBPjsiZ7WUOfI1ihM8hoKLexPFSyY=;
	b=tf/A/0JHIWQmz4uyeGtRgLTngYaozoZ/NgH59jmu6KrlnWYTtu1KUwKJ2/VJTDppklok
	 W+f9fCHVkDgyg8DiK4naUa9LcpblwE5bdEEpA8HKBpSFlNNK/DTF3brgckXe9Xkt0LjLB
	 T+rZLxHF0R7yfFZvDTk31u5uAG1hTCvHC2icUwFCbfpR+g11Kzo9Goh+6ayRnUVzyqlII
	 GKeLCXOaOlCc7HRWuB+CAuLcxTibK+oxi79wqpYvpbqvjg/3nJFajQd2EllfLjoJIT1GD
	 FBN7EzIX9APQdGc9iJu70JZFtqCg/UTDmSyXZ4GMV79TXYfMwz/ZSWvYKowYLjd9pBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zbNEq6gc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204D60A261A;
	Wed, 18 Nov 2026 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zbNEq6gc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7211F000C6;
	Wed, 18 Nov 2026 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019848;
	bh=31UL5+otG43VBZXBPjsiZ7WUOfI1ihM8hoKLexPFSyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zbNEq6gcwG5b6zHf0wkBEtQeSO6OC9kJhc5uGvF/uXcOfwh3cAFWmRJUy1oD2zCfC
	 I2F18NwVo/u9iREb5PQW26+Nt/vE/FYpFcBtcRNwBcFmk+ExPenHj4gOfolp18pNHc
	 e0M8+GHFNYZhD4naZ0UaAFLGs2mwA16XVYwG+rI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1740/2651] clk: qcom: gcc-eliza: Tie the CX power domain to controller
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150350.209518820@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit e8d919bc9a4cb27793d2aae12bb81f432c3f71a0 ]

Enable runtime PM for the controller, allowing CX to be powered down
once all GCC consumers have released their clocks and GDSCs.

Fixes: 3d356ab4a1ec ("clk: qcom: Add support for Global clock controller on Eliza")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260924-qcom-tie-cx-to-gcc-v5-14-38732033e5b5@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-eliza.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-eliza.c b/drivers/clk/qcom/gcc-eliza.c
index fe18942a59ac4..e26e6e6e52f10 100644
--- a/drivers/clk/qcom/gcc-eliza.c
+++ b/drivers/clk/qcom/gcc-eliza.c
@@ -3068,6 +3068,7 @@ static const struct qcom_cc_desc gcc_eliza_desc = {
 	.num_resets = ARRAY_SIZE(gcc_eliza_resets),
 	.gdscs = gcc_eliza_gdscs,
 	.num_gdscs = ARRAY_SIZE(gcc_eliza_gdscs),
+	.use_rpm = true,
 	.driver_data = &gcc_eliza_driver_data,
 };
 
-- 
2.53.0



