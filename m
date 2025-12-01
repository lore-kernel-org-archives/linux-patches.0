Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835DD2BE655;
	Mon,  1 Dec 2025 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588521; cv=none; b=lf8qh1ymxZmMeqbWzvgeAdy66V7cqO8QoLK6IIs3SkUNgvK00n1ZATcAo4x5z9mQblp+W4Pfd0NIpfTWIf5ebryhN3xxJiittQQcRAjUnRC+DPk7wnq15ubWMkA/qpDq7DoLLLRq9a5VrHNGN8XSil4WuSuWMyPTwlhrRbuD5uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588521; c=relaxed/simple;
	bh=2VNSAWMX5oj4PTo1uT3ZTfuBOHBO2GyUKK9fU+WkTzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hv4jCz81NLZlzVgHSBDaSYxzFepcQuW5AL/1FZtaetpobbJ/N6kwqIi8xnlmzVv0AElNLn/cRMSXzsHUdPB6McEpWEO7BqM3oJIzc7ESuDKGpYmq9DEbqWgg5LXFMBYImDM0leOP9mS0Vq/pklcdn+L9CMkylBrwSPjqAO0/DEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4q8Rmwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4q8Rmwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB3EC4CEF1;
	Mon,  1 Dec 2025 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588521;
	bh=2VNSAWMX5oj4PTo1uT3ZTfuBOHBO2GyUKK9fU+WkTzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4q8RmwtVRGCdvmEgnUawcvEhL0c7T7/ltUBQRdFV9nZmMU84W1qa1v951rFdjJUb
	 b5axVypr6KYYZbpAgDhRjp08//6f8ZqxlfB7NVWPAnCKpAgUrCCZkWCQGuyIR2/NRm
	 MXZEtI9beVKDakI9Bx1IPv55OBejImAkiMFrjQy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/187] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Mon,  1 Dec 2025 12:23:04 +0100
Message-ID: <20251201112243.979160335@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juraj Šarinay <juraj@sarinay.com>

[ Upstream commit 21f82062d0f241e55dd59eb630e8710862cc90b4 ]

An exchange with a NFC target must complete within NCI_DATA_TIMEOUT.
A delay of 700 ms is not sufficient for cryptographic operations on smart
cards. CardOS 6.0 may need up to 1.3 seconds to perform 256-bit ECDH
or 3072-bit RSA. To prevent brute-force attacks, passports and similar
documents introduce even longer delays into access control protocols
(BAC/PACE).

The timeout should be higher, but not too much. The expiration allows
us to detect that a NFC target has disappeared.

Signed-off-by: Juraj Šarinay <juraj@sarinay.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250902113630.62393-1-juraj@sarinay.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nfc/nci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 004e49f748419..beea7e014b157 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -52,7 +52,7 @@ enum nci_state {
 #define NCI_RF_DISC_SELECT_TIMEOUT		5000
 #define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
-#define NCI_DATA_TIMEOUT			700
+#define NCI_DATA_TIMEOUT			3000
 
 struct nci_dev;
 
-- 
2.51.0



