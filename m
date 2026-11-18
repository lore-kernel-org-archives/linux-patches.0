Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056313;
	b=Z8Z8pPdoWga3Nsp+r3iBJYnTQ+IIhIeOwwjOskNG4cG/as2Jz3JOBV8mXtfyyFTxyM/r
	 X91DZIrH6FMh4YuyXaZM0P6CPTiwcRqAV8ULI5q26b4uaA33qy+u8flvUfPr8oR54ZhI1
	 Z1R2T0AAyZ9bTeQpZxIO0FAM7ZUYwRMUQycb7/DjW/lPvHS/Eb50/+fAXre//m2A91xGV
	 1dADJL3s0sz8IZ2VTEU8L1E4PSC6J6qgAiKqn/4Z6QXQmLqlzJ0W/dt3e5CGmYm9DT4y1
	 61XDfMxI5GSkb6ucTC5t9kziSGFH3CcMXX7RsCl5VWbp5kfPaG7ymdjN7Zr0QtoVIuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxQcsY9LWMXDXz8aLiVF6v/+IEtNVBeKaQk4SepM4AU=;
	b=3LFyT5u95yKQfM0KN0SducfrIccJLPfjGrMtMtBdaD0jS2IUx8aVzot+d11kfu3h9dVG
	 qIbNjBpgyPAiOxdq4u9MD0+cOu64kztNh/borHR0Ioifhuls/YVCd43PmddQBZ7mJGY4a
	 yMmINwg5jDbbpldbUsl4XI5wbXSa/EFR7TVZZkKoEqJSwOPqMzu4ns2C4X7rj26H5MaVu
	 DdITMxaUDOF8dpnq/dlqvJI2ea6c+mD6e486p3fEbCVBWKHzKzflNoP1CYp7UNyLdJM7U
	 Nv8Ahp4UbKywcj5FVsb8CCSNJIO/LjNlefcG9ieW4VakMPHIbv71oe2iX+MqzsmzLDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ETMIX/t4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1EB606A320;
	Thu, 19 Nov 2026 02:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETMIX/t4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0321F000C4;
	Thu, 19 Nov 2026 02:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056313;
	bh=fxQcsY9LWMXDXz8aLiVF6v/+IEtNVBeKaQk4SepM4AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETMIX/t4/iICCleuMO1z7jHAV1tGiGHZMePpojwv9WxIjiWSIvDPi4aO9mvoWh/t6
	 82VKzyQp/JcgrAWB0krpxJw+vjEGI/4EH+Dncek0YJJr4hMHLi0/Pbd97yI21I9Erb
	 IQ9L6agFkcg+gUP5HyhW9Rr75QoE4AcCjtldBjtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1941/2214] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 16:00:17 +0100
Message-ID: <20261118150128.670597299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit cf87709d7ff83b4de5d42b61e4a9806fe374cb9d ]

Firmware may omit optional TLVs, leaving their corresponding fields
unset in the caller-supplied struct intel_version_tlv. Since the
structure is typically stack-allocated and not cleared beforehand,
fields for which no TLV is received retain uninitialized stack
memory. This stale data can be logged via btintel_version_info_tlv()
and copied back to the caller, leaking kernel stack contents.

Clear the structure in btintel_read_version_tlv() before parsing so
that fields with no corresponding TLV are deterministically zero
instead of containing garbage.

Fixes: 57375beef71a ("Bluetooth: btintel: Add infrastructure to read controller information")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 87a2cdedb1e7a..8b8dad2e1f4a4 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -639,6 +639,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



