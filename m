Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831072;
	b=FERS+ANLJlxA0/GJ2aWvdMeP6iBIQ83oOVHYPh09+RD0TgYxmdNhdN3/rb5/W1NUDqIK
	 Hm871H38xypXz5WEdDlHN6bzaaMydvDXH38mhd+KgpOUidAyfp22bHCEzgjkF3/a7JjPZ
	 2cHN2IJrfHiAdQQpCJuaSLT8lBflp4Qpt9WBjJhhoV1YpjgL5RdjL8VvjvpWwkp63ExsK
	 Gl/P8cSTSCFdk0zw9xk6iys7Se6cJOCPisV0wg7g8YglfJkbEJIAKXLl7EbnlwRFtnRJj
	 F/ejXJLbSMMkp2eGkkUTKQgkJXsTPpGss7PTxjy4fNWEKJmXQxWRRdLFA22M5b9y0CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GSyju8KggLplN6wcpU3PhLiXnIijKBeapLl3hYvHArg=;
	b=kIo7dZydeeXDMh+Vwk5kXXyfawzTKTmfo/848wfEo6k9GalytE5uatoyUWrYvGc1Qtfj
	 +XxYp8pq69ITNquTM7tQMOS+EebZ45P13PIzb5yEYWaN0iZz4+dWT+Rcs0l15hkPNic+2
	 NtsrbgNCLKYh5n/WKtcGbY/jgpCfrlFXRwWApP5oFZGVTzy4jXsPNuU9qxlibgcVOdpeh
	 i9A21iVRKLwiOyUZWbnKkdwVVFCix4z0G3V9zb0gjS31CFVrrVGhKK00pEJQSlUxAK/aZ
	 Kir8zP/XGKRQXdEuGuFLytMIW3HEJNLrsNnKq/3+8Zb6CGGovoADOq1NYW2I4CAz0ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPuVuIrC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA05606A32C;
	Wed,  4 Nov 2026 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPuVuIrC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4745E1F000C1;
	Wed,  4 Nov 2026 22:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831071;
	bh=GSyju8KggLplN6wcpU3PhLiXnIijKBeapLl3hYvHArg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPuVuIrCT1KtTKxWJKrXL78oLj3HiqiMIHQW8HbwH54pyeDW5Q1DXsmPJdTScLBqi
	 WWroGOv/pOFPo/YgolCKzhpBKPtP6U3mygj+weBV8EOluqW64c8QWS1bFJ9kgFLA/L
	 sbjYFj6cgHpUsRmOpqY/SMb63odNVGbqc9aZyklY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0488/1005] HID: Intel-thc-hid: Intel-quicki2c: Fix buffer overflow
Date: Wed,  4 Nov 2026 16:03:41 -0500
Message-ID: <20261104211057.643313855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit 5e5c3b9db1c5910d6a9175c97b76a95566e4dc32 ]

The input and output buffers are used to store complete HID-over-I2C
packets, including their protocol headers. However, their sizes are
currently calculated from the payload length only.

Allocate enough space for both the payload and the packet header to
prevent a buffer overflow when the payload reaches its maximum size.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
index c6ba6886072ad..4588c55cf255d 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -586,7 +586,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	 */
 	max_report_len = max(le16_to_cpu(qcdev->dev_desc.max_input_len), SZ_4K);
 
-	qcdev->input_buf = devm_kzalloc(qcdev->dev, max_report_len, GFP_KERNEL);
+	qcdev->input_buf = devm_kzalloc(qcdev->dev,
+					HIDI2C_PACKET_LEN(max_report_len), GFP_KERNEL);
 	if (!qcdev->input_buf)
 		return -ENOMEM;
 
@@ -596,7 +597,8 @@ static int quicki2c_alloc_report_buf(struct quicki2c_device *qcdev)
 	max_report_len = max(le16_to_cpu(qcdev->dev_desc.max_output_len),
 			     max_report_len);
 
-	qcdev->report_buf = devm_kzalloc(qcdev->dev, max_report_len, GFP_KERNEL);
+	qcdev->report_buf = devm_kzalloc(qcdev->dev,
+					 HIDI2C_PACKET_LEN(max_report_len), GFP_KERNEL);
 	if (!qcdev->report_buf)
 		return -ENOMEM;
 
-- 
2.53.0



