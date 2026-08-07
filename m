Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2479E473C8C;
	Fri,  7 Aug 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116907; cv=none; b=TX/ft4v3f0K17Z7pHYP1KEis1CmI/nEW8KuYHc6R4MKN61hLUErrUnkUyBbaSx9bSIKLFwT53P8n9RXyVEO3D0vZtB4akhYoWwnKttMm5Jq+RaCl/eRpYDnkJNzFev8pO5adyY25Atg2HW1bsDaYcH1ZvAdowBogVgZSWzHBqIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116907; c=relaxed/simple;
	bh=AmPoOUKo3dpc/LiBRFw9CulpO9dLF4iDm9ILAHVR1Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvd+0nghYjYTo4YVjNmgb0FrP45bKzS4GmrLdyVwlwnFioYsZHOse3p+t8Oi+hRYO2n2aInwNJ34BqDWkER2kJSWHBut5aEaZ4q15xwrNsfT48nZz/dVP/QOUL2ylZU4XTqPgx3cS+BR31/5YrTqqx4bVEIUA6r7K0fK5vC5vGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfcxpRmS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfcxpRmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B9C1F000E9;
	Fri,  7 Aug 2026 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116906;
	bh=v8wa4L7iG0YE4+/3wLPu1adFw2qyxaOVZj9BOaYaB4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfcxpRmSSb55UZcOhciF4tobzQE9RAttkgg9JkgNzpObTd7WJ7Na6zFBYRQfu4Z0R
	 RzLi5/a1qlFwu51s/13de8B5pmBBtxZqtOtG9CTRfdBAanOJF1LQmITg5QblDRzFcM
	 XSMXR3Ai/ZiJEs+GSEIP6BzW29sDYQEWPIVV0M5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 133/438] Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos
Date: Fri,  7 Aug 2026 16:35:29 +0200
Message-ID: <20260807143430.831827021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6fadaeb1f7e96..7e8f8a51eebd2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1795,7 +1795,7 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 		return false;
 
 	if (!qos->bcast.timeout)
-		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+		qos->bcast.timeout = BT_ISO_SYNC_TIMEOUT;
 
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
-- 
2.53.0



