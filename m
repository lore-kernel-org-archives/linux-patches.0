Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ADB3101A7;
	Fri,  7 Aug 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115973; cv=none; b=ltHzEVwgspjhYFw3epJZ6yQ36Gl4tSCSGiDmRHm+lghpYvGB9G0PyjBVNvJOnFfS6jqd/0AdZV/qQJWA0B/yElKctTleWYanx/S2+nVYCGL9PtFpWXihA2Fux4REruZR5a1lZbVYNd3L2lViMptlu7lEjR9P5YYRCtd9qfoCJrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115973; c=relaxed/simple;
	bh=qm77M13yVDJ3rOpqcsuAmHcHugyYrRIyDmkRxu++9XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gal/JKNYF+jSwG8waeAsCZ/nf3Az8IzMoWQ4RcfpfUcEwURL5JBbBOxR91zAdV/dI1jNh/JDLO1LwUeXm19EeIIjNEh9ZhM93d3eqGEa1kJjea1MaY00aVzQFIJf56aNU3UhJ+f1f7n90SiO1Uvzl9Yb2+CkRjFsBRYF7ljqLz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgEQ41mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgEQ41mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5A31F000E9;
	Fri,  7 Aug 2026 15:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115971;
	bh=1Mgs+V9MMxUp7wpyaxAW9Yi6J6TN+PMYJG46xReKs7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgEQ41mf/WVd4reYTKsJ57otSYRsQIWQeCrPlHLaUd6j0yPy31GgHN4mvIYVVU/iW
	 lHBt0DZ7teX4uu5LtxINkkKZc15IjqaapXIAv+OUSZMh/BoF4gUDCiePWvB8atFKem
	 UEp4WBpNk25j1IG/a/6PS5EVym79GBHC1C+pNFWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/261] Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos
Date: Fri,  7 Aug 2026 16:37:02 +0200
Message-ID: <20260807143416.784809874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e9cb51813d79fc9aae4a2098aab3ab6ebd7fb6c8 ]

In iso.c check_bcast_qos(), missing bcast.timeout is not set to its
default value, and appears typoed as bcast.sync_timeout.

Fix the typo.

Fixes: b37cab587aa3 ("Bluetooth: ISO: Don't reject BT_ISO_QOS if parameters are unset")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 51d0065f058c1..a67bce151aaff 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1439,7 +1439,7 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 		return false;
 
 	if (!qos->bcast.timeout)
-		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+		qos->bcast.timeout = BT_ISO_SYNC_TIMEOUT;
 
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
-- 
2.53.0



