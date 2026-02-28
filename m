Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC023321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301241; cv=none; b=L6pa7pRsIP9Nyr1RaruVMqT183Z1Q9eeFLywPyy4BamaybrGGWTwQ0qI7Cy2N/RDgKWwHRXnZsrLZ29CdOuVtOkuTqMgB4eWvGCRgEmjq995o6iPXQIZll8qa1a0pieb97vp+znFelgiBj5JVqJsNKvlEdz5P8u9RRUfD4sUXD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301241; c=relaxed/simple;
	bh=bAekLvKe5cXYjCit2m3nXXMiwpO0zC6TC3rs3T5uT+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9mpmmtUfis2nhKCZlUGvirIEfLEXqkEpFa2qJnK+11Ob8+uLIlBuTNQw4Gw/DAk4hf2W9rkllVa7u+CNaF+kAmv5VpQqkgwOU6aIKUmQz7EE/yGK7XjQNQLxFX4msPfAT1zSO8SIzlu3Tgns0Fx6mqE5j3DlMms2hap4wmL7tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGlHcjm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGlHcjm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F7BC19424;
	Sat, 28 Feb 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301241;
	bh=bAekLvKe5cXYjCit2m3nXXMiwpO0zC6TC3rs3T5uT+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGlHcjm8uzrDyb0TNlLOBVsgtFH9FwtsH1z5v0XAD+w8YN83ST6YPqPKrH+Yp82Ba
	 zgTjsKaGhoRuy6WUeG1oKqQ75pxxWbInM2HiLMR3UfYRn/70czrrDt6TalLxSnS43J
	 NgOIsnvccoszfcHZYlGOveaVfbDpwkyo6lXYQ8GqLQYLbHBCmL3f/COi4Fz2iALKnF
	 cRbcmOSrtE4IqMVbJ229HRbvf/fJcfRP6nqmluo3O1YLWB9L4PI62FhI4IRexIIFwU
	 uTMW79UDyaAxl/0p9UDUyGQaKTFIoiCy5d63ByBY59o33nbUKvA/Yy6IgYGo0X9q64
	 2QXFxKGZY5Auw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 422/752] Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
Date: Sat, 28 Feb 2026 12:42:13 -0500
Message-ID: <20260228174750.1542406-422-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 05761c2c2b5bfec85c47f60c903c461e9b56cf87 ]

Similar to 03dba9cea72f ("Bluetooth: L2CAP: Fix not responding with
L2CAP_CR_LE_ENCRYPTION") the result code L2CAP_CR_LE_ENCRYPTION shall
be used when BT_SECURITY_MEDIUM is set since that means security mode 2
which mean it doesn't require authentication which results in
qualification test L2CAP/ECFC/BV-32-C failing.

Link: https://github.com/bluez/bluez/issues/1871
Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0b236e977d70e..a5038160675ea 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5096,7 +5096,8 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
 	if (!smp_sufficient_security(conn->hcon, pchan->sec_level,
 				     SMP_ALLOW_STK)) {
-		result = L2CAP_CR_LE_AUTHENTICATION;
+		result = pchan->sec_level == BT_SECURITY_MEDIUM ?
+			L2CAP_CR_LE_ENCRYPTION : L2CAP_CR_LE_AUTHENTICATION;
 		goto unlock;
 	}
 
-- 
2.51.0

