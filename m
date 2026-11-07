Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060682;
	b=Z4L3vxFi4pplzt2WbE1G9AP1Q87ZQ1a5GlRu1NkjNTtMBs2Gk7a8tczgIbRzikXPDv16
	 970F2TR9Ko+YRLkzTW4emLtKP5OJhSyyA0Eje4kbUu67dwXBcVkZN6HaezOalX/x6lIC9
	 IIygfdr/v8zPlsjxXwvYVs8laETPz/YclesUMV7sdaSK7S/Bwut/VaFuSEM8y3H2nP3Vs
	 VtjRdHeJJfvuLVWc0vjiuaqz7pfAeBxxMMC0OTibvK3xClAX+Ax0IkdXSjTFY4s2WO9Np
	 V+upR54V7A5IAljerIEIWHWFzCKFrnDQLfEv0mB36D5XYuakbARh3R03ofbLtmJZEHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5DONlZ20fSArrdDCu5K3H/FtcpJIo+0zpRNm8xVr8Q=;
	b=p18IwcKvcNr4hKKJ9UmAsrVrZhfRaHjzFcfjAI5R/2ro8e7tKrVRPUquVDyB7OG2Zb6D
	 nlE0aO3isTX/yQRtXsGppNbR58i5HzzNqLQsbfzPakAPM4uaNpYKibDjjEigWi/zseG32
	 rO3xQxObzWNcNgFCCgTza2F1dy8BNMfvUOsmFtd5nDnDtfyzMVzhdF5QELm24phxWPLCp
	 1YR7oxIiZODSFKO2WQ9gdxJjE15b0vxvWsDW8Dcmo66yV0HOY/0PmrtzdkonVbCDnPrTQ
	 NU3AS9tqybVLJJzEiV1y3J1bkFfd/wE+/LNs71o0fEKhMHE/frlT1z2m4odHqyf0/8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwGEMNdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD239606A32C;
	Sat,  7 Nov 2026 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwGEMNdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883CF1F0089F;
	Sat,  7 Nov 2026 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060681;
	bh=s5DONlZ20fSArrdDCu5K3H/FtcpJIo+0zpRNm8xVr8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwGEMNdz0r/PY8hh6D6cr3KeniQ3U3N/35DQuTqCuPVNhp6ymlju3d0HYWxuB1rDi
	 P4bapOYVOETiEJ8h5wOZqg5ISl9zK4GwauBgYWxaBVYmi2hmYjBFhaRvKa2L4kKV3t
	 ng+VeYn7oVZfe54oSZjjkO5b39y0U9SgrVN2H2Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0114/1536] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:30 -0500
Message-ID: <20261107135000.876395651@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index fd0331a87cda2..f7120fdf96e45 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -849,6 +849,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0



