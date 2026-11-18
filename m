Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041735;
	b=JLhbHlpmTbEVmyF/Khl7BH0Gj2/6S2v/wDNt18NF85V8whWwiBeQHgtF8UsY0h3IZuCZ
	 bnr+xOSSmqJj3ayfqeql4GFDYnPrHkDKytrpfx3H8gEpdqZJoy4LjuaD1XBGkTVWZ9zV/
	 BsBxjPRlARmBVXGC3ON9VJcDWGBy+2eTFKvVkfAvBnzdrLwcgWtqu2ofAgKCsaNwyVdSG
	 IvS4P+nNM8fFNxeEWQN09L31kJfbQ7mJsh3NP0YlCd0mMPxq//aAVWbaZFczFtPW46Wgt
	 RStubX0lW64SHqNHArvtno100ePrFQyKqMujsxLuq9yQOiYhdo9QvFpnhrgOpTk/GNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+/1eXo86l4Y7TpQ2sZdHBtjQlmZROYuHPgI0plPJjI=;
	b=OwW9eR5NRT2XtWvd9/6XPHLm+MfzZVUCVtXB5L+xxgrShdmhqqZ4t/rhZHrAWRHNl5Nc
	 gbd5VWOyqmQpHjeIIcab6c/Nwytxenn9ZMdu3JTZUqEqVzZ6oO5dJHM/8/MZ11wviMr7I
	 Y4D4h0Pu6uNhLrpjalCSpQ3mMXnFObXuEt0L88E+eSwc0Ll4GcPe3GcU2vaOnCX7UVIme
	 dSYMZW080qR7v2yvzObdpowBBeF4CDuI7daIluxdU5OYI+TijmYb3bty5brL/5yrn+BRD
	 oPzIRaUcc2IwVAq3CxRDUgmw3LbmbkmUtv6uBnpZJu8GQYUOyDA7pMFfRsoGHEYTDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFRVgn8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64CD606A31C;
	Wed, 18 Nov 2026 22:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFRVgn8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDEB1F000C4;
	Wed, 18 Nov 2026 22:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041735;
	bh=e+/1eXo86l4Y7TpQ2sZdHBtjQlmZROYuHPgI0plPJjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFRVgn8GcMq2MiDXZ/KF7IVsDJkKVLaf6bAaE3ANw3w0UQpUKx9WbsnOYFxo33ibz
	 HFUC3cNmA2SFZ6QZhJ96Kzco02DACiBX2x+hQ09SPZs0kKsCiOCmOu8R5jwrDI46Hb
	 0P4dThrG+PxDYMuw93Q2FV1jrYnTTwg6ZLp/Hdh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2893/3318] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150447.292126146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0438bb3f1132c..48c956c608043 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -712,6 +712,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



