Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058340;
	b=sFCj8fP5U2olKVGrnIxqVkQ1VHYEztz1RzYYdfON9Ma0hfMdAyhM1aY+8y9J50PP9Oe3
	 asvpf/6mNw9cV6OLt8EpzR5b1933wEF6dzJNJ4fnfsKp5ZMpEEQ7fWKCaiATOsL8e93zo
	 Glm0RFu3NI1H2N28YK3DxlBRiQu45yr+9f2NA28l6q5RPxi0f31EuNiKILkiyGEYrZfhO
	 EDRtEPWDCQZr8mY1ecgURg8aTGjOmlBkPQ0b+BFe3aW1fCKf8XtC2F5en4a0eRUcr7C0T
	 Jiql5eleIJ0maPIgNkxWaLgS65kU2Q78HSxneliL1Sh6r5aonoWsxtrOHy0gldGtAZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ju8dpy3SfGXKpF/tBYNqOoAzVX2kBE7kXWwEZ+5pTeA=;
	b=h1iaHABtw6HW+7OOsfUgTqIo3pMLrKjXtJOKkvri/6Bmeui1JltZyQWn61ZR7MJDCc4C
	 lZE3AwHH1W6FmWCIIPwrqDbZzsCKb89qyQFUH8kf98ABMZbf+28gcge+hUzKLOA1r8X1Q
	 jzEKa6xvYuMbC43YGmaIpTBOlaMyIUtDTAP437mymAmgwEPs6jxBmD8CfS0XWgpmcFYQ/
	 PadXY9Nm2DhYa2KAtAMsn86fkD1o4zQ4Cq2y2CU+11etMb1HDm1cradhAh1vIvbjes2sQ
	 v9SgTQqRDWcbzs2gInRpW2vJ5cPyPJbqNl4D0Air9fBpEYpK79DPe4//yeHcJ7s//IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW3N10gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA6E606A320;
	Thu, 19 Nov 2026 03:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW3N10gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089731F000C4;
	Thu, 19 Nov 2026 03:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058340;
	bh=ju8dpy3SfGXKpF/tBYNqOoAzVX2kBE7kXWwEZ+5pTeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW3N10gwjARTGYTV7LG1+ph4tkuCl+6dgeIJsv3qo8k4nsjXqOqwFOywqyebbI7sf
	 Al7k8q5KwuPKSSDDLYKkiC376v0rKSWsSSpIZEzPtaiukBDKUp/7bghjxbbR8FmUwA
	 HRmfYx/80R0jlfX5nxx+CU6qM4RW47w6BxTiSjBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0452/1848] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Wed, 18 Nov 2026 15:41:30 +0100
Message-ID: <20261118145933.433599136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 3e42e209be374..e638c49b77b2a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -641,6 +641,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



