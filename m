Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061649;
	b=BnXSboQXzgvrRalozTxPtcxpdQV+Om+kem3zrqON8iQacJ4Pq35ZWCcmIaFoBFSIv3h2
	 ckxUwffo1yjOGsAjBbSpF+yrCS0bSL2mRdrAufr9bYgiesZR16ki+HxC1Q6XukmrHdd19
	 dBPh3Rm0w1iso/Eu3na8HwGRUUtBKvyGa8axa+/92VJsFj92c350bgIscDKlfbgRuaB2G
	 lmWLiIP8kZVTPzjOp+B705ACTHURiTNVrklrArrnG1eexbyMhwuHSIjd3ezHxdd4T07sl
	 jVaw4r0fq6/qKXGUlvPgz++2ijjMW8CyqQ8PibfOgYAkaCEh8wvR/Y44YiqgVENsTtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fQuZGhQ0NX7/QHRvb4128lTXIYP6Y6DdFqu15qzDhHU=;
	b=ixaEHjn7pmINI0cKM7RpBfi2HF3C74Y9rpfwqJGqz5uBew7qLBBSlXYaSQJG/a5aUZDP
	 I3dMCiQdVaykQSwKwplRU6Crp56MWzn0do08Lb1yIr2v1gz1RNZ5bt2f13BJTDEfxqoHC
	 X+swU4+JzTiwO6hal7ZVJMlDNjfA0zStaPYn37QhIQaFUWSE4Nig8iJ4ZitJM9FiVOCxT
	 0TOixfpv8F9Vl+3InwJ8LSaM/+KQORg25hW5LEj9zsUzRvvxmDmiZ0d7Lt0Qoyhp4U9sz
	 oSb6jTFpkt3XMPisiU9etXQsH621/LCwo6Oygg7HbY0OKYhYQA2FxQx9I/LwCxWsiOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpRbuu8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED993606A325;
	Thu, 19 Nov 2026 04:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpRbuu8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B341F000C4;
	Thu, 19 Nov 2026 04:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061648;
	bh=fQuZGhQ0NX7/QHRvb4128lTXIYP6Y6DdFqu15qzDhHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpRbuu8zYKBphOjGA5dIszQ8SC3437lSO1yKOg2Tx7d11iM9kPrwrjL32hiHdNIDf
	 wW2i8mi0gWtJqmfXidJaaK9eZu4B6IIl5ZmNy4M13dDh/oxUsNFajNzic7/uL+VRAH
	 DupXoCCQ6ZNv8YL/JTYUIW+fuYTxZJ5yGHb0DjZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1627/1848] tools/thermal/tmon: Fix string truncation warning in optarg copy
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150027.671179890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 602da762f7a7c494a95cb204ac005965b214e556 ]

GCC warns about possible string truncation with -Wstringop-truncation:

  tmon.c: In function ‘main’:
  tmon.c:233:25: warning: ‘__builtin_strncpy’ specified bound 20 equals
destination size [-Wstringop-truncation]
    233 |                         strncpy(ctrl_cdev, optarg,
	CDEV_NAME_SIZE);
        |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Replace strncpy() with snprintf() to guarantee NUL-termination and
silence the compiler warning.

Fixes: 94f69966faf8 ("tools/thermal: Introduce tmon, a tool for thermal subsystem")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260929201951.408456-1-florian.fainelli@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/tmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 7eb3216a27f45..0c8deee4652e2 100644
--- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -230,7 +230,7 @@ int main(int argc, char **argv)
 		switch (c) {
 		case 'c':
 			no_control = 0;
-			strncpy(ctrl_cdev, optarg, CDEV_NAME_SIZE);
+			snprintf(ctrl_cdev, sizeof(ctrl_cdev), "%s", optarg);
 			break;
 		case 'd':
 			start_daemon_mode();
-- 
2.53.0



