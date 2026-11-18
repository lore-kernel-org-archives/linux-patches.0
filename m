Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043136;
	b=Gyq7H2bl0lWa+YA2tFy85yDlLOaFPZD8u0kW9fL/oMPrv++S60PpGdwSejSMF35V09Gn
	 z9QkQ1L9RQX7wrGPKLzmzK9xXH81PM7Uz1gQURI3XMEN8OoESEKsMlUKsZOViS5cfAbRB
	 8pUkP8+L8PbvoXOmf9Tl8lonImsYc94IEORARKIUOnLEtxQGGnBmLz6qB7+YrA4bigJlL
	 izGBUlEeNll8wbkYHP4r3dJOQPn6DSBZfB45hFo0kEKFEF3/VDmcCAm40PAts+CeFHTUM
	 EJ0ik6Nmn3jH1RFzMjrJTc1kFHP0CDQ/h4EkIrgLrw4PVT4qIlheI/1SjFpKK4+Ekrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bth5Yaw8eHcZ1D7PHF+aWqBvvEwtnz71+Ymo3oVay4s=;
	b=CDGulPqwJbYOwi8RtkogfvqHbNNy38TjqO1XiQG02hV6kxpzHKlAZNMxvs4D/a9AwEGT
	 6414aU26qXjYCuHt4L8/g8jRqKQ5RfZWSz0iGVZYSw6T49KoM8eKC277y/atxA/6YSfDS
	 omuiMR50e5k2ALC6A5cV4MzeOPAip3MrnTSspGZdJY8KEdNtYIBntPPMC/gC5440HOkVF
	 a9uPQ254/jwNbA5omxjC2bIjRmSWik4V0s4lj6noFcHmoHYVRwTEQgou+Y4jdoArgCzJn
	 Y9rlyiRutBVniipGucitrihZQV8Oinx4WAS+Va5w9We9VkQXE4cSWV1IjGoIFUBTszQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRR20r1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B44606A33F;
	Wed, 18 Nov 2026 23:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRR20r1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7851F000C5;
	Wed, 18 Nov 2026 23:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043136;
	bh=bth5Yaw8eHcZ1D7PHF+aWqBvvEwtnz71+Ymo3oVay4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRR20r1uKQuJAX292qa0ywhuZIu9V4FSiJUNpYaH3QaqbZ5pYeP+gEaAI4//12+QN
	 Rwi2WUJu5IU+J8HY+2emHBH1LxxHw5Biy3lcBLH2zQ/vcnVZnPByAo/KedhT/xUkyC
	 whYQnZJTiaYWj5eSXJ0xDc3omL4kSuKvhDOvrdnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0101/2857] usb: misc: cypress_cy7c63: check result of IO
Date: Wed, 18 Nov 2026 15:18:55 +0100
Message-ID: <20261118150204.886469047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 0673b919e0933541ae56bb3f0253853f696d3773 ]

If the device returns a bogus short read, treat it as EIO.
Actually check for IO errors.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260710095523.1646308-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/cypress_cy7c63.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 3be5551a98678..3def90646fdcd 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -89,8 +89,11 @@ static int vendor_command(struct cypress *dev, unsigned char request,
 				 address, data, iobuf, CYPRESS_MAX_REQSIZE,
 				 USB_CTRL_GET_TIMEOUT);
 	/* we must not process garbage */
-	if (retval < 2)
+	if (retval < 2) {
+		if (retval >= 0)
+			retval = -EIO;
 		goto err_buf;
+	}
 
 	/* store returned data (more READs to be added) */
 	switch (request) {
@@ -175,8 +178,9 @@ static ssize_t read_port(struct device *dev, struct device_attribute *attr,
 	dev_dbg(&cyp->udev->dev, "READ_PORT%d called\n", port_num);
 
 	result = vendor_command(cyp, CYPRESS_READ_PORT, read_id, 0);
-
 	dev_dbg(&cyp->udev->dev, "Result of vendor_command: %d\n\n", result);
+	if (result < 0)
+		return result;
 
 	return sprintf(buf, "%d", cyp->port[port_num]);
 }
-- 
2.53.0



