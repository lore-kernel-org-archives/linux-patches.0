Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020283;
	b=4dqrDewas7uUBPUYpXrTDQJsocfPilxzeu7ADnVfQNVLwQCE0L5R2ISZe8ck/dSIpFgk
	 HuXObSIJWQ7dUjBUQqwTIG3O2ljBmZJL6VTJl+GNBxYUGa2+pNrzd4YLL7W8uRulaXpeJ
	 mXnTMrf4PWVuXZ+h+VEqGV+LC98EJ8jc9Rh2u5Ww56dO9jsoAS8sLxlGPo7QR9TlN9t2m
	 kPB48paBRtNQm/uvWXx7/rfZy1I7wu8oer2ORO0pXvcsrMmPVTY19LMqsP2aRYNXg/MQh
	 qeMlepI5xqQhuTb2UpudqSdoBvs8DhyTDUW5bywcVfnW68w96Lbua2DUN73K6pEE4uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ty4z7nhlf8ZXu6OfRN10Bb6yWAVdz2InTrqxrHbHBzI=;
	b=EEMri3+WFhTuqUFFCvpVlZTy3vB9bzbE8xdFpBeynZantFLfa9tRCFwaqjmpXzulKjXm
	 Xmc1BsKNbdTBrkSLW6XV31G3HvHeIhvFVhtZSndrEjocZdGPhPMHI+m24coZQVnrbwKVF
	 UofKgmVPc5fdCUzJZh26U4dIS5NNlMvVQEqiGRlcK7mUZvR6YwfBiRnCklIwvLO3NU4MO
	 R/cBw6/0td/Q3sGnEp1yoEmxXFbHXl5YCuFxeG4YemYOvNuy47xb8RZ1p7UQg3t1OjpOX
	 RECYYQsISCOVXuJKjC/iFXW/Zy9IoQGf19lmxFsoOruoMWwGz2D9fTJwcqfMWl/hDxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWpGU4vw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BD606A320;
	Wed, 18 Nov 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWpGU4vw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7D51F000C5;
	Wed, 18 Nov 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020283;
	bh=Ty4z7nhlf8ZXu6OfRN10Bb6yWAVdz2InTrqxrHbHBzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWpGU4vwpVS6xJRJkR1TwCZLeWzka/wakNvHP+cddSBVWI7Ic9FUKavHDXzGMsWTc
	 bJuc96vWLzH2nEyqLYE9ozscQ6g0e6EFZzS/Fs9WbeyStb7hbiBV0fxc3aONzlChcN
	 c8d/1YBlVMnkrjOujsPL1n7ItrMgOZX8u62xXZmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1879/2651] Bluetooth: btintel_pcie: remove duplicate BTINTEL_PCIE_MAGIC_NUM definition
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150354.576478549@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index b5540db17fec8..9f1ff12d85a07 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -73,11 +73,6 @@ struct btintel_pcie_dev_recovery {
 #define BTINTEL_PCIE_HCI_EVT_PKT	0x00000004
 #define BTINTEL_PCIE_HCI_ISO_PKT	0x00000005
 
-#define BTINTEL_PCIE_MAGIC_NUM    0xA5A5A5A5
-
-
-
-
 #define BTINTEL_PCIE_MAGIC_NUM	0xA5A5A5A5
 
 #define BTINTEL_PCIE_TRIGGER_REASON_USER_TRIGGER	0x17A2
-- 
2.53.0



