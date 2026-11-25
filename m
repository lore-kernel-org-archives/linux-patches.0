Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618492;
	b=uIcxRWA64FjowNRJJiE3XFWJinEMDEKoqzNiyMN08CxSdhakLiqYMF+h0zkVA3Jsg+Y6
	 idC9aqjR0mrUFi+LKj4VpHaU9kS/StMps2a/o2XtlKOUO87W/n3jNIQMTBkAGo7gPKuEA
	 VBR8CS3dznMrh5D65ZtnUW4QnHsmGiuhotoXrEo6Jet0sPnvYYi6lPp5JuR7ZOM2sO/Or
	 00J0h8kfVdxqShSGAuzjVY36ZEhM0J9Mv68gBpjuef8zBorefL0jZM07Rlal+9rl5OxgO
	 SalabVaC0f7OFDkIMA301vO/pKQ2admZr+1yImZYQCgs1VaFNfVfgge1+0waSXhQnQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AOY13lPAHYIV/5HGLkhwEC2w3dGU857Cj4xR4Fxi+aA=;
	b=BLdgc/Yur05n7qBClXxO9f9gHfQe1oKNdjXrvbQHqAS9UnzoD+aRspPqcLzKlpBe+l0i
	 YIHj9zP8pPUU67d9com+s+wuNKGO1PfAXHnoTXyKgQ0pNtXFXw+depjin11NAZJaY+tRb
	 opNYR6MCiyknBI1TPFByNDq+89dTH38o7v2ANcX2gVv37m9aitFud5+hV/wUvAZnLOul3
	 xamrjIyED1CfIyWrSMU2FEj9ugyWM5ixHATfoENnUy91lZwCZUJeOYdMbecof74xm52h5
	 xiJcXDX/OsuVzj+0MHwED+2LqQ/g5HG41mBWheUZoHeXMjqDPuUm+vPVWD1RhM6JLgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTHCXZ2r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F92606A321;
	Wed, 25 Nov 2026 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTHCXZ2r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66EC1F000C4;
	Wed, 25 Nov 2026 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618492;
	bh=AOY13lPAHYIV/5HGLkhwEC2w3dGU857Cj4xR4Fxi+aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTHCXZ2rbVAKnWOSp+gfH5yVp+Emr4i2fxAivW2hCKJHo4Btqh9RnkbJno/UPR7ux
	 OHl0SJDmtyfMdxzmX7wHsaAVU9sauAUs3wHk6USYkgU5c4UVQrqvNdG6FnvnGTh3vA
	 LlX9+TRGF4b/iWnr0lR1uOv8PhRCvI1fKRqdcohw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0296/1005] Bluetooth: Fix not updating of hdev->commands[] after reset
Date: Wed, 25 Nov 2026 15:27:14 +0100
Message-ID: <20261125143828.667987251@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e00aa1a33f81a5e25b510f569ab9cb9f97eb41b9 ]

Read Local Supported Commands was only read once during the INIT/SETUP
flow, but the supported commands bits may change at runtime, for
example after a firmware change applied with vendor commands, so update
hdev->commands[] every time the response is received.

Fixes: 6a070e6e81ad ("Bluetooth: Store supported commands only during setup procedure")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d1f142e6ea5b5..fd5c185bb10bf 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -816,9 +816,7 @@ static u8 hci_cc_read_local_commands(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
-	if (hci_dev_test_flag(hdev, HCI_SETUP) ||
-	    hci_dev_test_flag(hdev, HCI_CONFIG))
-		memcpy(hdev->commands, rp->commands, sizeof(hdev->commands));
+	memcpy(hdev->commands, rp->commands, sizeof(hdev->commands));
 
 	return rp->status;
 }
-- 
2.53.0



