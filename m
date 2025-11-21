Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8B3491C2;
	Fri, 21 Nov 2025 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732624; cv=none; b=IEVf1ikuZxO/99z+4zLY7Hh5KRBqucZd/EoBLG/2++tdtwJEm2vf4CE56H22EDvqz2mP/bZSvYnPy5iwBkExDQwVIm9oX2LMxgbQlB2l+6vhc0aLX6sqCG5YithHn7HXQlUiBpCz7YN3+2GFRN9gno1lnyddvNWg5YcKCrj6c1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732624; c=relaxed/simple;
	bh=x3b48/7KXJV3jNHcOccF0n1MClREp8QQh6JswJBSWkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seusAv3ORYTpjhYw6QgIH7GE7CM0sx8lJyHixaJGvgvFVZVjvdJJMd+kIrXut/NMol6aacNdrq6XDiZn4zH7YKs0XKBGvELAwaeMB/0UmIcgFQrOYHFPw4F10Gc/lVSdw9BWOQ1EMltsDzrIZeL1V0BphzK4nSSCJjPJpgDZS2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdkf7kj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdkf7kj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D77C4CEF1;
	Fri, 21 Nov 2025 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732624;
	bh=x3b48/7KXJV3jNHcOccF0n1MClREp8QQh6JswJBSWkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdkf7kj9CMCs+0o/xTGayMeU/kRWB1oANgRQ1c4fon1XJGNED88pYnV5RqmSCkvr6
	 gM9Mxtn2xQnPcN/gdCuw4+LIRVO3e5P5Y5me4oWtD58Cd9sYR2TaV2FUxxR1VvTZDd
	 nWDf4YUjx7M+hBFx6pOImJxnDwfQ9QR9336nB2V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juraj=20=C5=A0arinay?= <juraj@sarinay.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/529] net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms
Date: Fri, 21 Nov 2025 14:08:05 +0100
Message-ID: <20251121130237.637564900@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea8595651c384..e066bdbc807be 100644
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



