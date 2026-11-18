Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058534;
	b=Npv+rXK6+h+hzC2y9iup57uLXRqXMU71JNc5B4uAJGfy3zaoFcynazPLZVi/D1TVc1pP
	 o3+ssQl7SQY3LkEaBSYDm2lkP51H1oNT9Yiur1jXShM5FYKy5ndQor0tL5F9+cNYWNo6J
	 CfmiOyjsG560ALbFDKRJ1Vme9uswEfJtxwA519zJj/BOmK0ezVh2AMaEgEC9DPOo9yG4q
	 TtHMMEaC17UFMTGugp36yJ7i6cQRqqcQO7wjutQqGcoULg2ptHserXpQSLGd5aDqoVXis
	 pfkpOGTMa06H3/NtmJSRPeld0Mvj0/P68YdjbOndBLueyy9EbAbvv31nVSW+eLBgwow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VplIkVNR0cgQg+OyySxHHikYpCpBqXpP1hXXrOEpoV8=;
	b=iPwznVy9AQGGlKaftq/uzRPhdzk09GP9D9GX6NXEkldALlDjONNFoS77/JdF+A4fvPMp
	 bhgGg6f3sjB3p69OKC0cNRFQ3zrG1v21rZ8lauPOP4XOMQEQyw+elkwNUvxLoEJtsQvdG
	 Bi2ezbknQyHc44542wDf38Zs71SSSEMNK6TyOtXUEB2UWq+dMlrIlaNCTotPX5Q1hjtww
	 0QEa9PdAGHQ2ruR2ysjR5RrUT4XQrUbdiwuDS50SoGxmhr7yOJ6mEmGPpZPVTHJumXnqi
	 Kwo3IJ8RUo98+yqwY4Xkb/5ghKgmXIggh7q7lV1rAfYzq1AYRDTOEOteb7wr/RyQI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yB7jHQbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F3606A325;
	Thu, 19 Nov 2026 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yB7jHQbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB841F000C4;
	Thu, 19 Nov 2026 03:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058534;
	bh=VplIkVNR0cgQg+OyySxHHikYpCpBqXpP1hXXrOEpoV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yB7jHQbZHw5KhINFcn1vA5P4rRdDNVvBUU9QUJtDuRTSuYWUbzAqAz7OMhb3yUbrV
	 FUPrDhBUdCaRWUFbiqbl7fjHg6jjSYWnsEhgGra6Ar0ZMg3nVBtQ2gvfoHeQH2OXJV
	 xjbdZg66IbvqjdjKJtJxXO1eFfqZcjQXmZgSOyPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0519/1848] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118145936.401611438@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit c1398cf11b31a94c27ed810ba69515e0df5ce379 ]

A peer can send a configuration response with an RFC
option for another mode to a connected channel, for
example to switch it from Streaming to ERTM mode.
l2cap_parse_conf_rsp() then changes chan->mode, but
l2cap_ertm_init() is not called again, so the ERTM
sequence lists are never allocated. The next
out-of-sequence I-frame makes l2cap_seq_list_clear()
write through the NULL srej_list.list.

Refuse the channel when a response tries to change
the mode of a connected channel.

Fixes: f2fcfcd67025 ("Bluetooth: Add configuration support for ERTM and Streaming mode")
Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20261007144717.3832330-1-oss%40fourdim.xyz
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 587aad401256b..244cd0865df08 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3967,7 +3967,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
 		}
 	}
 
-	if (chan->mode == L2CAP_MODE_BASIC && chan->mode != rfc.mode)
+	/* A connected channel cannot change its mode, as the new mode would
+	 * not be initialized.
+	 */
+	if (chan->mode != rfc.mode &&
+	    (chan->mode == L2CAP_MODE_BASIC || chan->state == BT_CONNECTED))
 		return -ECONNREFUSED;
 
 	chan->mode = rfc.mode;
-- 
2.53.0



