Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C249620;
	Mon, 13 Apr 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097731; cv=none; b=jXSrExQj3t5/UNLtwNh7RYfzh7iSt9vLa/agM70TUs3HfarHeR+Pt/KZhUwt6Ge2YczOMw8OgTEksi0tKNo+rJcfwJ3vYl/RQh3hcLBrvc+dHp/KwaNV+/4EsMUjaH10ZNSV4KBe9D3HBh6nEqfl1X8LJhGLeAJunbWt5yliXvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097731; c=relaxed/simple;
	bh=kezZqFXvphmjuktTDoAuJk2U9Mp36O0c0I7CM8W23fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV0klMiLvejS0/YSEiMbAMFnBORdMprgOJApolOMCEdGHcYWp6fW2xajneFaQFfvRxsMxrb7WEKsGeWhLqg8mdIaU5WnocAGwWGInjV8fDY7gzCaEqmHcMKhpbRXlVW3eyivKfDj+mEZrm90jboELHo6j8NzEuyVDSnUBvqKTYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHHZmRWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHHZmRWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89400C2BCAF;
	Mon, 13 Apr 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097730;
	bh=kezZqFXvphmjuktTDoAuJk2U9Mp36O0c0I7CM8W23fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHHZmRWHdfxM2Ga4oK3qNCIXKZ/fzdfvXrm3zH74IahMoff82OauXuywYdNniplI0
	 zI8GBiFztRaBO7FvfWexHJQdcYISRDxH2NRkGwzg54PuCNny7rbHOzpEych+5vrZeI
	 uHcFArpQl9zIL4fdCAWRhj/7ckQ8QKB1bxw2EVEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 250/570] Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy
Date: Mon, 13 Apr 2026 17:56:21 +0200
Message-ID: <20260413155839.832227562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 0e4d4dcc1a6e82cc6f9abf32193558efa7e1613d ]

The last test step ("Test with Invalid public key X and Y, all set to
0") expects to get an "DHKEY check failed" instead of "unspecified".

Fixes: 6d19628f539f ("Bluetooth: SMP: Fail if remote and local public keys are identical")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index d1ba41153b66a..1621c24aebf88 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2737,7 +2737,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (!test_bit(SMP_FLAG_DEBUG_KEY, &smp->flags) &&
 	    !crypto_memneq(key, smp->local_pk, 64)) {
 		bt_dev_err(hdev, "Remote and local public keys are identical");
-		return SMP_UNSPECIFIED;
+		return SMP_DHKEY_CHECK_FAILED;
 	}
 
 	memcpy(smp->remote_pk, key, 64);
-- 
2.51.0



