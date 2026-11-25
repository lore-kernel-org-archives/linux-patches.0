Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618230;
	b=nfLjzXR/i1iVpEvo2VifwbG86aGXyN79VWlWMRCMwyOKKJImsegKlnK1EZT1y44PjDFI
	 5XArWfQK2OSp+cyvInaMaYsRctQGsuUi+9w0hrhgQ9cA6quVDj7VOS7t3e74h5JCX5kTb
	 TtZ4T1zkYs9/8lV59qh3UTbXRnXu8RKmmmqd4E5HuDqj67cj3swaZFzS2CEXEgB5LNnb8
	 VOcXjg4pGcPFM/MSTcPYV6q7ve+AzAFvjtwHDns10QMZoDX4GIC1/IDUiv6dbU7KlilFQ
	 PUuEtulQgfOxZwA3Vxssw1bzFp7P0wNj5zupCFWVKAjzoez93CvGD/KGLPbBgJogRaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3xmdCrBhjxt+DIrmxZbjZyXLMXZ/94/AWQSl+Xc95po=;
	b=ldaRPKXzCQc6+i1ThRrOvC9Sn2rOwVPHXc+rWl4g1QNjqjuIbAoJrpffHj7xSwgQ3JrG
	 25c50k001qrmUbBnS10pEMuI8f3kXM3XNkpy89IJg47/BWKjGzRwiMje+0NRoJtXX+D2j
	 Ms/jQkcT5LpYOgHWjuAd3EiUMzhIkaTloJyFrn0J7JIvSfaMeZ1zRRE7IJf2pqhINUXoy
	 +jA5dJsZ6zTFef6ZXptZs2bn5hRsF9B0amC8fQbMGeMM0AcjkHy+YccNaTelJiPgqUtrl
	 LPii1zVNVHV0Ikdxcn2wlMci4u6jAyS1pUuY/T60c0NIJxWieUjlzP8YRPDYVw+9emg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXHTMNFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AC8606A321;
	Wed, 25 Nov 2026 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXHTMNFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6B91F000C0;
	Wed, 25 Nov 2026 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618230;
	bh=3xmdCrBhjxt+DIrmxZbjZyXLMXZ/94/AWQSl+Xc95po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXHTMNFucjsqIJN68gpxqyuV9oF0IaPFnbrwVupiZ6xya+dpDomI8QLbdi1rz2XD8
	 sWpS47surwv0cUPZAE+bddTCWVDakT9et6onjyIuHl1G+Y1wljBuentTo65c1yg6Sd
	 ijqZSShhWfdzg8YNTiFyCU+xNSFbAlrCMW2Vn5Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0211/1005] Bluetooth: MGMT: Clear disabled connection parameters when loading none
Date: Wed, 25 Nov 2026 15:25:49 +0100
Message-ID: <20261125143826.684772660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit d90f24dc389b9a7524aaac109021d1530fa180f0 ]

Load Connection Parameters only clears the disabled connection
parameters when it loads more than one entry, so that loading a single
entry can update the parameters of one device without dropping the
others. Loading no entries does not clear them either, though, which is
what bluetoothd does when it starts without stored connection
parameters.

Pair Device adds disabled connection parameters for the device it pairs
with, so these now survive bluetoothd restarts, and new connections to
the device keep using the parameters they were created with instead of
the defaults set since, e.g. the connection interval from main.conf.

Clear the disabled connection parameters unless a single entry is
loaded, as was done for any number of entries before.

Fixes: 0ece498c27d8 ("Bluetooth: MGMT: Make MGMT_OP_LOAD_CONN_PARAM update existing connection")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b964382a01977..90d73ce442f42 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8175,7 +8175,11 @@ static int load_conn_param(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	if (param_count > 1)
+	/* A single entry may be an update for one device, so keep the other
+	 * disabled parameters then, but clear them otherwise, including when
+	 * no entries are loaded.
+	 */
+	if (param_count != 1)
 		hci_conn_params_clear_disabled(hdev);
 
 	for (i = 0; i < param_count; i++) {
-- 
2.53.0



