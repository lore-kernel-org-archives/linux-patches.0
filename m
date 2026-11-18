Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018625;
	b=JvQksu9RG981fV8F2g3oPxaxsco1p8/srvdJh+i0nriPt0Mkskk1VmgEfNUmkluHv46I
	 c4UPWFM95mcljC4JxnJAXeCB20DtF6zLY8hUKT5wpougKZXQDbtdllDxHOLAetNdSN6O8
	 ebb337v8PlLSLc2517YYdRRT4hZ4F2MJfhkYLy3Xr5Sjl9DRkYMV+fOjbN478ZdcbAn7h
	 1iGTXLitYeeBBfG8oP/EBVsQyY8k4JHtrwSTx+iOf37rtWL92HMThdtkvyiLTYmgRdxi4
	 d9P0UEVu3HAF9NgGGI5HYbyLhSW/x3cs/Mwu005ryCOnRsyjF7uYs4aNSH1aXM/P8Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0RwxHJwL96MOe/cocDN4VFELWNNLkHjUR76cw9pDKhc=;
	b=U+8MoOuT7nax95rFdp6zNs1ta+nF3Glof5yB1+ZoKTfPqVBQhIOYWYCmNQBpH+wYxKBg
	 9e3VaWbRWYrRcAVf8XpEGPuBrJanJ3xMXIyA9/2vYM1oqRigUg9RiPFOm1Fste7x1w1bU
	 ou0Fn6PEpsrZpIZm6RMYOGPl6bLODjS7H7ygLk3iK/v7RYo/6VSe4l4vxcQ95x0JnDMqu
	 mN2pbSNFAa1fr5FZOdiskLC00+2+9OwvZktsDUFR8G16srzbO3ufJFXSVQK4ELVxf63OZ
	 FCi2gRn+ZGXRyTWgXpNW+nDhdoeDym1EjCCV2hWsVxp/HV4uKxtXvgtMnhAvjbQkxdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPtXgC+r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B405A606A333;
	Wed, 18 Nov 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPtXgC+r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EE71F000C5;
	Wed, 18 Nov 2026 16:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018625;
	bh=0RwxHJwL96MOe/cocDN4VFELWNNLkHjUR76cw9pDKhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPtXgC+r5hryK3R028tj4dCBtphtQqghpYgsQfstKWhNHIZ2+Ow5qtpCYpMIj7MRY
	 jgtq7YyiqjQ0Gpt4AMVvWCU3xGx6foB8rV2r/PiACqukEnj4np5b7y3dxyKR8Vr4Hl
	 PzfH47TXha8jsFcg2/LCu60/p15K0ZzRgrQKg+5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1265/2651] selftests/alsa: Do not take another controls event as our own
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150333.509926549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 0857d64c322a0..01933ef9b349c 100644
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



