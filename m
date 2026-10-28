Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210857;
	b=MGBC3gdW/arItwpILWo+41lA+nbu+zJipEK21PHIuHGJVv3qPf6GRFtoSyahNPp24e21
	 C1mr6CD9srnsJx/KnMZDGWIGFt0obYBMWLZWO42g+ShuWOhcB+YWvoexF4mDhsSF2cRkC
	 p3f9k/WfvO/t3BmvP3RLJFkP/qem6MeDi4iYKbJkY6b6mtiZu5q9QRVBfh9ubGcXl1RDi
	 tcyZIdshuZJ5xtswSYYhnnqL9oOn9tyg2/h29SK2blU7N4WRn76wCmQMBVYFjrKwSfxjs
	 IkTVXk2i9uO7Xi1HFxpM3DLXgjjH1zY0Qmn2YIBEBNDSyQBtn52lPD6fiUxDVASvtEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiU+C9LNIpu+ldaIL1p6sXOZnpbPU/ZdJcuJr6rqggQ=;
	b=sx6YyXj/UhJac7SuiUS8PvqGGEtqsh51FuBNKIRLDxKYI+0VMqTXRriESnuBvUzHEdRs
	 7IHX3gqO/lhRf1IQhqhjVn0MFsR312Ac/DvkkTErelt2MxpYyyBiAnwDnysdqPE9Clehf
	 8Xv99tSHYVtRmI8DxRKU4ljQ7dDPBl8P8w9NG6a+NwYb1HwQe3dPkAfhQ5NYwPFSUkKuN
	 pPlLkY9acSqPzTHdCD4MstFubp1pOFIxOZKyeJ+nNs5e2stiD+U0ioTm86U2tbziRpS5g
	 z1C9YJuxKWnFCg0Zn1tw7BFVQFysXBX7nLsI3zvhMpo7e1oE14Wb2BSE9cJHMw9LQmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYqZWT6i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB53606A338;
	Wed, 28 Oct 2026 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dYqZWT6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A491F01829;
	Wed, 28 Oct 2026 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210856;
	bh=xiU+C9LNIpu+ldaIL1p6sXOZnpbPU/ZdJcuJr6rqggQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYqZWT6iQ7SPy69wT/lznt/wolbzHqB4y36p433qVirGBERDEgp7Mn4lsagkPude/
	 sMcrwCT8GB8Qvip23L6ZhmLUASb/4BlZsMgNA7NBnPZa0CnlHx1iRHZwPPSqnZ7XJr
	 V44wW4XGZqu8necpYLBWKQ4SiE6EiVSJIyFSXcLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/571] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Wed, 28 Oct 2026 17:55:18 +0100
Message-ID: <20261028170012.072196933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit d1ac915fb4184faad1b62148be50f317de7c24b5 ]

hci_register_dev() allocates an ID before calling dev_set_name().
If naming fails, it returns without releasing that ID. The device has
not been registered and hdev->id has not been assigned, so the normal
unregister path cannot release it.

Free the allocated ID before returning the naming error.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a587472c5f125..9dbc98879a00d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3949,8 +3949,10 @@ int hci_register_dev(struct hci_dev *hdev)
 		return id;
 
 	error = dev_set_name(&hdev->dev, "hci%u", id);
-	if (error)
+	if (error) {
+		ida_free(&hci_index_ida, id);
 		return error;
+	}
 
 	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
-- 
2.53.0



