Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FED5142E83;
	Sat, 14 Feb 2026 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104416; cv=none; b=mtz7geoYBuu4Rtb3euGWJPHd/vPIfYxt0d6ffr52PFtOQIGn6jh3PPN2O5+sQYzQIUI7xNPEtUtdCB4gKTFPnnF1SmClrBvSvS+KcRkcf2+YOVINGfMuLx+4y7UHSbv69zfkSWkWKUz2hiT9USjQess2or6By17anAICUJ57rfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104416; c=relaxed/simple;
	bh=zoMV/NzMg0A/PeUsA5HJP86gpV+x8YWFr2pJq9M8MxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJf9DZEp8WipvicLy0G1WsVDD1/xu5YkPo6Udlmbgelb6PczNus4xx/E0C2Nox56iuDz2HC2hs9OCUSlROGbPA/HVKIvnjfALRbsRil3yDvJ4vpLlycm8r7R8MJTFyXW5HqGVLiRcc602QrESwZ+411feEpvp+Y05Q9TvliIT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iqk6Mann; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iqk6Mann"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE86C16AAE;
	Sat, 14 Feb 2026 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104416;
	bh=zoMV/NzMg0A/PeUsA5HJP86gpV+x8YWFr2pJq9M8MxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iqk6Mann2/0YKesc32d0po8iLXM7dpBlaCq/EMm+MIkl5UjiI3Tn0NCcOqGrxlvxO
	 RCGfd4Hh9R5H6EImikcgfyHoM+08tJSeSrVvj6cBcDm7TT4pIOCr9APiEf+qoONAcE
	 meC3ia/1a/fIKiySEOJ02BVjZuzLfFo1ymXNfEIwgdOkwUpHs8KRZA3YHSZYIlOenv
	 Thx0Nf0prDzD1GdPAN0gr30Jpx/YVsAciejm4mezTShCLvFRt+1rXxoCGfv+InMwJa
	 oX3zpQxZ6V9rsxs1S39uQh4/IDVlybBnnA/iLI5wLxXCz5YvKoB1kuEfrKBEIFyFxQ
	 K49IEQw7Dj7uw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= <ssorensen@roku.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] Bluetooth: hci_conn: Set link_policy on incoming ACL connections
Date: Sat, 14 Feb 2026 16:23:38 -0500
Message-ID: <20260214212452.782265-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Stefan Sørensen <ssorensen@roku.com>

[ Upstream commit 4bb091013ab0f2edfed3f58bebe658a798cbcc4d ]

The connection link policy is only set when establishing an outgoing
ACL connection causing connection idle modes not to be available on
incoming connections. Move the setting of the link policy to the
creation of the connection so all ACL connection will use the link
policy set on the HCI device.

Signed-off-by: Stefan Sørensen <ssorensen@roku.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Bluetooth: hci_conn: Set link_policy on incoming ACL
connections

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes a functional bug: the connection
link policy is **only** set when establishing an **outgoing** ACL
connection, which means **incoming** ACL connections don't get the link
policy configured on the HCI device. This causes "connection idle modes
not to be available on incoming connections."

The fix moves the `link_policy` assignment from the outgoing-connection-
specific path (`hci_acl_create_conn_sync`) to the generic connection
creation path (`__hci_conn_add`), so all ACL connections (both incoming
and outgoing) inherit the device's link policy.

### 2. CODE CHANGE ANALYSIS

The change is extremely small and surgical:

**In `net/bluetooth/hci_conn.c` (`__hci_conn_add`):**
- Adds one line: `conn->link_policy = hdev->link_policy;` in the
  `ACL_LINK` case of the switch statement during connection
  initialization.

**In `net/bluetooth/hci_sync.c` (`hci_acl_create_conn_sync`):**
- Removes the line `conn->link_policy = hdev->link_policy;` from the
  outgoing connection creation path (since it's now handled in the
  common path).

This is a pure **move** of a single assignment from a specific path to a
common path. The net effect:
- Outgoing connections: behavior is unchanged (link_policy was set
  before, still set now, just earlier in the flow)
- Incoming connections: link_policy is now properly set (was previously
  missing)

### 3. CLASSIFICATION

This is a **bug fix**. Incoming Bluetooth ACL connections were not
getting the correct link policy, which means features like sniff mode
(power saving) and role switching wouldn't work properly on incoming
connections. This is a real functional issue affecting Bluetooth power
management and connection behavior.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 2 (1 added, 1 removed - it's a move)
- **Files changed:** 2
- **Complexity:** Extremely low - moving an assignment to a more
  appropriate location
- **Risk of regression:** Minimal. The assignment already existed for
  outgoing connections; this just ensures incoming connections get the
  same treatment. The value being assigned (`hdev->link_policy`) is the
  same in both cases.

### 5. USER IMPACT

Bluetooth is widely used on laptops, desktops, and embedded systems. The
link policy controls important features like:
- **Sniff mode**: Power-saving mode that reduces radio duty cycle
- **Role switching**: Ability to switch between master and slave roles
- **Hold mode**: Another power management feature

Without the correct link policy on incoming connections, Bluetooth
devices connecting to the affected system would not benefit from power-
saving modes, potentially leading to increased battery drain and missing
expected Bluetooth behavior.

### 6. STABILITY INDICATORS

- The author (Stefan Sørensen) submitted the fix and it was signed off
  by Luiz Augusto von Dentz, the Bluetooth subsystem maintainer. This
  indicates it was reviewed and approved by the person most
  knowledgeable about the code.
- The change is trivially correct - it's moving an existing assignment
  to a more general location.

### 7. DEPENDENCY CHECK

This commit is completely self-contained. It doesn't depend on any other
changes - it simply moves an existing line of code. The `link_policy`
field, `hdev->link_policy`, and `__hci_conn_add` function have been in
the kernel for a long time, so this should apply cleanly to stable
trees.

### 8. STABLE KERNEL CRITERIA

- **Obviously correct:** Yes - it's a one-line move that ensures all ACL
  connections get the device's link policy
- **Fixes a real bug:** Yes - incoming connections missing link policy
  settings
- **Small and contained:** Yes - 2 lines across 2 files
- **No new features:** Correct - this enables existing functionality
  that was incorrectly not applied
- **Risk vs benefit:** Very low risk (trivially correct code move) vs
  meaningful benefit (proper Bluetooth power management on incoming
  connections)

**YES**

 net/bluetooth/hci_conn.c | 1 +
 net/bluetooth/hci_sync.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c3f7828bf9d54..b5e345fa6c344 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1002,6 +1002,7 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type,
 	switch (type) {
 	case ACL_LINK:
 		conn->pkt_type = hdev->pkt_type & ACL_PTYPE_MASK;
+		conn->link_policy = hdev->link_policy;
 		conn->mtu = hdev->acl_mtu;
 		break;
 	case LE_LINK:
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index cbc3a75d73262..334eb4376a266 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6897,8 +6897,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	conn->attempt++;
 
-	conn->link_policy = hdev->link_policy;
-
 	memset(&cp, 0, sizeof(cp));
 	bacpy(&cp.bdaddr, &conn->dst);
 	cp.pscan_rep_mode = 0x02;
-- 
2.51.0

