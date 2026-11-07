Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064676;
	b=YyNyfqtV+rovR1tClm8mOUqDJbrtjGC5FZDsqSCjTH568cRZEToSgoSMN3Di6gNuXEe2
	 uE30eLsAFS3RLzeh7FgGRuxPLB2eRJTVUe/4uQudKZcG7iFHHZ5fJZDQ1Hid5cRapcjbF
	 3RWgO3BkZNeA9MKsJ+NvZHezlcENSU6WpaKEhwTqWlmQuj3KZY1nkbCMhN4fARwcal81C
	 AWyoS35/XgqUyR1tqP4IUlJzrzwyRtUfOfcicuQORAwD3b/IsdAujTv4DffdUw9JBgvYx
	 uYBsYD16p3QVrJvBdGp9COAXYH0Kj+hEQf3NnkqlyerH+Sf5JY3wTuYUbE3uA4/a3Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyQaQuBmDRJHnqGS16HtNYu+0uNbs2aXFFGUrwh/Oc0=;
	b=HH9r6bm1K9TsH+SLgPbi+nLBO9vFQe7jmymMysmEAdi7Cw0Nv9dJbxcJiu/zkvmM3GZb
	 UuroiZjGAk1n3VSzXRkBxbwUDoDABVmD9NpKS3oamCJXOl7vTeKgFuj7Pgd7yQ8zvCB4X
	 qwKbEiPW0T+zScBsYuvQN7F7XgcYxXT7Ih0ehIhB9+6DTTkXOWqF40HfNXxaNwMevBzxz
	 YZgqJ5E43mOsxjjZF218H1B/LN6Bkm8okFXdXe1KDmoyZQ8H5CyUsTAZKzn7wzCB+7i/T
	 kTrxKsGfyWwX6UQAqW3dD9hs02iDQnwtJrk9quldmzS8tPnjorycJSMXyAi9aX+N9Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qm6cBvLO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4036B606A32C;
	Sat,  7 Nov 2026 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qm6cBvLO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3E21F008A2;
	Sat,  7 Nov 2026 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064676;
	bh=wyQaQuBmDRJHnqGS16HtNYu+0uNbs2aXFFGUrwh/Oc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm6cBvLOQJQsDldHTn1wMsVSoBO8wDVzwtx5c3kKOp0XmTU/nlGdRNcPiii/Zvi3p
	 RN6F6UJvXfasY4oh5gwFcePB3wS8OZZJW6VimarMmZdfNPgZPK3Q0S+CoEk6l3fI+s
	 3GyCyfLwErIik1XZipocIkCvK0W0C+4XbX1Ig/iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0624/1257] USB: cdc-acm: add VeriFone VX820 device ID
Date: Sat,  7 Nov 2026 08:48:40 -0500
Message-ID: <20261107134956.529853690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Drobyshev Vladimir <enigma_137@icloud.com>

[ Upstream commit ddbddee6592ecf6cf6c24d888780f9ad45a3e30b ]

Add USB ID 11ca:0219 for the VeriFone VX820 to the cdc-acm device
table and apply the SINGLE_RX_URB quirk.

Signed-off-by: Drobyshev Vladimir <enigma_137@icloud.com>
Link: https://patch.msgid.link/20260929173833.105208-1-enigma_137@icloud.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6a1c574634949..489575d40bd14 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1819,6 +1819,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x11ca, 0x0219), /* VeriFone Vx820 Gadget Serial */
+	.driver_info = SINGLE_RX_URB,
+	},
 	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
 	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
 	},
-- 
2.53.0



