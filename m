Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025360;
	b=kRCIADAYZTkAB4c4KKWsb6QIWP2l3uafYQD3CnNljR8ORTW0mLgk15DKlhjSyRUNDq7g
	 72DA0hKYxr/QKbjEr+qvA/C/vwbIsq29d1gjBwPPe18SwtzLGUg5aagAvZWgb75XA/OXp
	 1FOaIaZAevWGy8JfI3P6COj5bshGZG62czthzzuaeRbM7XDSGK3OGCtHonUD3DFHzAioY
	 Ef8GtSoLNAVp7TELuH5uNIwY3/EMSQ7/gaH1y2GnvAhcqIp2QnO3Yiyke4kAhc3Dkoqi0
	 nRLQ9y9blUbW59ejALKYqjv6IrSMbEwURuDmHZh8J2YqOpZDbwJcpR6HtgDYeKBchLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQl427uEEJvMWnxhKmLBPGKundd/5mdtEEmpsBK1cXI=;
	b=hjz49yhxRN0Qef7NlMWNSKbytp/Rug138t2GE1+k+s2TvAGLfaEbrZ+L3EwYU6/mMDzU
	 LAMhOGGN4mYH+rgAQm510ArzsTM18YZGG6XC3tJxGvNZG9gR3tZi4IGZQ7ZiDiEhi5K/v
	 GyFFXCbr7O4KjIoYmYIk40L4n8CJKNqUjPxV1ye9GXsjAloNQCn8qyJqRCdoRXBGLeq+4
	 SVXI36/WRsETDzs/m/effMzce4Lldi1CWNBYEoltMn5IA9LNWu/5nCsT+VdWN7zMmVa8y
	 G0jBtC/CTrjBsPLWyiXg3z/jHv+XYX65f/ljIvOPADIO9lvacAFCc62I8R5TxET0RLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koFmyq1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19560A262D;
	Wed, 18 Nov 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=koFmyq1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981B11F000C9;
	Wed, 18 Nov 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025360;
	bh=hQl427uEEJvMWnxhKmLBPGKundd/5mdtEEmpsBK1cXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koFmyq1GkJME3GZorDlMLGH+OIAEustoi6trkA7Qwyx1cqCrlzwzAGCwGhZytxSk2
	 n64mYKsVGWRDw1I9u1XGr39yp/L6eEFb5dxbNmwLvA6m3XIa4+SUMU0Sn9tYg3EE2A
	 Gp9kqWejmTznjsL4ZEXPXEl14kPPGA6NInrpWu/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1051/2151] selftests/alsa: Do not take another controls event as our own
Date: Wed, 18 Nov 2026 15:46:26 +0100
Message-ID: <20261118150200.599939679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c9b0768669976a1beb0a1537b4257bd6b76dfbac ]

The wait_for_event() skips an event for a different control with a
continue inside its do-while loop. But continue goes straight to the
loop condition, and that tests the mask of the event just skipped. So
a value event for another control ends the wait as if it were ours.

A driver that notifies a second control from its put() queues that
event first. The core only sends ours once put() returns. So the wait
returns early and leaves ours in the queue. The next test then
reports it as spurious. And event_missing passes for a control whose
put() said nothing changed, as long as it notified a neighbour.

To fix this, clear the mask before skipping the event.

Fixes: b1446bda5645 ("kselftest: alsa: Check for event generation when we write to controls")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930111534.3782264-2-sammiee5311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index 2b9278475e6de..213300d0cad4e 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -261,6 +261,8 @@ static int wait_for_event(struct ctl_data *ctl, int timeout)
 		if (ev_id != snd_ctl_elem_info_get_numid(ctl->info)) {
 			ksft_print_msg("Event for unexpected ctl %s\n",
 				       snd_ctl_event_elem_get_name(event));
+			/* The loop condition must not see the other control's mask */
+			mask = 0;
 			continue;
 		}
 
-- 
2.53.0



