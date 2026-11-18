Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034810;
	b=kx1Mio8CgyNeASEDeTTKEyFRkyXZ/KAMELiu92yDRkKJm0AYii+UNgEK/PA3JfsnpU5z
	 Bs67hO43vMc0Oc7ZgdyRhrbGnSlQp1CUe93GWxWQdQgd4Y3d6FCuWpxSF2eMr4vNNdIJT
	 xRf5W1IXt+Iv+lF5XZmTsk3b2E243MsjoM70FWt0JfzqUuXGQw3HwOVj1KaMykzbE98X2
	 cwNm0uO/sblYcFKmtTSmq+VFK+mlERd77KVBx9dd4BjHnZ4nXG5hCTbyy1srBUxaVAAI6
	 TBPBvL5INqGtVugNxlpEREJV1jx2+lVabp+xynsUPtmU4YaI0g12MlR3oQCxjjUkHlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AqjOr2l5XZzAtoeu6YLfdQsnoecwe9LBOArRdxVsS+4=;
	b=j5pO0L/j0r6d4DwgNNS3QOWJxMpowICdcSb81jkZlOvfaKnBJd03rkRWv/x83YiWtc+C
	 Veq/DmoyKxgG+Tc81u20jHroHSHRWR4LNwmko6uIoFq8PaxQcc3wuErDM5PWbj/7ghM/M
	 wRDYiqhvHGu5mCyHbC/UgckugHRufnQKd9ZLAH2UlzE5Yup7YRtdsykf2oxfRxvOlywpz
	 rJb3VWciSvKp1V81Rkr3Dxo0UY27jN64oeGpRSlir0DXLwrylry/Kd3IgLIr5YVFxOVbk
	 qgMaDtuUtxkLYoWt/fQwZuns/wgD8x8rn29Wagoi6z2gbZm6UzMg4dVKh39RuZXVEDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw7KR4+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA9606A32A;
	Wed, 18 Nov 2026 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw7KR4+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A846A1F000C4;
	Wed, 18 Nov 2026 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034810;
	bh=AqjOr2l5XZzAtoeu6YLfdQsnoecwe9LBOArRdxVsS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw7KR4+JXyHaCXRzIaf942xjOx5e30sHDc5jk74KjgDpiaYOE9TsQ+LhsFV2CVHUA
	 fXQMPDfGT6cjgVjvf/FjCaNEL/jglgwGvgukFOwpkymzdZP188a2jz6xzpCDG/mZMo
	 SlZCXwxjjtOMZ/gfsKBxai+9Frc4rtJoFZoZwZKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0485/3318] Bluetooth: ISO: release unused CIS holds after channel attach
Date: Wed, 18 Nov 2026 15:18:27 +0100
Message-ID: <20261118150331.524022100@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 0fcd4dad555c96e0bd3a1b8c569f989be85c7341 ]

hci_bind_cis() and hci_connect_cis() return one hci_conn hold for the
ISO layer.  A new channel association consumes that hold, which is
eventually released by iso_conn_free().

There are two cases where iso_chan_add() does not create an association:
it returns success when the socket is already attached to the same
iso_conn, and it returns -EBUSY when another socket is attached.  The
hold returned for the current call is unused in both cases.  This occurs
when deferred setup calls iso_connect_cis() again for its existing
socket, or when another socket attempts to reuse the CIS.

Detect the idempotent case while the connection is locked and release
the unused hold after iso_chan_add().  Also release it on -EBUSY.  Do not
drop it for other errors: a newly allocated iso_conn releases the
transferred hold when its last temporary reference is put.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Dropped the iso_conn_put(conn) call and the missing bdaddr_t/u8 locals from the context, since this tree has no iso_conn refcounting, keeping only the new already_attached check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 217ba98b053b1..cc1267cec8229 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -407,6 +407,7 @@ static int iso_connect_cis(struct sock *sk)
 	struct iso_conn *conn;
 	struct hci_conn *hcon;
 	struct hci_dev  *hdev;
+	bool already_attached;
 	int err;
 
 	BT_DBG("%pMR -> %pMR", &iso_pi(sk)->src, &iso_pi(sk)->dst);
@@ -470,7 +471,13 @@ static int iso_connect_cis(struct sock *sk)
 		goto unlock;
 	}
 
+	iso_conn_lock(conn);
+	already_attached = iso_pi(sk)->conn == conn && conn->sk == sk;
+	iso_conn_unlock(conn);
+
 	err = iso_chan_add(conn, sk, NULL);
+	if (already_attached || err == -EBUSY)
+		hci_conn_drop(hcon);
 	if (err)
 		goto unlock;
 
-- 
2.53.0



