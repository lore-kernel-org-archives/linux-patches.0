Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020369;
	b=O3hUsQ/Na+IS8vN5MROmqOcNwj+vFvg3VH3ZSsaaz/H6xs8xqBmXBuTmO70ndJtoZ+YC
	 877Q2icEPB8PoRyvqVSA8nkfW4LbfsMEbzOBmTqQ9FKHNO1BtC698QS9dOMV7JZGeEPOr
	 LoIFZgz3Urq+XITjdEP3v5yw5D7FdjK/WCIKxafOp7M7eUV9vzX+7UnneEv26G4tN9t7k
	 y2v9Vq0oeGi9IdCJFYjcDA11fYXTsUAeVWXc+tzHBPa7lpY47qA9cOE1PUN/W8psvhF0n
	 7l9mTfowI91b1UhRnrNU8XZiFf/Lmt93frAxZs0BztedWGhg+w0rkLG0nICT2SB0I2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5fNLZ+ABuvRh0f3JVP6ww1eWNTZNf8isrom75ujobg=;
	b=qLmgO4rsVz0eBiOyi5kX15rNIeBxlnOln3+arxhzE7NUUg4wQTFdIkbg3xcRyhMSELlg
	 wx2X+KP6pJHnPk9g9WEZ8GaFxTb/i7Zej4aoRsCA6XAhdMAcbmvLUImHJ8jTdxCZ+nfuU
	 AMnsqOsUTmSy4rEg5leB0GHq8i2NPATWp6MOVIlSvShSHjumrndQzPjEne956ZlQ0y657
	 RJAxhb3bHkq9aejkjEW7E+GMHjlx3eqFFhvU6Q2igtcoImmvn70OUlBC20tEl8BbjNbum
	 5ZbRJXSAlaPtSYqn4T5dyVirtvgtOTX02IjUOmWbIllU6/PRhRVGywjVMYQm/bOqW6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H47doxFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB928606A32A;
	Wed, 18 Nov 2026 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H47doxFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D5F1F000C6;
	Wed, 18 Nov 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020369;
	bh=u5fNLZ+ABuvRh0f3JVP6ww1eWNTZNf8isrom75ujobg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H47doxFM02/o1Oj2RvbfxwU9nSfYF70SETIlLKhAYFPXxlj22fP4VWMPvz/jTwgSc
	 0hn9tl3WpvDzmcXffMT0dASJsFM3uUfl4xAQSCmKqsWeuGRc3mVRRDC51v0NPUj6ty
	 siLgxmAhOyh7fmsFLmkSInylFARDUqeSnCOqmDag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Sergey Lebedev <lsa.uz@pm.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1886/2651] Bluetooth: btintel_pcie: clear the GP0 cause with a W1C write
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150354.800272186@linuxfoundation.org>
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

From: Ravindra <ravindra@intel.com>

[ Upstream commit f2cee6e2aa35a6a701ce3f4bedf20273c808361f ]

MSIX_HW_INT_CAUSES is a write-one-to-clear register. Using a
read-modify-write helper writes zero to GP0, leaving the cause uncleared,
and can acknowledge unrelated pending causes through the read value.

Write only the GP0 bit directly, matching the interrupt handler's W1C
acknowledgment convention.

Fixes: 88c6216a52ea ("Bluetooth: btintel_pcie: Suspend/Resume: Controller doorbell interrupt handling")
Signed-off-by: Ravindra <ravindra@intel.com>
Tested-by: Sergey Lebedev <lsa.uz@pm.me>
Reviewed-by: Sergey Lebedev <lsa.uz@pm.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 8bf9a9b4ae78e..85141532de602 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -3543,10 +3543,12 @@ static int btintel_pcie_set_dxstate(struct btintel_pcie_data *data, u32 dxstate)
 				    "Timeout (%u ms) on alive interrupt for D%d entry, retry count %d",
 				    dx_intr_timeout_ms, dxstate, retry);
 
-			/* clear gp0 cause */
-			btintel_pcie_clr_reg_bits(data,
-						  BTINTEL_PCIE_CSR_MSIX_HW_INT_CAUSES,
-						  BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0);
+			/* MSIX_HW_INT_CAUSES is W1C. Write only GP0 so other
+			 * pending causes are not acknowledged here.
+			 */
+			btintel_pcie_wr_reg32(data,
+					      BTINTEL_PCIE_CSR_MSIX_HW_INT_CAUSES,
+					      BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0);
 		}
 
 		/* gp0_received is set at the top of the handler, before the switch on
-- 
2.53.0



