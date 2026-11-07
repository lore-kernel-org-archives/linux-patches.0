Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062063;
	b=D+wXtRD0oDFydIrdLBM9V2C68tu9nb6HzfTMDQrsqv+/Yy2yrBIngb0ZVHkB6ViO8AUK
	 0YMRox/XvI9jehubOa6wrsKfO/O3TpmFhw2BodCE/R2EkNz/hCFYervHbxwbd+4P4UWpy
	 /nQw8P5Sip+dBJ7v2bV4ZXFKbThXc1X8Lj+ksqbcsZJ+d9zH0jmO+P/ABBZgJA6wK/zuR
	 eIassQVdCtbGTeKIOHCm27vFnJ5RNXp4Ss/w5z+dd+OzWoOxXNGG0udXVZVUhwP/ty5DE
	 HOyOkwtw6xGl25HMc1PaCNzi8Kq2GGapo9CSXA/nooRETNMedeGCJIRxQoiGXbdqX5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L/CKGKBhMjaMZ6uoSQcPNCIsMk9B5Y0OsdTIMehfacE=;
	b=UUddtcOa9Af5HbbupkoJvyA4jI/IhNUe6Cu4aseV8yyW/UBWYsgI0vMTtAhNt8qp8g55
	 s7bm4nCKyuAFnJBE7qBRe7Xza0RvasJ2B7uSoCl3Z4HVHGEbndYX1AhbxsB/evibRymim
	 1JnVOMlu5gQoggKyNyGP3a329YrUuwPNhj1kuaJGZAo7Vwsr2rPcLXsT9/tEjisJ5WJ/5
	 HhRxN2qk9nrJqMzsNQ9BJAFVjyRR9xuyqmnPTpZAPCJvqEOhZGoa+jlXOSs5oYVGN5/w9
	 ITcvsavfzgeeuaWIj1KFDmV5GhxH+0ed0EJ71xpefu5U0PlQYW57OLsVU4fOnakiEWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n50+qcbu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FE5606A338;
	Sat,  7 Nov 2026 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n50+qcbu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B151F008A6;
	Sat,  7 Nov 2026 14:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062062;
	bh=L/CKGKBhMjaMZ6uoSQcPNCIsMk9B5Y0OsdTIMehfacE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n50+qcbuopaprXi86HULTToAPKuOTG/UnC97aOUDLepYsj4ep2emj/BGJLAMuJya9
	 eytS8iln8tzs2Pol2UJyrYp7ZDTJa4lkpOC7ra0t99+Wp8UUk30G/a5rjydARVtrO/
	 y54HjvgFpnuVYMN6odK+1XrFxpodsdHRoPqohbCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1043/1536] media: go7007: unregister the I2C adapter on USB probe failure
Date: Sat,  7 Nov 2026 08:50:59 -0500
Message-ID: <20261107135026.970513864@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14165cd16fa7c233aec6a407b56b304e7a283911 ]

USB probe failures after I2C adapter registration free the backing
go7007 structure without unregistering the adapter.

If i2c_adapter_online is set, unregister the adapter before releasing
USB resources so that I2C client removal can still use its callbacks.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 59aea928d57f ("[media] go7007: don't continue if firmware can't be loaded")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index bf3cf320b2c9c..ad9cc44660dd3 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1326,6 +1326,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	return 0;
 
 allocfail:
+	if (go->i2c_adapter_online)
+		i2c_del_adapter(&go->i2c_adapter);
 	go7007_usb_release(go);
 	kfree(go);
 	return -ENOMEM;
-- 
2.53.0



