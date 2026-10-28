Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217314;
	b=QEagFo3qadIawFoi0Dx0SFSdWHr0ZUnFopLjiZQyVFkglcXQOwe+m7miC0OSzPh1a6hI
	 kPqLtQfPHJ9DwDNYH8eFCZ3hNVj4hoxp9/Hud2IoU7MmZYtqrbN0PeXTlS1LidjnZ56dC
	 qwTn+VmsKQVT/uXsmqKDWb1721ANzRecv7ElPtzGBrUFfzAVWp9DzNXCujP9TmTDCTbdm
	 3LyfRXXB36XRXa/gtfGFH5CrzbLNw+u/Wwk9Gre4R6eDJV2vl+Sojm8reC4Dp542OGyFa
	 RsCJH+24PC6A6AA4JSL8RpyoFaRRYaEd4gdJV6QOXEFR0EIJRFDWvaWrEUvbCP7itnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AR/UMl4M8e4AqqEVdb9oo5xH5DS5hSQKnVuCHKHzjGw=;
	b=mKvN+65NhK23mLBh3m6hmLKn2kaYfI4qGKHqmC2m3mDDDKTORpCWrC0mEdKhqaON+/p5
	 ub4m6FtXQOwET5neNnqYFajglVOExceYOu/WidzrjUduT+CjZsWuM7VHysnq/K5PwlLMl
	 TcjhgzActYyYiWmcFXKVRTEqkxboYc00t3hUxk8G4FS3IltKpEdfFp34Iv5utoUeZwjSo
	 E2wX0uYDirJgtNChUFBO7rYKQed8NwPzcDQRseBMghKRYGsG8EQQlhXpXaCsXNIx68pDh
	 ohajO4VI1LL155kZD9Inkki/kg0PIbVFjXkUa/s0SAAfGlRZmy0sNqZ2SKp9grutgiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfUyKNXT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB1E606A325;
	Wed, 28 Oct 2026 19:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfUyKNXT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF701F01829;
	Wed, 28 Oct 2026 19:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217314;
	bh=AR/UMl4M8e4AqqEVdb9oo5xH5DS5hSQKnVuCHKHzjGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfUyKNXToAn/iBkWVTmbhKh1fA2c8yeI4LhiMMIe7FiCWrJzis7RzOzViLReDCCG4
	 l4OQW9vwpyqZTKzZ0aqz7SChhfOxdkhyWmDXxy02ULUjG5hyY07qFpEwYJn1PwvNop
	 wqDZnSWhW2SafQ+TNUNDTWs+m3mQZDI4TUUb6Zec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1834/1887] firmware: arm_scmi: Use channel ID for transport teardown
Date: Wed, 28 Oct 2026 18:05:30 +0100
Message-ID: <20261028170541.180944277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a71a3d4d8a6e9e399fd988c0e6da47a6ee21c99e ]

SCMI protocols can share the BASE transport channel when firmware does
not describe a dedicated channel for the protocol. In that case multiple
IDR entries can point at the same scmi_chan_info, whose owning transport
device was created with cinfo->id.

scmi_chan_destroy() used the IDR iterator key when destroying the
transport device. If an alias entry is visited before the owning channel
entry, the lookup can miss the device because the iterator key does not
match the protocol ID used when the transport device was created. The
code then clears cinfo->dev, so the later owning entry skips teardown and
leaks the transport device.

Destroy the transport device using cinfo->id, which is the protocol ID
that owns the channel and was used when creating the transport device.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-8-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 6c9107c32993c..2f959a3183273 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2217,7 +2217,7 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
 		of_node_put(cinfo->dev->of_node);
-		scmi_device_destroy(info->dev, id, sdev->name);
+		scmi_device_destroy(info->dev, cinfo->id, sdev->name);
 		cinfo->dev = NULL;
 	}
 
-- 
2.53.0



