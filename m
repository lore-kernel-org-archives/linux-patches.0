Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622739;
	b=qqCrRvGCLTmZsVDJDYqq1NGuAcPja1BPKNXL1AzqLDSXmNRutduwH1udV8/N7hr42tc0
	 tDMBAJElPYY6+oC6zSErxIlm4XrVQaMUhG3BWlBgeNJu/TuP/Kf+wAsPnUFGL5olEXIMa
	 9pDzyWb0hYGfrdmnNjd8H9pcm62TLfHEzCkiH4yWvXVKLvH+ela/tyyNy+IUD+CjaWjTJ
	 gUFco/OivwceAZLqg3hUnFs5hpioKgyxbstObzArq1gpth8qHcGg4xYZVA1APqfevcTlf
	 mInr8PYcJXPpJxufG9Y9SWdtPoAcS5IJmrGEiabZoOh6vWmu8LmTGvJTTwMePnx9d3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPaOCOc+RZtt4ErNlQ2HtHQDMv1wFqnuCOGI4pqbzQ8=;
	b=Ejr21zPqZ1cMiJLz5JlhW4akk+me/wKcqsThYSDYPeOwGcam8J8FQEfJRlN3lb4FrQjV
	 IoQqUpwy0jlWbzzAZjlEbBsOHksg0Vxtvi35pmrC5FbcvGH2Tpx+PN6iYiipu01Swcw7O
	 9BGoCgwxGGnP+IODaeY2G8nIPbatnTjwkgtlWBLNe80aaK5Bko7D47CY53jf9vHa+a42L
	 mksws7YpADN3VG3/S7T9gHJsicpLI7qkomWKthwG/yH3TXIpj6WY0zvbeWTgtLXxGejZb
	 FVhJASgNOFwPv7PtsHWCxT/U9Pvgzf5cQGHYSytlzsmnH50yOXu3Tf5B+j6+qaS32vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2V/kmqG5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607C5606A31E;
	Wed, 25 Nov 2026 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2V/kmqG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514501F000D0;
	Wed, 25 Nov 2026 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622738;
	bh=JPaOCOc+RZtt4ErNlQ2HtHQDMv1wFqnuCOGI4pqbzQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2V/kmqG57lb7bjb3ji9xXiI4C/ENmK3flv05w0QqzHz7XYqja1vv8B96qrZrmLpqs
	 o7oCYRWAxTCWSsIzn9JBmmwJ2asYxgRyxmnx8k1IJZ2TeDTNxI48bT/yYHq7/WEocO
	 3Di95+KOhw9ZWITlA3lGUP4oS+Q8f+fpHBHvB8cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 595/990] Bluetooth: btintel_pcie: remove duplicate BTINTEL_PCIE_MAGIC_NUM definition
Date: Wed, 25 Nov 2026 15:32:42 +0100
Message-ID: <20261125143836.028592331@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 937363063afde2dce1f45d8f22514db99b9eba6b ]

Two identical definitions of BTINTEL_PCIE_MAGIC_NUM were present in
btintel_pcie.c, one indented with spaces and one with a tab. Remove the
space-indented duplicate and the surrounding blank lines. Kernel coding
style requires tabs for indentation, so keep the tab-indented copy.

No functional change.

Assisted-by: Copilot:claude-opus-4.7 sparse
Fixes: 6ed83047389c ("Bluetooth: btintel_pcie: Setup buffers for firmware traces")
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Removed the duplicate space-indented BTINTEL_PCIE_MAGIC_NUM define and one blank line, since the two defines are not adjacent in this tree and the context differed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 3e8c894fbf640..75bbb2bb6be55 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -63,8 +63,6 @@ struct btintel_pcie_dev_recovery {
 #define BTINTEL_PCIE_HCI_EVT_PKT	0x00000004
 #define BTINTEL_PCIE_HCI_ISO_PKT	0x00000005
 
-#define BTINTEL_PCIE_MAGIC_NUM    0xA5A5A5A5
-
 #define BTINTEL_PCIE_BLZR_HWEXP_SIZE		1024
 #define BTINTEL_PCIE_BLZR_HWEXP_DMP_ADDR	0xB00A7C00
 
-- 
2.53.0



