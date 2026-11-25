Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621363;
	b=uvJfEGkMzRO4/s0C0MCDcaT5oes3dhJ4D+wmUzgmFidgvQ8avTsoNyUYhDRZi6bzKrYp
	 k7pd4ZYWjNe+K7VSp8XTY9rQAGQwJnmw3+IwgkFOSgaQXYlQ7V3PEKPgAy8HCK4Jo0TFf
	 u/y6wBw3IvwOmh8VjPbbOFi8YrdVU9r7foMIQZ/6ehDrWhbnU3xFRmldiGBUxYib8HylQ
	 lO9kYYciBZsmN7dRImADbZE0UWvvW0de9YCLcsDTFnXHNObHqmREffJMPQa7HIshqhTEl
	 Lk4cubQuq7xsdZcacoi9HelyoSBTW3Z5wEhPf5rQJw1lHlYynQ9l3IXWbtlIhLJRVpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rjGtR+ZzVlUp1+RvU/qOD26ngoBr2BM4cI51x42SnLg=;
	b=TuL5mwo/Zl/+/YXZKFexDza9f13hObGCe39oUmX82bL0lcTAaPMHqlE44vwS1Cx6aQqn
	 8jl+I+BEmeipPkckuikN3acOY9tOlgIiho7F2iW+FM/cyvi/ELZ4zHIpHwQkQJCjboMR3
	 tO8SmhUrPqLUf3k2pbjM39oCsLkkevxBzUnkBeLf/H+voqohEbxVP//8l1XhMr4yXHCVX
	 cizechZKzZAzKR7GuEWMt3uHIzXJeuDjZjQKYNNt4bElzJzb+BiwDHqKMfaqjrzZoAnUm
	 3iRuuttpd4sXTDHOn0z2Q1yCBv4JFxOgycrwNpB6CBK1/NWVcURITGsDFCErNhQA8Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEM2AHw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F38606BF4C;
	Wed, 25 Nov 2026 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEM2AHw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23271F000D1;
	Wed, 25 Nov 2026 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621363;
	bh=rjGtR+ZzVlUp1+RvU/qOD26ngoBr2BM4cI51x42SnLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEM2AHw++Pjm/wyTkuX6m+9LJVFNf3Lbb0LXwbupcEgtaFWUGlgdbJw91tk9+jBGX
	 u8ypobyWeMrWSos7CJIokon8EBBAYmB32S9g0lOCj2E3kUb+7LJyyNRkHC5Y4Wtd8M
	 xrqsngU8LsAZ0wv/yQzlrWwjKes3BK62JBH/wu7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Jiang <cheng.jiang@oss.qualcomm.com>,
	Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/990] power: sequencing: qcom-wcn: increase WCN7850 power-up delay
Date: Wed, 25 Nov 2026 15:26:07 +0100
Message-ID: <20261125143826.779707730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Zhang <shuai.zhang@oss.qualcomm.com>

[ Upstream commit bd60a639b621453fe37b780df4b6d3a13f981f13 ]

When the WCN7850 is powered up from the Bluetooth side first, i.e.
BT_EN is asserted while WLAN_EN is still low, the chip starts from a
cold state and is not ready to accept the first HCI command 50 ms after
BT_EN goes high. The first command (0xfc00, read QCA version) is lost,
hci_qca does not resend it and fails after the 2 s command timeout:

  Bluetooth: hci0: Reading QCA version information failed (-110)

When WLAN is powered first, 50 ms is sufficient, so the failure only
shows up in the BT-first ordering. Measured on the affected board by
which enable pin rose first:

  pwup_delay_ms   BT-first boots   with -110
  50              9                9
  75              23               0
  100             21               0
  300             20               0

Raise the power-up delay of WCN7850 to 100 ms. The delay is shared by
the Bluetooth and WLAN targets, so WLAN power-up also waits 50 ms
longer.

Fixes: 2f1630f437df ("power: pwrseq: add a driver for the PMU module on the QCom WCN chipsets")
Signed-off-by: Cheng Jiang <cheng.jiang@oss.qualcomm.com>
Signed-off-by: Shuai Zhang <shuai.zhang@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20261102094800.3225454-1-shuai.zhang@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index 663d9a5370653..4720cf0ffb664 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -324,7 +324,7 @@ static const char *const pwrseq_wcn7850_vregs[] = {
 static const struct pwrseq_qcom_wcn_pdata pwrseq_wcn7850_of_data = {
 	.vregs = pwrseq_wcn7850_vregs,
 	.num_vregs = ARRAY_SIZE(pwrseq_wcn7850_vregs),
-	.pwup_delay_ms = 50,
+	.pwup_delay_ms = 100,
 	.targets = pwrseq_qcom_wcn_targets,
 };
 
-- 
2.53.0



