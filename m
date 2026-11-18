Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020303;
	b=dfFEVD75r/Vb6gYvmxS7D/oV+zcig4hCstiaeLc+0LmeiIYSTjWd/nYZQKOQqCndo3aR
	 WIAymetW0xjCtHQcCQtnc8S2rbZvbAUFwudsUNcMZlMHod6b221GQXC1gJEYRokwzfeYi
	 EZEYm9qR2qv/DA9jQ/UJlaWEYAPQSw4H8JpyYrQY7s7/S3bIYG9RyLOcQIYYO46qb5U+O
	 jaS1gHwWwHU+fK5ep2mBW/2RoEyc6NXC+B+Et+BmLwSzP3qSah0wVsu+yJ0emHUKpj0jD
	 BA3uGC5kX3O2t3edr+otmxZqWdo2/7oB4ub5PQXFUzE+vAbOmguQmu3G3pm2xvvIVig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldmrU91OTO0WEb1WOcWqf0U0dpLXjWAh+06OV+NXkFo=;
	b=0r0tVEBtN7hgCxNe/QO2urPqzjzAzak508McXEJxIQPeaGcyTZSlPxpbksFor4z2X492
	 2SbBmhCDU33zThNdXd8Ne1LWjyy0A5TRXMNfeJz+kxry9rC1PMS96Uml/+nXg9kh30cID
	 vFItHz6JwoI3LjZKqXgHps4Oie9RXFD1SUJwmJHxPxwvxhfDkDwepuROKdTX8fqk7Ma8A
	 X0+6UJ93L6kRgrSiGFaF42KuAWHih6vVfrRTDnlIrLb5a4vismiA7mlYzvXXbE5YKH4Na
	 7vQd+Jcj43rBk2e/wbDEBoeCACdUT/1PNosvGql4ehdq9UIFsUoNs+l2i+z4Ngx0qgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCOJmRkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D6606A31C;
	Wed, 18 Nov 2026 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCOJmRkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459C61F000C4;
	Wed, 18 Nov 2026 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020302;
	bh=ldmrU91OTO0WEb1WOcWqf0U0dpLXjWAh+06OV+NXkFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCOJmRknAH2PEk5Hq47ZOQE3yNE9T9NPCgypVN4pdLOBXHs1uPqPVWpKs+BRYzFnu
	 x9DtmGnANWSNqBCEzsPvOJTPpXfLszdr53BXxPJTPpZZdXXJPNleSSZ8Co9MhT4Iws
	 ap0RpJLa1bsb7DBZI4++hyNvTX/a5GWnoToEZfIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1903/2651] Bluetooth: btintel: Zero version data before parsing TLVs
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150355.333043116@linuxfoundation.org>
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
index cf109d79569a2..4871a552d3aa0 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -751,6 +751,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
+	memset(version, 0, sizeof(*version));
 	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-- 
2.53.0



