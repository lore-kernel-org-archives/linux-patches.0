Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025377;
	b=pLiGKNIya27PKi8v32chwbaTkvH7cos0p64yry31wJGVGj9p72UYXDTe2aD0PPhZOfNt
	 aW2LeqNH6ioIOA9tPo7kXOgHBqpLtobbSc6CmemdU/47j5AqgcIEN+AD0bmY9RFP6tAQ2
	 9wv0wKLndvocGV1Uuki4AGRKH+sC9KIxHFdhsBsdouCpebbhrNQtIQWw7fVHNVhx3+cVp
	 t5RC5HVbEeU/nQ5qrYHpb2DJi7+UB3x0SA5w4WPl/L/lrhRuWkLpCDhWtV0+oV9sPLIES
	 m7BByOmeGpnH33B37QWSt1ubcXRlgmVLFWSyy5YJDSsoO+TwKVT4vbRivfkgxno4mzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wi66VFX9F+ZG+NxrjZ7iqyt9lVbeaNY8CWh9LLJD5i0=;
	b=vzgNOGah2IjRnu0rkPSmvb+yUQ5cP/0wH+1OIMkzl7GYC/EIKLP6heSy5QZBAykOHvCT
	 CrolVrxds56Rt2zIFxFpGrY6kHP2EMOMH2TpZ741ZCzJY/oRh9dQLd977Lt0jp84rg7VI
	 +QakQJcnjxSCDchGy09l/8S9Wke70SaDyFrvefoRgBlyLW+uK9RJ5NZAB/WgE7cAH7L8n
	 cG49AueZ+o6vJJUrrD7kjZLNcOHWSSQ6r+xn1kQZPgXQWbm9R+2uU0JvhEbGQV9QhHrn3
	 t4VNcK+XXau2TCPh1KSOBIY2UmRyyxS9DjjjgaF9XgLUT4BPyA0TeWwVOPAbyK4PdNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkB7OI1U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C21606A31C;
	Wed, 18 Nov 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkB7OI1U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF961F000C4;
	Wed, 18 Nov 2026 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025376;
	bh=wi66VFX9F+ZG+NxrjZ7iqyt9lVbeaNY8CWh9LLJD5i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkB7OI1UCE9t+RofffsCEMk0u7Pl5n0j9paeET7IkGeweS3BxqNWzPWT2XA3ZQ8le
	 ohlp8nvIgJ9slZPJco/B+hZE1dtDlXaJ1lGaKMdjo7elD8EO/BgJxNuMg9GKQ2mhNz
	 JmX2gNHJspq5hNQrbJKi52VdYQl6nRdnHfGtqJW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1021/2151] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150159.594491289@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6c339feb830daa097ccc4c50c339c1733c12d42 ]

resp_atomic_write() validates the fields that are specific to an atomic
write, but never the range that the command addresses. Every other command
that writes user data calls check_device_access_params() first, which
rejects a transfer that ends beyond the capacity of the device, one whose
length exceeds the size of the store, and any write to a write protected
device.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-28-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a54253c369549..5acf24391ae67 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6086,6 +6086,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/*
 	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
 	 * atomic write that cannot complete to leave its LBAs unaltered, and
-- 
2.53.0



