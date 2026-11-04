Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831070;
	b=0VL+J1MUn8I3ojocyThH1IDrEL7km6ZYvXbHUB5K+NjM0qJ6or0FgpGLwgboHd0BGbfz
	 GtGCJ2Ct4g8x3O3J7K3J62BwaV7BWlGCv7rQMvAwox1t82Z4A8zEFGEtUKQQy4IY8nNo/
	 8jv3F6QKbf6Jps6cjsnSxVZZAYSrThvfMc338H+JF2vCpzu3qmhcvxWeolL+Bh1sbaTZo
	 vl3akrFgz81eJrESrPkVwNSCuAJ5PuaFCsXIQRxagS4Qe3CzA5gOJpOCUheO4/tZvehDt
	 t082RetwLA+mNlfWlkx7qEV4GtfX986UPQCJc7CXEqn2cBtYwMf7PEXO3o5yH9FrmwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HRTQ6jnZVOTgzpJ4wriMe8BKz0RfvzKCJ/KORkWaTEM=;
	b=RKYnL7OusUauemMim2ksgM1WDtIb2/VLm/fdIOEYWoKqHhqfXICnmqxMKYwYvwZEpJns
	 7YmYojmhZIjClWV2drklKj3aIWE2wKzR4yVOrJKkesprqUWXoFoBtZoja/d5g0VVMcJTM
	 J7vuwp0tphNeVaUyjQnV8QKvNQ5kRqqoMEQ3E7y/FHUk+gUlfMW7eqMIbJJV21ugOSPOj
	 9mosBj1nRVMNRl3K/1QETIWJFBlLLVRm7UbOBk/TIMP8KB2VGQbt3xyklhrOHeoJM1pEB
	 4W6b/ejfA8dc4XC/nVoYwrfgn4VClB3eFsiYk3D1fNPTgzr+SEgE7VTRZpsO5zYS3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JckwQ0v7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F2E606A32C;
	Wed,  4 Nov 2026 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JckwQ0v7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF61B1F000C1;
	Wed,  4 Nov 2026 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831070;
	bh=HRTQ6jnZVOTgzpJ4wriMe8BKz0RfvzKCJ/KORkWaTEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JckwQ0v72lSgv/Baox526uyPI7jJBa0KxfLVTOOwZ5pYczsd4/yQnWIzlVBycPfqp
	 SMAxagxRLhXiNO4aMolKN/O7II4+S5hRbXoYBBWhFsClZcwXvM81teeERi6z0WeAn4
	 8JMYM80smcqgq1sN8MrVJ0m9Dv+1IzweY2BbRKn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0487/1005] HID: Intel-thc-hid: Intel-quickspi: Fix buffer overflow
Date: Wed,  4 Nov 2026 16:03:40 -0500
Message-ID: <20261104211057.618832416@linuxfoundation.org>
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

[ Upstream commit a1cdd72371270640bd357bd3e3b2ec0be17c9536 ]

The input buffers are used to store complete HID-over-SPI packets,
including their protocol headers. However, their sizes are
currently calculated from the payload length only.

Allocate enough space for both the payload and the packet header to
prevent a buffer overflow when the payload reaches its maximum size.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index 1c96d1d85845c..48387a7341604 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -549,7 +549,8 @@ static int quickspi_alloc_report_buf(struct quickspi_device *qsdev)
 	max_input_len = max(le16_to_cpu(qsdev->dev_desc.rep_desc_len),
 			    le16_to_cpu(qsdev->dev_desc.max_input_len));
 
-	qsdev->input_buf = devm_kzalloc(qsdev->dev, max_input_len, GFP_KERNEL);
+	qsdev->input_buf = devm_kzalloc(qsdev->dev,
+					HIDSPI_INPUT_BODY_SIZE(max_input_len), GFP_KERNEL);
 	if (!qsdev->input_buf)
 		return -ENOMEM;
 
-- 
2.53.0



