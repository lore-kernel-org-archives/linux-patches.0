Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062377;
	b=tqzydfIcN+dZgwPNNY0lLimOXrXIH1TgN5d+BODh2N4bXUVsDwgupnLcOFDfHXh1k2K8
	 Ic3a9OVEZ2gl6PVAJErNEa9s0X97G0uh6XAejinsXuUe5S9hwfhzb/NxiXt8EjWrUctGo
	 WENmNfD/5bzTLfl3Uh6AgILY6SCSBs3C31wI2H+5LuNMM7nf3udNQlaBrZKW58+Jh7EN5
	 fJ6MeAz1jsfTTpcmnhyg1MmbScEMhpe77jZW2cngXR+b4WJlenybzCHmiY2OVFStHPoTs
	 lb/yaTiey7FR2JTA8yRz+UvKp68eSpW6+HM10ZVVd8lt4t0WbLPXnAPSXjqNp05A53w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LFSAuN+GlfykjUU8GGNhIMw3wTczA76Qp5z3uDLtqUc=;
	b=BXJ6vPfu7V/XgWWw5pL4I8yx+XBiTTDRhUb1xerU5/XMFK2KHbGvMB75LWvDwBx9ZydO
	 iK6y1GNQHmspfbyIRyKgJJz2FCg0p/qrwHQkoJQkVM6kBTYmNp4y/2uk4q2geTAoKpIFk
	 hrNwPh7fNX8p6S89OvLkAewfLAE/2TZbjBel58UcdQfva+L16Mqn2ftZPziHY6n4k4rjD
	 FVElDgC2pgx87AlDJLI2zM6lENyjDk8wMSBR+4B3bwoIgkUeYtiHWmJfYhctfAIfwVm9t
	 fKRB0HIl0WRnNBMAsupFZ2EkPA6Aob2M3dvs8/xMEncMHeNB3guTLHiuu0hiADEYy5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbkM+Ujg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C9D6083603;
	Sat,  7 Nov 2026 14:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbkM+Ujg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129D51F0089F;
	Sat,  7 Nov 2026 14:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062376;
	bh=LFSAuN+GlfykjUU8GGNhIMw3wTczA76Qp5z3uDLtqUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbkM+UjgwWkXMJgh3vXwowMWMM9GTjWdKcY+vRIvNfAPK0BNZGJ0cTXcu/+ToZ5vR
	 322ur89Fl+TkXB+/e0HQqNF9pxej7/7QBzxol3efbY/c6beINgnjpOlPyv0+Fhc3oy
	 QrIbeuP0GL0XXebANqqS4M8Obz4rh0CqYy2ME7Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1299/1536] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Sat,  7 Nov 2026 08:55:15 -0500
Message-ID: <20261107135034.274013560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 894fcd779bd03..69e4ef4834b29 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3769,7 +3769,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
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



