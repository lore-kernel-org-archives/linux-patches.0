Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047595;
	b=0TPvXi1E4WQaxmWdRlgxE3MkdCYWV9PXcl11ivdqf0OrTQBuMCrrkmAX9dRRPi6Ws6mm
	 KUdgZXVB1yba2FSi+JNRivjO6bBmhL3L4BBOj9HMXYFVzYz3MiGYF5JN+AgsX6CCb0GBu
	 qRCM949Wi5H6xGRmRP/kyzWNat4Ev6L+e4SlbKMniJYW1t49XeiThCwK1a1LsS1INZbx5
	 AGv/GS1ps+NZFHmF0u001ccJ9IAwbqNsIfavM813a3TctV0O976V0Vsn0qyEqnF18tR5s
	 kpuAuc3RhpeC7I8RlYefe3BdFwhnEI6v3ziW3kLOm7MRy2eb1ND2p6SYOoFec6UvBYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bYLkzR+2KO9YGl5b7X+hPf72AZD7qhCYEUH6k2ACR3A=;
	b=XaDbhue8GTj+UkQJsKxNCf2E+PbSepRwug5l5JU8zjdPuDAqTcUXJstKGsI25Myj80dr
	 82di4KiDtZQe5cW4xQqdn+PtPgzep8BYbCrHWNp9ixq6HXpTF2j+ZxQR5ui2QuMett7xs
	 uEbe9uRdJWj8yL31EWzE4qKFGt8AP42pl8GmknCmK7iKt881YUgw6Ur0RSBrlNzp8nTx5
	 xafMiw2TIy8fxno9rjliyo/L/2hS9EhJuYAZjErH5A5Af4WU+6E/AkHLULXYVuoy02Ckh
	 47VnEzPtTPpdqdbGjggcdVqDpFbFRA65TWqAeWgs2tOiu9Of6iAIDNnoz4DltlbVgLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jo/kOkj7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B45A606A320;
	Thu, 19 Nov 2026 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jo/kOkj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D5A1F000C4;
	Thu, 19 Nov 2026 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047595;
	bh=bYLkzR+2KO9YGl5b7X+hPf72AZD7qhCYEUH6k2ACR3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jo/kOkj7itDeYourYBLqPRvB78E2f+DFwLt6gidDaTt5PGJOCTLMPElFsEwZnvYUE
	 RZPEhvNVTirfIH540VCMsUur6GsFpqwOaQx08zIb6WqwVNvUF+naXuGY+BYBbbW+Wc
	 Nhneoru5QGSGya+zwA+0UNUmphVMfEf1jNCNKG3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1696/2857] ASoC: qcom: audioreach: fix ADSP ready check
Date: Wed, 18 Nov 2026 15:45:30 +0100
Message-ID: <20261118150302.400719564@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit dd33c2e7b21d72b151a87b5dafffee2c019043e5 ]

currently q6apm_is_adsp_ready() will only return the cached value of
previous result. If we are unlucky and previous result is not-ready
then the caller will always get not-ready flag.

This is not correct, we should query the dsp of its current state in
irrespective of previous reported state.

Fixes: 47bc8cf60e92 ("ASoC: qdsp6: audioreach: Add ADSP ready check")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-5-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 8529381139865..79bf618a90166 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -145,14 +145,6 @@ static void q6apm_put_audioreach_graph(struct kref *ref)
 	kfree(graph);
 }
 
-bool q6apm_is_adsp_ready(void)
-{
-	if (g_apm && g_apm->state)
-		return true;
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(q6apm_is_adsp_ready);
 
 static int q6apm_get_apm_state(struct q6apm *apm)
 {
@@ -169,6 +161,15 @@ static int q6apm_get_apm_state(struct q6apm *apm)
 	return apm->state;
 }
 
+bool q6apm_is_adsp_ready(void)
+{
+	if (g_apm)
+		return q6apm_get_apm_state(g_apm);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(q6apm_is_adsp_ready);
+
 static struct audioreach_module *__q6apm_find_module_by_mid(struct q6apm *apm,
 						    struct audioreach_graph_info *info,
 						    uint32_t mid)
-- 
2.53.0



