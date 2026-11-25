Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621320;
	b=BczUyjoVIbCs9NiBMx3qd36xs9kwtPb9L+WWcrePWbnxSu2OdM/DoeT3+UvWwEWFNAx9
	 sI3zsfXXcoDH+HNPYHcHeKnAhtf60icJ6SJyTLtvyE9R70GxEjoLVEjlX+iWfM8pCw6DI
	 jMud08C3uUh+8fbvtctYXk//+J9cwtIEqu+EgVKaTgn5kmSfgxuKp/aWDhBrSTnVO6b5B
	 uupfYdaAPF02X0dix4vL5XgM9uhtmK5aVpz4t6ctNa3kSwl7KYwcUR69uXZU29SFsI4o+
	 PCEBQvD94o32MUxJvOC5cj7QSmGMNfABXR0rVZNDiefj5fpUwGAuA1MVguuk/EWD//Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0WI/vnB4LxI9Cs5XpPB2AtRW0+j12TuXE0jHjW8gbg=;
	b=cEmXut02gOjf/tVSP9HnQFJ2rRbLaNcBqVilIxmRwrVNjZutYbVOnoP+Tb6Ha/Jnf3IY
	 FM9m769N+as0x6iL2CrSu828OKNIupQU7MnngIHwsulpyIRd8wxoHHWznoTJaIuEaCubE
	 Awodhc5xoAFvPVeo42IuLdoDlCDzOyGQhBnYzSBf6qmus2N6fQmZwNK2Z+ZDljksbq6zY
	 J+S0oTAOtjk8vsLo9lqmh2cQLHVJjEUBmppu2a5hEzJoXBlw/E9waPEICastGHHRVh8Mh
	 xXtPAwRWgd1JblnjM9/Gk0hSZBDvHChuHjn+Dnfnh+bhUzbDag6zhHu0eKwD7BrxmqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnrHe2td;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F9606A69F;
	Wed, 25 Nov 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnrHe2td
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DA1F000E1;
	Wed, 25 Nov 2026 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621320;
	bh=y0WI/vnB4LxI9Cs5XpPB2AtRW0+j12TuXE0jHjW8gbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnrHe2tdILm16kRHeKjbVphL9kgpCCH1XNu05+ZNzXzAT3jXeXioc2fEi0H/IqumA
	 4Z37wp5/tmJ7rFhUQkCXq0/P0RjpHozdEuI28+Wa3AmwDFD167ZKxxnk9B0ieavMCg
	 QGnwCVlAvZ9aVLctoQldaL6y2uNPAxPnJiIC8PdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/990] Bluetooth: MGMT: Clear disabled connection parameters when loading none
Date: Wed, 25 Nov 2026 15:25:55 +0100
Message-ID: <20261125143826.497197201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 484243146f10e..8d18e94fe8c05 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8165,7 +8165,11 @@ static int load_conn_param(struct sock *sk, struct hci_dev *hdev, void *data,
 
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



